// Example widget to display the image
import 'package:flutter/material.dart';
import 'package:krishiyan/helper/app_global.dart';

class DriveImage extends StatelessWidget {
  final String imageUrlData;

  const DriveImage({super.key, required this.imageUrlData});

  @override
  Widget build(BuildContext context) {
    String? fileId = AppGlobal.extractCodeFromDriveLink(imageUrlData);
    String imageUrl = 'https://drive.google.com/uc?export=view&id=$fileId';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              backgroundColor: Colors.black,
              body: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ),
          ),
        );
      },
      child: Image.network(
        imageUrl,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      ),
    );
  }
}
