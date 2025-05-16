import 'package:emergency/Core/Colors/Constante.dart';
import 'package:emergency/Data/Services/TypeEmergency.dart';
import 'package:emergency/presentation/Pages/OnbardingPage.dart';
import 'package:emergency/presentation/Pages/SplashPage.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( 

     ChangeNotifierProvider(
      create: (context) => Typeemergency(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nejda',
      theme: ThemeData(
        fontFamily: 'Cairo',
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        scaffoldBackgroundColor: Colors.white
      ),
      home: Splashpage(),
    );
  }
}

