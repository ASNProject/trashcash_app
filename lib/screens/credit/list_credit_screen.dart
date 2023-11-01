import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trashcash_app/core/repository/base_repository.dart';

class ListCreditScreen extends StatefulWidget {
  const ListCreditScreen({super.key});

  @override
  State<ListCreditScreen> createState() => _ListCreditScreenState();

}

class _ListCreditScreenState extends State<ListCreditScreen> {
  Map? dataFromApi;

  Future<void> fetchDataCreditAll() async {
    final result = await BaseRepository.fetchCredit();

    setState(() {
      dataFromApi = result;
    });
  }

  @override
  void initState(){
    super.initState();
    initializeDateFormatting('en_US', null);
    fetchDataCreditAll();
  }

  @override
  Widget build(BuildContext context) {
    String jsonString = json.encode(dataFromApi);
    Map<String, dynamic>? jsonData;

    if (jsonString.isNotEmpty){
      jsonData = json.decode(jsonString);
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Kredit',
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
                      fetchDataCreditAll();
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
              child:
              Container(
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
                        DataColumn(label: Text('ID Nasabah')),
                        DataColumn(label: Text('Jenis Sampah')),
                        DataColumn(label: Text('Harga Satuan')),
                        DataColumn(label: Text('Berat')),
                        DataColumn(label: Text('Total Kredit')),
                        DataColumn(label: Text('Tanggal')),
                      ],
                      rows: jsonData != null
                          ? jsonData['data'].map<DataRow>((data) {
                        return DataRow(cells: [
                          DataCell(Text(data['id_user'] ?? '')),
                          DataCell(Text(data['type_waste']['type'] ?? '')),
                          DataCell(Text(data['type_waste']['price'].toString() )),
                          DataCell(Text(data['weight'].toString() )),
                          DataCell(Text(data['credit'].toString() )),
                          DataCell(Text(
                              formatDate(data['date_credit'] ?? ''))),
                        ]);
                      }).toList()
                          : [],
                    ),
                  ),
                ),
              ),
            ),
            Text(
              '** Data  untuk sementara tidak dapat diperbarui atau dihapus melalui aplikasi',
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

  String formatDate(String inputDate) {
    final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    final outputFormat =
    DateFormat("dd MMMM yyyy", 'id_ID'); // 'id_ID' untuk bahasa Indonesia

    final date = inputFormat.parse(inputDate);
    return outputFormat.format(date);
  }

  String jsonToCsv(List<dynamic>? jsonData) {
    if (jsonData == null || jsonData.isEmpty) {
      return '';
    }
    List<List<dynamic>> csvData = [];

    // Add CSV header (column names) based on your JSON data structure
    csvData
        .add(['ID Nasabah', 'Jenis Sampah', 'Harga Satuan', 'Berat', 'Total Kredit', 'Tanggal']);

    // Add rows of data from JSON
    for (var data in jsonData) {
      csvData.add([
        data['id_user'] ?? '',
        data['type_waste']['type'] ?? '',
        data['type_waste']['price'] ?? '',
        data['weight'] ?? '',
        data['credit'] ?? '',
        data['date_credit'] ?? '',
      ]);
    }

    // Convert to CSV format
    String csv = const ListToCsvConverter().convert(csvData);

    return csv;
  }

  Future<void> saveCsvToFile(String csv) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory?.path}/data_credit.csv');
    await file.writeAsString(csv);
  }
}
