class SendRequestModel {
  bool? success;
  String? message;
  int? totalJobs;

  SendRequestModel({
    this.message,
    this.success,
    this.totalJobs
});

  SendRequestModel.fromJson(Map<String, dynamic> json) {
    message = json['message']??"";
    success = json['success']??false;
    totalJobs = json['totalJobs']??0;
  }
}