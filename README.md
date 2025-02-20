# Neoja Q&A Forum Application

A real-time forum application where users can post questions, answer them, and see new responses immediately. The application is built using **Flutter** for the frontend and **Flask** with **Socket.IO** for the backend. MongoDB is used as the database, and the entire application can be run using Docker and Docker Compose.

---

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Running the Application](#running-the-application)
  - [Using Docker and Docker Compose](#using-docker-and-docker-compose)
  - [Running Without Docker](#running-without-docker)
- [API Endpoints](#api-endpoints)
- [WebSocket Events](#websocket-events)

---

## Features

- **Real-Time Updates**: Users can see new answers to questions immediately without refreshing the page.
- **Post Questions**: Users can post new questions to the forum.
- **Answer Questions**: Users can post answers to existing questions.
- **Responsive UI**: The frontend is built with Flutter, providing a responsive and attractive user interface.
- **Persistent Data**: All data is stored in MongoDB.
- **Dockerized Deployment**: Easy setup and deployment using Docker and Docker Compose.

---

## Technologies Used

- **Frontend**: Flutter (Dart)
- **Backend**: Flask (Python) with Flask-SocketIO
- **Database**: MongoDB
- **Real-Time Communication**: Socket.IO
- **Containerization**: Docker and Docker Compose

---

## Installation

### Clone the Repository

```bash
git clone https://github.com/yourusername/neoja-qna-forum.git
cd neoja-qna-forum
```

---

## Running the Application

### Using Docker and Docker Compose

#### Build and Start the Services

From the root directory of the project, run:

```bash
docker-compose up --build
```

- This command builds the Docker images and starts all the services defined in `docker-compose.yml`.

#### Access the Application

- Open your web browser and navigate to `http://localhost`.

### Running Without Docker

#### Backend Setup

1. **Install Python 3.12 or higher**.

2. **Create a Virtual Environment**:

   ```bash
   cd backend
   python -m venv venv
   ```

3. **Activate the Virtual Environment**:

   - **Windows**:

     ```bash
     venv\Scripts\activate
     ```

   - **macOS/Linux**:

     ```bash
     source venv/bin/activate
     ```

4. **Install Dependencies**:

   ```bash
   pip install -r requirements.txt
   ```

5. **Run the Flask App**:

   ```bash
   python app.py
   ```

     - Ensure that the Flask app is running on `http://0.0.0.0:5000`.

#### Frontend Setup

1. **Install Flutter SDK**: Follow the instructions on [Flutter's official website](https://flutter.dev/docs/get-started/install).

2. **Navigate to the Frontend Directory**:

   ```bash
   cd frontend
   ```

3. **Get Flutter Dependencies**:

   ```bash
   flutter pub get
   ```

4. **Update API Base URL**:

   - In `lib/services/api_service.dart`, set the `baseUrl` to point to the backend URL:

     ```dart
     // lib/services/api_service.dart
     class ApiService {
       static String baseUrl = 'http://localhost:5000';
       // ... rest of the code
     }
     ```

5. **Run the Flutter App**:

   - For web:

     ```bash
     flutter run -d chrome
     ```

   - For mobile emulator or physical device:

     ```bash
     flutter run
     ```

---

## API Endpoints

### Questions

- **GET /questions**: Retrieve all questions.
- **POST /questions**: Create a new question.
  - **Body Parameters**:
    - `title` (string): Title of the question.
    - `content` (string): Content of the question.
- **GET /questions/<question_id>**: Retrieve a specific question by ID.
- **PUT /questions/<question_id>**: Update a specific question.
  - **Body Parameters**:
    - `title` (string): Updated title of the question.
    - `content` (string): Updated content of the question.
- **DELETE /questions/<question_id>**: Delete a specific question.

### Answers

- **POST /questions/<question_id>/answers**: Add an answer to a question.
  - **Body Parameters**:
    - `content` (string): Content of the answer.
- **GET /questions/<question_id>/answers**: Retrieve all answers for a specific question.

---

## WebSocket Events

- **Event**: `new_answer`
  - **Description**: Broadcasts a new answer to all clients connected to the room corresponding to the question ID.
  - **Data**:
    - `question_id` (string): ID of the question.
    - `answer` (object): The new answer added.

- **Event**: `join`
  - **Description**: Client requests to join a room (question ID).
  - **Data**:
    - `room` (string): The room (question ID) to join.

---

**Enjoy using the Neoja Q&A Forum Application!**

---
