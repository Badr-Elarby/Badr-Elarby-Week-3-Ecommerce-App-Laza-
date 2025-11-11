import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';

class AddressData {
  final double latitude;
  final double longitude;
  final String address;

  AddressData({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  Map<String, dynamic> toMap() => {
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
  };
}

class AddressSelectionScreen extends StatefulWidget {
  const AddressSelectionScreen({super.key});

  @override
  State<AddressSelectionScreen> createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();

  Marker? _pickedMarker;
  CameraPosition _initialCamera = const CameraPosition(
    target: LatLng(30.0444, 31.2357), // Cairo as fallback
    zoom: 12,
  );
  bool _loading = false;
  String _addressText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _moveCamera(LatLng target) async {
    final controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 16)),
    );
  }

  Future<void> _setMarker(LatLng pos) async {
    setState(() {
      _pickedMarker = Marker(markerId: const MarkerId('picked'), position: pos);
    });
  }

  Future<void> _reverseGeocode(double lat, double lng) async {
    setState(() => _loading = true);
    try {
      final places = await placemarkFromCoordinates(lat, lng);
      if (places.isNotEmpty) {
        final p = places.first;
        final formatted = [
          p.street,
          p.locality,
          p.administrativeArea,
          p.country,
        ].where((s) => s != null && s.isNotEmpty).join(', ');
        setState(() {
          _addressText = formatted;
        });
      }
    } catch (_) {
      // ignore
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void _onMapTap(LatLng pos) async {
    _setMarker(pos);
    _searchController.clear();
    await _reverseGeocode(pos.latitude, pos.longitude);
  }

  void _onGPSPressed() async {
    try {
      final pos = await _determinePosition();
      final latLng = LatLng(pos.latitude, pos.longitude);
      await _moveCamera(latLng);
      _setMarker(latLng);
      _searchController.clear();
      _reverseGeocode(latLng.latitude, latLng.longitude);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not determine location: ${e.toString()}'),
          ),
        );
      }
    }
  }

  void _onAddressSearchSubmitted(String query) async {
    if (query.isEmpty) return;

    try {
      setState(() => _loading = true);
      final locations = await locationFromAddress(query);

      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);
        await _moveCamera(latLng);
        _setMarker(latLng);
        await _reverseGeocode(location.latitude, location.longitude);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Address not found')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  void _confirm() {
    if (_pickedMarker == null) return;
    final address = AddressData(
      latitude: _pickedMarker!.position.latitude,
      longitude: _pickedMarker!.position.longitude,
      address: _addressText.isNotEmpty
          ? _addressText
          : '${_pickedMarker!.position.latitude}, ${_pickedMarker!.position.longitude}',
    );
    context.pop(address.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Delivery Location')),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: _initialCamera,
            onMapCreated: (controller) => _controller.complete(controller),
            onTap: _onMapTap,
            markers: _pickedMarker != null ? {_pickedMarker!} : {},
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),

          // Search TextField at top
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search address',
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (query) {
                  if (query.isNotEmpty) {
                    _onAddressSearchSubmitted(query);
                  }
                },
              ),
            ),
          ),

          // Floating GPS Button (bottom-right)
          Positioned(
            right: 16,
            bottom: 120,
            child: FloatingActionButton(
              onPressed: _onGPSPressed,
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.gps_fixed),
            ),
          ),

          // Selected Address Card + Confirm Button (bottom)
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_loading) const LinearProgressIndicator(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _addressText.isNotEmpty
                                ? _addressText
                                : (_pickedMarker != null
                                      ? '${_pickedMarker!.position.latitude.toStringAsFixed(5)}, ${_pickedMarker!.position.longitude.toStringAsFixed(5)}'
                                      : 'Tap map to pick location or search address'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _confirm,
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
