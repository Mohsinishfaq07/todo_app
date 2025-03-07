import 'package:diary_app/classes/classes.dart';
import 'package:diary_app/enums/global_enums.dart';
import 'package:diary_app/model/notes_model/notes_model.dart';
import 'package:diary_app/services/databse/database.dart';
import 'package:diary_app/widgets/custom_input/custom_input_field.dart';
import 'package:diary_app/widgets/dialogue_boxes/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTaskScreen extends ConsumerWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('add task build');
    DatabaseService databaseService = DatabaseService();
    void addTask({
      required BuildContext context,
      required WidgetRef widgetRef,
    }) {
      String title = widgetRef.watch(diaryProvider.titleController).text.trim();
      String description =
          widgetRef.watch(diaryProvider.descriptionController).text.trim();
      String modeEmoji = widgetRef.watch(diaryProvider.selectedEmoji);

      if (title.isEmpty || description.isEmpty || modeEmoji.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Please enter a title , description and emoji')),
        );
        return;
      }

      debugPrint('Title: $title');
      debugPrint('Description: $description');
      databaseService.insertTask(
          DiaryModel(title: title, description: description, emoji: modeEmoji));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task added successfully!')),
      );
      Navigator.pop(context);
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (val, result) {
        ref.read(diaryProvider.titleController.notifier).state =
            TextEditingController();
        ref.read(diaryProvider.descriptionController.notifier).state =
            TextEditingController();
        ref.read(diaryProvider.selectedEmoji.notifier).state = '';
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 15,
              children: [
                MyTextField(
                  inpType: InputFieldType.title,
                  hintText: 'Enter Title',
                ),
                SizedBox(height: 20), // Spacing between fields
                MyTextField(
                  inpType: InputFieldType.description,
                  hintText: 'Enter description',
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer(
                      builder: (_, WidgetRef widgetRef, __) {
                        return ElevatedButton(
                          onPressed: () {
                            addTask(context: context, widgetRef: widgetRef);
                          },
                          child: Text('Add Task'),
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => EmojiPickerWidget(),
                        );
                      },
                      child: Text('Select Mode'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
