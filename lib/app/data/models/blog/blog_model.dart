class BlogListModel {
  final bool? success;
  final int? count;
  final BlogPagination? pagination;
  final List<BlogModel>? data;

  BlogListModel({this.success, this.count, this.pagination, this.data});

  factory BlogListModel.fromJson(Map<String, dynamic> json) {
    return BlogListModel(
      success: json['success'],
      count: json['count'],
      pagination: json['pagination'] != null
          ? BlogPagination.fromJson(json['pagination'])
          : null,
      data: json['data'] != null
          ? List<BlogModel>.from(
              json['data'].map((x) => BlogModel.fromJson(x)))
          : [],
    );
  }
}

class BlogPagination {
  final int? current;
  final int? pageSize;
  final int? total;

  BlogPagination({this.current, this.pageSize, this.total});

  factory BlogPagination.fromJson(Map<String, dynamic> json) {
    return BlogPagination(
      current: json['current'],
      pageSize: json['pageSize'],
      total: json['total'],
    );
  }
}

class BlogModel {
  final String? id;
  final String? title;
  final String? shortDescription;
  final String? coverImages;
  final String? status;
  final bool? isActive;
  final List<BlogContent>? content;
  final String? createdAt;
  final String? updatedAt;

  BlogModel({
    this.id,
    this.title,
    this.shortDescription,
    this.coverImages,
    this.status,
    this.isActive,
    this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['_id'],
      title: json['title'],
      shortDescription: json['shortDescription'],
      coverImages: json['coverImages'],
      status: json['status'],
      isActive: json['isActive'],
      content: json['content'] != null
          ? List<BlogContent>.from(
              json['content'].map((x) => BlogContent.fromJson(x)))
          : [],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class BlogContent {
  final String? type;
  final String? text;
  final String? language;
  final String? author;
  final String? caption;
  final String? style;
  final List<String>? items;
  final List<BlogImage>? images;

  BlogContent({
    this.type,
    this.text,
    this.language,
    this.author,
    this.caption,
    this.style,
    this.items,
    this.images,
  });

  factory BlogContent.fromJson(Map<String, dynamic> json) {
    return BlogContent(
      type: json['type'],
      text: json['text'],
      language: json['language'],
      author: json['author'],
      caption: json['caption'],
      style: json['style'],
      items: json['items'] != null
          ? List<String>.from(json['items'].map((x) => x.toString()))
          : null,
      images: json['images'] != null
          ? List<BlogImage>.from(
              json['images'].map((x) => BlogImage.fromJson(x)))
          : null,
    );
  }
}

class BlogImage {
  final String? url;

  BlogImage({this.url});

  factory BlogImage.fromJson(Map<String, dynamic> json) {
    return BlogImage(url: json['url']);
  }
}
