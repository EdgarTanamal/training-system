import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_web/models/class_model.dart';

void main() {
  group('TrainingClass Model', () {
    test('fromJson with "id"', () {
      final json = {
        "id": 10,
        "code": "CLS01",
        "title": "Flutter Training",
        "description": "Basic Introduction",
      };

      final result = TrainingClass.fromJson(json);

      expect(result.id, 10);
      expect(result.code, "CLS01");
      expect(result.title, "Flutter Training");
      expect(result.description, "Basic Introduction");
    });

    test('fromJson with "class_id" (string) + class_code/class_title', () {
      final json = {
        "class_id": "20",
        "class_code": "CLS02",
        "class_title": "FastAPI Training",
      };

      final result = TrainingClass.fromJson(json);

      expect(result.id, 20);
      expect(result.code, "CLS02");
      expect(result.title, "FastAPI Training");
      expect(result.description, isNull);
    });

    test('fromJson throws when id/class_id missing', () {
      final json = {
        "code": "CLS03",
        "title": "Tanpa ID",
      };

      expect(
        () => TrainingClass.fromJson(json),
        throwsA(isA<Exception>()),
      );
    });

    test('toJson returns correct map', () {
      final c = TrainingClass(
        id: 1,
        code: "CLS01",
        title: "Flutter",
        description: "Intro",
      );

      final json = c.toJson();

      expect(json['id'], 1);
      expect(json['code'], "CLS01");
      expect(json['title'], "Flutter");
      expect(json['description'], "Intro");
    });
  });
}
