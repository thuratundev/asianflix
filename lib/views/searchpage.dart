
import 'package:asianflix/models/movie.dart';
import 'package:asianflix/theme/theme_state.dart';
import 'package:asianflix/utils/resources/flix_colors.dart';
import 'package:asianflix/viewmodels/dataserviceviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'moviedetailpage.dart';

class SearchPage extends SearchDelegate {



  List<Movie> searchMovie = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [IconButton(icon: const Icon(Icons.clear), onPressed: (){
      query = "";
      searchMovie.clear();
    })];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: (){
      close(context, null);
    });
  }

  @override
  void showResults(BuildContext context) async {
    // TODO: implement showResults
    super.showResults(context);

    await Provider.of<DataServiceViewModel>(context, listen: false).
                        getMoviesByQuerySearch(query).then((value) =>
    {
             searchMovie = value,
             query = query
    });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults

    if(query.isEmpty)
    {
      return const Center(child: Icon(Icons.image_search,size: 100.0,color: Colors.grey,),);
    }
    else if(searchMovie.isEmpty)
      {
        return const Center(child: Icon(Icons.image_search,size: 100.0,color: Colors.grey,),);
      }
    else
    {
      return _buildListView(searchMovie,context);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(child: Icon(Icons.image_search,size: 100.0,color: Colors.grey,),);
  }

  Widget _buildListView(List<Movie> moviesList,BuildContext context) {
    final state = Provider.of<ThemeState>(context);
    return Scaffold(
      backgroundColor: muvi_appBackground,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount:moviesList.length,
          gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
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
                          themeData: state.themeData,
                          heroId: moviesList[index].moviename,
                          movieInfoLink:
                          moviesList[index].movielink!,
                        )));
              },
              child: Hero(
                tag: moviesList[index].moviename,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 160,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: FadeInImage(
                              image: NetworkImage(
                                  moviesList[index].moviethumbnail!),
                              fit: BoxFit.cover,
                              placeholder: const AssetImage(
                                  'images/muvi/images/na.jpg'),
                            ),
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          moviesList[index].moviename,
                          maxLines: 2,
                          style: const TextStyle(color: Colors.white),
                          //style: widget.themeData.textTheme.bodyText1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}