import 'package:diary_app/classes/classes.dart';
import 'package:diary_app/enums/global_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyTextField extends ConsumerWidget {
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final double? width;
  final double? height;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? borderRadius;
  final Color? containerColor;
  final InputFieldType inpType;
  final int maxLines;

  const MyTextField(
      {super.key,
      this.hintText,
      this.keyboardType,
      this.textInputAction,
      this.width,
      this.height,
      this.prefixIcon,
      this.suffixIcon,
      this.borderRadius,
      this.containerColor,
      required this.inpType,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FocusNode focusNode = FocusNode();
    final borderRadiusValue = borderRadius ?? 10;
    final containerColorValue = containerColor ?? Colors.grey.withOpacity(0.2);
    return Consumer(
      builder: (context, ref, child) {
        final controller = getController(inputFieldType: inpType, ref: ref);
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: containerColorValue,
            borderRadius: BorderRadius.circular(borderRadiusValue),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: TextField(
            focusNode: focusNode,
            onTapOutside: (val) {
              FocusScope.of(context).unfocus();
            },
            controller: controller,
            onChanged: (val) {
              // Update the state with the new value
            },
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
            ),
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            maxLines: maxLines,
          ),
        );
      },
    );
  }

  TextEditingController getController({
    required InputFieldType inputFieldType,
    required WidgetRef ref,
  }) {
    if (inputFieldType == InputFieldType.title) {
      return ref.watch(diaryProvider.titleController);
    } else {
      return ref.watch(diaryProvider.descriptionController);
    }
  }
}
