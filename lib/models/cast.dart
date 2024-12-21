class Cast {
  final int id;
  final String name;
  final String profilePath;
  final String character;

  Cast({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.character,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'] ?? '',
      character: json['character'] ?? '',
    );
  }
}
