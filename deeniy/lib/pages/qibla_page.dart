import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() =>
      _QiblaPageState();
}

class _QiblaPageState
    extends State<QiblaPage> {

  double qiblaDirection = 0;

  @override
  void initState() {
    super.initState();

    calculateQibla();
  }

  Future<void> calculateQibla() async {

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission ==
        LocationPermission.denied) {

      permission =
          await Geolocator
              .requestPermission();
    }

    Position position =
        await Geolocator
            .getCurrentPosition();

    double userLat =
        position.latitude;

    double userLng =
        position.longitude;

    const double kaabaLat =
        21.4225;

    const double kaabaLng =
        39.8262;

    double dLon =
        (kaabaLng - userLng) *
            pi /
            180;

    double lat1 =
        userLat * pi / 180;

    double lat2 =
        kaabaLat * pi / 180;

    double y = sin(dLon);

    double x =
        cos(lat1) * tan(lat2) -
            sin(lat1) *
                cos(dLon);

    double bearing =
        atan2(y, x);

    bearing =
        bearing * 180 / pi;

    bearing =
        (bearing + 360) % 360;

    setState(() {
      qiblaDirection = bearing;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(

        child: StreamBuilder<
            CompassEvent>(
          stream:
              FlutterCompass.events,

          builder: (
            context,
            snapshot,
          ) {

            if (!snapshot.hasData) {

              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            double direction =
                snapshot.data!.heading ?? 0;

            double angle =
                (qiblaDirection -
                        direction) *
                    (pi / 180);

            return SingleChildScrollView(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  buildHeader(),

                  const SizedBox(
                    height: 30,
                  ),

                  buildHeroCard(),

                  const SizedBox(
                    height: 40,
                  ),

                  Center(
                    child: Stack(
                      alignment:
                          Alignment.center,

                      children: [

                        Container(
                          width: 320,
                          height: 320,

                          decoration:
                              BoxDecoration(
                            shape:
                                BoxShape.circle,

                            color:
                                Colors.white,
                          ),
                        ),

                        Transform.rotate(
                          angle: angle,

                          child: Column(
                            children: [

                              const Icon(
                                Icons.navigation,
                                size: 130,
                                color:
                                    Color(
                                  0xFF1F4E45,
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              const Text(
                                'KA\'BAH',
                                style:
                                    TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  letterSpacing:
                                      2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 45,
                  ),

                  buildInfoCard(),

                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildHeader() {

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        const Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              'Arah Kiblat',
              style: TextStyle(
                fontSize: 30,
                fontWeight:
                    FontWeight.bold,
                color:
                    Color(0xFF1F4E45),
              ),
            ),

            SizedBox(height: 8),

            Text(
              'Realtime Qibla Compass',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),

        Container(
          padding:
              const EdgeInsets.all(14),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              18,
            ),
          ),

          child: const Icon(
            Icons.explore,
            color: Color(0xFF1F4E45),
          ),
        ),
      ],
    );
  }

  Widget buildHeroCard() {

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(
        28,
      ),

      decoration: BoxDecoration(

        gradient:
            const LinearGradient(
          colors: [
            Color(0xFF1F4E45),
            Color(0xFF2D6A5D),
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          32,
        ),
      ),

      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            'DEENIY QIBLA',
            style: TextStyle(
              color: Colors.white70,
              letterSpacing: 2,
            ),
          ),

          SizedBox(height: 18),

          Text(
            'Temukan arah kiblat akurat dimanapun kamu berada.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              height: 1.5,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard() {

    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(
        26,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          28,
        ),
      ),

      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            'Tips',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          SizedBox(height: 16),

          Text(
            '• Jauhkan HP dari magnet\n\n'
            '• Gunakan di area terbuka\n\n'
            '• Kalibrasi kompas dengan gerakan angka 8',
            style: TextStyle(
              fontSize: 16,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}