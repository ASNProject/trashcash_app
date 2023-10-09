import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashcash_app/core/repository/base_repository.dart';
import 'package:trashcash_app/core/router/app_route_constans.dart';

class DebitScreen extends StatefulWidget {
  const DebitScreen({super.key});

  @override
  State<DebitScreen> createState() => _DebitScreenState();
}

class _DebitScreenState extends State<DebitScreen> {
  TextEditingController idUserController = TextEditingController();
  TextEditingController nominalController = TextEditingController();
  TextEditingController statusDebitController = TextEditingController();

  String ids = '';
  String nominals = '';
  String statuss = '';

  Future<void> addDebit(BuildContext context) async {
    final idUser = idUserController.text;
    final nominal = nominalController.text;
    final status = statusDebitController.text;

    final success = await BaseRepository.addDebit(
      userId: idUser,
      debit: nominal,
      status: status,
    );

    if (success == false) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Data debit berhasil disimpan'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                idUserController.clear();
                nominalController.clear();
                statusDebitController.clear();
                ids = '';
                nominals = '';
                statuss = '';
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Gagal'),
            content:
                const Text('Terjadi kesalahan saat menambahkan data debit.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 32.0,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Debit',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Masukkan Debit Baru',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        GoRouter.of(context).pushNamed(AppRouteConstants.listDebitRouteName);
                      },
                      icon: const Icon(Icons.list),
                      label: const Text('Lihat Data'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF25A981)),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                _buildFormDebit()
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25A981),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: ids.isNotEmpty &&
                          nominals.isNotEmpty &&
                          statuss.isNotEmpty
                      ? () => addDebit(context)
                      : null,
                  child: Text(
                    'Simpan',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildFormDebit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ID Nasabah',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        TextFormField(
          controller: idUserController,
          decoration: InputDecoration(
              hintText: 'Masukkan ID Nasabah',
              labelStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
          onChanged: (value) {
            setState(() {
              ids = value;
            });
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Nominal (Rp)',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        TextFormField(
          controller: nominalController,
          decoration: InputDecoration(
              hintText: 'Masukkan Jumlah Nominal',
              labelStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
          onChanged: (value) {
            setState(() {
              nominals = value;
            });
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Status Penarikan',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        TextFormField(
          controller: statusDebitController,
          decoration: InputDecoration(
              hintText: 'Masukkan Status Penarikan',
              labelStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
          onChanged: (value) {
            setState(() {
              statuss = value;
            });
          },
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          '** Contoh status penarikan: Diambil',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
