import 'package:flutter/material.dart';

class MyAlert extends StatelessWidget {
  final String title;
  final String content;

  final double? width;
  final double? height;

  const MyAlert({
    super.key,
    required this.title,
    required this.content,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Confirm"),
        ),
      ],
      elevation: 24,
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
