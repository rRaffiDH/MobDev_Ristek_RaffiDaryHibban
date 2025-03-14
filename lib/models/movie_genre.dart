// To parse this JSON data, do
//
//     final movieGenre = movieGenreFromJson(jsonString);

import 'dart:convert';

MovieGenre movieGenreFromJson(String str) => MovieGenre.fromJson(json.decode(str));

String movieGenreToJson(MovieGenre data) => json.encode(data.toJson());

class MovieGenre {
    List<Genre> genres;

    MovieGenre({
        required this.genres,
    });

    factory MovieGenre.fromJson(Map<String, dynamic> json) => MovieGenre(
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
    };
}

class Genre {
    int id;
    String name;

    Genre({
        required this.id,
        required this.name,
    });

    factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
