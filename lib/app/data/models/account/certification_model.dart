class Certification {
  String? name;
  String? issuer;
  dynamic date;
  String? type;

  Certification({
     this.name,
     this.issuer,
     this.date,
     this.type,
  });

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      name: json['name'] ?? '',
      issuer: json['issuer'] ?? "",
      date: json['date']??"",
      type: json['type']??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name ?? "",
      "issuer": issuer ?? "",
      "date": date ?? "",
      "type": type ?? "",
    };
  }

}

class PaperData {
  String? tittle;
  String? event;
  String? year;
  String? description;

  PaperData.fromJson(Map<String, dynamic> json) {
    tittle = json["title"] ?? "";
    event = json["event"] ?? "";
    year = json["year"] ?? "";
    description = json["description"] ?? "";
  }

  PaperData({this.event, this.year, this.description, this.tittle});

  Map<String, dynamic> toJson() {
    return {
      "title": tittle,
      "event": event,
      "year": year,
      "description": description,
    };
  }
}
