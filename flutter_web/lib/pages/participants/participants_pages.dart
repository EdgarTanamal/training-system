import 'package:flutter/material.dart';

import '../../services/api_services.dart';
import '../../models/participant.dart';

class ParticipantsTab extends StatefulWidget {
  final ApiService api;

  const ParticipantsTab({
    super.key,
    required this.api,
  });

  @override
  State<ParticipantsTab> createState() => _ParticipantsTabState();
}

class _ParticipantsTabState extends State<ParticipantsTab> {
  List<Participant> _participants = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadParticipants();
  }

  Future<void> _loadParticipants() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await widget.api.getParticipants();
      setState(() {
        _participants = data;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat peserta: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showAddParticipantDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Tambah Peserta'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // NAMA (WAJIB)
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      hintText: 'Masukkan nama peserta',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama wajib diisi';
                      }
                      if (value.trim().length < 3) {
                        return 'Nama minimal 3 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // EMAIL (OPSIONAL)
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email (opsional)',
                      hintText: 'contoh@mail.com',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null; // boleh kosong
                      }
                      final emailRegex =
                          RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // PHONE (OPSIONAL, HANYA ANGKA / +)
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'No HP (opsional)',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      }
                      final onlyDigits = RegExp(r'^[0-9+]+$');
                      if (!onlyDigits.hasMatch(value.trim())) {
                        return 'No HP hanya boleh angka atau +';
                      }
                      return null;
                    },
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
                  await widget.api.createParticipant(
                    nameController.text.trim(),
                    emailController.text.trim(),
                    phoneController.text.trim(),
                  );
                  if (!mounted) return;
                  Navigator.of(ctx).pop();
                  await _loadParticipants();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Peserta berhasil ditambahkan'),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menambah peserta: $e'),
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

  void _showEditParticipantDialog(Participant p) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: p.name);
    final emailController =
        TextEditingController(text: p.email ?? '');
    final phoneController =
        TextEditingController(text: p.phone ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Peserta'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // NAMA
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama wajib diisi';
                      }
                      if (value.trim().length < 3) {
                        return 'Nama minimal 3 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // EMAIL
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email (opsional)',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      }
                      final emailRegex =
                          RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // PHONE
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'No HP (opsional)',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      }
                      final onlyDigits = RegExp(r'^[0-9+]+$');
                      if (!onlyDigits.hasMatch(value.trim())) {
                        return 'No HP hanya boleh angka atau +';
                      }
                      return null;
                    },
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
                  await widget.api.updateParticipant(
                    p.id,
                    nameController.text.trim(),
                    emailController.text.trim(),
                    phoneController.text.trim(),
                  );
                  if (!mounted) return;
                  Navigator.of(ctx).pop();
                  await _loadParticipants();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Peserta berhasil diupdate'),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal update peserta: $e'),
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

  void _confirmDeleteParticipant(Participant p) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Hapus Peserta'),
          content: Text(
            'Yakin ingin menghapus peserta "${p.name}"?',
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
                  await widget.api.deleteParticipant(p.id);
                  if (!mounted) return;
                  Navigator.of(ctx).pop();
                  await _loadParticipants();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Peserta berhasil dihapus'),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus peserta: $e'),
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
        _participants.isEmpty
            ? const Center(
                child: Text('Belum ada peserta.'),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _participants.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (ctx, index) {
                  final p = _participants[index];
                  return ListTile(
                    title: Text(p.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (p.email != null && p.email!.isNotEmpty)
                          Text('Email: ${p.email}'),
                        if (p.phone != null && p.phone!.isNotEmpty)
                          Text('HP: ${p.phone}'),
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit',
                          onPressed: () => _showEditParticipantDialog(p),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'Hapus',
                          onPressed: () => _confirmDeleteParticipant(p),
                        ),
                      ],
                    ),
                  );
                },
              ),

        // FAB Tambah Peserta
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: _showAddParticipantDialog,
            icon: const Icon(Icons.add),
            label: const Text('Tambah Peserta'),
          ),
        ),
      ],
    );
  }
}
