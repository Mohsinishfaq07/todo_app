import 'package:diary_app/classes/classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmojiPickerWidget extends ConsumerWidget {
  const EmojiPickerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> emojis = ["😢", "😞", "😐", "😊", "😄"];

    return AlertDialog(
      title: const Text("Mood Scale"),
      content: SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        height: 80, // Give it a fixed height
        child: ListView.builder(
          itemCount: emojis.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                ref.read(diaryProvider.selectedEmoji.notifier).state =
                    emojis[index];
              },
              child: Consumer(
                builder: (_, WidgetRef ref, __) {
                  final selectedEmoji = ref.watch(diaryProvider.selectedEmoji);
                  return Container(
                    width: 60,
                    height: 100,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: selectedEmoji == emojis[index]
                          ? Colors.greenAccent
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          emojis[index],
                          style: const TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
