import 'dart:convert';
import 'package:hive/hive.dart';

part 'movie.g.dart'; 

// Kelas Movie hanya digunakan untuk parsing data API (tidak disimpan di Hive)
class Movie {
  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  Movie({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        page: json["page"],
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}

/// Kelas Result digunakan untuk data film dari API dan disimpan di Hive
@HiveType(typeId: 34) 
class Result {
  @HiveField(0)
  bool adult;

  @HiveField(1)
  String backdropPath;

  @HiveField(2)
  List<int> genreIds;

  @HiveField(3)
  int id;

  @HiveField(4)
  String originalLanguage;

  @HiveField(5)
  String originalTitle;

  @HiveField(6)
  String overview;

  @HiveField(7)
  double popularity;

  @HiveField(8)
  String posterPath;

  @HiveField(9)
  DateTime releaseDate;

  @HiveField(10)
  String title;

  @HiveField(11)
  bool video;

  @HiveField(12)
  double voteAverage;

  @HiveField(13)
  int voteCount;

  Result({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        releaseDate: DateTime.parse(json["release_date"]),
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}

Movie movieFromJson(String str) => Movie.fromJson(json.decode(str));
String movieToJson(Movie data) => json.encode(data.toJson());
