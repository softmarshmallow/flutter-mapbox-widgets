import 'package:flutter/widgets.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart';

class MapboxMapWidgetController {
  addWidgetMarker(Widget marker) {}
}

// ignore: must_be_immutable
class MapboxMapWidget extends StatelessWidget {
  final CameraPosition initialCameraPosition;
  final MapboxMapWidgetController widgetController;
  MapboxMapController _controller;

  A() {
    _controller.addSymbol(
      null,
    );
//    _controller.updateSymbol(symbol, changes)
  }

  SymbolOptions _getSymbolOptions(String iconImage) {
    return SymbolOptions(
      geometry: LatLng(0, 0),
      iconImage: iconImage,
    );
  }

  MapboxMapWidget(
      {Key key, @required this.initialCameraPosition, this.widgetController})
      : super(key: key);

  _onMapCreated(MapboxMapController c) {
    _controller = c;
    _add("airport-15");
    Future.delayed(Duration(seconds: 1)).then((value) {
      _add("networkImage");

    });

//    _controller.addSymbol(_getSymbolOptions(
//        "https://icon.foundation/resources/image/og-img.png"));
  }

  Future<void> addImageFromUrl(String name, String url) async {
    var response = await get(url);
    return _controller.addImage(name, response.bodyBytes);
  }

  void _add(String iconImage) {
    List<int> availableNumbers = Iterable<int>.generate(12).toList();
    _controller.symbols.forEach(
        (s) => availableNumbers.removeWhere((i) => i == s.data['count']));
    if (availableNumbers.isNotEmpty) {
      _controller.addSymbol(
          _getSymbolOptions(iconImage), {'count': availableNumbers.first});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
        initialCameraPosition: initialCameraPosition,
        onStyleLoadedCallback: () {
          addImageFromUrl("networkImage", "https://via.placeholder.com/50");
        },
        onMapCreated: _onMapCreated);
  }
}
