import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {

  late Timer timer;

  late Box box;

  DateTime now = DateTime.now();

  int currentStreak = 0;

  int bestStreak = 0;

  final List<Map<String, dynamic>>
      prayerStreaks = [

    {
      'title': 'Subuh',
      'icon': Icons.dark_mode,
      'done': false,
    },

    {
      'title': 'Dzuhur',
      'icon': Icons.wb_sunny,
      'done': false,
    },

    {
      'title': 'Ashar',
      'icon': Icons.sunny,
      'done': false,
    },

    {
      'title': 'Maghrib',
      'icon': Icons.nightlight_round,
      'done': false,
    },

    {
      'title': 'Isya',
      'icon': Icons.bedtime,
      'done': false,
    },
  ];

  @override
  void initState() {
    super.initState();

    box = Hive.box(
      'deeniyBox',
    );

    loadData();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {

        if (!mounted) return;

        setState(() {

          now = DateTime.now();
        });
      },
    );
  }

  void loadData() {

    currentStreak =
        box.get(
          'currentStreak',
          defaultValue: 0,
        );

    bestStreak =
        box.get(
          'bestStreak',
          defaultValue: 0,
        );

    final saved =
        box.get(
          'prayerStreaks',
        );

    if (saved != null) {

      for (
        int i = 0;
        i < prayerStreaks.length;
        i++
      ) {

        prayerStreaks[i]['done'] =
            saved[i];
      }
    }
  }

  @override
  void dispose() {

    timer.cancel();

    super.dispose();
  }

  void togglePrayer(
    int index,
  ) {

    setState(() {

      prayerStreaks[index]['done'] =
          !prayerStreaks[index]['done'];

      final completed =
          prayerStreaks
              .where(
                (e) =>
                    e['done'] == true,
              )
              .length;

      currentStreak = completed;

      if (currentStreak >
          bestStreak) {

        bestStreak =
            currentStreak;
      }
    });

    box.put(
      'currentStreak',
      currentStreak,
    );

    box.put(
      'bestStreak',
      bestStreak,
    );

    box.put(
      'prayerStreaks',
      prayerStreaks
          .map(
            (e) =>
                e['done'],
          )
          .toList(),
    );
  }

  String getFeatureDescription(
    String title,
  ) {

    switch (title) {

      case 'Doa':
        return 'Kumpulan doa harian muslim lengkap untuk aktivitas sehari-hari.';

      case 'Sholat':
        return 'Lihat jadwal sholat dan pantau ibadah harianmu dengan mudah.';

      case 'Kiblat':
        return 'Temukan arah kiblat secara cepat dan akurat dimanapun kamu berada.';

      case 'Kalender':
        return 'Kalender islam modern lengkap dengan tanggal hijriyah.';

      default:
        return 'Fitur tersedia.';
    }
  }

  @override
  Widget build(BuildContext context) {

    const textColor =
        Colors.black;

    const subTextColor =
        Colors.black54;

    const cardColor =
        Colors.white;

    return Scaffold(

      backgroundColor:
          const Color(
        0xFFF5F7F6,
      ),

      body: SafeArea(

        child:
            SingleChildScrollView(

          padding:
              const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              buildHeader(),

              const SizedBox(
                height: 22,
              ),

              buildRealtimeCard(),

              const SizedBox(
                height: 24,
              ),

              buildSectionTitle(
                'Quick Access',
              ),

              const SizedBox(
                height: 14,
              ),

              buildQuickAccess(
                cardColor,
                textColor,
                subTextColor,
              ),

              const SizedBox(
                height: 24,
              ),

              buildSectionTitle(
                'Prayer Streak',
              ),

              const SizedBox(
                height: 14,
              ),

              buildPrayerStreakCard(
                cardColor,
                textColor,
                subTextColor,
              ),

              const SizedBox(
                height: 24,
              ),

              buildSectionTitle(
                'Statistik',
              ),

              const SizedBox(
                height: 14,
              ),

              buildStatsCard(
                cardColor,
                textColor,
                subTextColor,
              ),

              const SizedBox(
                height: 40,
              ),
            ],
          ),
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
              'Assalamu\'alaikum',

              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
                color: Colors.black,
              ),
            ),

            SizedBox(
              height: 4,
            ),

            Text(
              'Selamat datang kembali',

              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
              ),
            ),
          ],
        ),

        Container(

          padding:
              const EdgeInsets.all(
            11,
          ),

          decoration:
              BoxDecoration(

            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),

          child: const Icon(
            Icons.notifications_none,
            size: 22,
            color:
                Color(0xFF1F4E45),
          ),
        ),
      ],
    );
  }

  Widget buildRealtimeCard() {

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(
        22,
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
          28,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(
            'REALTIME',

            style: TextStyle(
              color: Colors.white70,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),

          const SizedBox(
            height: 14,
          ),

          AnimatedSwitcher(

            duration:
                const Duration(
              milliseconds: 300,
            ),

            child: Text(

              DateFormat(
                'HH:mm:ss',
              ).format(now),

              key: ValueKey(
                now.second,
              ),

              style:
                  const TextStyle(

                color: Colors.white,

                fontSize: 40,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Text(

            DateFormat(
              'EEEE, d MMMM yyyy',
            ).format(now),

            style:
                const TextStyle(

              color: Colors.white70,

              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(
    String title,
  ) {

    return Text(
      title,

      style: const TextStyle(
        fontSize: 20,
        fontWeight:
            FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget buildQuickAccess(
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {

    final features = [

      {
        'icon':
            Icons.menu_book_rounded,
        'title': 'Doa',
      },

      {
        'icon':
            Icons.access_time,
        'title': 'Sholat',
      },

      {
        'icon':
            Icons.explore,
        'title': 'Kiblat',
      },

      {
        'icon':
            Icons.calendar_month,
        'title': 'Kalender',
      },
    ];

    return GridView.builder(

      itemCount: features.length,

      shrinkWrap: true,

      physics:
          const NeverScrollableScrollPhysics(),

      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(

        crossAxisCount: 2,

        crossAxisSpacing: 12,
        mainAxisSpacing: 12,

        childAspectRatio: 1.25,
      ),

      itemBuilder:
          (context, index) {

        final item =
            features[index];

        return GestureDetector(

          onTap: () {

            showDialog(

              context: context,

              barrierDismissible: true,

              builder: (context) {

                return Dialog(

                  backgroundColor:
                      Colors.transparent,

                  child:
                      TweenAnimationBuilder(

                    duration:
                        const Duration(
                      milliseconds: 350,
                    ),

                    tween: Tween(
                      begin: 0.8,
                      end: 1.0,
                    ),

                    curve:
                        Curves.easeOutBack,

                    builder:
                        (
                          context,
                          value,
                          child,
                        ) {

                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },

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
                          32,
                        ),
                      ),

                      child: Column(

                        mainAxisSize:
                            MainAxisSize.min,

                        children: [

                          Container(

                            width: 72,
                            height: 72,

                            decoration:
                                BoxDecoration(

                              color:
                                  const Color(
                                0xFFE6F2EE,
                              ),

                              borderRadius:
                                  BorderRadius.circular(
                                22,
                              ),
                            ),

                            child: Icon(

                              item['icon']
                                  as IconData,

                              color:
                                  const Color(
                                0xFF1F4E45,
                              ),

                              size: 36,
                            ),
                          ),

                          const SizedBox(
                            height: 22,
                          ),

                          Text(

                            item['title']
                                as String,

                            style:
                                const TextStyle(

                              fontSize: 24,

                              fontWeight:
                                  FontWeight.bold,

                              color:
                                  Color(
                                0xFF1F4E45,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 14,
                          ),

                          Text(

                            getFeatureDescription(
                              item['title']
                                  as String,
                            ),

                            textAlign:
                                TextAlign.center,

                            style:
                                const TextStyle(

                              fontSize: 15,

                              color:
                                  Colors.black54,

                              height: 1.6,
                            ),
                          ),

                          const SizedBox(
                            height: 24,
                          ),

                          SizedBox(

                            width: double.infinity,

                            child:
                                ElevatedButton(

                              style:
                                  ElevatedButton.styleFrom(

                                backgroundColor:
                                    const Color(
                                  0xFF1F4E45,
                                ),

                                padding:
                                    const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),

                                shape:
                                    RoundedRectangleBorder(

                                  borderRadius:
                                      BorderRadius.circular(
                                    18,
                                  ),
                                ),
                              ),

                              onPressed: () {

                                Navigator.pop(
                                  context,
                                );
                              },

                              child:
                                  const Text(

                                'Mengerti',

                                style: TextStyle(
                                  color:
                                      Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },

          child:
              AnimatedContainer(

            duration:
                const Duration(
              milliseconds: 300,
            ),

            padding:
                const EdgeInsets.all(
              16,
            ),

            decoration:
                BoxDecoration(

              color: cardColor,

              borderRadius:
                  BorderRadius.circular(
                22,
              ),

              boxShadow: [

                BoxShadow(

                  color: Colors.black
                      .withOpacity(
                    0.04,
                  ),

                  blurRadius: 8,

                  offset:
                      const Offset(
                    0,
                    4,
                  ),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Container(

                  padding:
                      const EdgeInsets.all(
                    10,
                  ),

                  decoration:
                      BoxDecoration(

                    color:
                        const Color(
                      0xFFE6F2EE,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),

                  child: Icon(

                    item['icon']
                        as IconData,

                    color:
                        const Color(
                      0xFF1F4E45,
                    ),

                    size: 20,
                  ),
                ),

                const Spacer(),

                Text(

                  item['title']
                      as String,

                  style: TextStyle(

                    color:
                        textColor,

                    fontSize: 16,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(

                  'Tap to preview',

                  style: TextStyle(
                    color:
                        subTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPrayerStreakCard(
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {

    return Container(

      padding:
          const EdgeInsets.all(
        20,
      ),

      decoration: BoxDecoration(

        color: cardColor,

        borderRadius:
            BorderRadius.circular(
          26,
        ),
      ),

      child: Column(
        children: [

          Row(
            children: [

              Container(

                padding:
                    const EdgeInsets.all(
                  10,
                ),

                decoration:
                    BoxDecoration(

                  color: Colors.orange
                      .withOpacity(0.15),

                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),

                child: const Icon(

                  Icons
                      .local_fire_department,

                  color: Colors.orange,
                  size: 22,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    Text(

                      '$currentStreak / 5 Sholat',

                      style:
                          TextStyle(

                        color:
                            textColor,

                        fontSize: 18,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(

                      'Pertahankan konsistensi ibadah',

                      style:
                          TextStyle(
                        color:
                            subTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children:
                List.generate(
              prayerStreaks.length,
              (index) {

                final item =
                    prayerStreaks[index];

                final done =
                    item['done'];

                return GestureDetector(

                  onTap: () {

                    togglePrayer(
                      index,
                    );
                  },

                  child:
                      AnimatedContainer(

                    duration:
                        const Duration(
                      milliseconds: 300,
                    ),

                    width: 56,
                    height: 72,

                    decoration:
                        BoxDecoration(

                      color: done
                          ? const Color(
                              0xFF1F4E45,
                            )
                          : const Color(
                              0xFFF3F3F3,
                            ),

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),

                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                      children: [

                        Icon(

                          item['icon']
                              as IconData,

                          color: done
                              ? Colors.white
                              : const Color(
                                  0xFF1F4E45,
                                ),

                          size: 20,
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        Text(

                          item['title']
                              as String,

                          style:
                              TextStyle(

                            color: done
                                ? Colors.white
                                : textColor,

                            fontSize: 10,

                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatsCard(
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {

    return Row(
      children: [

        Expanded(
          child: buildMiniStat(
            'Current',
            '$currentStreak',
            Icons.bolt,
            cardColor,
            textColor,
            subTextColor,
          ),
        ),

        const SizedBox(
          width: 12,
        ),

        Expanded(
          child: buildMiniStat(
            'Best',
            '$bestStreak',
            Icons.emoji_events,
            cardColor,
            textColor,
            subTextColor,
          ),
        ),
      ],
    );
  }

  Widget buildMiniStat(
    String title,
    String value,
    IconData icon,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {

    return Container(

      padding:
          const EdgeInsets.all(
        18,
      ),

      decoration: BoxDecoration(

        color: cardColor,

        borderRadius:
            BorderRadius.circular(
          22,
        ),
      ),

      child: Column(
        children: [

          Icon(
            icon,
            color:
                const Color(
              0xFF1F4E45,
            ),
            size: 22,
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            value,

            style: TextStyle(

              color: textColor,

              fontSize: 24,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            title,

            style: TextStyle(
              color: subTextColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}