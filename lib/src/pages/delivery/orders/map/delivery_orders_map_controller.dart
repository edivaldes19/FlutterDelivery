import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/environment/environment.dart';
import 'package:flutter_delivery/src/models/order.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/providers/orders_provider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:socket_io_client/socket_io_client.dart';

class DeliveryOrdersMapController extends GetxController {
  Socket socket = io('${Environment.API_URL}orders/delivery', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });
  Order order = Order.fromJson(Get.arguments['order'] ?? {});
  OrdersProvider ordersProvider = OrdersProvider();
  CameraPosition initialPosition =
      const CameraPosition(target: LatLng(19.4040535, -102.0463693), zoom: 13);
  LatLng? addressLatLng;
  var addressName = ''.obs;
  Completer<GoogleMapController> mapController = Completer();
  Position? position;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? homeMarker;
  StreamSubscription? positionSubscribe;
  Set<Polyline> polylines = <Polyline>{}.obs;
  List<LatLng> points = [];
  double distanceBetween = 0.0;
  bool isClose = false;
  DeliveryOrdersMapController() {
    checkGPS();
    connectAndListen();
  }
  void addMarker(String markerId, double latitude, double longitude,
      String title, String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(title: title, snippet: content));
    markers[id] = marker;
    update();
  }

  Future animateCameraPosition(double latitude, double longitude) async {
    GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(latitude, longitude), zoom: 13, bearing: 0)));
  }

  void callNumber() async {
    String? number = order.client?.phone;
    number != null
        ? await FlutterPhoneDirectCaller.callNumber(number)
        : Get.snackbar('Error', 'Número desconocido.');
  }

  void centerPosition() {
    if (position != null) {
      animateCameraPosition(position!.latitude, position!.longitude);
    }
  }

  void checkGPS() async {
    deliveryMarker =
        await createMarkerFromAssets('assets/img/food_delivery.png');
    homeMarker =
        await createMarkerFromAssets('assets/img/destination_place.png');
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

  void connectAndListen() {
    socket.connect();
    socket.onConnect((data) {});
  }

  Future<BitmapDescriptor> createMarkerFromAssets(String path) async {
    ImageConfiguration configuration = const ImageConfiguration();
    BitmapDescriptor descriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return descriptor;
  }

  void emitPosition() {
    if (position != null) {
      socket.emit('position', {
        'id_order': order.id,
        'latitude': position!.latitude,
        'longitude': position!.longitude,
      });
    }
  }

  void emitToDelivered() {
    socket.emit('delivered', {
      'id_order': order.id,
    });
  }

  void isCloseToDeliveryPosition() {
    if (position != null) {
      distanceBetween = Geolocator.distanceBetween(
          position!.latitude,
          position!.longitude,
          order.address!.latitude!,
          order.address!.longitude!);
      if (distanceBetween <= 50 && isClose == false) {
        isClose = true;
        update();
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    socket.disconnect();
    positionSubscribe?.cancel();
  }

  void onMapCreate(GoogleMapController controller) {
    mapController.complete(controller);
  }

  void saveLocation() async {
    if (position != null) {
      order.latitude = position!.latitude;
      order.longitude = position!.longitude;
      await ordersProvider.updateLatLng(order);
    }
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
      addressName.value =
          '$street, $colony, $postalCode, $city, $state, $country';
      addressLatLng = LatLng(latitude, longitude);
    }
  }

  Future<void> setPolylines(LatLng from, LatLng to) async {
    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS, pointFrom, pointTo);
    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }
    Polyline polyline = Polyline(
        polylineId: const PolylineId('poly'),
        color: Colors.amber,
        points: points,
        width: 5);
    polylines.add(polyline);
    update();
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      position = await Geolocator.getLastKnownPosition();
      saveLocation();
      animateCameraPosition(position?.latitude ?? 19.4040535,
          position?.longitude ?? -102.0463693);
      addMarker(
          'delivery',
          position?.latitude ?? 19.4040535,
          position?.longitude ?? -102.0463693,
          'Tu posición',
          '',
          deliveryMarker!);
      addMarker('home', order.address?.latitude ?? 19.4040535,
          order.address?.longitude ?? -102.0463693, 'Destino', '', homeMarker!);
      LatLng from = LatLng(position!.latitude, position!.longitude);
      LatLng to = LatLng(order.address?.latitude ?? 19.4040535,
          order.address?.longitude ?? -102.0463693);
      setPolylines(from, to);
      LocationSettings locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.best, distanceFilter: 1);
      positionSubscribe =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position pos) {
        position = pos;
        addMarker(
            'delivery',
            position?.latitude ?? 19.4040535,
            position?.longitude ?? -102.0463693,
            'Tu posicion',
            '',
            deliveryMarker!);
        animateCameraPosition(position?.latitude ?? 19.4040535,
            position?.longitude ?? -102.0463693);
        emitPosition();
        isCloseToDeliveryPosition();
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void updateToDelivered() async {
    if (distanceBetween <= 50) {
      ResponseApi responseApi = await ordersProvider.updateToDelivered(order);
      Fluttertoast.showToast(
          msg: responseApi.message ?? 'Desconocido',
          toastLength: Toast.LENGTH_LONG);
      if (responseApi.success == true) {
        emitToDelivered();
        Get.offNamedUntil('/delivery/home', (route) => false);
      }
    } else {
      Get.snackbar('Error',
          'Estás demasiado lejos de tu destino para hacer la entrega.');
    }
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
}
