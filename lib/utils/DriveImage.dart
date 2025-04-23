// Example widget to display the image
import 'package:flutter/material.dart';
import 'package:krishiyan/utils/AppGlobal.dart';

class DriveImage extends StatelessWidget {
  final String imageUrlData;

  const DriveImage({super.key, required this.imageUrlData});

  @override
  Widget build(BuildContext context) {
    String? fileId = AppGlobal.extractCodeFromDriveLink(imageUrlData);
    String imageUrl = 'https://drive.google.com/uc?export=view&id=$fileId';

    return Image.network(
      imageUrl,
      fit: BoxFit.fill,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.error);
      },
    );
  }
}
