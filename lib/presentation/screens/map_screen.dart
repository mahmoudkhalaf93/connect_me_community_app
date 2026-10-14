import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    // 3 Hardcoded members
    _markers.add(
      const Marker(
        markerId: MarkerId('member1'),
        position: LatLng(30.0444, 31.2357), // Cairo
        infoWindow: InfoWindow(title: 'Ahmed Ali', snippet: 'Cairo, Egypt'),
      ),
    );
    _markers.add(
      const Marker(
        markerId: MarkerId('member2'),
        position: LatLng(25.2048, 55.2708), // Dubai
        infoWindow: InfoWindow(title: 'Sara Khalid', snippet: 'Dubai, UAE'),
      ),
    );
    _markers.add(
      const Marker(
        markerId: MarkerId('member3'),
        position: LatLng(48.8566, 2.3522), // Paris
        infoWindow: InfoWindow(title: 'John Doe', snippet: 'Paris, France'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Map')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(30.0444, 31.2357), // Default to Cairo
          zoom: 4,
        ),
        markers: _markers,
        myLocationEnabled: true,
      ),
    );
  }
}
