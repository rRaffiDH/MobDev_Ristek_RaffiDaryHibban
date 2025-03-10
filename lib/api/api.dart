import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/movie_genre.dart';

class Api{
  final String _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  String get _nowPlayingUrl =>
      "https://api.themoviedb.org/3/movie/now_playing?api_key=$_apiKey";
  String get _upcomingUrl =>
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$_apiKey";
  String get _popularUrl =>
      "https://api.themoviedb.org/3/movie/popular?api_key=$_apiKey";
  String get _genreUrl =>
      "https://api.themoviedb.org/3/genre/movie/list?api_key=$_apiKey";
  static const imagePath = "https://image.tmdb.org/t/p/w500";
  

  Future<List<Result>> getNowPlayingMovies() async {
    final response = await http.get(Uri.parse(_nowPlayingUrl));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["results"];
      return list.map((movie) => Result.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }
  
  Future<List<Result>> getUpcomingUrl() async {
    final response = await http.get(Uri.parse(_upcomingUrl));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["results"];
      return list.map((movie) => Result.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }
  
  Future<List<Result>> getPopularMovies() async {
    final response = await http.get(Uri.parse(_popularUrl));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["results"];
      return list.map((movie) => Result.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }

  Future<List<Genre>> getMovieGenres() async {
    final response = await http.get(Uri.parse(_genreUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final movieGenre = MovieGenre.fromJson(data);
      return movieGenre.genres;
    } else {
      throw Exception("Failed to load genres");
    }
  }

  Future<Map<int, String>> getGenreMap() async {
    final genres = await getMovieGenres(); 
    final Map<int, String> genreMap = {};
    for (var g in genres) {
      genreMap[g.id] = g.name; 
    }
    return genreMap;
  }


}