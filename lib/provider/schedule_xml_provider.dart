import 'package:xml/xml.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../model/schedule.dart';

class ScheduleXmlProvier with ChangeNotifier {
  List<Schedule> _items = [];

  List<Schedule> get items {
    return [..._items];
  }

  Future<void> fetchAndSetSchedule() async {
    List<Schedule> loadedData = [];
    try {
      var xmlfile = await rootBundle.loadString('assets/xml/schedule.xml');
      var raw = XmlDocument.parse(xmlfile);

      final hours = raw.findAllElements('hour');
      loadedData = hours.map((e) => Schedule(hour: e.text)).toList();
    } catch (e) {
      print(e);
    }

    _items = loadedData;

    notifyListeners();
  }
}
