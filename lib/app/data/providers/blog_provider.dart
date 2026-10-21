import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/blog/blog_model.dart';

class BlogProvider {
  final Dio? client;

  BlogProvider({@required this.client});

  int? _responseStatus;

  int get responseStatus => _responseStatus!;

  set responseStatus(int value) => _responseStatus = value;

  // GET ALL BLOGS WITH PAGINATION

  Future<BlogListModel> fetchAllBlogs({
    required int page,
    required int limit,
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getAllBlogs(page, limit),
      );
      responseStatus = response.statusCode!;
      return BlogListModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response?.statusCode ?? 500;
      if (err.response?.data != null) {
        return BlogListModel.fromJson(err.response!.data);
      }
      return BlogListModel();
    }
  }
}
