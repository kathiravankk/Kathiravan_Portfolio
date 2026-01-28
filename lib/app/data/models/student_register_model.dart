class StudentRegisterModel {
  String? message;
  RegisterData? registerData;
  String? studentToken;

  StudentRegisterModel({this.message, this.registerData, this.studentToken});

  StudentRegisterModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
    registerData =
    json['student'] != null ? RegisterData.fromJson(json['student']) : null;
    studentToken = json['studtoken'] ?? "";
  }

}

class RegisterData {
  String? id;
  String? studentName;
  String? studentMobileNo;
  bool? isVerified;
  String? studentCreditId;

  RegisterData(
      {this.id,
        this.studentName,
        this.studentMobileNo,
        this.isVerified,
        this.studentCreditId});

  RegisterData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    studentName = json['studname'] ?? "";
    studentMobileNo = json['studmobileno'] ?? "";
    isVerified = json['isVerified'] ?? false;
    studentCreditId = json['studentCreditId'] ?? "";
  }
}
