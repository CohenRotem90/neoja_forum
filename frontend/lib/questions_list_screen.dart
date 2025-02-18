import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'question_screen.dart';
import 'new_question_screen.dart';
import 'services/api_service.dart';

class QuestionsListScreen extends StatefulWidget {
  @override
  _QuestionsListScreenState createState() => _QuestionsListScreenState();
}

class _QuestionsListScreenState extends State<QuestionsListScreen> {
  List questions = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  void fetchQuestions() async {
    var data = await ApiService.getQuestions();
    setState(() {
      questions = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          // Expanded list of questions
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                fetchQuestions();
              },
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  var question = questions[index];
                  return ListTile(
                    title: Text(
                      question['title'],
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      question['content'],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              QuestionScreen(questionId: question['_id']),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // Centered "New Question" button under the list
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewQuestionScreen()),
                  ).then((_) => fetchQuestions());
                },
                icon: Icon(Icons.add),
                label: Text('New Question'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
