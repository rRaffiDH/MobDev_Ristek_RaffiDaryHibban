import 'package:flutter/material.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/pages/details_screen.dart';
import 'package:movie_app/models/favorite_movie.dart';

class MovieScroll extends StatelessWidget {
  final int itemCount;
  final AsyncSnapshot snapshot;

  const MovieScroll({super.key, required this.itemCount, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          
          final data = snapshot.data[index];
          if (data is FavoriteMovie) {
            final favMovie = data;
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        movie: Result(
                          adult: false, 
                          backdropPath: '',
                          genreIds: favMovie.genreIds,
                          id: favMovie.id,
                          originalLanguage: 'en',
                          originalTitle: favMovie.title,
                          overview: favMovie.overview,
                          popularity: favMovie.voteAverage,
                          posterPath: favMovie.posterPath,
                          releaseDate:
                              DateTime.now(), 
                          title: favMovie.title,
                          video: false,
                          voteAverage: favMovie.voteAverage,
                          voteCount: favMovie.voteCount,
                        ),
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 200,
                    width: 150,
                    child: Image.network(
                      "${Api.imagePath}${favMovie.posterPath}",
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          } else if (data is Result) {
            final resultMovie = data;
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        movie: resultMovie,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 200,
                    width: 150,
                    child: Image.network(
                      "${Api.imagePath}${resultMovie.posterPath}",
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink(); 
          }
        },
      ),
    );
  }
}
