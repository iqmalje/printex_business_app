class Order {
  // nullables are not important as of yet, fetching valuable information first

  String orderID, status;
  double cost;
  DateTime date;

  String? accountID, fileID, statusReason, apmID;
  bool? hasPaid;
  int? rating;

  Order(
      {required this.orderID,
      required this.status,
      this.apmID,
      required this.cost,
      required this.date,
      this.accountID,
      this.fileID,
      this.statusReason,
      this.hasPaid,
      this.rating});
}
