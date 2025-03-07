import 'package:diary_app/model/notes_model/notes_model.dart';
import 'package:diary_app/services/databse/database.dart';
import 'package:diary_app/view/add_task/add_task.dart';
import 'package:diary_app/view/edit_task/edit_task.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseHelper = DatabaseService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Diary'),
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskScreen()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
          child: StreamBuilder<List<DiaryModel>>(
        stream: databaseHelper.getTasksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks found.'));
          } else {
            final notes = snapshot.data!;

            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.description),
                  trailing: SizedBox(
                    width: 115,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(note.emoji),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            await databaseHelper.deleteTask(note.id!);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditTaskScreen(diaryModel: note),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      )),
    );
  }
}
