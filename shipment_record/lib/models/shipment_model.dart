class Shipment {
  final String shipmentId;
  final String date;
  final String model;
  final int quantity;
  final String destination;
  final String containerNo;
  final String sealNo;
  final String truckPoliceNo;
  
  Shipment({
    required this.shipmentId,
    required this.date,
    required this.model,
    required this.quantity,
    required this.destination,
    required this.containerNo,
    required this.sealNo,
    required this.truckPoliceNo,
  });

  Map<String, dynamic> toJson() {
    return {
      'shipmentId': 0,
      'date': date,
      'model': model,
      'quantity': quantity,
      'destination': destination,
      'containerNo': containerNo,
      'sealNo': sealNo,
      'truckPoliceNo': truckPoliceNo,
    };
  }
}
