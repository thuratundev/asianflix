

import 'package:asianflix/models/episodetype.dart';
import 'package:asianflix/theme/theme_state.dart';
import 'package:asianflix/utils/resources/flix_colors.dart';
import 'package:asianflix/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ThemeState>(context);
    return Scaffold(
      backgroundColor: muvi_appBackground,
      body: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
      children: <Widget>[
        DiscoverMovies(
          themeData: state.themeData,
        ),
        ScrollingMovies(
          themeData: state.themeData,
          title: 'Top Month',
          getepisodetype: episodeType.topmonth,
        ),
        ScrollingMovies(
          themeData: state.themeData,
          title: 'Movies',
          getepisodetype: episodeType.movies,
        ),
        ScrollingMovies(
          themeData: state.themeData,
          title: 'Latest Episode',
          getepisodetype: episodeType.latestepisode,
        ),
        ScrollingMovies(
          themeData: state.themeData,
          title: 'Raw Episode',
          getepisodetype: episodeType.rawepisode,
        ),
        ScrollingMovies(
          themeData: state.themeData,
          title: 'Other Drama Subbed',
          getepisodetype: episodeType.otherdramasubbed,
        )
      ],
    ),
      ),
      );
  }
}
