import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/calendar_page.dart';
import 'pages/doa_page.dart';
import 'pages/home_page.dart';
import 'pages/prayer_page.dart';
import 'pages/qibla_page.dart';
import 'pages/splash_page.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox(
    'deeniyBox',
  );

  runApp(
    const DeeniyApp(),
  );
}

class DeeniyApp extends StatelessWidget {

  const DeeniyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner:
          false,

      title: 'Deeniy',

      theme: ThemeData(

        useMaterial3: true,

        fontFamily: 'Roboto',

        scaffoldBackgroundColor:
            const Color(
          0xFFF5F7F6,
        ),

        colorScheme:
            ColorScheme.fromSeed(

          seedColor:
              const Color(
            0xFF1F4E45,
          ),
        ),

        appBarTheme:
            const AppBarTheme(

          backgroundColor:
              Colors.transparent,

          elevation: 0,
        ),

        navigationBarTheme:
            const NavigationBarThemeData(

          backgroundColor:
              Colors.white,

          indicatorColor:
              Color(
            0xFFE6F2EE,
          ),
        ),
      ),

      home: const SplashPage(),
    );
  }
}

class MainNavigation
    extends StatefulWidget {

  const MainNavigation({
    super.key,
  });

  @override
  State<MainNavigation>
      createState() =>
          _MainNavigationState();
}

class _MainNavigationState
    extends State<MainNavigation> {

  int currentIndex = 0;

  final List<Widget> pages = const [

    HomePage(),

    DoaPage(),

    PrayerPage(),

    QiblaPage(),

    CalendarPage(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: AnimatedSwitcher(

        duration:
            const Duration(
          milliseconds: 350,
        ),

        child: pages[currentIndex],
      ),

      bottomNavigationBar:
          Padding(

        padding:
            const EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 10,
        ),

        child: ClipRRect(

          borderRadius:
              BorderRadius.circular(
            28,
          ),

          child: NavigationBar(

            backgroundColor:
                Colors.white,

            height: 68,

            elevation: 0,

            selectedIndex:
                currentIndex,

            labelBehavior:
                NavigationDestinationLabelBehavior
                    .onlyShowSelected,

            animationDuration:
                const Duration(
              milliseconds: 400,
            ),

            onDestinationSelected:
                (index) {

              setState(() {

                currentIndex =
                    index;
              });
            },

            destinations: const [

              NavigationDestination(

                icon: Icon(
                  Icons.home_outlined,
                ),

                selectedIcon:
                    Icon(
                  Icons.home,
                ),

                label: 'Home',
              ),

              NavigationDestination(

                icon: Icon(
                  Icons.menu_book_outlined,
                ),

                selectedIcon:
                    Icon(
                  Icons.menu_book,
                ),

                label: 'Doa',
              ),

              NavigationDestination(

                icon: Icon(
                  Icons.access_time_outlined,
                ),

                selectedIcon:
                    Icon(
                  Icons.access_time,
                ),

                label: 'Sholat',
              ),

              NavigationDestination(

                icon: Icon(
                  Icons.explore_outlined,
                ),

                selectedIcon:
                    Icon(
                  Icons.explore,
                ),

                label: 'Kiblat',
              ),

              NavigationDestination(

                icon: Icon(
                  Icons.calendar_month_outlined,
                ),

                selectedIcon:
                    Icon(
                  Icons.calendar_month,
                ),

                label: 'Kalender',
              ),
            ],
          ),
        ),
      ),
    );
  }
}