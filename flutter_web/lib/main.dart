import 'package:flutter/material.dart';
import './services/api_services.dart';
import './pages/participants/participants_pages.dart';
import './pages/classes/classes_pages.dart';

void main() {
  runApp(const TrainingApp());
}

class TrainingApp extends StatelessWidget {
  const TrainingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Training Management',
      debugShowCheckedModeBanner: false,  // 👈 Tambahkan ini
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final api = ApiService();

  @override
  Widget build(BuildContext context) {
    final pages = [
      ParticipantsTab(api: api),
      ClassesTab(api: api),
    ];

    final titles = [
      'Daftar Peserta',
      'Daftar Kelas',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Peserta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Kelas',
          ),
        ],
      ),
    );
  }
}
