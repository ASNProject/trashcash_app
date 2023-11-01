import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:trashcash_app/core/repository/base_repository.dart';
import 'package:trashcash_app/core/router/app_route_constans.dart';

class DashboardAdminScreen extends StatefulWidget {
  final String userId;

  const DashboardAdminScreen({super.key, required this.userId});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  DateTime now = DateTime.now();
  String formattedDate = '';
  bool doubleTapToExit = false;
  final int delay = 2000;
  Timer? doubleTapTimer;

  Map? debitFromApi;
  Map? creditFromApi;

  Future<void> fetchDebit() async {
    final result = await BaseRepository.fetchDebit();

    setState(() {
      debitFromApi = result;
    });
  }

  Future<void> fetchCredit() async {
    final result = await BaseRepository.fetchCredit();

    setState(() {
      creditFromApi = result;
    });
  }

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd MMMM yyyy').format(now);
    fetchDebit();
    fetchCredit();
  }

  @override
  Widget build(BuildContext context) {
    int totalDebit = 0;
    int totalCredit = 0;
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
            if (debitValue != null){
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
            // totalCredit += (item['credit'] as num).toInt();
            final creditValue = num.tryParse(item['credit'].toString());
            if (creditValue != null){
              totalCredit += creditValue.toInt();
            }
          }
        }
      }
    }

    int totalSaldo = totalCredit - totalDebit;

    String formattedString = totalSaldo.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );

    return Scaffold(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 32,
                left: 16,
                bottom: 16,
              ),
              child: Text(
                'Dashboard',
                style: GoogleFonts.poppins(
                  textStyle:
                      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            _buildCardDashboard(formattedString),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              child: Text(
                'Menu',
                style: GoogleFonts.poppins(
                  textStyle:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            _buildMenu(),
          ],
        ),
      ),
    );
  }

  _buildMenu() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      GoRouter.of(context).pushNamed(
                        AppRouteConstants.creditRouteName,
                        queryParams: {'idUser': widget.userId},
                      );
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/penarikan.png',
                              width: 110,
                              height: 110,
                            ),
                            Text(
                              'Kredit',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      GoRouter.of(context)
                          .pushNamed(AppRouteConstants.debitRouteName);
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/pembelian.png',
                              width: 110,
                              height: 110,
                            ),
                            Text(
                              'Debit',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      GoRouter.of(context)
                          .pushNamed(AppRouteConstants.registerUserRouteName);
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/nasabah.png',
                              width: 110,
                              height: 110,
                            ),
                            Text(
                              'Nasabah',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      GoRouter.of(context)
                          .pushNamed(AppRouteConstants.wasteTypeRouteName);
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/jenis.png',
                              width: 110,
                              height: 110,
                            ),
                            Text(
                              'Jenis Sampah',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCardDashboard(String formattedString) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF25A981),
              Color(0xFF9CB5AD),
            ],
          ),
          boxShadow: <BoxShadow>[
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
                      Icons.wallet_membership,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Saldo Kas Bank Sampah',
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
                Text(
                  'Rp. $formattedString',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDate,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        fetchDebit();
                        fetchCredit();
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
            )
          ],
        ),
      ),
    );
  }


}
