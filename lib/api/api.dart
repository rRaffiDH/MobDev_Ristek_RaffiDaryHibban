import 'dart:convert';
import 'package:movie_app/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/movie_genre.dart';

class Api{
  static const _apiKey = "7e8344189361242fc3968d4da409b610";
  static const _nowPlayingUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=$_apiKey";
  static const _upcomingUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=$_apiKey";
  static const _popularUrl = "https://api.themoviedb.org/3/movie/popular?api_key=$_apiKey";
  static const _genreUrl = "https://api.themoviedb.org/3/genre/movie/list?api_key=$_apiKey";
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

  // 2) Convert that list into a map of id -> name
  Future<Map<int, String>> getGenreMap() async {
    final genres = await getMovieGenres(); // fetch all genres
    final Map<int, String> genreMap = {};
    for (var g in genres) {
      genreMap[g.id] = g.name; // build the map
    }
    return genreMap;
  }


}