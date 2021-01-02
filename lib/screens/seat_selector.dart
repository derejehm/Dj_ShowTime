import 'package:DjShowTime/model/seat.dart';
import 'package:DjShowTime/provider/seat_provider.dart';
import 'package:DjShowTime/screens/cinema_ticket.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SeatSelector extends StatefulWidget {
  static const String routeName = 'seat_selector';
  List<int> _selectedIndex = [];
  List<Seat> item = [];
  var _booked = [];
  var _selectedq = 1;
  var price = 0;

  @override
  _SeatSelectorState createState() => _SeatSelectorState();
}

class _SeatSelectorState extends State<SeatSelector> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
    final movieDetails = ModalRoute.of(context).settings.arguments as String;
    final seat = Provider.of<SeatProvider>(context, listen: false);
    widget.item = seat.items;
    widget._booked =
        Provider.of<SeatProvider>(context, listen: false).getBookedList;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Seat Selector",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  movieDetails.split(',')[0],
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                'Schedule Selected',
                style: TextStyle(color: Colors.black45),
                textAlign: TextAlign.center,
              ),
              Text(
                '${DateFormat('EEEE,MM').format(DateTime.parse(movieDetails.split(',')[1]))} | ${movieDetails.split(',')[2]}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment
                          .bottomCenter, // 10% of the width, so there are ten blinds.
                      colors: [Colors.grey[300], Colors.white],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Hall 1 : Block A',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Tab on your preferd seat',
                            style: TextStyle(color: Colors.grey),
                          ),
                          bulidGrid(widget.item ?? []),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              buildContainer(Colors.transparent),
                              Text(' Avalable'),
                              Spacer(),
                              buildContainer(Colors.black),
                              Text(' Booked'),
                              Spacer(),
                              buildContainer(Colors.blue),
                              Text(' Your Selection'),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildContainer(Colors.transparent),
                                Text(' Not-Avalable on Meda'),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text('TICKET'),
                                        Text('QTY'),
                                      ],
                                    ),
                                    Text(
                                      '${widget._selectedq}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    new DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        items: <String>[
                                          '1',
                                          '2',
                                          '3',
                                          '4',
                                          '5',
                                          '6',
                                          '7',
                                          '8',
                                          '9',
                                          '10'
                                        ].map((String value) {
                                          return new DropdownMenuItem<String>(
                                            value: value,
                                            child: new Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            widget._selectedq =
                                                int.parse(value);
                                          });
                                        },
                                      ),
                                    ),
                                    Text(
                                      '|',
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.grey),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text('TOTAL'),
                                        Text('PAYABLE'),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        '${widget._selectedIndex.length * 35} Br',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {},
                  child: ListTile(
                      onTap: () {
                        if (widget._selectedIndex.length > 0) {
                          Navigator.of(context).pushNamed(
                              CinemaTicket.routeName,
                              arguments: movieDetails);
                        } else {
                          _toastInfo('Please select seat!!');
                        }
                      },
                      title: Text(
                        "Next",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Icon(Icons.arrow_forward, color: Colors.white)),
                ),
              ),
            ],
          ),
        ));
  }

  Container buildContainer(Color color) {
    return Container(
      width: 30,
      height: 25,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(7), topRight: Radius.circular(7)),
      ),
    );
  }

  bulidGrid(item) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 40,
        maxHeight: 350,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: (item.length + 1) * (int.parse(item.first.count) + 1),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (!widget._booked.contains(index.toString())) {
                    if (widget._selectedIndex.contains(index)) {
                      widget._selectedIndex
                          .removeWhere((element) => element == index);
                    } else {
                      widget._selectedIndex.add(index);
                    }
                    widget._selectedq = widget._selectedIndex.length;
                  } else {
                    _toastInfo('This seat already taken!');
                  }
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
                                color: widget._selectedIndex.contains(index)
                                    ? Theme.of(context).primaryColor
                                    : widget._booked
                                            .any((e) => int.parse(e) == index)
                                        ? Colors.black54
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

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }
}
