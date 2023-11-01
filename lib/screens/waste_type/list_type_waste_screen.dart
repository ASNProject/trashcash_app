import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trashcash_app/core/repository/base_repository.dart';

class ListTypeWasteScreen extends StatefulWidget {
  const ListTypeWasteScreen({super.key});

  @override
  State<ListTypeWasteScreen> createState() => _ListTypeWasteScreenState();
}

class _ListTypeWasteScreenState extends State<ListTypeWasteScreen> {
  Map? dataFromApi;

  Future<void> fetchDataTypeWasteAll() async {
    final result = await BaseRepository.fetchDataTypeWasteAll();

    setState(() {
      dataFromApi = result;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('en_US', null);
    fetchDataTypeWasteAll();
  }

  @override
  Widget build(BuildContext context) {
    String jsonString = json.encode(dataFromApi);
    Map<String, dynamic>? jsonData;

    if (jsonString.isNotEmpty) {
      jsonData = json.decode(jsonString);
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Jenis Sampah',
              style: GoogleFonts.poppins(
                textStyle:
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      fetchDataTypeWasteAll();
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.refresh,
                          color: Color(0xFF25A981),
                          size: 14,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Perbarui',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF25A981),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (jsonData != null) {
                      String csv = jsonToCsv(jsonData['data'] ?? []);
                      await saveCsvToFile(csv);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'CSV berhasil di download. Silahkan buka Android/data/com.trashcash.trashcash_app/files'),
                      ));
                    }
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Unduh'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF25A981)),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('id')),
                        DataColumn(label: Text('Jenis')),
                        DataColumn(label: Text('Harga')),
                        DataColumn(label: Text('Aksi')),
                      ],
                      rows: jsonData != null
                          ? jsonData['data'].map<DataRow>((data) {
                        return DataRow(cells: [
                          DataCell(Text(data['id_type'] ?? '')),
                          DataCell(Text(data['type'] ?? '')),
                          DataCell(Text(data['price'] ?? '')),
                          DataCell(OutlinedButton.icon(
                            onPressed: () {
                              String idUserToDelete = data[
                              'id_type'];
                              showDeleteConfirmationDialog(
                                  idUserToDelete);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            label: const Text('Hapus'),
                          ))
                        ]);
                      }).toList()
                          : [],
                    ),
                  ),
                ),
              ),
            ),
            Text(
              '** Data jenis sampah untuk sementara tidak dapat diperbarui melalui aplikasi',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String jsonToCsv(List<dynamic>? jsonData) {
    if (jsonData == null || jsonData.isEmpty) {
      return '';
    }
    List<List<dynamic>> csvData = [];

    // Add CSV header (column names) based on your JSON data structure
    csvData.add([
      'id',
      'Jenis',
      'Harga',
    ]);

    // Add rows of data from JSON
    for (var data in jsonData) {
      csvData.add([
        data['id_type'] ?? '',
        data['type'] ?? '',
        data['price'] ?? '',
      ]);
    }

    // Convert to CSV format
    String csv = const ListToCsvConverter().convert(csvData);

    return csv;
  }

  Future<void> saveCsvToFile(String csv) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory?.path}/data_jenis_sampah.csv');
    await file.writeAsString(csv);
  }

  showDeleteConfirmationDialog(String idUserToDelete) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus Data'),
          content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                bool success =
                await BaseRepository.deleteTypeWaste(idUserToDelete);
                if (success) {
                  Navigator.of(context).pop();
                  fetchDataTypeWasteAll();
                } else {
                }
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
