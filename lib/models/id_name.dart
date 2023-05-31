class IdName {
  final String id;
  final String name;

  const IdName({
    required this.id,
    required this.name,
  });

  factory IdName.fromJson(Map<String, dynamic> json) {
    return IdName(
      id: json['id'],
      name: json['name'],
    );
  }
}
