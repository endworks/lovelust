class IdName {
  final String id;
  final String? name;

  const IdName({
    required this.id,
    this.name,
  });

  factory IdName.fromJson(Map<String, dynamic> json) {
    return IdName(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}
