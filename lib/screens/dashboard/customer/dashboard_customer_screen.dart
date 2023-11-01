import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:contained_tab_bar_view_with_custom_page_navigator/contained_tab_bar_view_with_custom_page_navigator.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trashcash_app/core/repository/base_repository.dart';

class DashboardCustomerScreen extends StatefulWidget {
  final String idUser;

  const DashboardCustomerScreen({
    super.key,
    required this.idUser,
  });

  @override
  State<DashboardCustomerScreen> createState() =>
      _DashboardCustomerScreenState();
}

class _DashboardCustomerScreenState extends State<DashboardCustomerScreen> {
  Map? customerFromApi;
  Map? creditFromApi;
  Map? debitFromApi;
  bool doubleTapToExit = false;
  final int delay = 2000;
  Timer? doubleTapTimer;

  String? nameCustomer;
  String? formattedString;

  Future<void> fetchCustomerId(String idUser) async {
    final result = await BaseRepository.fetchData(idUser);

    setState(() {
      customerFromApi = result;
    });
  }

  Future<void> fetchCreditId(String idUser) async {
    final result = await BaseRepository.fetchCreditId(idUser);
    setState(() {
      creditFromApi = result;
    });
  }

  Future<void> fetchDebitId(String idUser) async {
    final result = await BaseRepository.fetchDebitId(idUser);
    setState(() {
      debitFromApi = result;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('en_US', null);
    fetchCustomerId(widget.idUser);
    fetchCreditId(widget.idUser);
    fetchDebitId(widget.idUser);
  }

  @override
  Widget build(BuildContext context) {
    int totalDebit = 0;
    int totalCredit = 0;

    ///-------------- Customer ------------------
    if (widget.idUser.isNotEmpty) {
      String jsonString = json.encode(customerFromApi);
      Map<String, dynamic>? jsonData;

      if (jsonString.isNotEmpty) {
        jsonData = json.decode(jsonString);
      }

      if (jsonData != null) {
        List<dynamic>? dataList = jsonData['data'];

        if (dataList != null && dataList.isNotEmpty) {
          Map<String, dynamic> customerData = dataList[0];

          nameCustomer = customerData['name'] ?? '';
        }
      }
    }
    //--------------------Debit-------------------
    String jsonStringDebit = json.encode(debitFromApi);
    Map<String, dynamic>? jsonDebit;

    if (jsonStringDebit.isNotEmpty) {
      jsonDebit = json.decode(jsonStringDebit);
    }

    if (jsonDebit != null) {
      List<dynamic>? dataListDebit = jsonDebit['data'];

      if (dataListDebit != null && dataListDebit.isNotEmpty) {
        for (var item in dataListDebit) {
          if (item.containsKey('debit') && item['debit'] != null) {
            final debitValue = num.tryParse(item['debit'].toString());
            if (debitValue != null) {
              totalDebit += debitValue.toInt();
            }
          }
        }
      }
    }
    //--------------------Credit-------------------
    String jsonStringCredit = json.encode(creditFromApi);
    Map<String, dynamic>? jsonCredit;

    if (jsonStringCredit.isNotEmpty) {
      jsonCredit = json.decode(jsonStringCredit);
    }

    if (jsonCredit != null) {
      List<dynamic>? dataListCredit = jsonCredit['data'];

      if (dataListCredit != null && dataListCredit.isNotEmpty) {
        for (var item in dataListCredit) {
          if (item.containsKey('credit') && item['credit'] != null) {
            final creditValue = num.tryParse(item['credit'].toString());
            if (creditValue != null){
              totalCredit += creditValue.toInt();
            }
          }
        }
      }
    }

    int totalSaldo = totalCredit - totalDebit;

    formattedString = totalSaldo.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () async {
          if (doubleTapToExit) {
            return true;
          } else {
            doubleTapToExit = true;
            doubleTapTimer = Timer(Duration(milliseconds: delay), () {
              doubleTapToExit = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tekan sekali lagi untuk keluar')),
            );
            return false;
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Datang',
                style: GoogleFonts.poppins(
                  textStyle:
                      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                '$nameCustomer',
                style: GoogleFonts.poppins(
                  textStyle:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              _buildCardCustomer(),
              const SizedBox(
                height: 16,
              ),
              _buildTabBar(
                jsonDebit ?? {},
                jsonCredit ?? {},
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (jsonCredit != null) {
                        String csv = jsonToCsv(jsonCredit['data'] ?? []);
                        await saveCsvToFile(csv);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'CSV berhasil di download. Silahkan buka Android/data/com.trashcash.trashcash_app/files'),
                        ));
                      }
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Unduh Data Credit'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF25A981)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (jsonDebit != null) {
                        String csv = jsonToCsvDebit(jsonDebit['data'] ?? []);
                        await saveCsvToFileDebit(csv);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'CSV berhasil di download. Silahkan buka Android/data/com.trashcash.trashcash_app/files'),
                        ));
                      }
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Unduh Data Debit'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF25A981)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildTabBar(
      Map<String, dynamic> jsonDebit, Map<String, dynamic> jsonCredit) {
    return Expanded(
      child: ContainedTabBarView(
        tabs: [
          Text(
            'Kredit',
            style: GoogleFonts.poppins(
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            'Debit',
            style: GoogleFonts.poppins(
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        tabBarProperties: TabBarProperties(
          height: 32.0,
          indicatorColor: const Color(0xFF25A981),
          indicatorWeight: 6.0,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey[400],
        ),
        views: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            // decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey),
            //     borderRadius: BorderRadius.circular(8)),
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
                  rows: jsonCredit.isNotEmpty
                      ? jsonCredit['data'].map<DataRow>((data) {
                          return DataRow(cells: [
                            DataCell(Text(data['id_user'] ?? '')),
                            DataCell(Text(data['type_waste']['type'] ?? '')),
                            DataCell(Text(
                                data['type_waste']['price'].toString() )),
                            DataCell(Text(data['weight'].toString() )),
                            DataCell(Text(data['credit'].toString() )),
                            DataCell(
                                Text(formatDate(data['date_credit'] ?? ''))),
                          ]);
                        }).toList()
                      : [],
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            // decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey),
            //     borderRadius: BorderRadius.circular(8)),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID Nasabah')),
                    DataColumn(label: Text('Debit')),
                    DataColumn(label: Text('Satuan')),
                    DataColumn(label: Text('Tanggal')),
                  ],
                  rows: jsonDebit.isNotEmpty
                      ? jsonDebit['data'].map<DataRow>((data) {
                          return DataRow(cells: [
                            DataCell(Text(data['id_user'] ?? '')),
                            DataCell(Text(data['debit'].toString() )),
                            DataCell(Text(data['status_withdrawal'] ?? '')),
                            DataCell(Text(
                                formatDate(data['date_withdrawal']) )),
                          ]);
                        }).toList()
                      : [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildCardCustomer() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF25A981),
              Color(0xFF9CB5AD),
            ],
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 8.0,
                offset: Offset(0.0, 0.08))
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.wallet_membership,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Saldo Anda',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          fetchDebitId(widget.idUser);
                          fetchCreditId(widget.idUser);
                        });
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Update',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Center(
                  child: Text(
                    'Rp. $formattedString',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Text(
                '** Jumlah saldo adalah akumulasi dari jumlah seluruh transaksi sebelum penarikan',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontStyle: FontStyle.italic),
                ),
              ),
            )
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

  ///------ Debit --------
  String jsonToCsvDebit(List<dynamic>? jsonData) {
    if (jsonData == null || jsonData.isEmpty) {
      return '';
    }
    List<List<dynamic>> csvData = [];

    // Add CSV header (column names) based on your JSON data structure
    csvData
        .add(['ID Nasabah', 'Debit', 'Harga Satuan', 'Status', 'Tanggal']);

    // Add rows of data from JSON
    for (var data in jsonData) {
      csvData.add([
        data['id_user'] ?? '',
        data['debit'] ?? '',
        data['status_withdrawal'] ?? '',
        data['date_withdrawal'] ?? '',
      ]);
    }

    // Convert to CSV format
    String csv = const ListToCsvConverter().convert(csvData);

    return csv;
  }

  Future<void> saveCsvToFileDebit(String csv) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory?.path}/data_debit_$nameCustomer.csv');
    await file.writeAsString(csv);
  }

  ///------------ Credit --------
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
    final file = File('${directory?.path}/data_credit_$nameCustomer.csv');
    await file.writeAsString(csv);
  }
}
