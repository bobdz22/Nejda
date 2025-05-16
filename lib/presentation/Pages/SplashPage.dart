import 'package:emergency/Core/Colors/Constante.dart';
import 'package:emergency/presentation/AuthPages/LoginPage.dart';
import 'package:emergency/presentation/Pages/HomePage.dart';
import 'package:emergency/presentation/Pages/OnbardingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashpage extends StatefulWidget {
  const Splashpage({super.key});

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> with SingleTickerProviderStateMixin {
 String? name;
 bool? isSee;
  Future<void> getidUser() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
    name = await prefs.getString('User_id') ?? '';
 }
 Future<void> firsttime() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
    isSee = await prefs.getBool('firstTime') ?? false;
 }
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
   Future.delayed(Duration(seconds: 2),()async{
   await getidUser();
   await firsttime();

     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => name == '' ? isSee == false ?  Onbardingpage() : Loginpage()  : Homepage()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                  Spacer(),
                 SvgPicture.asset("Assets/Images/logo.svg"),
                  Spacer(),
                  Text("Dev by K-linker agency",style: TextStyle(color: Colors.white),)
            
              ],
            ),
          ),
        ) 
      
      ),
    );
  }
}