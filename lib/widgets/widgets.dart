import 'package:asianflix/models/episodetype.dart';
import 'package:asianflix/models/movie.dart';
import 'package:asianflix/viewmodels/dataserviceviewmodel.dart';
import 'package:asianflix/views/moviedetailpage.dart';
import 'package:asianflix/views/moviepage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:asianflix/services/dataservice.dart';
import 'package:provider/provider.dart';

class DiscoverMovies extends StatefulWidget {
  final ThemeData themeData;
  DiscoverMovies({required this.themeData});
  @override
  _DiscoverMoviesState createState() => _DiscoverMoviesState();
}

class _DiscoverMoviesState extends State<DiscoverMovies> {
  List<Movie>? moviesList;
  @override
  void initState() {
    super.initState();
    Provider.of<DataServiceViewModel>(context, listen: false)
        .getTopTodayList()
        .then((value) {
      setState(() {
        moviesList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text('Discover', style: widget.themeData.textTheme.headline5),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 250,
          child: moviesList == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : CarouselSlider.builder(
                  options: CarouselOptions(
                    disableCenter: true,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                    autoPlay: true,
                  ),
                  itemBuilder:
                      (BuildContext context, int index, pageViewIndex) {
                    return Container(
                      child: GestureDetector(
                        onTap: () {},
                        child: Hero(
                          tag: '${moviesList![index].moviename}discover',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: FadeInImage(
                              image: NetworkImage(
                                  moviesList![index].moviethumbnail!),
                              fit: BoxFit.cover,
                              placeholder:
                                  const AssetImage('images/muvi/images/na.jpg'),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: moviesList!.length,
                ),
        ),
      ],
    );
  }
}

class ScrollingMovies extends StatefulWidget {
  final ThemeData themeData;
  final String title;
  final episodeType getepisodetype;
  ScrollingMovies(
      {required this.themeData,
      required this.title,
      required this.getepisodetype});
  @override
  _ScrollingMoviesState createState() => _ScrollingMoviesState();
}

class _ScrollingMoviesState extends State<ScrollingMovies> {
  List<Movie>? moviesList;
  @override
  void initState() {
    super.initState();

    Provider.of<DataServiceViewModel>(context, listen: false)
        .getScrollMovieList(widget.getepisodetype)
        .then((value) {
      setState(() {
        moviesList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(widget.title,
                  style: widget.themeData.textTheme.headline5),
            ),
             Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                    ),
                    iconSize: 32,
                    color: Colors.white,
                    splashColor: Colors.black12,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MoviePage(
                                themeData: widget.themeData,
                              )));
                    },
                  ),),
            )
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: moviesList == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: moviesList!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MovieDetailPage(
                                        themeData: widget.themeData,
                                        heroId: moviesList![index].moviename,
                                        movieInfoLink:
                                            moviesList![index].movielink!,
                                      )));
                        },
                        child: Hero(
                          tag: '${moviesList![index].moviename}',
                          child: SizedBox(
                            width: 100,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: FadeInImage(
                                      image: NetworkImage(
                                          moviesList![index].moviethumbnail!),
                                      fit: BoxFit.cover,
                                      placeholder: const AssetImage(
                                          'images/muvi/images/na.jpg'),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    moviesList![index].moviename,
                                    style: widget.themeData.textTheme.bodyText1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
