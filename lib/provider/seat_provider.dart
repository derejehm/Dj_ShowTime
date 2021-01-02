import 'package:DjShowTime/model/seat.dart';
import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

class SeatProvider with ChangeNotifier {
  List<Seat> _items = [];
  List<String> _booked = [];

  List<Seat> get items {
    return _items == null ? [] : [..._items];
  }

  Seat findById(String id) {
    return _items.firstWhere((seat) => seat.id == id);
  }

  get getBookedList {
    return [..._booked];
  }

  Future<void> fetchAndSetSeat() async {
    List<Seat> loadedData = [];
    try {
      var xmlfile = await rootBundle.loadString('assets/xml/seat.xml');
      var raw = XmlDocument.parse(xmlfile);

      final hours = raw.findAllElements('row');
      loadedData = hours
          .map(
            (e) => Seat(
                id: e.findElements('id').single.text,
                no: int.parse(e.findElements('no').single.text),
                count: e.findElements('count').single.text,
                booked: e
                    .findElements('booked')
                    .map((e) => e.text)
                    .map((e) => e)
                    .toList()),
          )
          .toList();

      _items = loadedData;
      final total = raw.findAllElements('booked').map((node) => node
          .findElements('element')
          .where((element) => element.text.trim().isNotEmpty)
          .map((e) => e.text));
      for (var i in total) {
        for (var n in i) {
          _booked.add(n);
        }
      }
    } catch (e) {
      print(e);
    }

    _items = loadedData;

    notifyListeners();
  }
}
