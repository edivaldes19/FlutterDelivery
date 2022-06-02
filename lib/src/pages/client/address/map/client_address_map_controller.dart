import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;

class ClientAddressMapController extends GetxController {
  CameraPosition initialPosition =
      CameraPosition(target: LatLng(19.4040535, -102.0463693), zoom: 13);
  LatLng? addressLatLng;
  var fullAddress = ''.obs;
  Completer<GoogleMapController> mapController = Completer();
  Position? position;
  ClientAddressMapController() {
    checkGPS();
  }
  Future setLocationDraggableInfo() async {
    double latitude = initialPosition.target.latitude;
    double longitude = initialPosition.target.longitude;
    List<Placemark> address =
        await placemarkFromCoordinates(latitude, longitude);
    if (address.isNotEmpty) {
      String street = address[0].street ?? 'Desconocido';
      String colony = address[0].subLocality ?? 'Desconocido';
      String postalCode = address[0].postalCode ?? 'Desconocido';
      String city = address[0].locality ?? 'Desconocido';
      String state = address[0].administrativeArea ?? 'Desconocido';
      String country = address[0].country ?? 'Desconocido';
      fullAddress.value =
          '$street, $colony, $postalCode, $city, $state, $country';
      addressLatLng = LatLng(latitude, longitude);
    }
  }

  void selectAddress(BuildContext context) {
    if (addressLatLng != null) {
      Map<String, dynamic> data = {
        'address': fullAddress.value,
        'latitude': addressLatLng!.latitude,
        'longitude': addressLatLng!.longitude,
      };
      Navigator.pop(context, data);
    }
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled == true) {
      updateLocation();
    } else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS == true) {
        updateLocation();
      }
    }
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      position = await Geolocator.getLastKnownPosition();
      animateCameraPosition(position?.latitude ?? 19.4040535,
          position?.longitude ?? -102.0463693);
    } catch (e) {}
  }

  Future animateCameraPosition(double latitude, double longitude) async {
    GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(latitude, longitude), zoom: 13, bearing: 0)));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación están denegados.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Los permisos de ubicación se niegan permanentemente, no podemos solicitar permisos.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void onMapCreate(GoogleMapController controller) {
    mapController.complete(controller);
  }
}
