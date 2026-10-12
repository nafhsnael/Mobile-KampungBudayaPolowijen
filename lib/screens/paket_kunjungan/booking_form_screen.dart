import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/primary_button.dart';

class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _participantCountController = TextEditingController(text: '1');

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _participantCountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data pemesanan berhasil divalidasi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Pemesanan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Nama pemesan'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama pemesan wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Nomor WhatsApp'),
              validator: (value) {
                if (value == null || value.trim().length < 10) {
                  return 'Nomor WhatsApp minimal 10 digit';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _participantCountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Jumlah peserta'),
              validator: (value) {
                final count = int.tryParse(value ?? '');
                if (count == null || count < 1) {
                  return 'Jumlah peserta minimal 1 orang';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            PrimaryButton(label: 'Kirim Pemesanan', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
