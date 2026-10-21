import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/models/blog/blog_model.dart';
import 'package:internsharks/app/data/providers/blog_provider.dart';

class BlogController extends GetxController {
  final BlogProvider? blogProvider;

  BlogController(this.blogProvider);

  int getResponseCode() => blogProvider!.responseStatus;

  // --- Blog List ---

  final _blogLoading = false.obs;
  bool get blogLoading => _blogLoading.value;
  set blogLoading(bool value) => _blogLoading.value = value;

  final _blogListModel = BlogListModel().obs;
  BlogListModel get blogListModel => _blogListModel.value;
  set blogListModel(BlogListModel value) => _blogListModel.value = value;

  // All fetched blogs (accumulated across pages)
  final RxList<BlogModel> allBlogs = <BlogModel>[].obs;

  // Search
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  List<BlogModel> get filteredBlogs {
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) return allBlogs;
    return allBlogs.where((blog) {
      final titleMatch = blog.title?.toLowerCase().contains(query) ?? false;
      final descMatch =
          blog.shortDescription?.toLowerCase().contains(query) ?? false;
      return titleMatch || descMatch;
    }).toList();
  }

  // Pagination
  final RxInt currentPage = 1.obs;
  final int pageSize = 12;
  final RxBool hasMorePages = true.obs;
  final RxBool isPaginationLoading = false.obs;

  // Currently selected blog for detail view
  final Rxn<BlogModel> selectedBlog = Rxn<BlogModel>();

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
    fetchBlogs();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchBlogs({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasMorePages.value = true;
      allBlogs.clear();
    }

    if (!hasMorePages.value) return;
    if (isPaginationLoading.value) return;

    try {
      if (allBlogs.isEmpty) {
        blogLoading = true;
      } else {
        isPaginationLoading.value = true;
      }

      blogListModel = await blogProvider!.fetchAllBlogs(
        page: currentPage.value,
        limit: pageSize,
      );

      if (blogListModel.data != null && blogListModel.data!.isNotEmpty) {
        allBlogs.addAll(blogListModel.data!);
      }

      final pagination = blogListModel.pagination;
      if (pagination != null) {
        final totalItems = pagination.total ?? 0;
        if (allBlogs.length >= totalItems) {
          hasMorePages.value = false;
        } else {
          currentPage.value += 1;
        }
      } else {
        hasMorePages.value = false;
      }

      blogLoading = false;
      isPaginationLoading.value = false;
    } catch (err) {
      blogLoading = false;
      isPaginationLoading.value = false;
      rethrow;
    }
  }

  Future<void> refreshBlogs() async {
    await fetchBlogs(refresh: true);
  }

  void selectBlog(BlogModel blog) {
    selectedBlog.value = blog;
  }
}
