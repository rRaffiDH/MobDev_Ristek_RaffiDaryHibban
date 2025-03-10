import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/models/movie.dart'; 
import 'package:movie_app/models/favorite_movie.dart';

class DetailsScreen extends StatefulWidget {
  final Result movie;

  const DetailsScreen({super.key, required this.movie});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<Map<int, String>> _futureGenreMap;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _futureGenreMap = Api().getGenreMap();
    _checkIfFavorite();
  }

  void _checkIfFavorite() {
    final favoritesBox = Hive.box<FavoriteMovie>('favoriteMovies');
    final List<FavoriteMovie> favorites = favoritesBox.values.toList();
    setState(() {
      _isFavorite = favorites.any((fav) => fav.id == widget.movie.id);
    });
  }

  void _addToFavorites() {
    final favoritesBox = Hive.box<FavoriteMovie>('favoriteMovies');
    
    if (!_isFavorite) {
      final fav = FavoriteMovie.fromResult(widget.movie);
      favoritesBox.add(fav);
      setState(() {
        _isFavorite = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.movie.title} added to favorites")),
      );
    } else {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("${widget.movie.title} is already in favorites")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = '${Api.imagePath}${widget.movie.posterPath}';
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          
          IconButton(
            onPressed: _addToFavorites,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: _isFavorite
                  ? Icon(
                      Icons.favorite,
                      key: const ValueKey('filled'),
                      color: Colors.yellow[700],
                    )
                  : const Icon(
                      Icons.favorite_border,
                      key: ValueKey('outlined'),
                      color: Colors.white,
                    ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<int, String>>(
        future: _futureGenreMap,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No data"));
          }
          final genreMap = snapshot.data!;
          final List<String> genreNames = widget.movie.genreIds
              .map((id) => genreMap[id] ?? 'Unknown')
              .toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 400,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey,
                              child: const Center(child: Icon(Icons.error)),
                            );
                          },
                        ),
                      ),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 400,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 120,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black,
                                Colors.black.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.movie.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildRatingChip(
                            label:
                                "IMDB ${widget.movie.voteAverage.toStringAsFixed(1)}",
                            color: Colors.yellow[700]!,
                            textColor: Colors.black,
                          ),
                          const SizedBox(width: 8),
                          _buildRatingChip(
                            label:
                                "${widget.movie.voteAverage.toStringAsFixed(1)} ★",
                            color: Colors.grey[800]!,
                            textColor: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          _buildRatingChip(
                            label: "${widget.movie.voteCount} votes",
                            color: Colors.grey[800]!,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: genreNames
                            .map((genre) => _buildGenreChip(genre))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.movie.overview,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.4,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRatingChip({
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Chip(
      label: Text(label),
      backgroundColor: color,
      labelStyle: TextStyle(color: textColor),
    );
  }

  Widget _buildGenreChip(String genre) {
    return Chip(
      label: Text(genre),
      backgroundColor: Colors.grey[900],
      labelStyle: const TextStyle(color: Colors.white),
    );
  }
}
