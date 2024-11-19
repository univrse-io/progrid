import 'package:flutter/material.dart';

class MyLoadingIndicator extends StatelessWidget {
  const MyLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // fullscreen backdrop
        Container(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
          width: double.infinity,
          height: double.infinity,
        ),

        // indicator
        const Center(
          child: CircularProgressIndicator(),
        )
      ],
    );
  }
}
