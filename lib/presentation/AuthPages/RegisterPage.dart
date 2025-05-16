import 'dart:io';

import 'package:emergency/Core/Colors/Constante.dart';
import 'package:emergency/Data/Services/Auth_Services.dart';
import 'package:emergency/presentation/AuthPages/LoginPage.dart';
import 'package:emergency/presentation/AuthPages/VerifyNumberPage.dart';
import 'package:emergency/presentation/Pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final _formKey = GlobalKey<FormState>();
   final TextEditingController _phoneController = TextEditingController();
   final TextEditingController _nameController = TextEditingController();
   final TextEditingController _emailController = TextEditingController();
   final TextEditingController _passwordController = TextEditingController();
   final TextEditingController _confirmationPasswordController = TextEditingController();
   bool isLoading = false;
   File? _profileImage;
   AuthServices authServices =AuthServices();
   Future<void> _getImage(ImageSource source) async {
  try {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
    );
    
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  } catch (e) {

    print('Error picking image: $e');
  }
}
Widget _buildOptionButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: mainColor, size: 30),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}
 @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      backgroundColor: Colors.white,
      body: SafeArea(
  child: Center(
    child: Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(right: 15,left: 15,bottom: 20),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
         
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                   // Image.asset("Assets/Images/20547283_6310505 1.png", width: 100),
                    const Text(
                      "إنشاء حساب",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "قم بإنشاء لتتمكن من",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10,),
                   GestureDetector(
  onTap: () {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Profile Photo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionButton(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(ImageSource.camera);
                    },
                  ),
                  _buildOptionButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  },
  child: Stack(
  alignment: Alignment.bottomRight,
  children: [
    GestureDetector(
      onTap: () {
   
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: mainColor.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 45,
          backgroundColor: mainColor,
          child: CircleAvatar(
            radius: 42,
            backgroundColor: Colors.white,
            child: _profileImage != null
                ? ClipOval(
                    child: Image.file(
                      _profileImage!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey.shade600,
                  ),
          ),
        ),
      ),
    ),
    Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: mainColor,
        shape: BoxShape.circle,
        border: Border.all(color: mainColor),
      ),
      child: Icon(Icons.edit, color: Colors.white, size: 20),
    ),
  ],
),)
                  ],
                ),
                  SizedBox(height: 30,),
                TextFormField(
                  controller: _nameController,
                  validator: FormValidators.validateName,
                  decoration: InputDecoration(
                    labelText: "الاسم الكامل",
                    filled: true,
                    fillColor: Color(0xffF5F3F3),
                        enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none, 
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.black, width: 1), 
    ),
                  ),
                ),
                  SizedBox(height: 26,),
                TextFormField(
                  controller: _emailController,
                  validator: FormValidators.validateEmail,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffF5F3F3),
                    labelText: "البريد الالكتروني",
                       enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none, 
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.black, width: 1), 
    ),
                  ),
                ),
               SizedBox(height: 26,),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: FormValidators.validatePhoneNumber,
                  decoration: InputDecoration(
                    labelText: "رقم الهاتف",
                    filled: true,
                    fillColor: Color(0xffF5F3F3),
                    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none, 
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.black, width: 1), 
    ),
                  ),
                ),
               SizedBox(height: 26,),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: FormValidators.validatePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffF5F3F3),
                    labelText: "كلمة المرور",
                        enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none, 
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.black, width: 1), 
    ),
                  ),
                ),
                 SizedBox(height: 26,),
                TextFormField(
                  controller: _confirmationPasswordController,
                  obscureText: true,
                  validator: (value) => FormValidators.validateConfirmPassword(
                    value, 
                    _passwordController.text
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffF5F3F3),
                    labelText: "تاكيد كلمة المرور",
                       enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none, 
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.black, width: 1), 
    ),
                  ),
                ),
              SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    onPressed: _submitForm,
                    color: mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                    padding: EdgeInsets.all(10),
                    child: isLoading 
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "إنشاء حساب",
                          style: TextStyle(color: Colors.white, fontSize: 24)
                        ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("بالفعل؟"),
                    GestureDetector(
                      onTap: () {
                         Get.back();
                      },
                      child: Text(
                        "حساب",
                        style: TextStyle(color: mainColor),
                      )
                    ),
                    Text("هل لديك")
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    ),
  ),
),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Future.delayed(Duration(seconds: 2), () async {
        String result = await authServices.Register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nameController.text.trim(),
          _phoneController.text.trim(),
           _profileImage

        );

        if (result == "success") {
         Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Homepage()), 
      (route) => false,
    );
        } else {
          showCustomSnackbar(context, result, isError: true);
        }

        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {

    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmationPasswordController.dispose();
    super.dispose();
  }
}
void showCustomSnackbar(BuildContext context, String message, {bool isError = false}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(
          isError ? Icons.error_outline : Icons.check_circle_outline,
          color: Colors.white,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    ),
    backgroundColor: isError ? Colors.redAccent : Colors.green,
    behavior: SnackBarBehavior.floating,
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    duration: Duration(seconds: 3),
    action: SnackBarAction(
      label: 'OK',
      textColor: Colors.white,
      onPressed: () {},
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
class FormValidators {

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال الاسم الكامل';
    }
    if (value.trim().length < 4) {
      return 'يجب أن يكون الاسم أكثر من اربعة احرف';
    }
   
    return null;
  }

  // Validate Email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال البريد الإلكتروني';
    }
    
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'البريد الإلكتروني غير صحيح';
    }
    
    return null;
  }

  // Validate Phone Number
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال رقم الهاتف';
    }
    
    // Validate phone number (adjust regex for specific country/format if needed)
    final phoneRegExp = RegExp(r'^[0-9]{10}$');
    
    if (!phoneRegExp.hasMatch(value.trim())) {
      return 'رقم الهاتف يجب أن يكون 10 أرقام';
    }
    
    return null;
  }

  // Validate Password
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    }
    
    if (value.trim().length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    

   
    
    return null;
  }


  static String? validateConfirmPassword(String? value, String? originalPassword) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء تأكيد كلمة المرور';
    }
    
    if (value.trim() != originalPassword?.trim()) {
      return 'كلمة المرور غير متطابقة';
    }
    
    return null;
  }
}