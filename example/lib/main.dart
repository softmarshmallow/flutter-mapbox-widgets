import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(title: 'Mapbox Widgets'),
    );
  }
}

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MapboxMapController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildMap(),
        if (controller != null)
          MarkerLayer(
            controller: controller,
          )
      ],
    );
  }

  onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    controller.addListener(() {
      print("updated");
    });

    setState(() {});
  }

  Widget buildMap() {
    return MapboxMap(
      onMapCreated: onMapCreated,
      onCameraIdle: () {
        print("idle");
      },
      onMapIdle: () {
        print("map idle");
      },
      accessToken:
          "pk.eyJ1Ijoic29mdG1hcnNobWFsbG93IiwiYSI6ImNqN2xnOHR1NDJvczEyd2t5ZmljYXZ0NHIifQ.uUIoAP8Ip49wxqPVKLH8_g",
      initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
    );
  }
}

class Marker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.black,
    );
  }
}

class MarkerLayer extends StatefulWidget {
  final MapboxMapController controller;

  const MarkerLayer({Key key, @required this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MarkerLayerState();
}

class _MarkerLayerState extends State<MarkerLayer> {
  MapboxMapController get controller {
    return widget.controller;
  }

  LatLngBounds visibleRegion;
  CameraPosition cameraPosition;
  Point<double> point; //  = Point<double>(0, 0);
  Point<double> point2; //  = Point<double>(0, 0);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      print("updated");

      if (controller.isCameraMoving) {
        startUpdate();
      } else {
        stopUpdate();
      }

      //          controller.
//          cameraPosition = controller.cameraPosition;
//          print("cameraPosition.bearing : ${cameraPosition.bearing}");
//          print("cameraPosition.tilt : ${cameraPosition.tilt}");
//          print("cameraPosition.target : ${cameraPosition.target}");
//          print("cameraPosition.zoom : ${cameraPosition.zoom}");
    });
  }

  bool isUpdating;

  var a = 0.0;

  startUpdate() async {
    if (isUpdating) {
      return;
    }
    isUpdating = true;
    while (isUpdating) {
      print("point!!");
//      final newp = await controller.toScreenLocation(LatLng(0, 0));
//      final newp2 = await controller.toScreenLocation(LatLng(0, 80));
      await Future.delayed(Duration(microseconds: 1000));
      setState(() {
        a += 0.01;
        point = Point<double>(a, a);
//        point2 = newp2;
      });
    }
  }

  stopUpdate() {
    isUpdating = false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (point != null)
          Positioned(
            child: Marker(),
            top: point.y,
            left: point.x,
          ),
        if (point2 != null)
          Positioned(
            child: Marker(),
            top: point2.y,
            left: point2.x,
          ),
      ],
    );
  }
}
