class FilterOptionModel {
  bool? success;
  FilterData? filters;

  FilterOptionModel({
    this.success,
    this.filters,
  });

  FilterOptionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    filters =
    json['filters'] != null ? FilterData.fromJson(json['filters']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    if (filters != null) {
      data['filters'] = filters!.toJson();
    }
    return data;
  }
}

class FilterData {
  List<String>? roleType;
  List<String>? companyState;
  List<String>? companyCity;
  List<String>? studentQualification;

  FilterData({
    this.roleType,
    this.companyState,
    this.companyCity,
    this.studentQualification,
  });

  FilterData.fromJson(Map<String, dynamic> json) {
    roleType = json['roletype'] != null
        ? List<String>.from(json['roletype'])
        : [];
    companyState = json['companystate'] != null
        ? List<String>.from(json['companystate'])
        : [];
    companyCity = json['companycity'] != null
        ? List<String>.from(json['companycity'])
        : [];
    studentQualification = json['studentqualification'] != null
        ? List<String>.from(json['studentqualification'])
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['roletype'] = roleType ?? [];
    data['companystate'] = companyState ?? [];
    data['companycity'] = companyCity ?? [];
    data['studentqualification'] = studentQualification ?? [];
    return data;
  }
}