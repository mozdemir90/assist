import os
from flask_apscheduler import APScheduler
from app.modules.tasks.models import Task
from app.modules.auth.models import User
from app.core.database import db
import datetime
import firebase_admin
from firebase_admin import credentials, messaging
from app.modules.reminders.models import Reminder
import traceback


scheduler = APScheduler()

import json

def init_firebase():
    if not firebase_admin._apps:
        # For local dev without real credentials, try to initialize,
        # otherwise provide a dummy app so it doesn't crash on boot.
        try:
            # Check if JSON is passed directly via an environment variable
            firebase_json_env = os.environ.get('FIREBASE_SERVICE_ACCOUNT_JSON')
            if firebase_json_env:
                try:
                    cred_dict = json.loads(firebase_json_env)
                    cred = credentials.Certificate(cred_dict)
                    firebase_admin.initialize_app(cred)
                    print("Firebase initialized successfully via JSON environment variable.")
                    return
                except json.JSONDecodeError as e:
                    print("Failed to parse FIREBASE_SERVICE_ACCOUNT_JSON as JSON. Please check syntax.")
                    traceback.print_exc()
                except Exception as e:
                    print("Unexpected error initializing Firebase via JSON string:")
                    traceback.print_exc()

            # We attempt to use default credentials or a path from env
            cred_path = os.environ.get('GOOGLE_APPLICATION_CREDENTIALS')


            # Fallback to local file if env variable is not set
            if not cred_path:
                default_path = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), 'firebase-service-account.json')
                if os.path.exists(default_path):
                    cred_path = default_path

            if cred_path and os.path.exists(cred_path):
                cred = credentials.Certificate(cred_path)
                firebase_admin.initialize_app(cred)
                print("Firebase initialized successfully via file path.")
            else:
                # Provide dummy init for dev environments without keys
                print("No firebase credentials found (ENV or default file). Firebase mock initialized.")
        except Exception as e:
            print("Failed to initialize firebase completely:")
            traceback.print_exc()

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
        print(f"FCM: Attempting to send message to token: {fcm_token[:10]}... Title: '{title}'")
        response = messaging.send(message)
        print(f"FCM: Successfully sent message. Message ID: {response}")
        return True
    except firebase_admin.exceptions.FirebaseError as e:
        print("FCM FirebaseError: Failed to send notification (Check token validity or project config).")
        traceback.print_exc()
        return False
    except ValueError as e:
        print("FCM ValueError: Invalid argument passed to messaging.send().")
        traceback.print_exc()
        return False
    except Exception as e:
        print("FCM Unexpected Error:")
        traceback.print_exc()
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

        # Check dedicated reminders
        reminders_to_send = Reminder.query.filter(
            Reminder.is_sent == False,
            Reminder.is_deleted == False,
            Reminder.trigger_time <= now
        ).all()

        if reminders_to_send:
            print(f"Scheduler found {len(reminders_to_send)} reminders due (<= {now.isoformat()}). Sending FCM...")

        for rem in reminders_to_send:
            user = User.query.get(rem.user_id)
            if user and user.fcm_token:
                success = send_push_notification(
                    user.fcm_token,
                    rem.title,
                    rem.message or "Task reminder"
                )
                if success:
                    rem.is_sent = True
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
        minutes=1
    )

    scheduler.start()
