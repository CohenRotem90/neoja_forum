import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'custom_app_bar.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class QuestionScreen extends StatefulWidget {
  final String questionId;

  QuestionScreen({required this.questionId});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  Map<String, dynamic> question = {};
  List<dynamic> answers = [];
  IO.Socket? socket;
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchQuestion();
    setupSocket();
  }

  void fetchQuestion() async {
    try {
      var data = await ApiService.getQuestion(widget.questionId);
      setState(() {
        question = data;
        answers = data['answers'] ?? [];
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching question data')));
    }
  }

  void setupSocket() {
    socket = IO.io(
      'http://localhost:5000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      joinRoom(widget.questionId);
    });

    socket!.onDisconnect((_) {});

    socket!.on('new_answer', (data) {
      if (data['question_id'] == widget.questionId) {
        setState(() {
          answers.add(data['answer']);
        });
      }
    });
  }

  void joinRoom(String room) {
    socket!.emit('join', {'room': room});
  }

  void addAnswer(String content) async {
    if (content.isNotEmpty) {
      try {
        await ApiService.addAnswer(widget.questionId, content);
        _answerController.clear();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error submitting answer')));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter an answer')));
    }
  }

  @override
  void dispose() {
    socket?.disconnect();
    socket?.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (question.isEmpty) {
      return Scaffold(
        appBar: CustomAppBar(automaticallyImplyLeading: true),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(automaticallyImplyLeading: true),
      body: Column(
        children: [
          // Question title
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              question['title'] ?? '',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              question['content'] ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Divider(),
          // List of answers
          Expanded(
            child:
                answers.isNotEmpty
                    ? ListView.builder(
                      itemCount: answers.length,
                      itemBuilder: (context, index) {
                        var answer = answers[index];
                        return ListTile(
                          title: Text(
                            answer['content'],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      },
                    )
                    : Center(
                      child: Text(
                        'No answers yet. Be the first to answer!',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
          ),
          Divider(),
          // Input field to add a new answer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                // Answer input
                Expanded(
                  child: TextField(
                    controller: _answerController,
                    decoration: InputDecoration(labelText: 'Your Answer'),
                  ),
                ),
                SizedBox(width: 8),
                // Send button
                ElevatedButton(
                  onPressed: () {
                    addAnswer(_answerController.text.trim());
                  },
                  child: Icon(Icons.send),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
