import 'package:asianflix/constants/api_constants.dart';
import 'package:asianflix/models/movie.dart';
import 'package:asianflix/models/movieparts.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

Future<Movie> getMovie(String _url) async {
  String url = '$API_BASE_URL$_url';
  Movie movie = Movie(moviename: '', movielink: url);
  movie.moviefieldname = _url.substring(_url.lastIndexOf('/') + 1, _url.length);

  http.Response response = await http.get(Uri.parse(url));
  dom.Document document = parser.parse(response.body);

  var movieElement = document.getElementsByClassName('movie').first;

  movie.moviethumbnail = movieElement
      .getElementsByClassName('left')
      .first
      .getElementsByTagName('img')
      .first
      .attributes['src']
      .toString();
  movie.moviename = movieElement
      .getElementsByTagName('a')
      .first
      .attributes['title']
      .toString();
  return movie;
}

Future<Movie> getDetailMovie(String _url) async {
  String url = _url;
  Movie movie = Movie(moviename: '', movielink: url);

  movie.moviefieldname = _url.substring(_url.lastIndexOf('/') +1, _url.length);

  List<Movie> movieList = [];
  http.Response response = await http.get(Uri.parse(url));
  dom.Document document = parser.parse(response.body);

  var movieElement = document.getElementsByClassName('movie').first;

  movie.plot = movieElement
      .getElementsByClassName('right')
      .first
      .getElementsByClassName('info')
      .first
      .text;
  String? playurl = movieElement
      .getElementsByClassName('h1-span')
      .first
      .getElementsByTagName('a')
      .first
      .attributes['href']
      .toString();

  movie.playurl = '$API_BASE_URL$playurl';

  movie.downloadurl = movieElement
      .getElementsByClassName('h1-span')
      .first
      .getElementsByTagName('a')
      .last
      .attributes['href']
      .toString();

  movieElement.getElementsByClassName('left').forEach((leftElement) {
    movie.moviethumbnail = leftElement
        .getElementsByTagName('img')
        .first
        .attributes['src']
        .toString();

    leftElement.getElementsByTagName('p').forEach((singleParagraphElement) {
      singleParagraphElement.getElementsByTagName('strong').forEach((element) {
        switch (element.text.trim().toLowerCase()) {
          case "name:":
            {
              movie.moviename = singleParagraphElement
                  .getElementsByTagName('span')
                  .first
                  .text;
            }
            break;
          case "original name:":
            {
              movie.originalname = singleParagraphElement
                  .getElementsByTagName('span')
                  .first
                  .text;
            }
            break;
          case "release year:":
            {
              movie.releaseyear = int.parse(singleParagraphElement
                  .getElementsByTagName('span')
                  .first
                  .text);
            }
            break;
          case "status:":
            {
              movie.moviestatus = singleParagraphElement
                  .getElementsByTagName('span')
                  .first
                  .text;
            }
            break;
          case "country:":
            break;
          case "genre:":
            {
              movie.genre = singleParagraphElement
                  .getElementsByTagName('span')
                  .first
                  .text;
            }
            break;
        }
      });
    });
  });

  movie.movieparts = await getMovieParts(movie.moviefieldname);

  return movie;
}

Future<List<MovieParts>> getMovieParts(String? _movieFieldName,{int pageCount = 1}) async {
  List<MovieParts> moviePartsList = [];

  http.Response response = await http.get(
      Uri.parse(
          'https://myasiantv.cc/ajax/episode-list/$_movieFieldName/$pageCount.html?page=$pageCount'),
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
      });
  dom.Document document = parser.parse(response.body);

  /*Don't Replace With ForEach*/
  for (var li in document.getElementsByTagName('li')) {
    MovieParts movieparts = MovieParts();

    movieparts.moviesubbedimageurl =
        '$API_BASE_URL${li.getElementsByTagName('img').first.attributes['src'].toString()}';

    movieparts.playurl =
        '$API_BASE_URL${li.getElementsByTagName('a').first.attributes['href'].toString()}';
    movieparts.moviepartname =
        li.getElementsByTagName('a').first.attributes['title'].toString();
    movieparts.movieuploadedtime =
        li.getElementsByTagName('span').first.text.toString();

    moviePartsList.add(movieparts);
  }

  return moviePartsList;
}

Future<List<Movie>> getMovies() async {
  List<Movie> movieList = [];

  http.Response response = await http.get(
      Uri.parse('https://myasiantv.cc/ajax/drama_by_status/1.html?page=1'),
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
      });
  dom.Document document = parser.parse(response.body);

  /*Don't Replace With ForEach*/
  for (var li in document
      .getElementsByClassName('items')[0]
      .getElementsByTagName('li')) {
    Movie movie = Movie(moviename: '');

    for (var content in li.getElementsByClassName('pic')) {
      movie.moviethumbnail = content
          .getElementsByTagName('img')
          .first
          .attributes['src']
          .toString();
    }

    for (var content in li.getElementsByTagName('h2')) {
      movie.movielink =
          '$API_BASE_URL${content.getElementsByTagName('a').first.attributes['href'].toString()}';

      movie.moviefieldname = movie.movielink!.substring(
          movie.movielink!.lastIndexOf('/') + 1, movie.movielink!.length);
      movie.moviename = content.getElementsByTagName('a').first.text.toString();
    }

    movieList.add(movie);
  }

  return movieList;
}

