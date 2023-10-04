import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashcash_app/core/repository/base_repository.dart';
import 'package:trashcash_app/core/router/app_route_constans.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreenContent();
  }
}

class LoginScreenContent extends StatefulWidget {
  const LoginScreenContent({
    super.key,
  });

  @override
  State<LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<LoginScreenContent> {
  late Map dataFromApi;

  TextEditingController nasabahIdTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  Future<void> fetchData(String idUser) async {
    // Menggunakan fungsi fetchData dari ApiService
    final result = await BaseRepository.fetchData(idUser);

    setState(() {
      dataFromApi = result!;
    });
  }

  @override
  void initState() {
    super.initState();
    // fetchData(nasabahIdTextController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            _buildBody(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 95),
          child: Text(
            'Selamat Datang',
            style: GoogleFonts.poppins(
              textStyle:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        Text(
          'Masuk',
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
          controller: nasabahIdTextController,
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
              nasabahIdTextController.text = value;
            });
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Kata Sandi',
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
          controller: passwordTextController,
          decoration: InputDecoration(
              hintText: 'Masukkan kata sandi',
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
              passwordTextController.text = value;
            });
          },
          obscureText: true,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Belum ada akun? Silahkan daftar ke Bank Sampah terdeket.',
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
            onPressed: () {
              fetchData(nasabahIdTextController.text);
              String jsonString = json.encode(dataFromApi);
              Map<String, dynamic> jsonData = json.decode(jsonString);

              List<dynamic> dataList = jsonData['data'];

              if (dataList.isNotEmpty) {
                Map<String, dynamic> userData = dataList[0];

                String password = userData['password'];
                String idUser = userData['id_user'];
                int status = userData['id_status'];

                if (idUser == nasabahIdTextController.text &&
                    password == passwordTextController.text) {
                  if (status == 1) {
                    GoRouter.of(context)
                        .pushNamed(AppRouteConstants.dashboardAdminRouteName);
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration:  Duration(seconds: 3),
                        content: Text(
                          'Anda adalah customer',
                        ),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(
                     duration:  Duration(seconds: 3),
                      content: Text(
                        'Gagal login, Id Nasabah atau password salah. Silahkan coba lagi!',
                      ),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration:  Duration(seconds: 3),
                    content: Text(
                      'Data kosong',
                    ),
                  ),
                );
              }
              // fetchData(nasabahIdTextController.text).then((apiResponse) {
              //   if (dataFromApi != null) {
              //     Map<String, dynamic> jsonResponse = json.decode(dataFromApi);
              //
              //     if (jsonResponse.containsKey('data')) {
              //       String password = jsonResponse['data'][0]['password'];
              //
              //       if (password == passwordTextController.text) {
              //         // Password sesuai, lakukan tindakan selanjutnya
              //         // Contoh: Navigasi ke layar berikutnya
              //       } else {
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           const SnackBar(
              //             duration: Duration(seconds: 3),
              //             content: Text(
              //                 'ID Nasabah atau Password tidak sesuai, silakan coba lagi'),
              //           ),
              //         );
              //       }
              //     } else {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(
              //           duration: Duration(seconds: 3),
              //           content: Text(
              //               'Data dari API tidak sesuai, silakan coba lagi'),
              //         ),
              //       );
              //     }
              //   } else {
              //     // Handle the case where apiResponse is null (e.g., an error occurred)
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(
              //         duration: Duration(seconds: 3),
              //         content: Text(
              //             'An error occurred while fetching data from the API'),
              //       ),
              //     );
              //   }
              // });
            },
            child: Text(
              'Masuk',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Sistem Bank Sampah Rumah Tangga mendorong partisipasi aktif dalam '
          'pemilihan penabung sampah untuk meningkatkan upaya melestarikan '
          'linkungan dengan bergotong royong untuk mengelola sampah, sehingga '
          'dapat berdampak pada peningkatan daya saing rumah tangga keluarga',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w300,
              color: Colors.black87,
            ),
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  _buildFooter() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Column(
        children: [
          Text(
            'Daur Ulang',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF25A981),
              ),
            ),
          ),
          Text(
            'Sampah Mu',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFFBFE84B),
              ),
            ),
          )
        ],
      ),
    );
  }
}
