import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_localizations.dart';
import '../../data/model/story_model.dart';
import '../../provider/auth_provider.dart';
import '../../provider/story_provider.dart';
import '../widgets/overlay_snackbar_helper.dart';
import '../widgets/placemark_widget.dart';

class StoryDetailLocationPage extends StatefulWidget {
  final String storyId;

  const StoryDetailLocationPage({super.key, required this.storyId});

  @override
  State<StoryDetailLocationPage> createState() => _StoryMapPageState();
}

class _StoryMapPageState extends State<StoryDetailLocationPage> {
  late GoogleMapController mapController;
  Position? currentPosition;
  bool isLoading = true;
  bool _isMapControllerInitialized = false;
  geo.Placemark? placemark;

  late LatLng _storyLocation = LatLng(0, 0); // Diisi di initState

  @override
  void initState() {
    super.initState();
    _loadStoryDetail();

    _getCurrentLocation();
  }

  Future<void> _loadStoryDetail() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    final token = await authProvider.getToken();

    if (token != null) {
      await storyProvider.fetchStoryDetail(
        id: widget.storyId,
        token: token,
        context: context,
      );
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Handle location service tidak aktif
      setState(() => isLoading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle permission ditolak
        setState(() => isLoading = false);
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentPosition = position;
        isLoading = false;
      });

      // Animasi kamera ke posisi user dan story
      if (_isMapControllerInitialized) {
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(
                max(_storyLocation.latitude, position.latitude),
                max(_storyLocation.longitude, position.longitude),
              ),
              southwest: LatLng(
                min(_storyLocation.latitude, position.latitude),
                min(_storyLocation.longitude, position.longitude),
              ),
            ),
            0.0,
            //padding: const EdgeInsets.all(100),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      OverlaySnackbar.error(context, 'Gagal mendapatkan lokasi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryProvider>(context);
    final story = storyProvider.selectedStory;
    final lang = AppLocalizations.of(context);

    _storyLocation = LatLng(story!.lat!, story.lon!);

    return Scaffold(
      appBar: AppBar(title: Text('${lang?.translate('story_location')}')),
      body: Center(
        child: Stack(
          children: [
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                  onMapCreated: (controller) async {
                    final info = await geo.placemarkFromCoordinates(
                      story.lat!,
                      story.lon!,
                    );
                    final place = info[0];
                    setState(() {
                      placemark = place;
                    });

                    setState(() {
                      mapController = controller;
                      _isMapControllerInitialized = true;
                    });
                  },
                  initialCameraPosition: CameraPosition(
                    target: _storyLocation,
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('story_location'),
                      position: _storyLocation,
                      infoWindow: InfoWindow(
                        title: lang?.translate('goto_story_location'),
                      ),
                      onTap: () {
                        mapController.animateCamera(
                          CameraUpdate.newLatLng(_storyLocation),
                        );
                        _setLocationInfo(null, story);
                      },
                    ),
                    if (currentPosition != null)
                      Marker(
                        markerId: const MarkerId('my_location'),
                        position: LatLng(
                          currentPosition!.latitude,
                          currentPosition!.longitude,
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue,
                        ),
                        infoWindow: InfoWindow(
                          title: lang?.translate('my_position'),
                        ),
                        onTap: () async {
                          mapController.animateCamera(
                            CameraUpdate.newLatLng(
                              LatLng(
                                currentPosition!.latitude,
                                currentPosition!.longitude,
                              ),
                            ),
                          );
                          _setLocationInfo(currentPosition, null);
                        },
                      ),
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                ),

            if (placemark == null)
              const SizedBox()
            else
              Positioned(
                bottom: 100,
                right: 16,
                left: 16,
                child: PlacemarkWidget(placemark: placemark!),
              ),

            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                heroTag: 'my_location',
                tooltip: lang?.translate('goto_my_position'),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                onPressed: () async {
                  _zoomToFitTwoMarkers(
                    mapController,
                    LatLng(
                      currentPosition!.latitude,
                      currentPosition!.longitude,
                    ),
                    LatLng(story.lat!, story.lon!),
                  );

                  _setLocationInfo(currentPosition, null);
                },
                child: Icon(Icons.my_location),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'story_location',
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        onPressed: () async {
          mapController.animateCamera(CameraUpdate.newLatLng(_storyLocation));
          _setLocationInfo(null, story);
        },
        tooltip: lang?.translate('goto_story_location'),
        child: const Icon(Icons.location_on),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  void _setLocationInfo(Position? currentPosition, StoryModel? story) async {
    final info = await geo.placemarkFromCoordinates(
      currentPosition != null ? currentPosition.latitude : story!.lat!,
      currentPosition != null ? currentPosition.longitude : story!.lon!,
    );
    final place = info[0];
    setState(() {
      placemark = place;
    });
  }

  void _zoomToFitTwoMarkers(
    GoogleMapController controller,
    LatLng firstLocation,
    LatLng secondLocation,
  ) {
    final bounds = LatLngBounds(
      southwest: LatLng(
        firstLocation.latitude < secondLocation.latitude
            ? firstLocation.latitude
            : secondLocation.latitude,
        firstLocation.longitude < secondLocation.longitude
            ? firstLocation.longitude
            : secondLocation.longitude,
      ),
      northeast: LatLng(
        firstLocation.latitude > secondLocation.latitude
            ? firstLocation.latitude
            : secondLocation.latitude,
        firstLocation.longitude > secondLocation.longitude
            ? firstLocation.longitude
            : secondLocation.longitude,
      ),
    );

    final padding = 50.0; // dalam pixel

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, padding));
  }
}
