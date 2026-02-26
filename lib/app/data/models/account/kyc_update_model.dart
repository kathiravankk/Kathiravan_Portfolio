class KycUpdateModel {
  String? candidateDetails;
  String? name;
  String? aadhaar;
  String? collegeId;
  String? collegeMatch;
  String? reasoning;

  KycUpdateModel.fromJson(Map<String, dynamic> json) {
    candidateDetails = json["candidate_details"] ?? "";
    name = json["name"] ?? "";
    aadhaar = json["aadhaar"] ?? "";
    collegeId = json["college_id"] ?? "";
    collegeId = json["college_match"] ?? "";
    reasoning = json["reasoning"] ?? "";
  }

  KycUpdateModel({
    this.collegeId,
    this.aadhaar,
    this.name,
    this.candidateDetails,
  });
}
