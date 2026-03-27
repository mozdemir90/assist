#!/bin/bash
set -e

echo "Starting Vercel Build Script..."

if [ "$VERCEL_PROJECT_DIR" == "frontend" ] || [ -d "frontend" ] && [ -z "$VERCEL_PROJECT_DIR" ]; then
    echo "Building Flutter Web Frontend..."
    cd frontend
    if [ ! -d "flutter" ]; then
        git clone https://github.com/flutter/flutter.git -b stable
    fi
    export PATH="$PATH:`pwd`/flutter/bin"
    flutter precache
    flutter clean
    flutter pub get
    flutter build web --release --dart-define=API_URL=/api
    echo "Frontend Build Completed."
    cd ..
fi

if [ "$VERCEL_PROJECT_DIR" == "backend" ] || [ -d "backend" ] && [ -z "$VERCEL_PROJECT_DIR" ]; then
    echo "Building Python Flask Backend..."
    cd backend
    pip install -r requirements.txt
    echo "Backend Build Completed."
    cd ..
fi
