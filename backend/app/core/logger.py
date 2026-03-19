import os
import logging
from logging.handlers import RotatingFileHandler
from flask import Flask

def init_logger(app: Flask):
    """
    Uygulama için RotatingFileHandler kullanarak yapısal loglama kurar.
    Loglar 'logs/app.log' dosyasına yazılır, dosya boyutu çok büyümez.
    """
    # Log klasörünün var olduğundan emin olalım
    log_dir = os.path.join(app.root_path, '..', '..', 'logs')
    if not os.path.exists(log_dir):
        os.makedirs(log_dir)

    log_file = os.path.join(log_dir, 'app.log')

    # Handler oluştur (maksimum 10 MB, 5 yedek dosyası)
    file_handler = RotatingFileHandler(log_file, maxBytes=10240000, backupCount=5)

    # Log formatını belirle
    formatter = logging.Formatter(
        '%(asctime)s %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]'
    )
    file_handler.setFormatter(formatter)

    # Log seviyesini ayarla (örneğin DEBUG modundaysa DEBUG, yoksa INFO)
    log_level = logging.DEBUG if app.debug else logging.INFO
    file_handler.setLevel(log_level)

    # Uygulamanın logger'ına ekle
    app.logger.addHandler(file_handler)
    app.logger.setLevel(log_level)
    app.logger.info('Uygulama loglaması başlatıldı.')
