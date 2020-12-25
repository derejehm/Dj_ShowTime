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

class _MovieDetailsState extends State<MovieDetails> {
  var _selectedValue;

  @override
  Widget build(BuildContext context) {
    final id =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProduct = Provider.of<MoviesProvider>(
      context,
      listen: false,
    ).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title, style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Hero(
                        tag: 'poster',
                        child: Image.network(
                          loadedProduct.poster,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      loadedProduct.title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.star_border),
                          label: Text('${loadedProduct.rating}'),
                        ),
                        FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.schedule),
                          label: Text('${loadedProduct.runtime}'),
                        ),
                        FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.theaters_outlined),
                          label: Text('3D'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Synopsis',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  FlatButton(
                      onPressed: null,
                      child: Text(loadedProduct.genre.split(',')[0])),
                  FlatButton(
                      onPressed: null,
                      child: Text(loadedProduct.genre.split(',')[1])),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedProduct.plot,
                textAlign: TextAlign.justify,
                softWrap: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Date', textAlign: TextAlign.right),
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
                    print(_selectedValue);
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
