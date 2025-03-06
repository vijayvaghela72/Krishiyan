
// Example widget to display the image
import 'package:flutter/material.dart';
import 'package:krishiyan/utils/AppGlobal.dart';

class DriveImage extends StatelessWidget {
  final String imageUrlData;

  const DriveImage({super.key, required this.imageUrlData});

  @override
  Widget build(BuildContext context) {
    // Extract the file ID from the provided Google Drive URL
    String? fileId = AppGlobal.extractCodeFromDriveLink(imageUrlData);
    // Construct the full image URL
    String imageUrl = 'https://drive.google.com/uc?export=view&id=$fileId';

    return Image.network(
      imageUrl,
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
      fit: BoxFit.fill,
      errorBuilder: (context, error, stackTrace) {
        // Handle any errors that occur while loading the image
        return const Icon(Icons.error);
      },
    );
  }
}