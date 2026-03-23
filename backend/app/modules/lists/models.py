from app.core.database import db
import uuid
from datetime import datetime, timezone

def generate_uuid():
    return str(uuid.uuid4())

class List(db.Model):
    __tablename__ = 'lists'

    id = db.Column(db.String(36), primary_key=True, default=generate_uuid)
    name = db.Column(db.String(255), nullable=False)
    color = db.Column(db.String(7), nullable=True) # Hex color code
<<<<<<< Updated upstream

    user_id = db.Column(db.String(36), db.ForeignKey('users.id'), nullable=False)

=======

    user_id = db.Column(db.String(36), db.ForeignKey('users.id'), nullable=False)

>>>>>>> Stashed changes
    # Offline sync requirements
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))
    is_deleted = db.Column(db.Boolean, default=False)
<<<<<<< Updated upstream

=======

>>>>>>> Stashed changes
    tasks = db.relationship('Task', backref='list', lazy=True)

    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'color': self.color,
            'user_id': self.user_id,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
            'is_deleted': self.is_deleted
        }
