class APM {
  String apmID, printerName, pictureUrl, pictureUrl2;
  int paperAmount;
  String address1, address2, city, state;
  double lat, lng;

  APM(
      {required this.apmID,
      required this.printerName,
      required this.pictureUrl,
      required this.pictureUrl2,
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
