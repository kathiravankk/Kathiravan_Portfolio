import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';

class CategoryCard extends StatelessWidget {
  final List<Color> colors;
  final int count;
  final String categoryName;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.colors,
    required this.count,
    required this.categoryName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        width: 150,
        height: 130,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(23),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: Stack(
            children: [
              // Top-left halftone overlay
              Positioned(
                top: -50,
                left: -50,
                child: Opacity(
                  opacity: 0.25,
                  child: Image.asset(
                    AssetImages.halftoneOverlay, // add to AssetImages
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
              // Bottom-right halftone overlay
              Positioned(
                bottom: -50,
                right: -50,
                child: Opacity(
                  opacity: 0.25,
                  child: Image.asset(
                    AssetImages.halftoneOverlay,
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
              // Content
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 12,
                  children: [
                    // Count badge circle
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.last.withValues(alpha: 0.45),
                      ),
                      alignment: Alignment.center,
                      child: _AnimatedCount(count: count),
                    ),
                    // Category name
                    Text(
                      categoryName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppStyles.customTextStyle(
                        size: 13,
                        lineSpace: 1.3,
                        color: Colors.white,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedCount extends StatelessWidget {
  final int count;
  const _AnimatedCount({required this.count});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: count == 0 ? 1 : count.toDouble()),
      duration: const Duration(milliseconds: 900),
      builder: (context, value, child) {
        return Text(
          count == 0 ? "0" : value.toInt().toString(),
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.bold,
            fontFamily: "Roboto",
          ),
        );
      },
    );
  }
}