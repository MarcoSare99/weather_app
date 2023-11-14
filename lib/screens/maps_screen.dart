import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:weather_app/database/database_helper.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/network/api_weather.dart';
import 'package:weather_app/screens/weather_details_screen.dart';
import 'package:weather_app/widgets/dialog_widget.dart';
import 'package:weather_app/widgets/text_field_widget.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Location location = Location();
  late CameraPosition cameraPosition;
  List<Marker> markers = List.empty(growable: true);
  List<LocationModel> locations = List.empty(growable: true);
  List<WeatherData> dataLocations = List.empty(growable: true);
  DatabaseHelper database = DatabaseHelper();
  ApiWeather apiWeather = ApiWeather();
  late TextFieldWidget locationName;
  bool isMapView = true;
  Set<Circle> circles = <Circle>{};

  double lat = 37.42796133580664;
  double lon = -122.085749655962;

  List<MapType> mapType = [
    MapType.normal,
    MapType.terrain,
    MapType.satellite,
    MapType.hybrid
  ];

  List<IconData> icons = [
    Icons.terrain,
    Icons.satellite_alt,
    Icons.place,
    Icons.public
  ];
  int _mapTypeController = 0;

  @override
  void initState() {
    super.initState();
    checkLocationStatus()
        .then((value) => _getLocation().then((value) => setState(() {})));
  }

  Future<void> checkLocationStatus() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        cameraPosition = const CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 14.4746,
        );
      }
    } else {
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          cameraPosition = const CameraPosition(
            target: LatLng(37.42796133580664, -122.085749655962),
            zoom: 14.4746,
          );
        } else {
          LocationData locationData = await location.getLocation();
          cameraPosition = CameraPosition(
            target:
                LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0),
            zoom: 14.4746,
          );
          lat = locationData.latitude ?? 0;
          lon = locationData.longitude ?? 0;
        }
      } else {
        LocationData locationData = await location.getLocation();
        cameraPosition = CameraPosition(
          target:
              LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0),
          zoom: 14.4746,
        );
        lat = locationData.latitude ?? 0;
        lon = locationData.longitude ?? 0;
      }
    }
  }

  Future<void> _getLocation() async {
    WeatherData? weatherData = await getWeatherData(lat: lat, lon: lon);
    markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: cameraPosition.target, // Posición actual
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
            title: 'Posición actual',
            snippet: 'Temperatura actual ${weatherData!.main.temp}°C',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WeatherDetailsScreen(weatherData: weatherData),
                ),
              );
            }) // Icono rojo
        ));
    await setLocationsInMap();
  }

  Future<WeatherData?> getWeatherData(
      {required double lat, required double lon}) async {
    WeatherData? response = await apiWeather.getWeatherData(lat: lat, lon: lon);
    return response;
  }

  Future<List<LocationModel>> getLocations() async {
    return await database.GETALLLOCATIONS();
  }

  Future<void> setLocationsInMap() async {
    locations = await getLocations();
    for (LocationModel element in locations) {
      WeatherData? weatherData =
          await getWeatherData(lat: element.lat!, lon: element.lon!);
      dataLocations.add(weatherData!);
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(element.lat!, element.lon!),
        zoom: 14.4746,
      );

      final Uint8List markerIcon = await getBytesFromAsset(
          'assets/icons/${weatherData.weather[0].icon}.png', 100);
      markers.add(Marker(
          markerId: MarkerId(element.name!),
          position: cameraPosition.target, // Posición actual
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(
              title: element.name,
              snippet: 'Temperatura actual ${weatherData.main.temp}°C',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WeatherDetailsScreen(weatherData: weatherData),
                  ),
                );
              })));
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _getLocation(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return SafeArea(
                  child: Scaffold(
                      body: isMapView
                          ? GoogleMap(
                              mapType: mapType[_mapTypeController],
                              initialCameraPosition: cameraPosition,
                              onMapCreated: (GoogleMapController controller) {
                                if (!_controller.isCompleted) {
                                  _controller.complete(controller);
                                }
                              },
                              markers: Set<Marker>.of(markers),
                              circles: circles,
                              onLongPress: (LatLng latLng) {
                                setState(() {
                                  circles.add(
                                    Circle(
                                      circleId: const CircleId('aux'),
                                      center: latLng,
                                      radius: 500, // Radio en metros
                                      fillColor: Colors.blue.withOpacity(0.3),
                                      strokeColor: Colors.blue,
                                      strokeWidth: 2,
                                    ),
                                  );
                                });

                                locationName = TextFieldWidget(
                                  label: "Nombre de la localización",
                                  hint: "Ingresa el nombre",
                                  msgError: "",
                                  inputType: 1,
                                  lenght: 50,
                                  icono: Icons.place,
                                );
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      DialogWidget dialogWidget =
                                          DialogWidget(context: context);
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: Container(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                const Text(
                                                  'Agregar un nueva localización',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                const SizedBox(height: 16.0),
                                                locationName,
                                                const SizedBox(height: 16.0),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    if (locationName
                                                        .formkey.currentState!
                                                        .validate()) {
                                                      bool isInserted =
                                                          await insertLocation(
                                                              name: locationName
                                                                  .controlador,
                                                              lat: latLng
                                                                  .latitude,
                                                              lon: latLng
                                                                  .longitude,
                                                              dialogWidget:
                                                                  dialogWidget);
                                                      if (isInserted) {
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      }
                                                    }
                                                  },
                                                  child: const Text('Guardar'),
                                                ),
                                              ],
                                            )),
                                      );
                                    }).then((value) => {
                                      setState(() {
                                        circles.clear();
                                      })
                                    });
                              },
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      locations[index].name!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        '${dataLocations[index].main.temp} °C'),
                                    leading: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/icons/${dataLocations[index].weather[0].icon}.png'),
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              WeatherDetailsScreen(
                                                  weatherData:
                                                      dataLocations[index]),
                                        ),
                                      );
                                    },
                                  );
                                },
                                itemCount: dataLocations.length,
                              ),
                            ),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.startFloat,
                      floatingActionButton: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FloatingActionButton(
                                heroTag: "btn1",
                                onPressed: () {
                                  setState(() {
                                    isMapView = !isMapView;
                                  });
                                },
                                child:
                                    Icon(!isMapView ? Icons.map : Icons.list),
                              ),
                            ),
                            isMapView
                                ? Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: FloatingActionButton(
                                      heroTag: "btn2",
                                      onPressed: () {
                                        if (_mapTypeController == 3) {
                                          _mapTypeController = 0;
                                        } else {
                                          _mapTypeController++;
                                        }

                                        setState(() {});
                                      },
                                      child: Icon(icons[_mapTypeController]),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      )),
                );
              });
            }
          }),
    );
  }

  Future<bool> insertLocation(
      {required String name,
      required double lat,
      required double lon,
      DialogWidget? dialogWidget}) async {
    late String msg;
    int error = 0;
    try {
      dialogWidget!.showProgress();
      WeatherData? weatherData = await getWeatherData(lat: lat, lon: lon);
      dialogWidget.closeProgress();
      error = await database
          .INSERT('tblLocations', {'name': name, 'lat': lat, 'lon': lon});
      msg = error > 0 ? 'Registro insertado' : 'Error inesperado';
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(lat, lon),
        zoom: 14.4746,
      );
      locations.add(LocationModel(
          id: Random().nextInt(100), lat: lat, lon: lon, name: name));
      dataLocations.add(weatherData!);

//'assets/icons/${snapshot.data!.weather[0].icon}.png'
      final Uint8List markerIcon = await getBytesFromAsset(
          'assets/icons/${weatherData!.weather[0].icon}.png', 100);
      markers.add(Marker(
          markerId: MarkerId(name),
          position: cameraPosition.target, // Posición actual
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(
              title: name,
              snippet: 'Temperatura actual ${weatherData.main.temp}°C',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WeatherDetailsScreen(weatherData: weatherData),
                  ),
                );
              }) // Icono rojo
          ));
    } catch (e) {
      dialogWidget!.closeProgress();
      msg = "Error inesperado";
    } finally {
      Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT, // Duración del toast
        gravity: ToastGravity
            .TOP, // Posición del toast (puedes usar BOTTOM, TOP, CENTER)
        timeInSecForIosWeb:
            1, // Duración en segundos para iOS (se ignora en Android)
        backgroundColor: error > 0
            ? const Color(0x9B4CAF4F)
            : const Color(0x7EF44336), // Color del texto del toast
        fontSize: 16.0, // Tamaño de fuente del texto del toast
      );
      // ignore: control_flow_in_finally
      if (error > 0) {
        return true;
      }
      return false;
    }
  }
}
