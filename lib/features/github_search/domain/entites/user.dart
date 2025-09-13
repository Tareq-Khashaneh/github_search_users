class User {
  final String login;
  final String avatarUrl;
  final String htmlUrl;
  final int publicRepos;
  final DateTime updatedAt;

  final String? name;
  final String? bio;
  final String? company;
  final String? location;
  final int? followers;
  final int? following;

  User({
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
  });
}
