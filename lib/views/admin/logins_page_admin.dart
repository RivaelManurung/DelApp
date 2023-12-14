import 'package:delapp/controllers/authentication.dart';
import 'package:delapp/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:delapp/components/my_textfield.dart';
import 'package:delapp/components/square_tile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginsAdminPage extends StatefulWidget {
  const LoginsAdminPage({Key? key}) : super(key: key);

  @override
  State<LoginsAdminPage> createState() => _LoginsAdminPageState();
}

class _LoginsAdminPageState extends State<LoginsAdminPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  void signUserIn() {
    // Implement your sign-in logic here
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF093545),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // Logo
                SquareTile(imagePath: 'images/del.jpg'),
                const SizedBox(height: 50),
                // Welcome text
                Text(
                  'Welcome back, you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                // name textfield
                MyTextField(
                  controller: _nameController,
                  hintText: 'name',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                // Password textfield
                MyTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                // Forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // Sign-in button
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
                    await _authenticationController.login(
                      name: _nameController.text.trim(),
                      password: _passwordController.text.trim(),
                    );
                  },
                  child: Obx(() {
                    return _authenticationController.isLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'Login',
                            style: GoogleFonts.poppins(
                              fontSize: size * 0.040,
                            ),
                          );
                  }),
                ),

                const SizedBox(height: 50),
                // Or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                // Google + Apple sign-in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // Google button
                    SquareTile(imagePath: 'images/google.png'),
                    SizedBox(width: 25),
                    // Facebook button (corrected image path)
                    SquareTile(imagePath: 'images/logoFacebook.png'),
                  ],
                ),
                const SizedBox(height: 50),
                // Not a member? Register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const RegisterPage());
                      },
                      child: Text(
                        'Register',
                        style: GoogleFonts.poppins(
                          fontSize: size * 0.040,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
