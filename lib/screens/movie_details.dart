import 'package:DjShowTime/provider/schedule_xml_provider.dart';
import 'package:DjShowTime/screens/seat_selector.dart';
import 'package:DjShowTime/widgets/movie_detail_card.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/movies_provider.dart';

const labelMonth = 'Month';
const labelDate = 'Date';
const labelWeekDay = 'Week Day';

class MovieDetails extends StatefulWidget {
  static const String routeName = 'movie_details';

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

var color = Colors.white;
var text = Colors.black;
var _selectedIndex = 0;

class _MovieDetailsState extends State<MovieDetails> {
  var _selectedValue;
  bool _isInit = true;
  bool _isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ScheduleXmlProvier>(context)
          .fetchAndSetSchedule()
          .then((value) => {
                setState(() {
                  _isLoading = false;
                }),
              });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final id =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedMovie = Provider.of<MoviesProvider>(
      context,
      listen: false,
    ).findById(id);
    final scheduleItem = Provider.of<ScheduleXmlProvier>(context).items;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(loadedMovie.title, style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MovieDetailCard(loadedMovie),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Date', style: TextStyle(fontSize: 20)),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              height: 120,
              child: DatePicker(
                DateTime.now(),
                initialSelectedDate: DateTime.now(),
                selectionColor: Theme.of(context).primaryColor,
                selectedTextColor: Colors.white,
                deactivatedColor: Colors.grey,
                onDateChange: (date) {
                  // New date selected
                  setState(() {
                    _selectedValue = date;
                    // print(_selectedValue);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Time', style: TextStyle(fontSize: 20)),
            ),
            Container(
              margin: EdgeInsets.all(15.0),
              padding: EdgeInsets.all(15.0),
              height: 250,
              child: ListView.builder(
                itemCount: scheduleItem.length,
                itemBuilder: (context, index) {
                  return RaisedButton(
                    color: _selectedIndex == index
                        ? Theme.of(context).primaryColor
                        : color,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    child: Text(
                      index == 0
                          ? scheduleItem[index].hour + " (Available)"
                          : scheduleItem[index].hour + " (Not-Available)",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: _selectedIndex == index ? Colors.white : text),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  );
                },
              ),
            ),
            FlatButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {},
              child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(SeatSelector.routeName,
                        arguments:
                            '${loadedMovie.title},${_selectedValue ?? DateTime.now()},${scheduleItem[_selectedIndex].hour}');
                  },
                  title: Text(
                    "Continue to seat selector",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Icon(Icons.arrow_forward, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
