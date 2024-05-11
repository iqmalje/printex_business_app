class APM {
  String apmID, printerName, pictureUrl, pictureUrl2;
  bool isActive;
  int paperAmount;
  String address1, address2, city, state;
  double lat, lng;

  APM(
      {required this.apmID,
      required this.printerName,
      required this.pictureUrl,
      required this.pictureUrl2,
      required this.isActive,
      required this.paperAmount,
      required this.address1,
      required this.address2,
      required this.city,
      required this.state,
      required this.lat,
      required this.lng});
}

class APMDetails {
  String type, papersize, layout;
  bool bwprint, colorprint, bothsideprint;

  APMDetails(this.type, this.papersize, this.layout, this.bwprint,
      this.colorprint, this.bothsideprint);
}

class APMOperatingHours {
  String monday, tuesday, wednesday, thursday, friday, saturday, sunday;

  APMOperatingHours(
      {required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday,
      required this.sunday});

  List<String> toList() {
    return [monday, tuesday, wednesday, thursday, friday, saturday, sunday];
  }

  Map<String, String> toMap() {
    return {
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
    };
  }
}

class APMPricing {
  double blackWhiteSingle, blackWhiteBoth, colorSingle, colorBoth;

  APMPricing(
      {required this.blackWhiteSingle,
      required this.blackWhiteBoth,
      required this.colorSingle,
      required this.colorBoth});
}
