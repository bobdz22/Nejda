import 'package:emergency/Core/Colors/Constante.dart';
import 'package:emergency/Data/Services/Auth_Services.dart';
import 'package:emergency/presentation/AuthPages/RegisterPage.dart';
import 'package:emergency/presentation/Pages/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
   final TextEditingController _emailController = TextEditingController();
   final TextEditingController _passwordController = TextEditingController();
     final _formKey = GlobalKey<FormState>();
     bool isLoading = false ;
     AuthServices authServices =AuthServices();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                children: [
                  Image.asset(
                    "Assets/Images/20547283_6310505 1.png", 
                    width: 150,
                  ),
                  const Text(
                    "تسجيل الدخول",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "! مرحبًا بعودتك! لقد افتقدناك",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "البريد الالكتروني   ",
                  filled: true,
                    fillColor: Color(0xffF5F3F3),
                        enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none, 
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: mainColor, width: 1), 
    ),
                ),
                validator: LoginFormValidators.validateEmailOrPhone,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "كلمة المرور",
                  filled: true,
                    fillColor: Color(0xffF5F3F3),
                        enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none, 
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: mainColor, width: 1), 
    ),
                ),
                validator: LoginFormValidators.validatePassword,
              ),
              SizedBox(height: 20),
              
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  onPressed: _submitLoginForm,
                  color: mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  padding: EdgeInsets.all(10),
                  child: isLoading 
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 24
                        ),
                      ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _navigateToRegister,
                child: Text(
                  "إنشاء حساب",
                  style: TextStyle(
                    color: Color(0xff494949), 
                    fontSize: 20
                  )
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submitLoginForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Future.delayed(Duration(seconds: 2), () async {
        String result = await authServices.login(
          _emailController.text.trim(),
          _passwordController.text.trim()
        );

        if (result == "success") {
          Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Homepage()), // Replace with your target page
      (route) => false,
    );
        } else {
          showCustomSnackbar(
            context, 
            "كلمة سر او البريد الالكتروني خاطئ", 
            isError: true
          );
        }

        setState(() {
          isLoading = false;
        });
      });
    }
  }

 

  void _navigateToRegister() {
  Get.to(Registerpage(),transition: Transition.rightToLeft);
  }

  @override
  void dispose() {
    
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
class LoginFormValidators {
  // Validate Email or Phone Number
  static String? validateEmailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال البريد الإلكتروني   ';
    }
    
    // Allow either email or 10-digit phone number
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    
    
    if (!emailRegExp.hasMatch(value.trim()) ) {
      return 'البريد الإلكتروني';
    }
    
    return null;
  }

  // Validate Password
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    }
    
    if (value.trim().length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    
    return null;
  }
}