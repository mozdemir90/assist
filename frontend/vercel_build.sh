#!/bin/bash

# Vercel sunucusunda Flutter Web uygulaması derlemek için script

echo "-> Adım 1: Flutter SDK (stable branch) indiriliyor..."
# Eğer daha önceden clone'lanmışsa tekrar clone'lamayı önle
if [ ! -d "./flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 ./flutter
else
  echo "Flutter klasörü zaten mevcut, atlanıyor."
fi

echo "-> Adım 2: Flutter path ayarlamaları yapılıyor..."
export PATH="$PATH:`pwd`/flutter/bin"

echo "-> Adım 3: Bağımlılıklar indiriliyor (flutter pub get)..."
flutter pub get

echo "-> Adım 4: Flutter Web uygulaması derleniyor (release mode)..."
flutter build web --release

echo "-> Başarılı: Derleme tamamlandı!"
