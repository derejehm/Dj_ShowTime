import '../provider/movies_provider.dart';
import '../widgets/movie_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieData = Provider.of<MoviesProvider>(context);
    final movies = movieData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(25.0),
      itemCount: movies.length,
      itemBuilder: (ctx, i) => MovieItem(
        movies[i].id,
        movies[i].title,
        movies[i].runtime,
        movies[i].poster,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
    );
  }
}
