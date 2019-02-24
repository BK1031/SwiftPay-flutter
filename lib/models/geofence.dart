class Geofence {
  String id;
  String name;
  double distance;
  double price;
  double lat;
  double long;
  bool inside;

  Geofence(this.id, this.name, this.distance, this.price, this.lat, this.long, this.inside);
}