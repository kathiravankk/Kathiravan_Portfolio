import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';

class FullScreenImagePreview extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePreview({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor_2,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor_2,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 5,
          child: Hero(
            tag: imageUrl,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },

              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.broken_image,
                  color: AppColors.whiteColor,
                  size: 80,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
