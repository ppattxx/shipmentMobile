import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipment_record/api/api_service.dart';
import 'package:shipment_record/constants/color.dart';
import 'package:shipment_record/view/shipment_code.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Memastikan body menyatu dengan AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparan agar menyatu dengan gradasi
        elevation: 0, // Menghilangkan shadow AppBar
        title: Padding(
          padding: EdgeInsets.only(top: 20), // Geser teks ke bawah
          child: Center(
            child: Text(
              'Hello !',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity, // Memastikan lebar penuh
        height: double.infinity, // Memastikan tinggi penuh
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Pusatkan isi form
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildTextField('NIK', _nikController, Icons.person, false),
                    SizedBox(height: 16),
                    _buildTextField('Password', _passwordController, Icons.lock, true),
                    SizedBox(height: 16),
                    if (_errorMessage.isNotEmpty)
                      Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: Material(
                        borderRadius: BorderRadius.circular(6),
                        elevation: 5, // Tambahkan efek bayangan tombol
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: AppColors.buttonGradient,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: InkWell(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                _login();
                              }
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              alignment: Alignment.center,
                              child: Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, bool isPassword) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _isObscure : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }

  // Menambahkan metode login
  void _login() async {
    setState(() {
      _errorMessage = ''; // Reset error message
    });

    bool isLoginSuccessful = await ApiService().login(
      context,
      _nikController.text,
      _passwordController.text,
    );

    if (!isLoginSuccessful) {
      setState(() {
        _errorMessage = 'Login gagal! Periksa NIK dan password Anda.';
      });
    } else {
      // Jika login berhasil, arahkan ke halaman utama atau halaman berikutnya
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => ShipmentCode()),
      );
    }
  }

  @override
  void dispose() {
    _nikController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
