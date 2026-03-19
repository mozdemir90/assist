from app.core.database import db
import uuid
from datetime import datetime, timezone

def generate_uuid():
    return str(uuid.uuid4())

class Task(db.Model):
    __tablename__ = 'tasks'

    id = db.Column(db.String(36), primary_key=True, default=generate_uuid)
    title = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text, nullable=True)
    is_completed = db.Column(db.Boolean, default=False)

    # Offline sync requirements
    updated_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))
    is_deleted = db.Column(db.Boolean, default=False)

    def to_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'description': self.description,
            'is_completed': self.is_completed,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
            'is_deleted': self.is_deleted
        }