Future<List<Movie>> getMoviesByFilter({int pageCount = 1}) async {
  List<Movie> movieList = [];

  http.Response response = await http.get(
      Uri.parse('https://myasiantv.cc/movie?selOrder=4&selYear=2021&page=$pageCount'));
  dom.Document document = parser.parse(response.body);
  /*Don't Replace With ForEach*/
  for (var li in document.getElementsByClassName('items')[0].getElementsByTagName('li'))
    {
      Movie movie = Movie(moviename: '');
      movie.moviethumbnail = li.getElementsByClassName('pic').first.getElementsByTagName('img').first.attributes['src'].toString();
      movie.movielink = '$API_BASE_URL${li.getElementsByTagName('h2').first.getElementsByTagName('a').first.attributes['href'].toString()}';
      movie.moviefieldname = movie.movielink!.substring(movie.movielink!.lastIndexOf('/') + 1, movie.movielink!.length);
      movie.moviename = li.getElementsByTagName('h2').first.getElementsByTagName('a').first.text.toString();
      //movie.releaseyear = int.parse(li.getElementsByTagName('h2').first.text.toString());
      movieList.add(movie);
    }
  return movieList;
}

Future<List<Movie>> getQuerySearch(String movieName) async {
  List<Movie> movieList = [];

  http.Response response = await http.get(
      Uri.parse('https://myasiantv.cc/search.html?key=$movieName'));
  dom.Document document = parser.parse(response.body);
  /*Don't Replace With ForEach*/
  for (var li in document.getElementsByClassName('items')[0].getElementsByTagName('li'))
  {
    Movie movie = Movie(moviename: '');
    movie.moviethumbnail = li.getElementsByClassName('pic').first.getElementsByTagName('img').first.attributes['src'].toString();
    movie.movielink = '$API_BASE_URL${li.getElementsByTagName('h2').first.getElementsByTagName('a').first.attributes['href'].toString()}';
    movie.moviefieldname = movie.movielink!.substring(movie.movielink!.lastIndexOf('/') + 1, movie.movielink!.length);
    movie.moviename = li.getElementsByTagName('h2').first.getElementsByTagName('a').first.text.toString();
    //movie.releaseyear = int.parse(li.getElementsByTagName('h2').first.text.toString());
    movieList.add(movie);
  }
  return movieList;
}

Future<List<Movie>> getRecentEpisode() async {
  List<Movie> movieList = [];

  http.Response response = await http.get(Uri.parse(API_BASE_URL));
  dom.Document document = parser.parse(response.body);

  /*Don't Replace With ForEach*/
  for (var episode in document.getElementsByClassName('loadep intro1')) {
    for (var li in episode.getElementsByTagName('li')) {
      String movieDataUrl =
          li.getElementsByTagName('a').first.attributes['href'].toString();
      movieDataUrl = movieDataUrl.substring(0, movieDataUrl.lastIndexOf('/'));
      var movie = await getMovie(movieDataUrl);
      movieList.add(movie);
    }
  }
  return movieList;
}

Future<List<Movie>> getRecentRawEpisode() async {
  List<Movie> movieList = [];

  http.Response response = await http.get(Uri.parse(API_BASE_URL));
  dom.Document document = parser.parse(response.body);

  /*Don't Replace With ForEach*/
  for (var episode in document.getElementsByClassName('loadep intro2')) {
    for (var li in episode.getElementsByTagName('li')) {
      String movieDataUrl =
          li.getElementsByTagName('a').first.attributes['href'].toString();
      movieDataUrl = movieDataUrl.substring(0, movieDataUrl.lastIndexOf('/'));
      var movie = await getMovie(movieDataUrl);
      movieList.add(movie);
    }
  }
  return movieList;
}

Future<List<Movie>> getRecentOtherDramaSubEpisode() async {
  List<Movie> movieList = [];

  http.Response response = await http.get(Uri.parse(API_BASE_URL));
  dom.Document document = parser.parse(response.body);

  /*Don't Replace With ForEach*/
  for (var episode in document.getElementsByClassName('loadep intro3')) {
    for (var li in episode.getElementsByTagName('li')) {
      String movieDataUrl =
          li.getElementsByTagName('a').first.attributes['href'].toString();
      movieDataUrl = movieDataUrl.substring(0, movieDataUrl.lastIndexOf('/'));
      var movie = await getMovie(movieDataUrl);
      movieList.add(movie);
    }
  }
  return movieList;
}

Future<List<Movie>> getTopList(String topListUrl) async {
  List<Movie> movieList = [];

  http.Response response = await http.get(Uri.parse(topListUrl));
  dom.Document document = parser.parse(response.body);

  /*Don't Replace With ForEach*/
  for (var episode in document.getElementsByTagName('div')) {
    Movie movie = Movie(moviename: '');
    String movieDataUrl =
        episode.getElementsByTagName('a').first.attributes['href'].toString();
    movieDataUrl = '$API_BASE_URL$movieDataUrl';
    movie.movielink = movieDataUrl;
    movie.moviename =
        episode.getElementsByTagName('img').first.attributes['alt'].toString();
    movie.moviethumbnail =
        episode.getElementsByTagName('img').first.attributes['src'].toString();

    movieList.add(movie);
  }
  return movieList;
}

Future<String> getPlayUrl(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  dom.Document document = parser.parse(response.body);
  String videoplayUrl;

  videoplayUrl = document
      .getElementsByClassName('play-video')
      .first
      .getElementsByTagName('iframe')
      .first
      .attributes['src']
      .toString();
  videoplayUrl = 'https:$videoplayUrl';

  return videoplayUrl;
}
