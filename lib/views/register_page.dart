import 'package:delapp/views/logins_page.dart';
import 'package:flutter/material.dart';
import 'package:delapp/controllers/authentication.dart';
import 'package:get/get.dart';
import './widgets/input_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nomorKtpController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _nomorHandphoneController =
      TextEditingController();

  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Register Page',
                style: GoogleFonts.poppins(
                  fontSize: size * 0.080,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InputWidget(
                hintText: 'Name',
                obscureText: false,
                controller: _nameController,
              ),
              const SizedBox(
                height: 10,
              ),
              InputWidget(
                hintText: 'Email',
                obscureText: false,
                controller: _emailController,
              ),
              const SizedBox(
                height: 10,
              ),
              InputWidget(
                hintText: 'Password',
                obscureText: true,
                controller: _passwordController,
              ),
              const SizedBox(
                height: 10,
              ),
              InputWidget(
                hintText: 'Nomor KTP',
                obscureText: false,
                controller: _nomorKtpController,
              ),
              const SizedBox(
                height: 10,
              ),
              InputWidget(
                hintText: 'NIM',
                obscureText: false,
                controller: _nimController,
              ),
              const SizedBox(
                height: 10,
              ),
              InputWidget(
                hintText: 'Nama Lengkap',
                obscureText: false,
                controller: _namaLengkapController,
              ),
              const SizedBox(
                height: 10,
              ),
              InputWidget(
                hintText: 'Nomor Handphone',
                obscureText: false,
                controller: _nomorHandphoneController,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                onPressed: () async {
                  await _authenticationController.register(
                    name: _nameController.text.trim(),
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                    nomorKtp: _nomorKtpController.text.trim(),
                    nim: _nimController.text.trim(),
                    namaLengkap: _namaLengkapController.text.trim(),
                    nomorHandphone: _nomorHandphoneController.text.trim(),
                  );
                },
                child: Obx(() {
                  return _authenticationController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Register',
                          style: GoogleFonts.poppins(
                            fontSize: size * 0.040,
                          ),
                        );
                }),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => const LoginsPage());
                },
                child: Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    fontSize: size * 0.040,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
