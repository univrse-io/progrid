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

    // return Stack(
    //   children: [
    //     // fullscreen barrier
    //     ModalBarrier(
    //       color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
    //       dismissible: false,
    //     ),

    //     // animated loader
    //     AnimatedOpacity(
    //       opacity: 1.0,
    //       duration: const Duration(milliseconds: 300),
    //       child: Center(
    //         child: SizedBox(
    //           width:40.0,
    //           height: 40.0,
    //           child: CircularProgressIndicator(
    //             color: Theme.of(context).colorScheme.primary,
    //             strokeWidth: 4.0,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
