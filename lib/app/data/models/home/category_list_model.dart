class CategoryListModel {
  List<CategoryListData>? categoryList;

  CategoryListModel({this.categoryList});

  factory CategoryListModel.fromJson(List<dynamic> json) {
    return CategoryListModel(
      categoryList: json.map((e) => CategoryListData.fromJson(e)).toList(),
    );
  }
}

class CategoryListData {
  String? categoryId;
  String? categoryName;
  String? categoryImage;
  dynamic vId;
  int? count;

  CategoryListData({
    this.categoryId,
    this.categoryImage,
    this.categoryName,
    this.vId,
    this.count,
  });

  CategoryListData.fromJson(Map<String, dynamic> json) {
    categoryId = json["_id"] ?? "";
    categoryName = json["name"] ?? "";
    categoryImage = json["industryimage"] ?? "";
    vId = json["__v"] ?? 0;
    count = json["count"] ?? 0;
  }
}
