import 'package:asianflix/constants/api_constants.dart';
import 'package:asianflix/models/episodetype.dart';
import 'package:asianflix/models/movie.dart';
import 'package:asianflix/models/movieparts.dart';
import 'package:asianflix/services/dataservice.dart';
import 'package:flutter/cupertino.dart';

class DataServiceViewModel extends ChangeNotifier {
  List<Movie> topTodayList = [];
  List<Movie> topMonthList = [];
  List<Movie> latestEpisodeList = [];
  List<Movie> latestRawEpisodeList = [];
  List<Movie> otherDramaSubbed = [];
  List<Movie> movies = [];
  List<Movie> searchMovies = [];

  Future<List<Movie>> getTopTodayList() async {
    if (topTodayList.isEmpty) {
      await getTopList(TOP_TODAY_LIST_URL).then((value) => {topTodayList = value});
    }
    return topTodayList;
  }

  Future<List<Movie>?> getScrollMovieList(episodeType episodetype) async {
    switch (episodetype) {
      case episodeType.rawepisode:
        {
           return await getRawEpisodeList();
        }
      case episodeType.latestepisode:
        {
          return await getLatestEpisodeList();
        }
      case episodeType.otherdramasubbed:
        {
          return await getOtherDramaSubbedList();
        }
      case episodeType.topmonth:
        {
          return await getTopMonthList();
        }
      case episodeType.movies:
        {
          return await getMovies();
        }
    }
  }

  Future<List<Movie>> getMovies() async {
    if(movies.isEmpty){
      await getMoviesByFilter().then((value) => {movies = value});
    }
    return movies;
  }

  Future<List<Movie>> getMoviesByPageCount({int pageCount = 1}) async {
      await getMoviesByFilter(pageCount: pageCount).then((value) => {movies.addAll(value)});
      return movies;
  }

  Future<List<MovieParts>> getMoviesPartsByPageCount(String _movieFieldName,{int pageCount = 1}) async {
    late List<MovieParts> movieParts;
    await getMovieParts(_movieFieldName,pageCount: pageCount).then((value) => {movieParts = value});
    return movieParts;
  }

  Future<List<Movie>> getMoviesByQuerySearch(String movieName) async {

    await getQuerySearch(movieName).then((value) => {searchMovies = value});
    return searchMovies;
  }

  Future<List<Movie>> getTopMonthList() async {
    if (topMonthList.isEmpty) {
      await getTopList(TOP_MONTH_LIST_URL).then((value) => {topMonthList = value});
    }
    return topMonthList;
  }

  Future<List<Movie>> getLatestEpisodeList() async {
    if (latestEpisodeList.isEmpty) {
      await getRecentEpisode().then((value) => {latestEpisodeList = value});
    }
    return latestEpisodeList;
  }

  Future<List<Movie>> getRawEpisodeList() async {
    if (latestRawEpisodeList.isEmpty) {
      await getRecentRawEpisode().then((value) => {latestRawEpisodeList = value});
    }
    return latestRawEpisodeList;
  }

  Future<List<Movie>> getOtherDramaSubbedList() async {
    if (otherDramaSubbed.isEmpty) {
      await getRecentOtherDramaSubEpisode().then((value) => {otherDramaSubbed = value});
    }
    return otherDramaSubbed;
  }

  Future<Movie> getMovieDetail(String _url) async {
    late Movie movie;
    await getDetailMovie(_url).then((value) => {movie = value});

    return movie;
  }

  Future<String> getMoviePlayUrl(String _url) async {
    return await getPlayUrl(_url);
  }
}
