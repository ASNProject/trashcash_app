import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashcash_app/core/repository/base_repository.dart';
import 'package:trashcash_app/core/router/app_route_constans.dart';

class CreditScreen extends StatefulWidget {
  final String idUser;

  const CreditScreen({
    super.key,
    required this.idUser,
  });

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  TextEditingController idUserController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  Map? customerFromApi;
  Map? loadFromApi;
  Map? typeWasteFromApi;
  Map? typeWasteIdFromApi;
  Map? creditFromApi;

  String ids = '';
  String? loadId;
  double? loadValue = 0;

  bool dataFetched = false;

  int selectedTypeId = 1;
  int priceType = 0;
  double? total;

  List<dynamic> typeData = [];

  Future<void> fetchCustomer() async {
    final result = await BaseRepository.fetchData(widget.idUser);

    setState(() {
      customerFromApi = result;
    });
  }

  Future<void> fetchTypeWaste() async {
    final result = await BaseRepository.fetchDataTypeWasteAll();

    setState(() {
      typeWasteFromApi = result;
      dataFetched = true;
    });
  }

  Future<void> fetchTypeWasteId(String id) async {
    final result = await BaseRepository.fetchDataTypeWasteId(id);

    setState(() {
      typeWasteIdFromApi = result;
    });
  }

  Future<void> fetchLoad() async {
    final result = await BaseRepository.fetchLoadId(loadId!);
    setState(() {
      loadFromApi = result;
    });
  }

  Future<void> fetchCredit() async {
    final result = await BaseRepository.fetchCredit();

    setState(() {
      creditFromApi = result;
    });
  }

  Future<void> addCredit(BuildContext context) async {
    final idUser = idUserController.text;
    final idType = selectedTypeId;
    final weight = loadValue;
    final totalPrice = total;

    final allCustomersData = await BaseRepository.fetchDataCustomerAll();

    if (allCustomersData != null) {
      final List<dynamic> customers = allCustomersData['data'];

      bool userExists =
      customers.any((customer) => customer['id_user'] == idUser);

      if (userExists) {
        final success = await BaseRepository.addCredit(
          userId: idUser,
          typeId: idType.toString(),
          weight: weight.toString(),
          credit: totalPrice.toString(),
        );

        if (success == false) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Data kedit berhasil disimpan'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      idUserController.clear();
                      ids = '';
                    });
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
                    'Terjadi kesalahan saat menambahkan data kredit.'),
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
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Gagal'),
            content: const Text(
                'ID yang anda tambahkan tidak ada dalam daftar. Silahkan periksa kembali'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              )
            ],
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCustomer();
    fetchTypeWaste();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///-------------User-----------------
    if (widget.idUser.isNotEmpty) {
      String jsonString = json.encode(customerFromApi);
      Map<String, dynamic>? jsonData;

      if (jsonString.isNotEmpty) {
        jsonData = json.decode(jsonString);
      }

      if (jsonData != null) {
        List<dynamic>? dataList = jsonData['data'];

        if (dataList != null && dataList.isNotEmpty) {
          Map<String, dynamic> userData = dataList[0];

          String code = userData['id_load'] ?? '';

          loadId = code;
        }
      }
    }

    ///----------------Load-----------------
    if (loadId != null) {
      fetchLoad();
      String jsonString = json.encode(loadFromApi);
      Map<String, dynamic>? jsonData;

      if (jsonString.isNotEmpty) {
        jsonData = json.decode(jsonString);
      }

      if (jsonData != null) {
        List<dynamic>? dataList = jsonData['data'];

        if (dataList != null && dataList.isNotEmpty) {
          Map<String, dynamic> userData = dataList.last;

          double value = double.tryParse(userData['value'].toString()) ?? 0;

          setState(() {
            loadValue = value;
          });
        }
      }
    }

    ///-------Load Type-Waste------------------------
    if (loadId != null) {
      String jsonString = json.encode(typeWasteFromApi);
      Map<String, dynamic>? jsonData;

      if (jsonString.isNotEmpty) {
        jsonData = json.decode(jsonString);
      }

      if (jsonData != null) {
        List<dynamic>? dataList = jsonData['data'];
        setState(() {
          typeData = dataList!;
        });
        if (dataList != null && dataList.isNotEmpty) {
          // Map<String, dynamic> userData = dataList[0];

          // int value = userData['value'] ?? 0;
          //
          // priceType = value;
        }
      }
    }

    if (loadId != null) {
      fetchTypeWasteId(selectedTypeId.toString());
      String jsonString = json.encode(typeWasteIdFromApi);
      Map<String, dynamic>? jsonData;

      if (jsonString.isNotEmpty) {
        jsonData = json.decode(jsonString);
      }

      if (jsonData != null) {
        List<dynamic>? dataList = jsonData['data'];

        if (dataList != null && dataList.isNotEmpty) {
          Map<String, dynamic> userData = dataList[0];

          int? value = int.tryParse(userData['price'] ?? '');

          priceType = value!;
        }
      }
    }

    ///------------Calculate Total--------------------
    total = loadValue! * priceType;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kredit',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                          color: Colors.teal, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          loadId ?? 'C',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                _buildCardCredit(),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Masukkan Credit Baru',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        GoRouter.of(context).pushNamed(
                          AppRouteConstants.listCreditRouteName,
                        );
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
                _buildFormCredit()
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
                  onPressed: ids.isNotEmpty ? () => addCredit(context) : null,
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

  _buildCardCredit() {
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
                  children: [
                    const Icon(
                      Icons.balance,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Timbangan Digital',
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
                const SizedBox(
                  height: 8,
                ),
                Center(
                  child: Text(
                    loadValue != null ? '${loadValue.toString()} Kg' : '0 Kg',
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
                '** Berat dibulatkan dalam kilogram',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 12,
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

  _buildFormCredit() {
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
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(
                8,
              )),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: DropdownButton<int>(
              isExpanded: true,
              value: selectedTypeId,
              items: typeData.map((item) {
                return DropdownMenuItem<int>(
                  value: int.tryParse(item['id_type'] ?? '') ?? 1,
                  child: Text(item['type']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTypeId = value!;
                });
              },
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          '** Total dana akan diakumulasikan otomatis dengan berat dan jenis sampah',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: GoogleFonts.poppins(
                textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '$total',
              style: GoogleFonts.poppins(
                textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
