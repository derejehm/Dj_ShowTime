import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/movie.dart';

const String API = 'http://www.omdbapi.com/?i';
const String APIKEY = "522a51fe";

const MOVIEID = {
  'tt3794354',
  'tt6723592',
  'tt4154796',
  'tt0448157',
  'tt0094898'
};

class MoviesProvider with ChangeNotifier {
  List<Movie> _items = [];

  //MoviesProvider(this._items);

  List<Movie> get items {
    return [..._items];
  }

  Movie findById(String id) {
    return _items.firstWhere((move) => move.id == id);
  }

  Future<void> fetchAndSetMovies() async {
    try {
      List<Movie> loadedData = [];

      for (var movie in MOVIEID) {
        final url = '$API=$movie&apikey=$APIKEY';
        final response = await http.get(url);

        var extractedData = json.decode(response.body) as Map<String, dynamic>;

        //  print("extracted data : ${extractedData.length}");

        if (extractedData == null) {
          return;
        }

        loadedData.add(
          Movie(
            id: extractedData["imdbID"],
            title: extractedData['Title'],
            year: extractedData['Year'],
            rated: extractedData['Rated'],
            released: extractedData['Released'],
            runtime: extractedData['Runtime'],
            genre: extractedData['Genre'],
            director: extractedData['Director'],
            writer: extractedData['Writer'],
            actors: extractedData['Actors'],
            plot: extractedData['Plot'],
            language: extractedData['Language'],
            country: extractedData['Country'],
            awards: extractedData['Awards'],
            poster: extractedData['Poster'],
            rating: extractedData['imdbRating'],
          ),
        );

        extractedData.clear();
      }

      _items = loadedData;

      //print("Total Lenght: ${loadedData.length}");
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
