import 'package:diary_app/classes/classes.dart';
import 'package:diary_app/enums/global_enums.dart';
import 'package:diary_app/model/notes_model/notes_model.dart';
import 'package:diary_app/services/databse/database.dart';
import 'package:diary_app/widgets/custom_input/custom_input_field.dart';
import 'package:diary_app/widgets/dialogue_boxes/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

bool isInitialized = false;

class EditTaskScreen extends ConsumerWidget {
  final DiaryModel diaryModel;
  const EditTaskScreen({super.key, required this.diaryModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('Edit Task Screen Build');

    final titleController = ref.watch(diaryProvider.titleController);
    final descriptionController =
        ref.watch(diaryProvider.descriptionController);
    String selectedEmoji = ref.watch(diaryProvider.selectedEmoji);
    final databaseService = DatabaseService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isInitialized) {
        titleController.text = diaryModel.title;
        descriptionController.text = diaryModel.description;
        selectedEmoji = ref.read(diaryProvider.selectedEmoji.notifier).state =
            diaryModel.emoji;
        isInitialized = true;
      } else {
        debugPrint('Edit Task Screen already initialized');
      }
    });

    void updateTask() {
      String title = titleController.text.trim();
      String description = descriptionController.text.trim();

      if (title.isEmpty || description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a title, description')),
        );
        return;
      }

      debugPrint('Title: $title');
      debugPrint('Description: $description');

      databaseService.updateTask(DiaryModel(
        title: title,
        description: description,
        emoji: selectedEmoji,
        id: diaryModel.id,
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated successfully!')),
      );
      Navigator.pop(context);
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (val, res) {
        isInitialized = false;
        ref.read(diaryProvider.titleController.notifier).state =
            TextEditingController();
        ref.read(diaryProvider.descriptionController.notifier).state =
            TextEditingController();
        ref.read(diaryProvider.selectedEmoji.notifier).state = '';
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Edit Task")),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextField(
                    inpType: InputFieldType.title,
                    hintText: 'Enter Title',
                    // Attach controller
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    inpType: InputFieldType.description,
                    hintText: 'Enter description',
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: updateTask,
                        child: const Text('Update Task'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const EmojiPickerWidget(),
                          );
                        },
                        child: const Text('Update Mood'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (selectedEmoji.isNotEmpty) // Show selected emoji
                    Text(
                      "Selected Mood: $selectedEmoji",
                      style: const TextStyle(fontSize: 18),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
