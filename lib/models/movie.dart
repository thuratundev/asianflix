

import 'package:asianflix/models/movieparts.dart';

class Movie {
  late String moviename;
  String? moviefieldname;
  String? movielink;
  String? moviethumbnail;
  String? originalname;
  int? releaseyear;
  String? moviestatus;
  String? genre;
  String? plot;
  String? playurl;
  String? downloadurl;
  List<MovieParts>? movieparts;


  Movie({
    required this.moviename,
    this.moviefieldname,
    this.movielink,
    this.moviethumbnail,
    this.originalname,
    this.releaseyear,
    this.moviestatus,
    this.genre,
    this.plot,
    this.playurl,
    this.downloadurl,
    this.movieparts,
  });
}
