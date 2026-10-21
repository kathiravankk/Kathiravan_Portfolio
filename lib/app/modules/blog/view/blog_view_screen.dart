import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/data/models/blog/blog_model.dart';
import 'package:internsharks/app/modules/blog/controller/blog_controller.dart';

class BlogViewScreen extends StatelessWidget {
  const BlogViewScreen({super.key});

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final BlogController blogController = Get.find<BlogController>();

    return Obx(() {
      final blog = blogController.selectedBlog.value;
      if (blog == null) {
        return const Scaffold(
          backgroundColor: AppColors.appBgColor,
          body: Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        );
      }

      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.appBackgroundImg),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              // Sliver AppBar with cover image
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: AppColors.appBgColor,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.whiteColor,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Cover image
                      blog.coverImages != null &&
                              blog.coverImages!.isNotEmpty &&
                              blog.coverImages!.startsWith('http')
                          ? Image.network(
                              blog.coverImages!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _buildCoverPlaceholder(),
                            )
                          : _buildCoverPlaceholder(),

                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),

                      // Title at bottom of image
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (blog.status == 'published')
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'PUBLISHED',
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            Text(
                              blog.title ?? '',
                              style: const TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Body content
              SliverToBoxAdapter(
                child: _buildContent(blog),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCoverPlaceholder() {
    return Container(
      color: AppColors.fieldBgColor,
      child: const Center(
        child: Icon(
          Icons.article_outlined,
          color: AppColors.primaryColor,
          size: 48,
        ),
      ),
    );
  }

  Widget _buildContent(BlogModel blog) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meta row
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.primaryColor,
                size: 13,
              ),
              const SizedBox(width: 5),
              Text(
                _formatDate(blog.createdAt),
                style: TextStyle(
                  color: AppColors.lightColorText.withOpacity(0.65),
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.access_time_rounded,
                color: AppColors.primaryColor,
                size: 13,
              ),
              const SizedBox(width: 5),
              Text(
                '5 min read',
                style: TextStyle(
                  color: AppColors.lightColorText.withOpacity(0.65),
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Short description
          if (blog.shortDescription != null &&
              blog.shortDescription!.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.2),
                ),
              ),
              child: Text(
                blog.shortDescription!,
                style: TextStyle(
                  color: AppColors.whiteColor.withOpacity(0.75),
                  fontSize: 13.5,
                  fontFamily: 'Inter',
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

          // Content blocks
          if (blog.content != null)
            ...blog.content!.map((block) => _buildContentBlock(block)),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildContentBlock(BlogContent block) {
    switch (block.type) {
      case 'heading':
        return _buildHeading(block.text);
      case 'paragraph':
        return _buildParagraph(block.text);
      case 'image':
        return _buildImageBlock(block);
      case 'list':
        return _buildList(block);
      case 'quote':
        return _buildQuote(block);
      case 'code':
        return _buildCode(block);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHeading(String? text) {
    if (text == null || text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.whiteColor,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildParagraph(String? text) {
    if (text == null || text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.whiteColor.withOpacity(0.78),
          fontSize: 14,
          fontFamily: 'Inter',
          height: 1.7,
        ),
      ),
    );
  }

  Widget _buildImageBlock(BlogContent block) {
    final images = block.images;
    if (images == null || images.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (images.length == 1)
            _buildSingleImage(images.first.url)
          else
            _buildImageGrid(images),
          if (block.caption != null && block.caption!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                block.caption!,
                style: TextStyle(
                  color: AppColors.lightColorText.withOpacity(0.5),
                  fontSize: 11,
                  fontFamily: 'Inter',
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSingleImage(String? url) {
    if (url == null || url.isEmpty || !url.startsWith('http')) {
      return const SizedBox.shrink();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => Container(
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.fieldBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(Icons.broken_image_outlined,
                color: AppColors.primaryColor, size: 36),
          ),
        ),
      ),
    );
  }

  Widget _buildImageGrid(List<BlogImage> images) {
    final validImages =
        images.where((img) => img.url != null && img.url!.startsWith('http')).toList();
    if (validImages.isEmpty) return const SizedBox.shrink();

    if (validImages.length == 2) {
      return Row(
        children: validImages
            .map((img) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          img.url!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.fieldBgColor,
                            child: const Icon(Icons.broken_image_outlined,
                                color: AppColors.primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: validImages.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1,
      ),
      itemBuilder: (_, i) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          validImages[i].url!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.fieldBgColor,
            child: const Icon(Icons.broken_image_outlined,
                color: AppColors.primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildList(BlogContent block) {
    final items = block.items;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isOrdered = block.style == 'ordered';

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  child: isOrdered
                      ? Text(
                          '${index + 1}.',
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(0.75),
                      fontSize: 13.5,
                      fontFamily: 'Inter',
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuote(BlogContent block) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(
            color: AppColors.secondaryColor,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"${block.text ?? ''}"',
            style: TextStyle(
              color: AppColors.whiteColor.withOpacity(0.85),
              fontSize: 14,
              fontFamily: 'Inter',
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
          if (block.author != null && block.author!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '— ${block.author}',
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCode(BlogContent block) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.contColor3,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.contBorderColor2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (block.language != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                block.language!,
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 11,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Text(
            block.text ?? '',
            style: const TextStyle(
              color: AppColors.codeColor,
              fontSize: 13,
              fontFamily: 'Roboto',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
