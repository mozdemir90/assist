# Backend API Documentation

This document describes the available API endpoints for the backend service. All endpoints that require authentication must include a JWT in the `Authorization` header as a Bearer token.

## Base URL
`/api`

## Authentication

### Register
Register a new user.
- **Endpoint:** `POST /auth/register`
- **Request Body:**
  ```json
  {
    "username": "johndoe",
    "email": "johndoe@example.com",
    "password": "securepassword"
  }
  ```
- **Response:** `201 Created`
  ```json
  {
    "message": "User registered successfully",
    "user": { ... }
  }
  ```

### Login
Authenticate user and retrieve JWT token.
- **Endpoint:** `POST /auth/login`
- **Request Body:**
  ```json
  {
    "username": "johndoe",
    "password": "securepassword"
  }
  ```
- **Response:** `200 OK`
  ```json
  {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": { ... }
  }
  ```

---

## Authorization

All endpoints below require an `Authorization` header containing the JWT token returned from the `/auth/login` endpoint.

**Header Format:**
```
Authorization: Bearer <token>
```

---

## Tasks

### Get Tasks
Retrieve all non-deleted tasks for the authenticated user.
- **Endpoint:** `GET /tasks/`
- **Response:** `200 OK`
  ```json
  [
    {
      "id": "uuid",
      "title": "Task 1",
      "description": "Task 1 description",
      "is_completed": false,
      "user_id": "uuid",
      "updated_at": "2023-10-25T12:00:00Z",
      "is_deleted": false
    }
  ]
  ```

### Create Task
Create a new task. The client can provide a generated UUID to support offline-first sync strategies.
- **Endpoint:** `POST /tasks/`
- **Request Body:**
  ```json
  {
    "id": "optional-client-generated-uuid",
    "title": "New Task",
    "description": "Task description",
    "is_completed": false
  }
  ```
- **Response:** `201 Created`
  ```json
  { ... }
  ```

### Update Task
Update an existing task.
- **Endpoint:** `PUT /tasks/<task_id>`
- **Request Body:** (Include only fields to update)
  ```json
  {
    "title": "Updated Task Title",
    "is_completed": true,
    "is_deleted": false
  }
  ```
- **Response:** `200 OK`
  ```json
  { ... }
  ```

### Delete Task
Soft-delete a task (used for sync).
- **Endpoint:** `DELETE /tasks/<task_id>`
- **Response:** `200 OK`
  ```json
  {
    "message": "Task marked as deleted"
  }
  ```

---

## Activities

### Get Activities
Retrieve all non-deleted activities for the authenticated user.
- **Endpoint:** `GET /activities/`
- **Response:** `200 OK`
  ```json
  [
    {
      "id": "uuid",
      "title": "Reading",
      "description": "Read a book",
      "start_time": "2023-10-25T10:00:00Z",
      "end_time": "2023-10-25T11:00:00Z",
      "duration": 3600,
      "user_id": "uuid",
      "updated_at": "2023-10-25T12:00:00Z",
      "is_deleted": false
    }
  ]
  ```

### Create Activity
Create a new activity. Start/end times should be in ISO-8601 format.
- **Endpoint:** `POST /activities/`
- **Request Body:**
  ```json
  {
    "title": "Reading",
    "description": "Read a book",
    "start_time": "2023-10-25T10:00:00Z",
    "end_time": "2023-10-25T11:00:00Z",
    "duration": 3600
  }
  ```
- **Response:** `201 Created`
  ```json
  { ... }
  ```

### Update Activity
Update an existing activity.
- **Endpoint:** `PUT /activities/<activity_id>`
- **Request Body:** (Include only fields to update)
  ```json
  {
    "duration": 4000
  }
  ```
- **Response:** `200 OK`
  ```json
  { ... }
  ```

### Delete Activity
Soft-delete an activity.
- **Endpoint:** `DELETE /activities/<activity_id>`
- **Response:** `200 OK`
  ```json
  {
    "message": "Activity marked as deleted"
  }
  ```

---

## Reminders

### Get Reminders
Retrieve all non-deleted reminders for the authenticated user.
- **Endpoint:** `GET /reminders/`
- **Response:** `200 OK`
  ```json
  [
    {
      "id": "uuid",
      "title": "Drink Water",
      "message": "Time to hydrate!",
      "trigger_time": "2023-10-25T15:00:00Z",
      "is_sent": false,
      "task_id": null,
      "activity_id": null,
      "user_id": "uuid",
      "updated_at": "2023-10-25T12:00:00Z",
      "is_deleted": false
    }
  ]
  ```

### Create Reminder
Create a new reminder. `title` and `trigger_time` are required.
- **Endpoint:** `POST /reminders/`
- **Request Body:**
  ```json
  {
    "title": "Drink Water",
    "message": "Time to hydrate!",
    "trigger_time": "2023-10-25T15:00:00Z"
  }
  ```
- **Response:** `201 Created`
  ```json
  { ... }
  ```

### Update Reminder
Update an existing reminder.
- **Endpoint:** `PUT /reminders/<reminder_id>`
- **Request Body:** (Include only fields to update)
  ```json
  {
    "is_sent": true
  }
  ```
- **Response:** `200 OK`
  ```json
  { ... }
  ```

### Delete Reminder
Soft-delete a reminder.
- **Endpoint:** `DELETE /reminders/<reminder_id>`
- **Response:** `200 OK`
  ```json
  {
    "message": "Reminder marked as deleted"
  }
  ```
