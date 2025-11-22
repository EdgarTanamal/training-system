import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/participant.dart';
import '../models/class_model.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  // -------- Peserta --------

  Future<List<Participant>> getParticipants() async {
    final res = await http.get(Uri.parse('$baseUrl/participants'));
    if (res.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(res.body);
      return jsonList.map((e) => Participant.fromJson(e)).toList();
    }
    throw Exception('Failed to load participants');
  }

  Future<void> createParticipant(String name, String email, String phone) async {
    final res = await http.post(
      Uri.parse('$baseUrl/participants'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
      }),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to create participant');
    }
  }

  Future<void> updateParticipant(
    int id,
    String name,
    String email,
    String phone,
  ) async {
    final res = await http.put(
      Uri.parse('$baseUrl/participants/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
      }),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to update participant');
    }
  }

  Future<void> deleteParticipant(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/participants/$id'));
    if (res.statusCode != 200) {
      throw Exception('Failed to delete participant');
    }
  }

  // -------- Kelas --------

  Future<List<TrainingClass>> getClasses() async {
    final res = await http.get(Uri.parse('$baseUrl/classes'));
    if (res.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(res.body);
      return jsonList.map((e) => TrainingClass.fromJson(e)).toList();
    }
    throw Exception('Failed to load classes');
  }

  Future<void> createClass(
    String code,
    String title,
    String description,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/classes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'code': code,
        'title': title,
        'description': description,
      }),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to create class');
    }
  }

  Future<void> updateClass(
    int id,
    String code,
    String title,
    String description,
  ) async {
    final res = await http.put(
      Uri.parse('$baseUrl/classes/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'code': code,
        'title': title,
        'description': description,
      }),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to update class');
    }
  }

  Future<void> deleteClass(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/classes/$id'));
    if (res.statusCode != 200) {
      throw Exception('Failed to delete class');
    }
  }

  // -------- Registrations (pendaftaran) --------

  Future<void> registerToClass(int participantId, int classId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/registrations'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'participant_id': participantId,
        'class_id': classId,
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to register to class: ${res.body}');
    }
  }

  Future<List<TrainingClass>> getClassesForParticipant(int participantId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/registrations/participant/$participantId/classes'),
    );
    if (res.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(res.body);
      return jsonList.map((e) => TrainingClass.fromJson(e)).toList();
    }
    throw Exception('Failed to load classes for participant');
  }

  Future<List<Map<String, dynamic>>> getParticipantsForClass(int classId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/registrations/class/$classId/participants'),
    );
    if (res.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(res.body);
      return jsonList.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to load participants for class');
  }

  Future<void> cancelRegistration(int registrationId) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/registrations/$registrationId'),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to cancel registration');
    }
  }
}
