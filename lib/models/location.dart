class LocationModel {
  int? id;
  String? name;
  double? lon;
  double? lat;

  LocationModel({this.id, this.name, this.lon, this.lat});
  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
        id: map['id'], name: map['name'], lon: map['lon'], lat: map['lat']);
  }
}
