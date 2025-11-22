import 'package:flutter/material.dart';

import '../../services/api_services.dart';
import '../../models/class_model.dart';

class ClassesTab extends StatefulWidget {
  final ApiService api;

  const ClassesTab({
    super.key,
    required this.api,
  });

  @override
  State<ClassesTab> createState() => _ClassesTabState();
}

class _ClassesTabState extends State<ClassesTab> {
  List<TrainingClass> _classes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await widget.api.getClasses();
      setState(() {
        _classes = data;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat kelas: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ---------- Dialog Tambah Kelas (dengan validasi) ----------

  void _showAddClassDialog() {
    final formKey = GlobalKey<FormState>();
    final codeController = TextEditingController();
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Tambah Kelas'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // CODE (WAJIB)
                  TextFormField(
                    controller: codeController,
                    decoration: const InputDecoration(
                      labelText: 'Kode Kelas',
                      hintText: 'Misal: CLS-001',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Kode kelas wajib diisi';
                      }
                      if (value.trim().length < 2) {
                        return 'Kode minimal 2 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // TITLE (WAJIB)
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Judul Kelas',
                      hintText: 'Misal: Dasar Pemrograman',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Judul kelas wajib diisi';
                      }
                      if (value.trim().length < 3) {
                        return 'Judul minimal 3 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // DESCRIPTION (OPSIONAL)
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi (opsional)',
                    ),
                    minLines: 2,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                try {
                  await widget.api.createClass(
                    codeController.text.trim(),
                    titleController.text.trim(),
                    descController.text.trim(),
                  );
                  if (!mounted) return;
                  Navigator.of(ctx).pop();
                  await _loadClasses();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kelas berhasil ditambahkan'),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menambah kelas: $e'),
                    ),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // ---------- Dialog Edit Kelas (dengan validasi) ----------

  void _showEditClassDialog(TrainingClass c) {
    final formKey = GlobalKey<FormState>();
    final codeController = TextEditingController(text: c.code);
    final titleController = TextEditingController(text: c.title);
    final descController = TextEditingController(text: c.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Kelas'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // CODE
                  TextFormField(
                    controller: codeController,
                    decoration: const InputDecoration(
                      labelText: 'Kode Kelas',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Kode kelas wajib diisi';
                      }
                      if (value.trim().length < 2) {
                        return 'Kode minimal 2 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // TITLE
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Judul Kelas',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Judul kelas wajib diisi';
                      }
                      if (value.trim().length < 3) {
                        return 'Judul minimal 3 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // DESCRIPTION
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi (opsional)',
                    ),
                    minLines: 2,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                try {
                  await widget.api.updateClass(
                    c.id,
                    codeController.text.trim(),
                    titleController.text.trim(),
                    descController.text.trim(),
                  );
                  if (!mounted) return;
                  Navigator.of(ctx).pop();
                  await _loadClasses();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kelas berhasil diupdate'),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal update kelas: $e'),
                    ),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // ---------- Konfirmasi Hapus Kelas ----------

  void _confirmDeleteClass(TrainingClass c) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Hapus Kelas'),
          content: Text(
            'Yakin ingin menghapus kelas "${c.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                try {
                  await widget.api.deleteClass(c.id);
                  if (!mounted) return;
                  Navigator.of(ctx).pop();
                  await _loadClasses();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kelas berhasil dihapus'),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus kelas: $e'),
                    ),
                  );
                }
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        _classes.isEmpty
            ? const Center(
                child: Text('Belum ada kelas.'),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _classes.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (ctx, index) {
                  final c = _classes[index];
                  return ListTile(
                    title: Text('${c.code} - ${c.title}'),
                    subtitle: c.description != null &&
                            c.description!.isNotEmpty
                        ? Text(c.description!)
                        : const Text('Tidak ada deskripsi'),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit',
                          onPressed: () => _showEditClassDialog(c),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'Hapus',
                          onPressed: () => _confirmDeleteClass(c),
                        ),
                      ],
                    ),
                  );
                },
              ),

        // FAB Tambah Kelas
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: _showAddClassDialog,
            icon: const Icon(Icons.add),
            label: const Text('Tambah Kelas'),
          ),
        ),
      ],
    );
  }
}
