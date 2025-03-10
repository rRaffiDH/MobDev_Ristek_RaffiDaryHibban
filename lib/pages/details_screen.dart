import 'package:flutter/material.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/models/movie.dart';

class DetailsScreen extends StatefulWidget {
  final Result movie;

  const DetailsScreen({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<Map<int, String>> _futureGenreMap;

  @override
  void initState() {
    super.initState();
    // Fetch the genre map once when the screen is initialized
    _futureGenreMap = Api().getGenreMap();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        '${Api.imagePath}${widget.movie.posterPath}';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<Map<int, String>>(
        future: _futureGenreMap,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data'));
          }

          final genreMap = snapshot.data!;

          final List<String> genreNames = widget.movie.genreIds
              .map((id) => genreMap[id] ?? 'Unknown')
              .toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
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

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 150,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black, 
                              Colors.black
                                  .withOpacity(0.0), // fade to transparent
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ============= MOVIE INFO SECTION =============
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        widget.movie.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ============= RATINGS ROW =============
                      Row(
                        children: [
                          // IMDB rating
                          _buildRatingChip(
                            label:
                                "IMDB ${widget.movie.voteAverage.toStringAsFixed(1)}",
                            color: Colors.yellow[700]!,
                            textColor: Colors.black,
                          ),
                          const SizedBox(width: 8),

                          // Another rating (★)
                          _buildRatingChip(
                            label:
                                "${widget.movie.voteAverage.toStringAsFixed(1)} ★",
                            color: Colors.grey[800]!,
                            textColor: Colors.white,
                          ),
                          const SizedBox(width: 8),

                          // Vote count
                          _buildRatingChip(
                            label: "${widget.movie.voteCount} votes",
                            color: Colors.grey[800]!,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ============= GENRE CHIPS (DYNAMIC) =============
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: genreNames
                            .map((genre) => _buildGenreChip(genre))
                            .toList(),
                      ),
                      const SizedBox(height: 16),

                      // ============= OVERVIEW =============
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

  // Helper to build rating chips
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

  // Helper to build genre chips
  Widget _buildGenreChip(String genre) {
    return Chip(
      label: Text(genre),
      backgroundColor: Colors.grey[900],
      labelStyle: const TextStyle(color: Colors.white),
    );
  }
}
