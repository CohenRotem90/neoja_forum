import eventlet

eventlet.monkey_patch()
from flask_cors import CORS
from flask import Flask, request, jsonify
from flask_pymongo import PyMongo
from flask_socketio import SocketIO, join_room
from bson.objectid import ObjectId
import os

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes
socketio = SocketIO(app, cors_allowed_origins="*")

# mongo url for local run
# app.config["MONGO_URI"] = "mongodb://localhost:27017/qna_db"

# mongo url for docker run
app.config["MONGO_URI"] = os.getenv("MONGO_URI", "mongodb://localhost:27017/qna_db")

mongo = PyMongo(app)




# Handle client joining a room
@socketio.on('join')
def on_join(data):
    room = data['room']
    join_room(room)
    print(f'Client joined room: {room}')


# Create a new question
@app.route('/questions', methods=['POST'])
def create_question():
    data = request.get_json()
    title = data.get('title')
    content = data.get('content')

    if not title or not content:
        return jsonify({'error': 'Title and content are required.'}), 400

    question = {
        'title': title,
        'content': content,
        'answers': []
    }
    print("Question created")
    result = mongo.db.questions.insert_one(question)
    question['_id'] = str(result.inserted_id)
    return jsonify(question), 201


# Retrieve all questions
@app.route('/questions', methods=['GET'])
def get_questions():
    questions = mongo.db.questions.find().sort('_id', -1)  # From newest to oldest
    result = []
    for q in questions:
        q['_id'] = str(q['_id'])
        result.append(q)
    return jsonify(result), 200


# Retrieve a single question by ID
@app.route('/questions/<question_id>', methods=['GET'])
def get_question(question_id):
    try:
        question = mongo.db.questions.find_one({'_id': ObjectId(question_id)})
        if question:
            question['_id'] = str(question['_id'])
            # Convert ObjectIds in answers if they have '_id' field
            for answer in question.get('answers', []):
                if '_id' in answer:
                    answer['_id'] = str(answer['_id'])
            return jsonify(question), 200
        else:
            return jsonify({'error': 'Question not found'}), 404
    except Exception as e:
        return jsonify({'error': 'Invalid question ID'}),


# Update a question
@app.route('/questions/<question_id>', methods=['PUT'])
def update_question(question_id):
    data = request.get_json()
    mongo.db.questions.update_one({'_id': ObjectId(question_id)}, {'$set': data})
    return jsonify({'message': 'Question updated.'}), 200


# Delete a question
@app.route('/questions/<question_id>', methods=['DELETE'])
def delete_question(question_id):
    mongo.db.questions.delete_one({'_id': ObjectId(question_id)})
    return jsonify({'message': 'Question deleted.'}), 200


# Add an answer to a question
@app.route('/questions/<question_id>/answers', methods=['POST'])
def add_answer(question_id):
    data = request.get_json()
    content = data.get('content')

    if not content:
        return jsonify({'error': 'Content is required.'}), 400

    answer = {
        '_id': str(ObjectId()),
        'content': content
    }
    mongo.db.questions.update_one(
        {'_id': ObjectId(question_id)},
        {'$push': {'answers': answer}}
    )

    # Emit the new answer to the room with the question_id
    socketio.emit('new_answer', {'question_id': question_id, 'answer': answer}, room=str(question_id))
    return jsonify(answer), 201


# Retrieve answers for a question
@app.route('/questions/<question_id>/answers', methods=['GET'])
def get_answers(question_id):
    question = mongo.db.questions.find_one({'_id': ObjectId(question_id)})
    if not question:
        return jsonify({'error': 'Question not found.'}), 404
    return jsonify(question.get('answers')), 200


if __name__ == '__main__':
    socketio.run(app, host="0.0.0.0", port=5000, debug=True)
