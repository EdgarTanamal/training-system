class TrainingClass {
  final int id;
  final String code;
  final String title;
  final String? description;

  TrainingClass({
    required this.id,
    required this.code,
    required this.title,
    this.description,
  });

  factory TrainingClass.fromJson(Map<String, dynamic> json) {
    // Ambil id dari 'id' atau 'class_id'
    final dynamic rawId = json['id'] ?? json['class_id'];
    if (rawId == null) {
      throw Exception('TrainingClass.fromJson: id is null. JSON: $json');
    }

    final intId = rawId is int ? rawId : int.parse(rawId.toString());

    // Kadang-kadang backend bisa pakai nama berbeda juga
    final rawCode = json['code'] ?? json['class_code'] ?? '';
    final rawTitle = json['title'] ?? json['class_title'] ?? '';

    return TrainingClass(
      id: intId,
      code: rawCode as String,
      title: rawTitle as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'description': description,
    };
  }
}
