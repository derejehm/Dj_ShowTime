import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/movies_provider.dart';
import './screens/movie_details.dart';

import './screens/now_showing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: MoviesProvider())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Dj Showtime",
          theme: ThemeData(
            primarySwatch: Colors.lightBlue,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: NowShowing(),
          routes: {
            MovieDetails.routeName: (ctx) => MovieDetails(),
          }),
    );
  }
}
