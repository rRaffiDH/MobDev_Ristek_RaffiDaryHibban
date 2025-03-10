import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:movie_app/models/user_profile.dart';
import 'package:movie_app/models/favorite_movie.dart';
import 'package:movie_app/pages/profile_edit.dart';
import 'package:movie_app/widgets/movie_scroll.dart';

class AboutMePage extends StatefulWidget {
  const AboutMePage({super.key});

  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final profileBox = Hive.box<UserProfile>('profile');
    final profile = profileBox.get('user');
    setState(() {
      _userProfile = profile;
    });
  }

  Future<List<FavoriteMovie>> _getFavorites() async {
    final favoritesBox = Hive.box<FavoriteMovie>('favoriteMovies');
    return favoritesBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final fullName = _userProfile?.fullName ?? 'John Doe';
    final nickname = _userProfile?.nickname ?? 'Johnny';
    final hobbies = _userProfile?.hobbies ?? 'Photography, Traveling, Coding';
    final social = _userProfile?.social ?? '@yourSocial';
    final imagePath = _userProfile?.imagePath;

    return Scaffold(
      appBar: AppBar(
        title: Text('About Me', style: GoogleFonts.bebasNeue()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileEditPage()),
              );
              _loadProfile();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: (imagePath != null && imagePath.isNotEmpty)
                            ? FileImage(File(imagePath))
                            : const AssetImage('assets/default_profile.png') as ImageProvider,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        fullName,
                        style: GoogleFonts.bebasNeue(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        nickname,
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.favorite, color: Colors.pink),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              hobbies,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.link, color: Colors.blue),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              social,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My Favorites',
                  style: GoogleFonts.bebasNeue(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<FavoriteMovie>>(
              future: _getFavorites(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No favorites added', style: TextStyle(color: Colors.white)),
                  );
                }
                
                return MovieScroll(itemCount: snapshot.data!.length, snapshot: snapshot);
              },
            ),
          ],
        ),
      ),
    );
  }
}
