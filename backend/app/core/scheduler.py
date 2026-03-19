from apscheduler.schedulers.background import BackgroundScheduler
import atexit

# Global scheduler instance
scheduler = BackgroundScheduler()

def init_scheduler(app):
    """
    BackgroundScheduler'ı başlatır ve uygulama bağlamı (app context) ile görevlerin çalışmasını sağlar.
    Örnek görevleri bu fonksiyon içinde scheduler'a ekleyebiliriz.
    """

    # scheduler henüz çalışmıyorsa başlat
    if not scheduler.running:
        scheduler.start()
        app.logger.info("APScheduler (BackgroundScheduler) başlatıldı.")

        # Uygulama kapandığında scheduler'ı da kapat
        atexit.register(lambda: scheduler.shutdown(wait=False))

        # Görevleri içe aktar ve kaydet
        from app.modules.tasks.jobs import register_jobs
        register_jobs(scheduler, app)
