import 'package:DjShowTime/screens/movie_details.dart';
import 'package:flutter/material.dart';

class MovieItem extends StatelessWidget {
  final String id;
  final String title;
  final String runtime;
  final String poster;

  MovieItem(this.id, this.title, this.runtime, this.poster);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  MovieDetails.routeName,
                  arguments: id,
                );
              },
              child: Image.network(
                poster,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        ListTile(
            title: Text(title),
            subtitle: Text(
              getTimeString(
                int.parse(runtime.split(' ')[0]),
              ),
            )),
      ],
    );
  }

  String getTimeString(int value) {
    final int hour = (value ~/ 60).floor();
    final int minutes = value % 60;
    return '${hour}h ${minutes}m';
  }
}
