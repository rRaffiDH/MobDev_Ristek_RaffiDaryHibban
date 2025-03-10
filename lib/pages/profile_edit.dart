
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app/models/user_profile.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  
  
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _hobbiesController = TextEditingController();
  final TextEditingController _socialController = TextEditingController();

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  
  late Box<UserProfile> profileBox;

  @override
  void initState() {
    super.initState();
    profileBox = Hive.box<UserProfile>('profile');
    _loadProfile();
  }

  void _loadProfile() {
    
    final profile = profileBox.get('user');
    if (profile != null) {
      _fullNameController.text = profile.fullName;
      _nicknameController.text = profile.nickname;
      _hobbiesController.text = profile.hobbies;
      _socialController.text = profile.social;
      if (profile.imagePath != null) {
        _profileImage = File(profile.imagePath!);
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      final profile = UserProfile(
        fullName: _fullNameController.text,
        nickname: _nicknameController.text,
        hobbies: _hobbiesController.text,
        social: _socialController.text,
        imagePath: _profileImage?.path,
      );
      
      profileBox.put('user', profile);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _nicknameController.dispose();
    _hobbiesController.dispose();
    _socialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", style: GoogleFonts.bebasNeue(),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage('assets/default_profile.png')
                          as ImageProvider,
                  child: _profileImage == null
                      ? const Icon(Icons.add_a_photo,
                          size: 30, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your full name' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _hobbiesController,
                decoration: const InputDecoration(
                  labelText: 'Hobbies',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _socialController,
                decoration: const InputDecoration(
                  labelText: 'Social Media',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text("Save Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
