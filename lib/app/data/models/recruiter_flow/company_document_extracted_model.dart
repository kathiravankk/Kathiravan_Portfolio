class CompanyDocumentExtractedModel {
  bool? success;
  String? message;
  ExtractedDataWrapper? data;

  CompanyDocumentExtractedModel({this.success, this.message, this.data});

  CompanyDocumentExtractedModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? ExtractedDataWrapper.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ExtractedDataWrapper {
  bool? success;
  String? filename;
  ExtractedData? extractedData;
  int? tokenUsage;
  int? totalTokens;
  num? totalInrCost;

  ExtractedDataWrapper({
    this.success,
    this.filename,
    this.extractedData,
    this.tokenUsage,
    this.totalTokens,
    this.totalInrCost,
  });

  ExtractedDataWrapper.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    filename = json['filename'];
    extractedData = json['extracted_data'] != null
        ? ExtractedData.fromJson(json['extracted_data'])
        : null;
    tokenUsage = json['token_usage'];
    totalTokens = json['total_tokens'];
    totalInrCost = json['total_inr_cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['filename'] = filename;
    if (extractedData != null) {
      data['extracted_data'] = extractedData!.toJson();
    }
    data['token_usage'] = tokenUsage;
    data['total_tokens'] = totalTokens;
    data['total_inr_cost'] = totalInrCost;
    return data;
  }
}

class ExtractedData {
  bool? isCompanyProfile;
  CompanyInformation? companyInformation;
  SocialMediaLinks? socialMediaLinks;

  ExtractedData({
    this.isCompanyProfile,
    this.companyInformation,
    this.socialMediaLinks,
  });

  ExtractedData.fromJson(Map<String, dynamic> json) {
    isCompanyProfile = json['is_company_profile'];
    companyInformation = json['company_information'] != null
        ? CompanyInformation.fromJson(json['company_information'])
        : null;
    socialMediaLinks = json['social_media_links'] != null
        ? SocialMediaLinks.fromJson(json['social_media_links'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_company_profile'] = isCompanyProfile;
    if (companyInformation != null) {
      data['company_information'] = companyInformation!.toJson();
    }
    if (socialMediaLinks != null) {
      data['social_media_links'] = socialMediaLinks!.toJson();
    }
    return data;
  }
}

class CompanyInformation {
  String? companyName;
  String? companyAddress;
  String? companyPincode;
  String? companyWebsite;
  String? companyEmail;
  String? industryType;
  String? companyDescription;
  String? companyContactNumber;

  CompanyInformation({
    this.companyName,
    this.companyAddress,
    this.companyPincode,
    this.companyWebsite,
    this.companyEmail,
    this.industryType,
    this.companyDescription,
    this.companyContactNumber,
  });

  CompanyInformation.fromJson(Map<String, dynamic> json) {
    companyName = json['company_name'];
    companyAddress = json['company_address'];
    companyPincode = json['company_pincode']?.toString();
    companyWebsite = json['company_website'];
    companyEmail = json['company_email'];
    industryType = json['industry_type'];
    companyDescription = json['company_description'];
    companyContactNumber = json['company_contact_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_name'] = companyName;
    data['company_address'] = companyAddress;
    data['company_pincode'] = companyPincode;
    data['company_website'] = companyWebsite;
    data['company_email'] = companyEmail;
    data['industry_type'] = industryType;
    data['company_description'] = companyDescription;
    data['company_contact_number'] = companyContactNumber;
    return data;
  }
}

class SocialMediaLinks {
  String? linkedin;
  String? facebook;
  String? instagram;
  String? twitterX;
  String? youtube;

  SocialMediaLinks({
    this.linkedin,
    this.facebook,
    this.instagram,
    this.twitterX,
    this.youtube,
  });

  SocialMediaLinks.fromJson(Map<String, dynamic> json) {
    linkedin = json['linkedin'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    twitterX = json['twitter_x'];
    youtube = json['youtube'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['linkedin'] = linkedin;
    data['facebook'] = facebook;
    data['instagram'] = instagram;
    data['twitter_x'] = twitterX;
    data['youtube'] = youtube;
    return data;
  }
}
