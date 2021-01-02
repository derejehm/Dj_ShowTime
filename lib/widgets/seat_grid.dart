import '../provider/seat_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeatGrid extends StatefulWidget {
  @override
  _SeatGridState createState() => _SeatGridState();
}

class _SeatGridState extends State<SeatGrid> {
  bool _isInit = true;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<SeatProvider>(context).fetchAndSetSeat();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final seat = Provider.of<SeatProvider>(context);
    final item = seat.items;
    int _selectedIndex;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 40,
        maxHeight: 500,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: (item.length + 1) * (int.parse(item.first.count) + 1),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: index == 109 ||
                      index == 110 ||
                      index == 111 ||
                      index == 112 ||
                      index == 113 ||
                      index == 114 ||
                      index == 115 ||
                      index == 116 ||
                      index == 117 ||
                      index == 118 ||
                      index == 119
                  ? Text('${index - 108}')
                  : index == 0 ||
                          index == 12 ||
                          index == 24 ||
                          index == 36 ||
                          index == 48 ||
                          index == 60 ||
                          index == 72 ||
                          index == 84 ||
                          index == 96
                      ? Text('${item[index ~/ 12].id}')
                      : index == 108
                          ? Container()
                          : Container(
                              width: 50,
                              height: 25,
                              decoration: BoxDecoration(
                                color: _selectedIndex == index
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(7),
                                    topRight: Radius.circular(7)),
                              ),
                            ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: int.parse(item.first.count) + 1,
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
          ),
        ),
      ),
    );
  }
}
