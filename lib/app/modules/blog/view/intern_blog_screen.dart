import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/data/models/blog/blog_model.dart';
import 'package:internsharks/app/data/providers/blog_provider.dart';
import 'package:internsharks/app/modules/blog/controller/blog_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class InternBlogScreen extends StatefulWidget {
  final bool showBack;

  const InternBlogScreen({super.key, this.showBack = false});

  @override
  State<InternBlogScreen> createState() => _InternBlogScreenState();
}

class _InternBlogScreenState extends State<InternBlogScreen> {
  late final BlogController blogController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (Get.isRegistered<BlogController>()) {
      blogController = Get.find<BlogController>();
    } else {
      blogController = Get.put(
        BlogController(BlogProvider(client: Dio())),
        permanent: true,
      );
    }

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (blogController.allBlogs.isEmpty) {
        blogController.fetchBlogs();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!blogController.isPaginationLoading.value &&
          blogController.hasMorePages.value &&
          blogController.searchQuery.value.isEmpty) {
        blogController.fetchBlogs();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: widget.showBack
            ? AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.whiteColor,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Blog',
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        )
            : null,
        body: Obx(() {
          if (blogController.blogLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: AppColors.appBgColor,
            onRefresh: blogController.refreshBlogs,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Header Section
                SliverToBoxAdapter(child: _buildHeader()),

                // Search Bar
                SliverToBoxAdapter(child: _buildSearchBar()),

                // Results Count
                SliverToBoxAdapter(child: _buildResultCount()),

                // Blog Grid
                _buildBlogGrid(),

                // Pagination Loader
                SliverToBoxAdapter(
                  child: Obx(() {
                    if (blogController.isPaginationLoading.value) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }
                    if (!blogController.hasMorePages.value &&
                        blogController.allBlogs.isNotEmpty &&
                        blogController.searchQuery.value.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'No more articles',
                            style: TextStyle(
                              color: AppColors.lightColorText.withOpacity(0.5),
                              fontSize: 13,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox(height: 20);
                  }),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withOpacity(0.15),
            AppColors.appBgColor.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Internship Blog &',
                  style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(0.7),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Text(
                  'Career Insights',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 22,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Explore expert tips, career advice, and industry trends.',
                  style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(0.55),
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.3),
              ),
            ),
            child: const Icon(
              Icons.article_rounded,
              color: AppColors.primaryColor,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.contColor2.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.contBorderColor2,
            width: 1,
          ),
        ),
        child: TextField(
          controller: blogController.searchController,
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 14,
            fontFamily: 'Inter',
          ),
          decoration: InputDecoration(
            hintText: 'Search blogs...',
            hintStyle: TextStyle(
              color: AppColors.lightColorText.withOpacity(0.5),
              fontSize: 14,
              fontFamily: 'Inter',
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.primaryColor,
              size: 20,
            ),
            suffixIcon: Obx(() {
              if (blogController.searchQuery.value.isNotEmpty) {
                return IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppColors.lightColorText.withOpacity(0.6),
                    size: 18,
                  ),
                  onPressed: () {
                    blogController.searchController.clear();
                  },
                );
              }
              return const SizedBox.shrink();
            }),
            border: InputBorder.none,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCount() {
    return Obx(() {
      final count = blogController.filteredBlogs.length;
      final total = blogController.blogListModel.pagination?.total ??
          blogController.allBlogs.length;
      final isSearching = blogController.searchQuery.value.isNotEmpty;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Text(
          isSearching
              ? 'Showing $count result${count != 1 ? 's' : ''} for "${blogController.searchQuery.value}"'
              : 'Latest Articles · Showing ${blogController.allBlogs.length} of $total articles',
          style: TextStyle(
            color: AppColors.lightColorText.withOpacity(0.65),
            fontSize: 12,
            fontFamily: 'Inter',
          ),
        ),
      );
    });
  }

  Widget _buildBlogGrid() {
    return Obx(() {
      final blogs = blogController.filteredBlogs;

      if (blogs.isEmpty && !blogController.blogLoading) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 56,
                  color: AppColors.lightColorText.withOpacity(0.3),
                ),
                const SizedBox(height: 12),
                Text(
                  blogController.searchQuery.value.isNotEmpty
                      ? 'No articles found'
                      : 'No articles available',
                  style: TextStyle(
                    color: AppColors.lightColorText.withOpacity(0.5),
                    fontSize: 15,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.72,
          ),
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return _BlogCard(
                blog: blogs[index],
                onTap: () {
                  blogController.selectBlog(blogs[index]);
                  Get.toNamed(AppRoutes.blogViewScreen);
                },
                formatDate: _formatDate,
              );
            },
            childCount: blogs.length,
          ),
        ),
      );
    });
  }
}

class _BlogCard extends StatelessWidget {
  final BlogModel blog;
  final VoidCallback onTap;
  final String Function(String?) formatDate;

  const _BlogCard({
    required this.blog,
    required this.onTap,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.contColor2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.contBorderColor2,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(14)),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 10,
                    child: blog.coverImages != null &&
                        blog.coverImages!.isNotEmpty &&
                        blog.coverImages!.startsWith('http')
                        ? Image.network(
                      blog.coverImages!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _buildImagePlaceholder(),
                    )
                        : _buildImagePlaceholder(),
                  ),
                  // Status Badge
                  if (blog.status == 'published')
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'PUBLISHED',
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date & read time
                    Text(
                      '${formatDate(blog.createdAt)} · 5 min read',
                      style: TextStyle(
                        color: AppColors.lightColorText.withOpacity(0.5),
                        fontSize: 10,
                        fontFamily: 'Inter',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),

                    // Title
                    Text(
                      blog.title ?? '',
                      style: const TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),

                    // Description
                    Expanded(
                      child: Text(
                        blog.shortDescription ?? '',
                        style: TextStyle(
                          color: AppColors.lightColorText.withOpacity(0.6),
                          fontSize: 11,
                          fontFamily: 'Inter',
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Read Article
                    Row(
                      children: [
                        Text(
                          'Read Article',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.primaryColor,
                          size: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.fieldBgColor,
      child: const Center(
        child: Icon(
          Icons.article_outlined,
          color: AppColors.primaryColor,
          size: 32,
        ),
      ),
    );
  }
}
