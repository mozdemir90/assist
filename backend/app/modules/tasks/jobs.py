import logging
from datetime import datetime, timezone, timedelta
from app.core.database import db
from app.modules.tasks.models import Task

def deactivate_old_tasks(app):
    """
    Belirli bir süre öncesine ait tamamlanmamış görevleri (is_deleted = True) olarak işaretler.
    Örnek olarak: Son 30 gündür güncellenmeyen görevleri siliyor varsayalım.
    (İhtiyaca göre pasife alma mantığı değişebilir)
    """
    with app.app_context():
        try:
            thirty_days_ago = datetime.now(timezone.utc) - timedelta(days=30)

            # Tamamlanmamış ve son güncellenme tarihi 30 günden eski olan görevler
            old_tasks = Task.query.filter(
                Task.is_completed == False,
                Task.is_deleted == False,
                Task.updated_at < thirty_days_ago
            ).all()

            count = 0
            for task in old_tasks:
                task.is_deleted = True
                task.updated_at = datetime.now(timezone.utc)
                count += 1

            if count > 0:
                db.session.commit()
                app.logger.info(f"{count} adet eski görev başarıyla pasife alındı (soft delete).")
            else:
                app.logger.info("Pasife alınacak eski görev bulunamadı.")

        except Exception as e:
            app.logger.error(f"Eski görevleri pasife alma işlemi sırasında hata oluştu: {str(e)}")
            db.session.rollback()

def register_jobs(scheduler, app):
    """
    Görevleri (jobs) APScheduler'a ekler.
    """
    # Her gece 03:00'te 'deactivate_old_tasks' fonksiyonunu çalıştır
    scheduler.add_job(
        func=deactivate_old_tasks,
        trigger='cron',
        hour=3,
        minute=0,
        args=[app],
        id='job_deactivate_old_tasks',
        replace_existing=True
    )
    app.logger.info("Görev planlayıcıya eklendi: deactivate_old_tasks (Her gece 03:00)")
