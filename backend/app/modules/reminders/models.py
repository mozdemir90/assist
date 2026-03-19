from app.core.database import db
import uuid
from datetime import datetime, timezone

def generate_uuid():
    return str(uuid.uuid4())

class Reminder(db.Model):
    __tablename__ = 'reminders'

    id = db.Column(db.String(36), primary_key=True, default=generate_uuid)
    title = db.Column(db.String(255), nullable=False)
    message = db.Column(db.Text, nullable=True)
    trigger_time = db.Column(db.DateTime, nullable=False)
    is_sent = db.Column(db.Boolean, default=False)

    # Optionally link to a specific task or activity
    task_id = db.Column(db.String(36), db.ForeignKey('tasks.id'), nullable=True)
    activity_id = db.Column(db.String(36), db.ForeignKey('activities.id'), nullable=True)

    user_id = db.Column(db.String(36), db.ForeignKey('users.id'), nullable=False)

    # Offline sync requirements
    updated_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))
    is_deleted = db.Column(db.Boolean, default=False)

    def to_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'message': self.message,
            'trigger_time': self.trigger_time.isoformat() if self.trigger_time else None,
            'is_sent': self.is_sent,
            'task_id': self.task_id,
            'activity_id': self.activity_id,
            'user_id': self.user_id,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
            'is_deleted': self.is_deleted
        }
