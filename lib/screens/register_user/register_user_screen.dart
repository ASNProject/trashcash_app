import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashcash_app/core/repository/base_repository.dart';
import 'package:trashcash_app/core/router/app_route_constans.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  TextEditingController idUserController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController idStatusController = TextEditingController();
  TextEditingController idLoadController = TextEditingController();

  String ids = '';
  String passwords = '';
  String names = '';
  String addresss = '';
  String idNumbers = '';
  String statuss = '';
  String loads = '';

  Future<void> addCustomer(BuildContext context) async {
    final idUser = idUserController.text;
    final password = passwordController.text;
    final name = nameController.text;
    final address = addressController.text;
    final idNumber = idNumberController.text;
    final idStatus = idStatusController.text;
    final idLoad = idLoadController.text;

    final existingData = await BaseRepository.fetchData(idUser);

    if (existingData != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Gagal'),
          content: const Text('ID User sudah ada di database.'),
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
      final success = await BaseRepository.addCustomer(
        idUser: idUser,
        password: password,
        name: name,
        address: address,
        idNumber: idNumber,
        idStatus: idStatus,
        idLoad: idLoad,
      );

      if (success == false) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Data nasabah berhasil ditambahkan.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    idUserController.clear();
                    idStatusController.clear();
                    idNumberController.clear();
                    nameController.clear();
                    addressController.clear();
                    passwordController.clear();
                    ids = '';
                    passwords = '';
                    names = '';
                    addresss = '';
                    idNumbers = '';
                    statuss = '';
                    loads = '';
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
                  'Terjadi kesalahan saat menambahkan data pelanggan.'),
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
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
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
                  'Registrasi Nasabah',
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
                      'Data Diri',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        GoRouter.of(context)
                            .pushNamed(AppRouteConstants.listCustomerRouteName);
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25A981),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: statuss == '1'
                ? ids.isNotEmpty &&
                        names.isNotEmpty &&
                        passwords.isNotEmpty &&
                        addresss.isNotEmpty &&
                        idNumbers.isNotEmpty &&
                        statuss.isNotEmpty &&
                        loads.isNotEmpty
                    ? () => addCustomer(context)
                    : null
                : ids.isNotEmpty &&
                        names.isNotEmpty &&
                        passwords.isNotEmpty &&
                        addresss.isNotEmpty &&
                        idNumbers.isNotEmpty &&
                        statuss.isNotEmpty
                    ? () => addCustomer(context)
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
      ),
    );
  }

  _buildForm() {
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
                const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          ),
          onChanged: (value) {
            setState(() {
              ids = value;
            });
          },
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Nama',
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
          controller: nameController,
          decoration: InputDecoration(
              hintText: 'Masukkan nama',
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
              names = value;
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
          controller: passwordController,
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
              passwords = value;
            });
          },
          obscureText: true,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Alamat',
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
          controller: addressController,
          decoration: InputDecoration(
              hintText: 'Masukkan alamat',
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
              addresss = value;
            });
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'NIK',
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
          controller: idNumberController,
          decoration: InputDecoration(
              hintText: 'Masukkan NIK',
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
              idNumbers = value;
            });
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'ID Status',
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
          controller: idStatusController,
          decoration: InputDecoration(
              hintText: 'Masukkan ID Status',
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
        Text(
          '** Pilih ID Status: 1: admin, 2: customer',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        Visibility(
          visible: statuss == '1', // Ubah kondisi sesuai kebutuhan Anda
          child: _addIdLoad(),
        ),
      ],
    );
  }

  _addIdLoad() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        Text(
          'ID Timbangan',
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
          controller: idLoadController,
          decoration: InputDecoration(
              hintText: 'Masukkan ID Timbangan',
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
              loads = value;
            });
          },
        ),
      ],
    );
  }
}
