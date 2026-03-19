# Application Requirements Baseline

This document serves as the architectural guide and baseline requirements for our cross-platform (Web & Mobile) offline-first task, daily activity, and reminder tracking application.

## 1. Functional Requirements (Core Features)

* **Authentication & Authorization:** Users must be able to register and log in securely using email and password. The session should be maintained via JWT.
* **Task Management:** Users can create, read, update, and delete (CRUD) tasks. Tasks should have states (e.g., pending, completed).
* **Reminders:** Users can set, edit, and manage time-and-date-based reminders.
* **Activity Tracking:** Users can log and list their daily activities.
* **Offline Mode (Offline-First):** The mobile application must allow users to create tasks and reminders even without an internet connection, storing data locally using SQLite (Drift).
* **Data Synchronization:** When the device connects to the internet, all local changes (inserts, updates, deletes) must automatically sync with the backend server.

## 2. Non-Functional Requirements (System Quality)

* **Security:** Passwords must be hashed (never stored in plain text). All user-specific API endpoints must be protected with token-based authorization.
* **Performance:** The Flutter app must run smoothly at 60 FPS with instant UI feedback. API response times should ideally be kept under 200ms.
* **Scalability & Modularity:** The backend must maintain its Flask Blueprint structure so future modules (e.g., finance, education) can be added without breaking the core. Database changes must be strictly managed via migrations (Alembic/Flask-Migrate).
* **Reliability:** The app must be fault-tolerant against network drops, relying on its offline-first architecture to prevent data loss.
* **Cross-Platform:** The codebase must support seamless deployment to both iOS and Android via Flutter.
* **Documentation:** The `API_DOCS.md` must be kept strictly up-to-date with any endpoint changes.
