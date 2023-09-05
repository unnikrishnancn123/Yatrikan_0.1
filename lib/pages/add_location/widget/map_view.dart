import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  final Function(String)? onLocationSelected;

  const MapScreen({super.key, this.onLocationSelected});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  static const CameraPosition _kgooglepixel = CameraPosition(
    target: LatLng(10.0158685, 76.3418586),
    zoom: 11.0,
    tilt: 0,
    bearing: 0,
  );
  String stAddress = '';
  bool isUpdate = false;
  int? studentIdForUpdate;


  final Set<Marker> _markers = {};

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.checkPermission();
      return;
    }

    final currentLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    String lat = currentLocation.latitude.toString();
    String lon = currentLocation.longitude.toString();
    double latData = double.parse(lat);
    double lonData = double.parse(lon);

    List<Placemark> placemarks = await placemarkFromCoordinates(latData, lonData);

    if (mounted) {
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('selected_location'),
            position: LatLng(
              currentLocation.latitude,
              currentLocation.longitude,
            ),
          ),
        );
        final placemark = placemarks.first;
        stAddress = '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}';
      });
    }
  }
  Future<void> _getMarkedLocation(LatLng latLng) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.checkPermission();
      return;
    }
      // Clear existing markers
      setState(() {
        _markers.clear();
      });
      // Add the tapped location as a new marker
      List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('tapped_location'),
            position: latLng,
          ),
        );
        final placemark = placemarks.first;
        stAddress = '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}';
      });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _kgooglepixel,
              markers: _markers,
              onMapCreated: (controller) {
                setState(() {
                });
              },
              onTap: (LatLng latLng) {
                _getMarkedLocation(latLng);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          FloatingActionButton.small(
            onPressed: () async {
              await _getCurrentLocation();

               Navigator.pop(context, stAddress);
            },
            child: const Icon(Icons.my_location,color: Color(0xF0000000),),
          ),
          FloatingActionButton.small(
            onPressed: () async {
               _getMarkedLocation;
              Navigator.pop(context, stAddress);
            },
            child: const Icon(Icons.location_on,color: Color(0xFFF65959),),
          ),
          ]
          )
        ],
      ),
    );
  }
}

