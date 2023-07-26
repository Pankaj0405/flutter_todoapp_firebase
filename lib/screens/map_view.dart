import 'package:flutter/material.dart';
import 'package:flutter_todoapp_firebase/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(20.5937, 78.9629), // Default initial position
          zoom: 5,
        ),
        onMapCreated: (GoogleMapController controller) {},
        onTap: (LatLng latLng) {
          // On tap of the map, update the text fields with latitude and longitude
          homeController.updateCoordinates(latLng.latitude, latLng.longitude);
          print(latLng.longitude);
          Get.back();
        },
      ),
    );
  }
}
