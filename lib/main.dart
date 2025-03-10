import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:movie_app/models/favorite_movie.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/user_profile.dart';
import 'package:movie_app/pages/main_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ResultAdapter());
  Hive.registerAdapter(FavoriteMovieAdapter());
  Hive.registerAdapter(UserProfileAdapter());

  await Hive.openBox<FavoriteMovie>('favoriteMovies');
  await Hive.openBox<UserProfile>('profile');
  
  await dotenv.load(fileName: 'assets/.env');
  
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',  
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF131010),
      ),
      home: const MainScreen(),
    );
  }
}
