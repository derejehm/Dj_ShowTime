import 'package:DjShowTime/provider/movies_provider.dart';
import 'package:DjShowTime/widgets/movie_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NowShowing extends StatefulWidget {
  static const String routeName = 'now_showing';

  @override
  _NowShowingState createState() => _NowShowingState();
}

class _NowShowingState extends State<NowShowing> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<MoviesProvider>(context).fetchAndSetMovies().then((value) => {
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
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Now Showing",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : MovieGrid());
  }
}
