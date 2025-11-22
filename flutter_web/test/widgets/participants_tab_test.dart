import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// GANTI 'training_system' dengan nama package kamu
import 'package:flutter_web/services/api_services.dart';
import 'package:flutter_web/models/participant.dart';
import 'package:flutter_web/pages/participants/participants_pages.dart';

// Fake ApiService untuk ParticipantsTab
class FakeApiServiceParticipants extends ApiService {
  FakeApiServiceParticipants() : super();

  bool returnEmpty = false;

  @override
  Future<List<Participant>> getParticipants() async {
    if (returnEmpty) {
      return [];
    }
    return [
      Participant(
        id: 1,
        name: 'Edgar',
        email: 'edgar@example.com',
        phone: '081234567890',
      ),
      Participant(
        id: 2,
        name: 'Budi',
        email: null,
        phone: '0800000000',
      ),
    ];
  }

  @override
  Future<void> createParticipant(
      String name, String email, String phone) async {}

  @override
  Future<void> updateParticipant(
      int id, String name, String email, String phone) async {}

  @override
  Future<void> deleteParticipant(int id) async {}
}

void main() {
  group('ParticipantsTab widget test', () {
    testWidgets(
      'menampilkan loading, lalu list peserta dan FAB',
      (WidgetTester tester) async {
        final fakeApi = FakeApiServiceParticipants();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ParticipantsTab(api: fakeApi),
            ),
          ),
        );

        // awal: loading
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle();

        // loading hilang
        expect(find.byType(CircularProgressIndicator), findsNothing);

        // tidak ada teks kosong
        expect(find.text('Belum ada peserta.'), findsNothing);

        // ListTile untuk 2 peserta
        expect(find.byType(ListTile), findsNWidgets(2));

        // Nama peserta
        expect(find.text('Edgar'), findsOneWidget);
        expect(find.text('Budi'), findsOneWidget);

        // Subtitle: email & HP
        expect(find.text('Email: edgar@example.com'), findsOneWidget);
        expect(find.text('HP: 081234567890'), findsOneWidget);
        expect(find.text('HP: 0800000000'), findsOneWidget);

        // FAB Tambah Peserta
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.text('Tambah Peserta'), findsOneWidget);
      },
    );

    testWidgets(
      'menampilkan teks "Belum ada peserta." ketika list kosong',
      (WidgetTester tester) async {
        final fakeApi = FakeApiServiceParticipants()..returnEmpty = true;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ParticipantsTab(api: fakeApi),
            ),
          ),
        );

        // awal: loading
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle();

        // sekarang harus menampilkan pesan kosong
        expect(find.text('Belum ada peserta.'), findsOneWidget);
        expect(find.byType(ListTile), findsNothing);
      },
    );
  });
}