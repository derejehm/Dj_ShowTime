import 'package:flutter/material.dart';

class MovieDetailCard extends StatelessWidget {
  final loadedProduct;

  MovieDetailCard(this.loadedProduct);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    loadedProduct.poster,
                    fit: BoxFit.cover,
                    width: double.infinity,
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
      ],
    );
  }
}
