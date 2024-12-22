import 'package:flutter/material.dart';
import 'package:progrid/utils/themes.dart';

class DialogUtils {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // cannot be dismissed on tap
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  static void showImageDialog(BuildContext context, String imageUrl, Future<void> Function(String) onDownload) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Stack(
                children: [
                  // image object
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.error, color: AppColors.red),
                      );
                    },
                  ),

                  // download button
                  Positioned(
                    bottom: 7,
                    right: 7,
                    child: FloatingActionButton(
                      onPressed: () => onDownload(imageUrl),
                      child: Icon(Icons.download),
                      mini: true,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
