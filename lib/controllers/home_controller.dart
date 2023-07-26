import 'package:get/get.dart';

class HomeController extends GetxController {
  RxDouble latitude = RxDouble(0.0);
  RxDouble longitude = RxDouble(0.0);
  // to store latitude and longitude
  void updateCoordinates(double lat, double lng) {
    latitude.value = lat;
    longitude.value = lng;
  }
}
