import 'package:hive/hive.dart';
part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile {
  @HiveField(0)
  String fullName;
  
  @HiveField(1)
  String nickname;
  
  @HiveField(2)
  String hobbies;
  
  @HiveField(3)
  String social;
  
  @HiveField(4)
  String? imagePath;

  UserProfile({
    required this.fullName,
    required this.nickname,
    required this.hobbies,
    required this.social,
    this.imagePath,
  });
}
