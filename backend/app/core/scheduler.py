import datetime
from app.core.database import db
from app.core.mail import mail
from flask_mail import Message

def check_task_deadlines(app):
    with app.app_context():
        from app.modules.tasks.models import Task
        from app.modules.auth.models import User

        now = datetime.datetime.now(datetime.timezone.utc)
        # Find tasks that are due in the next hour, and have remind_via_email=True
        target_time = now + datetime.timedelta(hours=1)

        tasks_to_remind = Task.query.filter(
            Task.remind_via_email == True,
            Task.is_completed == False,
            Task.is_deleted == False,
            Task.deadline > now,
            Task.deadline <= target_time
        ).all()

        for task in tasks_to_remind:
            user = User.query.get(task.user_id)
            if user and user.email:
                try:
                    msg = Message(
                        f"Reminder: Task '{task.title}' is due soon",
                        recipients=[user.email]
                    )
                    msg.body = f"Hello {user.username},\n\nYour task '{task.title}' is due at {task.deadline.strftime('%Y-%m-%d %H:%M')}.\n\nDescription:\n{task.description}\n\nStay focused!\nODAK Team"
                    mail.send(msg)
                    app.logger.info(f"Reminder email sent to {user.email} for task {task.id}")
                    # Disable reminder after sending so we don't send it again
                    task.remind_via_email = False
                    db.session.commit()
                except Exception as e:
                    app.logger.error(f"Failed to send reminder email to {user.email} for task {task.id}: {str(e)}")

def setup_jobs(scheduler, app):
    # Run the check every 15 minutes
    scheduler.add_job(func=check_task_deadlines, trigger="interval", minutes=15, args=[app], id="deadline_checker", replace_existing=True)
