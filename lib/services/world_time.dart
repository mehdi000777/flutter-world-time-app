import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location;
  late String time;
  String flag;
  String url;
  bool isDayTime = false;

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    try {
      var url = Uri.https('worldtimeapi.org', 'api/timezone/${this.url}');
      Response res = await get(url);
      Map data = jsonDecode(res.body);

      String dateTime = data['datetime'];
      String offsetHours = data['utc_offset'].substring(1, 3);
      String offsetMinutes = data['utc_offset'].substring(4, 6);

      // create date time object
      DateTime now = DateTime.parse(dateTime);
      now = now.add(Duration(
          hours: int.parse(offsetHours), minutes: int.parse(offsetMinutes)));

      this.isDayTime = now.hour > 6 && now.hour < 20 ? true : false;
      this.time = DateFormat.jm().format(now);
    } catch (e) {
      print('caught error: $e');
      this.time = 'could not get time data';
    }
  }
}
