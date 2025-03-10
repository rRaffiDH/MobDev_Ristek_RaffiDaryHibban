import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/widgets/hero_scroll.dart';
import 'package:movie_app/widgets/movie_scroll.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

late Future<List<Result>> nowPlayingMovies;
late Future<List<Result>> upComingMovies;
late Future<List<Result>> popularMovies;

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    nowPlayingMovies = Api().getNowPlayingMovies();
    upComingMovies = Api().getUpcomingUrl();
    popularMovies = Api().getPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Movie App",
          style:
              GoogleFonts.bebasNeue(textStyle: const TextStyle(fontSize: 30)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Now Playing",
                style: GoogleFonts.bebasNeue(
                    textStyle: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: FutureBuilder(
                  future: nowPlayingMovies,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return HeroScroll(
                          itemCount: snapshot.data!.length, snapshot: snapshot);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Upcoming Movies",
                style: GoogleFonts.bebasNeue(
                    textStyle: const TextStyle(fontSize: 20)),
              ),
              SizedBox(
                child: FutureBuilder(
                  future: upComingMovies,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return MovieScroll(
                          itemCount: snapshot.data!.length, snapshot: snapshot);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Popular Movies",
                style: GoogleFonts.bebasNeue(
                    textStyle: const TextStyle(fontSize: 20)),
              ),
              SizedBox(
                child: FutureBuilder(
                  future: popularMovies,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return MovieScroll(
                          itemCount: snapshot.data!.length, snapshot: snapshot);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
