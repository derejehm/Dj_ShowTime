import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CinemaTicket extends StatefulWidget {
  static const String routeName = 'cinema_ticket';

  @override
  _CinemaTicketState createState() => _CinemaTicketState();
}

class _CinemaTicketState extends State<CinemaTicket> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File _imageFile;
  GlobalKey _globalKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final movieDetails = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Cinema Ticket',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Cinema Ticket',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 150,
                child: Divider(
                  color: Colors.black38,
                ),
              ),
              Text(
                '${movieDetails.split(',')[0]}',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Screenshot(
                controller: screenshotController,
                child: Container(
                  padding: EdgeInsets.all(30),
                  child: QrImage(
                    backgroundColor: Colors.white,
                    data: movieDetails,
                    version: QrVersions.auto,
                  ),
                ),
              ),
              Container(
                child: Divider(
                  color: Colors.black38,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildRowDetail(context, movieDetails),
                    Container(
                      height: 20,
                    ),
                    buildRowDetail2(context, movieDetails),
                  ],
                ),
              ),
              Container(
                child: Divider(
                  color: Colors.black38,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notice ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('1. Keep this receipt safe and private'),
                  Text('2. Do not shar or duplicate this receipt'),
                  Text('3. Keep this receipt safe and private'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {},
                  child: ListTile(
                      onTap: () {
                        _requestPermission();
                        _imageFile = null;
                        screenshotController
                            .capture(delay: Duration(milliseconds: 10))
                            .then((File image) async {
                          setState(() {
                            _imageFile = image;
                          });
                          final result = await ImageGallerySaver.saveImage(
                              _imageFile.readAsBytesSync());
                          print("File Saved to Gallery");
                          print(result['isSuccess']);
                          if (result['isSuccess']) {
                            _toastInfo('Ticket Saved to Gallery');
                            Navigator.of(context).pushNamed('/');
                          }
                        }).catchError((onError) {
                          print(onError);
                        });
                      },
                      title: Text(
                        "Save As image",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Icon(Icons.arrow_forward, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildRowDetail(BuildContext context, String movieDetails) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '${DateFormat('EEEE MM, y').format(DateTime.parse(movieDetails.split(',')[1]))}',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '${movieDetails.split(',')[2]}',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }

  Row buildRowDetail2(BuildContext context, String movieDetails) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cinema Hall',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'A',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seat',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '1A',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              width: 60,
            )
          ],
        )
      ],
    );
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    if (!info.contains("granted")) {
      _toastInfo(info);
    }
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }
}
