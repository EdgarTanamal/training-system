import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// GANTI 'training_system' dengan nama package kamu
import 'package:flutter_web/services/api_services.dart';
import 'package:flutter_web/models/class_model.dart';
import 'package:flutter_web/pages/classes/classes_pages.dart';

// Fake ApiService untuk ClassesTab
class FakeApiServiceClasses extends ApiService {
  FakeApiServiceClasses() : super();

  bool returnEmpty = false;

  @override
  Future<List<TrainingClass>> getClasses() async {
    if (returnEmpty) {
      return [];
    }
    return [
      TrainingClass(
        id: 1,
        code: 'CLS-001',
        title: 'Flutter Dasar',
        description: 'Pengenalan Flutter',
      ),
      TrainingClass(
        id: 2,
        code: 'CLS-002',
        title: 'FastAPI Lanjutan',
        description: '',
      ),
    ];
  }

  @override
  Future<void> createClass(String code, String title, String description) async {}

  @override
  Future<void> updateClass(
      int id, String code, String title, String description) async {}

  @override
  Future<void> deleteClass(int id) async {}
}

void main() {
  group('ClassesTab widget test', () {
    testWidgets(
      'menampilkan loading, lalu list kelas dan FAB',
      (WidgetTester tester) async {
        final fakeApi = FakeApiServiceClasses();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ClassesTab(api: fakeApi),
            ),
          ),
        );

        // awal: loading
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // tunggu Future selesai
        await tester.pumpAndSettle();

        // Loading hilang
        expect(find.byType(CircularProgressIndicator), findsNothing);

        // Tidak ada teks kosong
        expect(find.text('Belum ada kelas.'), findsNothing);

        // ListTile untuk 2 kelas
        expect(find.byType(ListTile), findsNWidgets(2));

        // Judul + kode kelas
        expect(find.text('CLS-001 - Flutter Dasar'), findsOneWidget);
        expect(find.text('CLS-002 - FastAPI Lanjutan'), findsOneWidget);

        // Deskripsi & default 'Tidak ada deskripsi'
        expect(find.text('Pengenalan Flutter'), findsOneWidget);
        expect(find.text('Tidak ada deskripsi'), findsOneWidget);

        // FAB Tambah Kelas
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.text('Tambah Kelas'), findsOneWidget);
      },
    );

    testWidgets(
      'menampilkan teks "Belum ada kelas." ketika list kosong',
      (WidgetTester tester) async {
        final fakeApi = FakeApiServiceClasses()..returnEmpty = true;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ClassesTab(api: fakeApi),
            ),
          ),
        );

        // awal: loading
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle();

        // sekarang harus menampilkan pesan kosong
        expect(find.text('Belum ada kelas.'), findsOneWidget);
        expect(find.byType(ListTile), findsNothing);
      },
    );
  });
}
