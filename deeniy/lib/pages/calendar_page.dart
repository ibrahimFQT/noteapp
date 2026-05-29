import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() =>
      _CalendarPageState();
}

class _CalendarPageState
    extends State<CalendarPage>
    with TickerProviderStateMixin {

  late Box box;

  Timer? timer;

  DateTime now = DateTime.now();

  DateTime selectedDate =
      DateTime.now();

  final TextEditingController
      scheduleController =
          TextEditingController();

  late AnimationController
      progressController;

  final List<Map<String, dynamic>>
      islamicEvents = [

    {
      'title': 'Isra Mi’raj',
      'date': DateTime(2026, 1, 27),
      'icon': Icons.auto_awesome,
    },

    {
      'title': 'Awal Ramadhan',
      'date': DateTime(2026, 2, 17),
      'icon': Icons.nights_stay,
    },

    {
      'title': 'Nuzulul Quran',
      'date': DateTime(2026, 3, 26),
      'icon': Icons.menu_book,
    },

    {
      'title': 'Idul Fitri',
      'date': DateTime(2026, 3, 19),
      'icon': Icons.mosque,
    },

    {
      'title': 'Idul Adha',
      'date': DateTime(2026, 5, 27),
      'icon': Icons.star,
    },

    {
      'title': 'Tahun Baru Hijriyah',
      'date': DateTime(2026, 6, 16),
      'icon': Icons.calendar_month,
    },

    {
      'title': 'Maulid Nabi',
      'date': DateTime(2026, 9, 4),
      'icon': Icons.favorite,
    },
  ];

  @override
  void initState() {
    super.initState();

    box = Hive.box(
      'deeniyBox',
    );

    if (box.get('calendarSchedules') ==
        null) {

      box.put(
        'calendarSchedules',
        {},
      );
    }

    if (box.get('userXP') == null) {

      box.put(
        'userXP',
        0,
      );
    }

    progressController =
        AnimationController(
      vsync: this,
      duration:
          const Duration(
        milliseconds: 900,
      ),
    );

    progressController.forward();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {

        setState(() {

          now = DateTime.now();
        });
      },
    );
  }

  @override
  void dispose() {

    timer?.cancel();

    progressController.dispose();

    scheduleController.dispose();

    super.dispose();
  }

  String get dateKey {

    return DateFormat(
      'yyyy-MM-dd',
    ).format(
      selectedDate,
    );
  }

  Map get schedules {

    return box.get(
      'calendarSchedules',
    );
  }

  List<Map<String, dynamic>>
      get todaySchedules {

    return List<Map<String, dynamic>>.from(
      schedules[dateKey] ?? [],
    );
  }

  int get totalXP {

    return box.get(
      'userXP',
      defaultValue: 0,
    );
  }

  int get currentLevel {

    int level = 1;

    int xp = totalXP;

    int needed = 500;

    while (xp >= needed) {

      xp -= needed;

      level++;

      needed *= 2;
    }

    return level;
  }

  int get currentLevelXP {

    int xp = totalXP;

    int needed = 500;

    while (xp >= needed) {

      xp -= needed;

      needed *= 2;
    }

    return xp;
  }

  int get nextLevelXP {

    int needed = 500;

    for (
      int i = 1;
      i < currentLevel;
      i++
    ) {

      needed *= 2;
    }

    return needed;
  }

  double get progressValue {

    return currentLevelXP /
        nextLevelXP;
  }

  List<Map<String, dynamic>>
      get currentMonthEvents {

    return islamicEvents.where(
      (event) {

        final date =
            event['date'] as DateTime;

        return date.month ==
                selectedDate.month &&
            date.year ==
                selectedDate.year;
      },
    ).toList();
  }

  void saveSchedule() {

    if (scheduleController.text
        .trim()
        .isEmpty) {

      return;
    }

    final allSchedules =
        Map<String, dynamic>.from(
      schedules,
    );

    List<Map<String, dynamic>>
        currentList =
            List<Map<String, dynamic>>.from(
      allSchedules[dateKey] ?? [],
    );

    currentList.add({

      'title':
          scheduleController.text,

      'done': false,
    });

    allSchedules[dateKey] =
        currentList;

    box.put(
      'calendarSchedules',
      allSchedules,
    );

    scheduleController.clear();

    setState(() {});
  }

  void toggleDone(
    int index,
  ) {

    final allSchedules =
        Map<String, dynamic>.from(
      schedules,
    );

    List<Map<String, dynamic>>
        currentList =
            List<Map<String, dynamic>>.from(
      allSchedules[dateKey] ?? [],
    );

    bool currentStatus =
        currentList[index]['done'];

    currentList[index]['done'] =
        !currentStatus;

    if (!currentStatus) {

      int xp = totalXP;

      xp += 100;

      box.put(
        'userXP',
        xp,
      );
    }

    allSchedules[dateKey] =
        currentList;

    box.put(
      'calendarSchedules',
      allSchedules,
    );

    setState(() {});
  }

  void deleteSchedule(
    int index,
  ) {

    final allSchedules =
        Map<String, dynamic>.from(
      schedules,
    );

    List<Map<String, dynamic>>
        currentList =
            List<Map<String, dynamic>>.from(
      allSchedules[dateKey] ?? [],
    );

    currentList.removeAt(index);

    allSchedules[dateKey] =
        currentList;

    box.put(
      'calendarSchedules',
      allSchedules,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(
        0xFFF4F7F5,
      ),

      body: SafeArea(

        child:
            SingleChildScrollView(

          physics:
              const BouncingScrollPhysics(),

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

              buildXPCard(),

              const SizedBox(
                height: 28,
              ),

              buildCalendarCard(),

              const SizedBox(
                height: 28,
              ),

              buildSectionTitle(
                'Tambah Schedule',
              ),

              const SizedBox(
                height: 14,
              ),

              buildAddScheduleField(),

              const SizedBox(
                height: 30,
              ),

              buildSectionTitle(
                'Schedule Hari Ini',
              ),

              const SizedBox(
                height: 16,
              ),

              todaySchedules.isEmpty
                  ? buildEmptySchedule()
                  : Column(
                      children:
                          List.generate(
                        todaySchedules.length,
                        (index) {

                          return buildScheduleCard(
                            todaySchedules[
                                index],
                            index,
                          );
                        },
                      ),
                    ),

              const SizedBox(
                height: 32,
              ),

              buildSectionTitle(
                'Hari Besar Bulan Ini',
              ),

              const SizedBox(
                height: 18,
              ),

              currentMonthEvents.isEmpty
                  ? buildNoEventCard()
                  : Column(
                      children:
                          currentMonthEvents.map(
                        (event) {

                          return buildEventCard(
                            event,
                          );
                        },
                      ).toList(),
                    ),

              const SizedBox(
                height: 50,
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

        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              'Kalender Muslim',
              style: TextStyle(
                fontSize: 30,
                fontWeight:
                    FontWeight.bold,
                color:
                    Color(0xFF1F4E45),
              ),
            ),

            const SizedBox(
              height: 6,
            ),

            Text(
              DateFormat(
                'EEEE, d MMMM yyyy',
              ).format(now),

              style:
                  const TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
          ],
        ),

        Container(
          padding:
              const EdgeInsets.all(
            15,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              20,
            ),

            boxShadow: [

              BoxShadow(
                color: Colors.black
                    .withOpacity(0.05),

                blurRadius: 10,
              ),
            ],
          ),

          child: const Icon(
            Icons.auto_awesome,
            color:
                Color(0xFF1F4E45),
          ),
        ),
      ],
    );
  }

  Widget buildXPCard() {

    return AnimatedContainer(

      duration:
          const Duration(
        milliseconds: 500,
      ),

      width: double.infinity,

      padding:
          const EdgeInsets.all(
        28,
      ),

      decoration: BoxDecoration(

        gradient:
            const LinearGradient(
          colors: [

            Color(0xFF1F4E45),

            Color(0xFF2F7D6B),
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

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [

              const Text(
                'PRODUCTIVITY XP',
                style: TextStyle(
                  color:
                      Colors.white70,

                  letterSpacing: 2,
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),

                decoration:
                    BoxDecoration(
                  color: Colors.white24,

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child: Text(
                  'LEVEL $currentLevel',

                  style:
                      const TextStyle(
                    color:
                        Colors.white,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 24,
          ),

          Text(
            '$totalXP XP',

            style:
                const TextStyle(
              color: Colors.white,

              fontSize: 44,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          ClipRRect(

            borderRadius:
                BorderRadius.circular(
              20,
            ),

            child:
                TweenAnimationBuilder<double>(

              tween: Tween(
                begin: 0,
                end: progressValue,
              ),

              duration:
                  const Duration(
                milliseconds: 1200,
              ),

              builder:
                  (
                    context,
                    value,
                    child,
                  ) {

                return LinearProgressIndicator(

                  value: value,

                  minHeight: 12,

                  backgroundColor:
                      Colors.white24,

                  valueColor:
                      const AlwaysStoppedAnimation(
                    Colors.white,
                  ),
                );
              },
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          Text(
            '$currentLevelXP / $nextLevelXP XP menuju Level ${currentLevel + 1}',

            style:
                const TextStyle(
              color:
                  Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCalendarCard() {

    final firstDay =
        DateTime(
      selectedDate.year,
      selectedDate.month,
      1,
    );

    final daysInMonth =
        DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;

    final startWeekday =
        firstDay.weekday;

    final weekDays = [

      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return Container(

      padding:
          const EdgeInsets.all(
        24,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          30,
        ),

        boxShadow: [

          BoxShadow(
            color: Colors.black
                .withOpacity(0.04),

            blurRadius: 12,
          ),
        ],
      ),

      child: Column(

        children: [

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [

              IconButton(
                onPressed: () {

                  setState(() {

                    selectedDate =
                        DateTime(
                      selectedDate.year,
                      selectedDate.month -
                          1,
                      1,
                    );
                  });
                },

                icon: const Icon(
                  Icons.chevron_left,
                ),
              ),

              Text(
                DateFormat(
                  'MMMM yyyy',
                ).format(
                  selectedDate,
                ),

                style:
                    const TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              IconButton(
                onPressed: () {

                  setState(() {

                    selectedDate =
                        DateTime(
                      selectedDate.year,
                      selectedDate.month +
                          1,
                      1,
                    );
                  });
                },

                icon: const Icon(
                  Icons.chevron_right,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          Row(
            children:
                weekDays.map(
              (day) {

                return Expanded(
                  child: Center(
                    child: Text(
                      day,

                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,

                        color:
                            Colors.black54,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),

          const SizedBox(
            height: 18,
          ),

          GridView.builder(

            shrinkWrap: true,

            physics:
                const NeverScrollableScrollPhysics(),

            itemCount:
                daysInMonth +
                    startWeekday -
                    1,

            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(

              crossAxisCount: 7,

              mainAxisSpacing: 10,

              crossAxisSpacing: 10,
            ),

            itemBuilder:
                (context, index) {

              if (index <
                  startWeekday - 1) {

                return const SizedBox();
              }

              final day =
                  index -
                      startWeekday +
                      2;

              final date =
                  DateTime(
                selectedDate.year,
                selectedDate.month,
                day,
              );

              final isToday =
                  now.day == day &&
                      now.month ==
                          selectedDate
                              .month &&
                      now.year ==
                          selectedDate
                              .year;

              final isSelected =
                  selectedDate.day ==
                      day;

              return GestureDetector(

                onTap: () {

                  setState(() {

                    selectedDate =
                        date;
                  });
                },

                child:
                    AnimatedContainer(

                  duration:
                      const Duration(
                    milliseconds:
                        250,
                  ),

                  decoration:
                      BoxDecoration(

                    color: isSelected
                        ? const Color(
                            0xFF1F4E45,
                          )
                        : isToday
                            ? const Color(
                                0xFFB7E4D7,
                              )
                            : const Color(
                                0xFFF5F5F5,
                              ),

                    shape:
                        BoxShape.circle,
                  ),

                  child: Center(
                    child: Text(
                      '$day',

                      style:
                          TextStyle(

                        color: isSelected
                            ? Colors.white
                            : Colors.black,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
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
        fontSize: 24,
        fontWeight:
            FontWeight.bold,
      ),
    );
  }

  Widget buildAddScheduleField() {

    return Row(
      children: [

        Expanded(
          child: TextField(
            controller:
                scheduleController,

            decoration:
                InputDecoration(

              hintText:
                  'Tambah aktivitas...',

              filled: true,

              fillColor:
                  Colors.white,

              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 18,
              ),

              border:
                  OutlineInputBorder(

                borderRadius:
                    BorderRadius.circular(
                  24,
                ),

                borderSide:
                    BorderSide.none,
              ),
            ),
          ),
        ),

        const SizedBox(
          width: 14,
        ),

        GestureDetector(
          onTap: saveSchedule,

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
                22,
              ),
            ),

            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildScheduleCard(
    Map<String, dynamic> data,
    int index,
  ) {

    final bool done =
        data['done'];

    return AnimatedContainer(

      duration:
          const Duration(
        milliseconds: 300,
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

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          28,
        ),

        boxShadow: [

          BoxShadow(
            color: Colors.black
                .withOpacity(0.04),

            blurRadius: 10,
          ),
        ],
      ),

      child: Row(
        children: [

          GestureDetector(

            onTap: () {

              toggleDone(
                index,
              );
            },

            child: AnimatedContainer(

              duration:
                  const Duration(
                milliseconds: 300,
              ),

              width: 34,
              height: 34,

              decoration:
                  BoxDecoration(

                color: done
                    ? Colors.green
                    : Colors.transparent,

                border: Border.all(
                  color: done
                      ? Colors.green
                      : Colors.grey,
                  width: 2,
                ),

                shape:
                    BoxShape.circle,
              ),

              child: done
                  ? const Icon(
                      Icons.check,
                      color:
                          Colors.white,
                      size: 18,
                    )
                  : null,
            ),
          ),

          const SizedBox(
            width: 16,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Text(
                  data['title'],

                  style: TextStyle(

                    fontSize: 18,

                    fontWeight:
                        FontWeight.w600,

                    decoration: done
                        ? TextDecoration
                            .lineThrough
                        : null,

                    color: done
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  done
                      ? '+100 XP didapat'
                      : 'Selesaikan untuk mendapatkan 100 XP',

                  style:
                      TextStyle(

                    color: done
                        ? Colors.green
                        : Colors.black54,

                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {

              deleteSchedule(
                index,
              );
            },

            icon: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptySchedule() {

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(
        30,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          28,
        ),
      ),

      child: const Column(
        children: [

          Icon(
            Icons.event_busy,
            size: 52,
            color: Colors.black38,
          ),

          SizedBox(
            height: 16,
          ),

          Text(
            'Belum ada schedule',

            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNoEventCard() {

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(
        24,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          28,
        ),
      ),

      child: const Text(
        'Tidak ada hari besar Islam di bulan ini.',

        style: TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget buildEventCard(
    Map<String, dynamic> event,
  ) {

    final DateTime date =
        event['date'];

    return Container(

      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      padding:
          const EdgeInsets.all(
        22,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          28,
        ),

        boxShadow: [

          BoxShadow(
            color: Colors.black
                .withOpacity(0.04),

            blurRadius: 10,
          ),
        ],
      ),

      child: Row(
        children: [

          Container(
            padding:
                const EdgeInsets.all(
              16,
            ),

            decoration: BoxDecoration(
              color:
                  const Color(
                0xFFE6F2EE,
              ),

              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),

            child: Icon(
              event['icon'],

              color:
                  const Color(
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
                  CrossAxisAlignment
                      .start,

              children: [

                Text(
                  event['title'],

                  style:
                      const TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  DateFormat(
                    'd MMMM yyyy',
                  ).format(date),

                  style:
                      const TextStyle(
                    color:
                        Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}