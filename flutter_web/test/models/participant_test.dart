import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_web/models/participant.dart';

void main() {
  group('Participant Model', () {
    test('fromJson normal', () {
      final json = {
        "id": 5,
        "name": "Edgar",
        "email": "edgar@example.com",
        "phone": "081234567890",
      };

      final p = Participant.fromJson(json);

      expect(p.id, 5);
      expect(p.name, "Edgar");
      expect(p.email, "edgar@example.com");
      expect(p.phone, "081234567890");
    });

    test('fromJson with nullable email/phone', () {
      final json = {
        "id": 6,
        "name": "Budi",
        "email": null,
        "phone": null,
      };

      final p = Participant.fromJson(json);

      expect(p.id, 6);
      expect(p.name, "Budi");
      expect(p.email, isNull);
      expect(p.phone, isNull);
    });

    test('toJson returns correct map', () {
      final p = Participant(
        id: 7,
        name: "Charlie",
        email: "charlie@example.com",
        phone: null,
      );

      final json = p.toJson();

      expect(json['id'], 7);
      expect(json['name'], "Charlie");
      expect(json['email'], "charlie@example.com");
      expect(json['phone'], isNull);
    });
  });
}
