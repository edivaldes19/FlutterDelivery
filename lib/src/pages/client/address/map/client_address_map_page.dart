import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/pages/client/address/map/client_address_map_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientAddressMapPage extends StatelessWidget {
  ClientAddressMapController con = Get.put(ClientAddressMapController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text('Ubica tu dirección',
                style: TextStyle(color: Colors.black))),
        body: Stack(children: [
          _googleMaps(),
          _iconMyLocation(),
          _cardAddress(),
          _buttonAccept(context)
        ])));
  }

  Widget _googleMaps() {
    return GoogleMap(
        initialCameraPosition: con.initialPosition,
        mapType: MapType.hybrid,
        onMapCreated: con.onMapCreate,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        onCameraMove: (position) {
          con.initialPosition = position;
        },
        onCameraIdle: () async {
          await con.setLocationDraggableInfo();
        });
  }

  Widget _iconMyLocation() {
    return Center(
        child:
            Image.asset('assets/img/location_red.png', width: 50, height: 50));
  }

  Widget _cardAddress() {
    return Container(
        width: double.infinity,
        alignment: Alignment.topCenter,
        margin: EdgeInsets.symmetric(vertical: 30),
        child: Card(
            color: Colors.grey[800],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(con.fullAddress.value,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)))));
  }

  Widget _buttonAccept(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 30),
        child: ElevatedButton(
            onPressed: () => con.selectAddress(context),
            child: Text('Establecer dirección',
                style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.all(15))));
  }
}
