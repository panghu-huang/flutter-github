enum UserType {
  User, Organization,
}

class User {

  String login;
  String name;
  String location;
  String url;
  UserType type;
  String reposUrl;
  String bio;
  String blog;
  String avatarUrl;
  int followers;
  int following;

  User({
    this.login,
    this.name,
    this.url,
    this.location,
    this.type,
    this.reposUrl,
    this.bio,
    this.blog,
    this.following,
    this.followers,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      login: json['login'],
      name: json['name'],
      location: json['location'],
      url: json['url'],
      type: json['type'] == 'Organization' ? UserType.Organization : UserType.User,
      reposUrl: json['repos_url'],
      bio: json['bio'],
      blog: json['blog'],
      avatarUrl: json['avatar_url'],
      followers: json['followers'],
      following: json['following'],
    );
  }

}