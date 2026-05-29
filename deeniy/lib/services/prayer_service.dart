import 'dart:convert';

import 'package:http/http.dart' as http;

class PrayerService {

  static Future<Map<String, dynamic>>
      getPrayerTimes(
    String city,
  ) async {

    final url = Uri.parse(
      'https://api.aladhan.com/v1/timingsByCity?city=$city&country=&method=8',
    );

    final response =
        await http.get(url);

    final data =
        jsonDecode(response.body);

    return data['data']['timings'];
  }
}