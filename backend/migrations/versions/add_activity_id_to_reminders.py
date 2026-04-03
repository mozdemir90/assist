"""add activity_id to reminders

Revision ID: c1a2b3d4e5f6
Revises: 8772e8103424
Create Date: 2026-04-03

"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = 'c1a2b3d4e5f6'
down_revision = '8772e8103424'
branch_labels = None
depends_on = None


def upgrade():
    # Check if the column already exists before adding
    conn = op.get_bind()
    inspector = sa.inspect(conn)
    columns = [col['name'] for col in inspector.get_columns('reminders')]
    
    if 'activity_id' not in columns:
        with op.batch_alter_table('reminders', schema=None) as batch_op:
            batch_op.add_column(sa.Column('activity_id', sa.String(length=36), nullable=True))


def downgrade():
    with op.batch_alter_table('reminders', schema=None) as batch_op:
        batch_op.drop_column('activity_id')
