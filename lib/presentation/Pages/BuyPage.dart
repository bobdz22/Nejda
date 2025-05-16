import 'package:emergency/Core/Colors/Constante.dart';
import 'package:emergency/presentation/AuthPages/RegisterPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class Buypage extends StatefulWidget {
  const Buypage({super.key});

  @override
  State<Buypage> createState() => _BuypageState();
}

class _BuypageState extends State<Buypage> {
   int amount = 1000;
     final _formKey = GlobalKey<FormState>();
   final TextEditingController _phoneController = TextEditingController();
   final TextEditingController _nameController = TextEditingController();
   final TextEditingController _emailController = TextEditingController();
   final TextEditingController _passwordController = TextEditingController();
   Future<void> _launchURL() async {
    final Uri url = Uri.parse("https://docs.google.com/forms/u/0/d/e/1FAIpQLScwwnpIbLLLdHfcEeQYOCGo3vYi9EZHkUO7ZYj-Gz5gxkPgcQ/formResponse?pli=1");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $url");
    }
  }// Make sure to include this FormValidators class if not already defined elsewhere


@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      bottom: true,
      top: false,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Background SVG
              Positioned(
                top: -70,
                child: SvgPicture.asset("Assets/Images/Group 1.svg"),
              ),
              
              // Logo
              Positioned(
                top: 120,
                left: 20,
                child: Container(
                  decoration: BoxDecoration(),
                  child: SvgPicture.asset("Assets/Images/logo.svg", width: 100),
                ),
              ),
              
              // Main Content with ScrollView
              Padding(
                  padding: EdgeInsets.only(top: 300, right: 15, left: 15, bottom: 20),
                  child: Column(
                    children: [
                      // Course Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "تسجيل في دورة",
                            style: TextStyle(
                              fontSize: 28,
                              color: mainColor
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 30),
                      
                      // Course Description
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "الاسعاف من حوادث الغرق",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      
                      // Amount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "المبلغ: $amount  DA ",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 10),
                      
                      // Payment Card
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset("Assets/Images/dahabiya.jpg", width: 100),
                            SizedBox(width: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Carte Edahabia", 
                                  style: TextStyle(
                                    fontSize: 18, 
                                    fontWeight: FontWeight.bold, 
                                    color: Color(0xff00008A)
                                  ),
                                ),
                                Text(
                                  "*** **** **** 9034", 
                                  style: TextStyle(
                                    fontSize: 16, 
                                    fontWeight: FontWeight.bold, 
                                    color: Colors.grey
                                  ),
                                ),
                                Text(
                                  "06/19", 
                                  style: TextStyle(
                                    fontSize: 16, 
                                    fontWeight: FontWeight.bold, 
                                    color: Colors.grey
                                  ),
                                )
                              ],
                            ),
                            Spacer(), // Add spacer to push the following content to the right
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "Assets/Images/point.png", 
                                  color: Colors.green, 
                                  width: 20
                                ),
                                Text(
                                  " principale", 
                                  style: TextStyle(
                                    fontSize: 14, 
                                    color: Colors.green
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 10),
                      
                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        validator: FormValidators.validateName,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          labelText: "الاسم الكامل",
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          alignLabelWithHint: true,
                          filled: true,
                          fillColor: Color(0xffF5F3F3),
                          labelStyle: TextStyle(fontSize: 16),
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black, width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                     
                      
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        validator: FormValidators.validateEmail,
                        textDirection: TextDirection.rtl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "البريد الإلكتروني",
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          alignLabelWithHint: true,
                          filled: true,
                          fillColor: Color(0xffF5F3F3),
                          labelStyle: TextStyle(fontSize: 16),
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black, width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: FormValidators.validatePassword,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          labelText: "كلمة المرور",
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          alignLabelWithHint: true,
                          filled: true,
                          fillColor: Color(0xffF5F3F3),
                          labelStyle: TextStyle(fontSize: 16),
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black, width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _launchURL();
                            }
                          },
                          color: mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "التسجيل",
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 24
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
    ),
  );
}}