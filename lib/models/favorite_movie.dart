import 'package:hive/hive.dart';
import 'movie.dart'; // Mengimpor kelas Result

part 'favorite_movie.g.dart';

@HiveType(typeId: 2) // Pastikan typeId berbeda dengan Result
class FavoriteMovie {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String posterPath;

  @HiveField(3)
  double voteAverage;

  @HiveField(4)
  int voteCount;

  @HiveField(5)
  String overview;

  @HiveField(6)
  List<int> genreIds;

  FavoriteMovie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.overview,
    required this.genreIds,
  });

  // Konversi dari Result ke FavoriteMovie
  factory FavoriteMovie.fromResult(Result result) {
    return FavoriteMovie(
      id: result.id,
      title: result.title,
      posterPath: result.posterPath,
      voteAverage: result.voteAverage,
      voteCount: result.voteCount,
      overview: result.overview,
      genreIds: result.genreIds,
    );
  }
}
