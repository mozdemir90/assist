import os
from flask_apscheduler import APScheduler
from app.modules.tasks.models import Task
from app.modules.auth.models import User
from app.core.database import db
import datetime
import firebase_admin
from firebase_admin import credentials, messaging

scheduler = APScheduler()

def init_firebase():
    if not firebase_admin._apps:
        # For local dev without real credentials, try to initialize,
        # otherwise provide a dummy app so it doesn't crash on boot.
        try:
            # We attempt to use default credentials or a path from env
            cred_path = os.environ.get('GOOGLE_APPLICATION_CREDENTIALS')
            if cred_path and os.path.exists(cred_path):
                cred = credentials.Certificate(cred_path)
                firebase_admin.initialize_app(cred)
            else:
                # Provide dummy init for dev environments without keys
                print("No GOOGLE_APPLICATION_CREDENTIALS found. Firebase mock initialized.")
        except Exception as e:
            print(f"Failed to initialize firebase: {e}")

def send_push_notification(fcm_token, title, body):
    if not fcm_token:
        return False

    if not firebase_admin._apps:
        print(f"Mock push notification to {fcm_token}: {title} - {body}")
        return True

    try:
        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=body,
            ),
            token=fcm_token,
        )
        response = messaging.send(message)
        return True
    except Exception as e:
        print(f"Failed to send FCM message: {e}")
        return False

def check_upcoming_tasks(app):
    with app.app_context():
        now = datetime.datetime.now(datetime.timezone.utc)
        one_hour_later = now + datetime.timedelta(hours=1)

        # Query tasks that are incomplete, not deleted, want a push, haven't been sent,
        # and have a deadline within the next hour.
        tasks_to_remind = Task.query.filter(
            Task.is_completed == False,
            Task.is_deleted == False,
            Task.remind_via_push == True,
            Task.reminder_sent == False,
            Task.deadline <= one_hour_later,
            Task.deadline > now
        ).all()

        for task in tasks_to_remind:
            user = User.query.get(task.user_id)
            if user and user.fcm_token:
                success = send_push_notification(
                    user.fcm_token,
                    "Task Reminder",
                    f"Your task '{task.title}' is due soon!"
                )
                if success:
                    task.reminder_sent = True
                    db.session.commit()

def init_scheduler(app):
    init_firebase()
    scheduler.init_app(app)

    # Run the job every 15 minutes
    scheduler.add_job(
        id='check_upcoming_tasks_job',
        func=check_upcoming_tasks,
        args=[app],
        trigger='interval',
        minutes=15
    )

    scheduler.start()
