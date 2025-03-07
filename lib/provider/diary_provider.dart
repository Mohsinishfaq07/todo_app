import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiaryProvider {
  final titleController = StateProvider<TextEditingController>((val) {
    return TextEditingController();
  });

  final descriptionController = StateProvider<TextEditingController>((val) {
    return TextEditingController();
  });
  final selectedEmoji = StateProvider<String>((val) {
    return '';
  });
}
