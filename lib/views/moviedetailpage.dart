import 'package:asianflix/constants/api_constants.dart';
import 'package:asianflix/models/movie.dart';
import 'package:asianflix/models/movieparts.dart';
import 'package:asianflix/utils/resources/flix_colors.dart';
import 'package:asianflix/viewmodels/dataserviceviewmodel.dart';
import 'package:asianflix/views/playscreen.dart';
import 'package:asianflix/views/playscreentwo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatefulWidget {
  final ThemeData themeData;
  final String heroId;
  final String movieInfoLink;



  MovieDetailPage(
      {required this.themeData,
      required this.heroId,
      required this.movieInfoLink,
      Key? key})
      : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  int _pageCount = 1;
  Movie? movie;
  UniqueKey redrawkey = UniqueKey();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);


   _scrollController.addListener(() {
     if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent)
     {
       _refreshdata();
     }
   });
    Provider.of<DataServiceViewModel>(context, listen: false)
        .getMovieDetail(widget.movieInfoLink)
        .then((value) {
      setState(() {
        movie = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: muvi_appBackground,
      body: movie == null
          ? const Center(child: CircularProgressIndicator())
          : MediaQuery.of(context).orientation == Orientation.landscape?
                const Center(child : CircularProgressIndicator()) :
                Column(
                key: ValueKey<UniqueKey>(redrawkey),
                children: <Widget>[
                  AppBar(
                    backgroundColor: muvi_appBackground,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Hero(
                          tag: widget.heroId,
                          child: SizedBox(
                            width: 150,
                            height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: movie!.moviethumbnail == null
                                  ? Image.asset(
                                      'assets/images/na.jpg',
                                      fit: BoxFit.cover,
                                    )
                                  : FadeInImage(
                                      image: NetworkImage(
                                          movie!.moviethumbnail!),
                                      fit: BoxFit.cover,
                                      placeholder: AssetImage(
                                          'assets/images/loading.gif'),
                                    ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  movie!.moviename,
                                  style: widget
                                      .themeData.textTheme.headline5,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                movie!.releaseyear == null
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4,
                                            top: 16,
                                            bottom: 4),
                                        child: Text(
                                          '${movie!.releaseyear ?? ''}',
                                          style: widget.themeData
                                              .textTheme.caption,
                                        ),
                                      ),
                                movie!.genre == null
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, top: 4, bottom: 4),
                                        child: Text(
                                          '${movie!.genre}',
                                          style: widget.themeData
                                              .textTheme.caption,
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                            icon: const Icon(Icons.cloud_download),
                            onPressed: () {},
                            label: const Text('Download'),
                            style: OutlinedButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.brown,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20.0)))),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: OutlinedButton.icon(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () async {
                                final value = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PlayScreen(
                                                initurl:
                                                    movie!.playurl ??
                                                        '')));

                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.portraitUp,
                                  DeviceOrientation.portraitDown,
                                ]);

                                setState(() {
                                  redrawkey = UniqueKey();
                                });
                              },
                              label: const Text('Play Now '),
                              style: OutlinedButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                              20.0)))),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 150),
                        child: SingleChildScrollView(
                          child:Text(
                            movie!.plot ?? DEFAULT_PLOT,
                            style: widget.themeData.textTheme.caption,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Episode List',
                              style: widget.themeData.textTheme.headline5),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: moviepartlist(movie!.movieparts),
                  ),
                ],
              ),

    );
  }

  Widget moviepartlist(List<MovieParts>? movieparts) {
    return ListView.separated(
      controller: _scrollController,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: movieparts!.length,
      separatorBuilder: (context,index){
        return const SizedBox(height: 16,child:
        Divider(thickness: 0.8,indent: 25,endIndent: 25, color: Colors.white54,),);
      },
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
          child: InkWell(
            onTap: () async{
              final value = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PlayScreen(
                              initurl:
                              movieparts[index].playurl ??
                                  '')));

              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);


              setState(() {
                redrawkey = UniqueKey();
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network(movieparts[index].moviesubbedimageurl!),
                const SizedBox(width: 16,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movieparts[index].moviepartname!,style: widget.themeData.textTheme.subtitle1),
                      Text(movieparts[index].movieuploadedtime!,style: widget.themeData.textTheme.caption,)
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _refreshdata() async{
    _pageCount ++;
    Provider.of<DataServiceViewModel>(context, listen: false)
        .getMoviesPartsByPageCount(movie!.moviefieldname!,pageCount: _pageCount)
        .then((value) {
      setState(() {
        movie!.movieparts!.addAll(value);
      });
    });
  }
}
