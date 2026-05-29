import 'package:flutter/material.dart';

import '../services/prayer_service.dart';

class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key});

  @override
  State<PrayerPage> createState() =>
      _PrayerPageState();
}

class _PrayerPageState
    extends State<PrayerPage> {

  late Future<Map<String, dynamic>>
      prayerData;

  final TextEditingController
      cityController =
          TextEditingController();

  String currentCity =
      'Jakarta';

  String nextPrayerName = '';
  String nextPrayerTime = '';

  @override
  void initState() {
    super.initState();

    prayerData =
        PrayerService.getPrayerTimes(
      currentCity,
    );
  }

  void searchCity() {

    if (cityController.text
        .trim()
        .isEmpty) {

      return;
    }

    setState(() {

      currentCity =
          cityController.text;

      prayerData =
          PrayerService.getPrayerTimes(
        currentCity,
      );
    });
  }

  void calculateNextPrayer(
    Map<String, dynamic> data,
  ) {

    final now = TimeOfDay.now();

    final prayers = {

      'Subuh': data['Fajr'],
      'Dzuhur': data['Dhuhr'],
      'Ashar': data['Asr'],
      'Maghrib': data['Maghrib'],
      'Isya': data['Isha'],
    };

    for (var entry
        in prayers.entries) {

      final split =
          entry.value.split(':');

      final prayerHour =
          int.parse(split[0]);

      final prayerMinute =
          int.parse(split[1]);

      final prayerTime =
          TimeOfDay(
        hour: prayerHour,
        minute: prayerMinute,
      );

      final nowMinutes =
          now.hour * 60 +
              now.minute;

      final prayerMinutes =
          prayerTime.hour * 60 +
              prayerTime.minute;

      if (prayerMinutes >
          nowMinutes) {

        nextPrayerName =
            entry.key;

        nextPrayerTime =
            entry.value;

        return;
      }
    }

    nextPrayerName = 'Subuh';
    nextPrayerTime = data['Fajr'];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(

        child: FutureBuilder<
            Map<String, dynamic>>(
          future: prayerData,

          builder: (
            context,
            snapshot,
          ) {

            if (snapshot.connectionState ==
                ConnectionState.waiting) {

              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {

              return const Center(
                child: Text(
                  'Gagal mengambil jadwal',
                ),
              );
            }

            final data = snapshot.data!;

            calculateNextPrayer(data);

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
                    height: 28,
                  ),

                  buildSearchField(),

                  const SizedBox(
                    height: 30,
                  ),

                  buildHeroCard(),

                  const SizedBox(
                    height: 35,
                  ),

                  buildStatisticsCard(),

                  const SizedBox(
                    height: 35,
                  ),

                  buildSectionTitle(
                    'Prayer Schedule',
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  prayerTile(
                    Icons.wb_twilight,
                    'Subuh',
                    data['Fajr'],
                  ),

                  prayerTile(
                    Icons.light_mode,
                    'Dzuhur',
                    data['Dhuhr'],
                  ),

                  prayerTile(
                    Icons.sunny,
                    'Ashar',
                    data['Asr'],
                  ),

                  prayerTile(
                    Icons.nights_stay,
                    'Maghrib',
                    data['Maghrib'],
                  ),

                  prayerTile(
                    Icons.dark_mode,
                    'Isya',
                    data['Isha'],
                  ),

                  const SizedBox(
                    height: 35,
                  ),

                  buildDailyMotivation(),

                  const SizedBox(
                    height: 25,
                  ),

                  buildReminderCard(),

                  const SizedBox(
                    height: 50,
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

        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              'Jadwal Sholat',
              style: TextStyle(
                fontSize: 30,
                fontWeight:
                    FontWeight.bold,
                color:
                    Color(0xFF1F4E45),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              currentCity,
              style: const TextStyle(
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
            Icons.public,
            color: Color(0xFF1F4E45),
          ),
        ),
      ],
    );
  }

  Widget buildSearchField() {

    return Row(
      children: [

        Expanded(
          child: TextField(
            controller:
                cityController,

            onSubmitted: (value) {
              searchCity();
            },

            decoration:
                InputDecoration(

              hintText:
                  'Cari kota / negara',

              filled: true,

              fillColor:
                  Colors.white,

              prefixIcon:
                  const Icon(
                Icons.search,
              ),

              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),

                borderSide:
                    BorderSide.none,
              ),
            ),
          ),
        ),

        const SizedBox(
          width: 12,
        ),

        GestureDetector(
          onTap: searchCity,

          child: Container(
            padding:
                const EdgeInsets.all(
              18,
            ),

            decoration: BoxDecoration(
              color:
                  const Color(
                0xFF1F4E45,
              ),

              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),

            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHeroCard() {

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(
        30,
      ),

      decoration: BoxDecoration(

        gradient:
            const LinearGradient(
          begin: Alignment.topLeft,
          end:
              Alignment.bottomRight,

          colors: [
            Color(0xFF1F4E45),
            Color(0xFF2D6A5D),
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          34,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(
            'Current Location',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            currentCity,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          Container(
            padding:
                const EdgeInsets.all(
              18,
            ),

            decoration: BoxDecoration(
              color: Colors.white24,

              borderRadius:
                  BorderRadius.circular(
                22,
              ),
            ),

            child: Row(
              children: [

                Container(
                  padding:
                      const EdgeInsets.all(
                    14,
                  ),

                  decoration:
                      BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),

                  child: const Icon(
                    Icons.notifications_active,
                    color:
                        Color(0xFF1F4E45),
                  ),
                ),

                const SizedBox(
                  width: 18,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      const Text(
                        'Next Prayer',
                        style: TextStyle(
                          color:
                              Colors.white70,
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Text(
                        '$nextPrayerName • $nextPrayerTime',
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize: 24,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatisticsCard() {

    return Row(
      children: [

        Expanded(
          child: Container(
            padding:
                const EdgeInsets.all(
              24,
            ),

            decoration:
                BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                28,
              ),
            ),

            child: const Column(
              children: [

                Icon(
                  Icons.language,
                  size: 36,
                  color:
                      Color(0xFF1F4E45),
                ),

                SizedBox(height: 12),

                Text(
                  'Global',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  'Worldwide Prayer',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color:
                        Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(
          width: 16,
        ),

        Expanded(
          child: Container(
            padding:
                const EdgeInsets.all(
              24,
            ),

            decoration:
                BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                28,
              ),
            ),

            child: const Column(
              children: [

                Icon(
                  Icons.watch_later,
                  size: 36,
                  color:
                      Color(0xFF1F4E45),
                ),

                SizedBox(height: 12),

                Text(
                  'Realtime',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  'Live Schedule',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color:
                        Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSectionTitle(
    String title,
  ) {

    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight:
            FontWeight.bold,
      ),
    );
  }

  Widget prayerTile(
    IconData icon,
    String title,
    String time,
  ) {

    final isNextPrayer =
        title == nextPrayerName;

    return AnimatedContainer(
      duration:
          const Duration(
        milliseconds: 400,
      ),

      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      padding:
          const EdgeInsets.all(
        20,
      ),

      decoration: BoxDecoration(

        color: isNextPrayer
            ? const Color(
                0xFF1F4E45,
              )
            : Colors.white,

        borderRadius:
            BorderRadius.circular(
          28,
        ),
      ),

      child: Row(
        children: [

          Container(
            padding:
                const EdgeInsets.all(
              15,
            ),

            decoration: BoxDecoration(
              color: isNextPrayer
                  ? Colors.white24
                  : const Color(
                      0xFFE7F3EF,
                    ),

              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),

            child: Icon(
              icon,

              color: isNextPrayer
                  ? Colors.white
                  : const Color(
                      0xFF1F4E45,
                    ),
            ),
          ),

          const SizedBox(
            width: 18,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,

                    color:
                        isNextPrayer
                            ? Colors.white
                            : Colors.black,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  isNextPrayer
                      ? 'Upcoming Prayer'
                      : 'Prayer Time',

                  style: TextStyle(
                    color:
                        isNextPrayer
                            ? Colors.white70
                            : Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          Text(
            time,

            style: TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,

              color:
                  isNextPrayer
                      ? Colors.white
                      : const Color(
                          0xFF1F4E45,
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDailyMotivation() {

    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(
        28,
      ),

      decoration: BoxDecoration(

        gradient:
            const LinearGradient(
          colors: [
            Color(0xFF3A4750),
            Color(0xFF303841),
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          30,
        ),
      ),

      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            'Daily Motivation',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),

          SizedBox(height: 16),

          Text(
            'Sholat bukan sekadar kewajiban, tapi bentuk disiplin hidup seorang muslim.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              height: 1.5,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReminderCard() {

    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(
        28,
      ),

      decoration: BoxDecoration(

        gradient:
            const LinearGradient(
          colors: [
            Color(0xFF222831),
            Color(0xFF393E46),
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          30,
        ),
      ),

      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            'Reminder',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),

          SizedBox(height: 16),

          Text(
            'Sholat tepat waktu lebih penting daripada mood dan rasa malas.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              height: 1.5,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}