import 'package:asianflix/models/episodetype.dart';
import 'package:asianflix/models/movie.dart';
import 'package:asianflix/utils/resources/flix_colors.dart';
import 'package:asianflix/viewmodels/dataserviceviewmodel.dart';
import 'package:asianflix/views/moviedetailpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoviePage extends StatefulWidget {
  final ThemeData themeData;
  MoviePage({required this.themeData,Key? key}) : super(key: key);



  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {

  int _pageCount = 1;
  ScrollController _scrollController = ScrollController();
  List<Movie>? moviesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent)
          {
            _refreshdata();
          }
    });

    Provider.of<DataServiceViewModel>(context, listen: false)
        .getMovies()
        .then((value) {
      setState(() {
        moviesList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:   AppBar(
        backgroundColor: muvi_appBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: muvi_appBackground,
      body: GridView.builder(
        controller: _scrollController,
        itemCount:moviesList!.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).orientation ==
              Orientation.landscape ? 4: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: (9/16),
        ),
        itemBuilder: (context,index,) {
          return GestureDetector(
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
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 160,
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
                      maxLines: 2,
                      style: widget.themeData.textTheme.bodyText1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _refreshdata() async{
    _pageCount ++;

    Provider.of<DataServiceViewModel>(context, listen: false)
        .getMoviesByPageCount(pageCount: _pageCount)
        .then((value) {
      setState(() {
        moviesList = value;
      });
    });
  }
}
