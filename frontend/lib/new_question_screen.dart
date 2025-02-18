import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'services/api_service.dart';

class NewQuestionScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void createQuestion(BuildContext context) async {
    if (_titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty) {
      try {
        await ApiService.createQuestion(
          _titleController.text,
          _contentController.text,
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating question')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both title and content')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(automaticallyImplyLeading: true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title input
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 8),
            // Content input
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            // Submit button
            ElevatedButton(
              onPressed: () => createQuestion(context),
              child: Text('Post Question'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                textStyle: TextStyle(fontSize: 18),
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
