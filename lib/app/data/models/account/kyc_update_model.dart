class KycUpdateModel {
  String? candidateDetails;
  String? name;
  String? aadhaarDocument;
  String? aadhaarName;
  String? collegeId;
  String? collegeName;
  String? collegeMatch;
  String? reasoning;

  KycUpdateModel.fromJson(Map<String, dynamic> json) {
    candidateDetails = json["candidate_details"] ?? "";
    name = json["name"] ?? "";
    aadhaarDocument = json["aadhaar_document"] ?? "";
    aadhaarName = json["aadhar_name"] ?? "";
    collegeId = json["college_id"] ?? "";
    collegeName = json["college_id_name"] ?? "";
    collegeMatch = json["college_match"] ?? "";
    reasoning = json["reasoning"] ?? "";
  }

  KycUpdateModel({
    this.collegeId,
    this.aadhaarDocument,
    this.name,
    this.candidateDetails,
  });
}
