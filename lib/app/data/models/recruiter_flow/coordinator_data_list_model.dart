class CoordinatorDataListModel {
  bool? success;
  String? message;
  List<CoordinatorData>? coordinatorList;
  Pagination? pagination;

  CoordinatorDataListModel({
    this.success,
    this.message,
    this.coordinatorList,
    this.pagination,
  });

  CoordinatorDataListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "";

    if (json['data'] != null) {
      coordinatorList = <CoordinatorData>[];
      json['data'].forEach((v) {
        coordinatorList!.add(CoordinatorData.fromJson(v));
      });
    }

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['success'] = success;
    data['message'] = message;

    if (this.coordinatorList != null) {
      data['data'] = this.coordinatorList!.map((v) => v.toJson()).toList();
    }

    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }

    return data;
  }
}

class CoordinatorData {
  String? id;
  String? recruiter;
  String? name;
  String? email;
  String? mobile;
  String? role;
  bool? isActive;
  dynamic deletedAt;
  dynamic deletedBy;
  String? createdAt;
  String? updatedAt;
  int? v;

  CoordinatorData({
    this.id,
    this.recruiter,
    this.name,
    this.email,
    this.mobile,
    this.role,
    this.isActive,
    this.deletedAt,
    this.deletedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  CoordinatorData.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? "";
    recruiter = json['recruiter'] ?? "";
    name = json['name'] ?? "";
    email = json['email'] ?? "";
    mobile = json['mobile'] ?? "";
    role = json['role'] ?? "";
    isActive = json['isActive'] ?? false;
    deletedAt = json['deletedAt'];
    deletedBy = json['deletedBy'];
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    v = json['__v'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['_id'] = id;
    data['recruiter'] = recruiter;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['role'] = role;
    data['isActive'] = isActive;
    data['deletedAt'] = deletedAt;
    data['deletedBy'] = deletedBy;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;

    return data;
  }
}

class Pagination {
  int? current;
  int? total;
  int? pageSize;

  Pagination({
    this.current,
    this.total,
    this.pageSize,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    current = json['current'] ?? 0;
    total = json['total'] ?? 0;
    pageSize = json['pageSize'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['current'] = current;
    data['total'] = total;
    data['pageSize'] = pageSize;

    return data;
  }
}