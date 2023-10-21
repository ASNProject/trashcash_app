import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashcash_app/core/repository/base_repository.dart';

class WasteTypeScreen extends StatefulWidget {
  const WasteTypeScreen({super.key});

  @override
  State<WasteTypeScreen> createState() => _WasteTypeScreenState();
}

class _WasteTypeScreenState extends State<WasteTypeScreen> {
  TextEditingController idTypeController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  String idTypes = '';
  String types = '';
  String prices = '';

  Future<void> addWasteType(BuildContext context) async {
    final idType = idTypeController.text;
    final type = typeController.text;
    final price = priceController.text;

    final existingData = await BaseRepository.fetchDataTypeWasteId(idType);

    if (existingData != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Gagal'),
          content: const Text('ID Jenis Sampah sudah ada di database.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      final success = await BaseRepository.addWasteType(
        idType: idType,
        type: type,
        price: price,
      );

      if (success == false) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Data jenis sampah berhasil ditambahkan.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  idTypeController.clear();
                  typeController.clear();
                  priceController.clear();
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
              content: const Text(
                  'Terjadi kesalahan saat menambahkan data jenis sampah.'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tambah Jenis Sampah',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Masukkan data',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    _buildForm(),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Pastikan data yang ditambahkan sudah benar.',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25A981),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: idTypes.isNotEmpty &&
                                types.isNotEmpty &&
                                prices.isNotEmpty
                            ? () => addWasteType(context)
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ID Jenis Sampah',
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
          controller: idTypeController,
          decoration: InputDecoration(
              hintText: 'Masukkan ID Sampah',
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
              idTypes = value;
            });
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Jenis Sampah',
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
          controller: typeController,
          decoration: InputDecoration(
              hintText: 'Masukkan Jenis Sampah',
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
              types = value;
            });
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Harga',
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
          controller: priceController,
          decoration: InputDecoration(
              hintText: 'Masukkan harga',
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
              prices = value;
            });
          },
        ),
        Text(
          '** Harga dibulatkan dalam satuan Kilogram (Kg)',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              fontStyle: FontStyle.italic,
            ),
          ),
        )
      ],
    );
  }
}
