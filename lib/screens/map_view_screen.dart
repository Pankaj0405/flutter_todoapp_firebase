import 'package:flutter/material.dart';
import 'package:flutter_todoapp_firebase/models/task.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
 // Import the Task model

class MapViewScreen extends StatelessWidget {
  final List<Task> tasks;

  MapViewScreen({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map View')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(20.5937, 78.9629),
          zoom: 5,
        ),
        markers: tasks
            .map((task) => Marker(
          markerId: MarkerId(task.title!),
          position: LatLng(task.latitude!, task.longitude!),
          infoWindow: InfoWindow(title: task.title),
        ))
            .toSet(),
      ),
    );
  }
}
