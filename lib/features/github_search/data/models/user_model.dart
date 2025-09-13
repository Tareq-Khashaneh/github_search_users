import 'package:hive/hive.dart';
import '../../domain/entites/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends User {
  @HiveField(0)
  final String login;

  @HiveField(1)
  final String avatarUrl;

  @HiveField(2)
  final String htmlUrl;

  @HiveField(3)
  final int publicRepos;

  @HiveField(4)
  final DateTime updatedAt;

  @HiveField(5)
  final String? name;

  @HiveField(6)
  final String? bio;

  @HiveField(7)
  final String? company;

  @HiveField(8)
  final String? location;

  @HiveField(9)
  final int? followers;

  @HiveField(10)
  final int? following;

  UserModel({
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
    required this.publicRepos,
    required this.updatedAt,
    this.name,
    this.bio,
    this.company,
    this.location,
    this.followers,
    this.following,
  }) : super(
    login: login,
    avatarUrl: avatarUrl,
    htmlUrl: htmlUrl,
    publicRepos: publicRepos,
    updatedAt: updatedAt,
    name: name,
    bio: bio,
    company: company,
    location: location,
    followers: followers,
    following: following,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      login: json['login'],
      avatarUrl: json['avatar_url'],
      htmlUrl: json['html_url'],
      publicRepos: json['public_repos'] ?? 0,
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      name: json['name'],
      bio: json['bio'],
      company: json['company'],
      location: json['location'],
      followers: json['followers'],
      following: json['following'],
    );
  }
}
