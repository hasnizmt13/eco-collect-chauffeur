
class Address {
  final int id;
  final String region;
  final String address;
  double distance;
  int tauxRemplissage;
  final double longitude;
  final double latitude ;

  Address({
    required this.id,
    required this.region,
    required this.address,
    required this.distance,
    required this.tauxRemplissage,
    required this.longitude,
    required this.latitude,

  });
}