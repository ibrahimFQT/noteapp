import 'dart:async';

import 'package:flutter/material.dart';

import '../main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
  });

  @override
  State<SplashPage> createState() =>
      _SplashPageState();
}

class _SplashPageState
    extends State<SplashPage>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  late Animation<double> fadeAnimation;

  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );

    scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ),
    );

    controller.forward();

    Timer(
      const Duration(seconds: 4),
      () {

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const MainNavigation(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF1F4E45),

      body: Center(

        child: FadeTransition(

          opacity: fadeAnimation,

          child: ScaleTransition(

            scale: scaleAnimation,

            child: Column(

              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                Container(

                  width: 140,
                  height: 140,

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      40,
                    ),

                    boxShadow: const [

                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 25,
                        offset: Offset(
                          0,
                          10,
                        ),
                      ),
                    ],
                  ),

                  child: const Icon(
                    Icons.mosque_rounded,
                    size: 70,
                    color:
                        Color(0xFF1F4E45),
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                const Text(

                  'DEENIY',

                  style: TextStyle(

                    color: Colors.white,

                    fontSize: 40,

                    fontWeight:
                        FontWeight.bold,

                    letterSpacing: 4,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                const Text(

                  'Modern Muslim Companion',

                  style: TextStyle(

                    color: Colors.white70,

                    fontSize: 16,

                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(
                  height: 60,
                ),

                const SizedBox(

                  width: 45,
                  height: 45,

                  child:
                      CircularProgressIndicator(

                    color: Colors.white,

                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}