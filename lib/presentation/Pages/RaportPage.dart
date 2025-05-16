import 'package:emergency/presentation/Pages/FastTelephone.dart';
import 'package:emergency/presentation/Pages/Message1.dart';
import 'package:emergency/presentation/Pages/Message3.dart';
import 'package:emergency/presentation/Pages/ReportText.dart';
import 'package:emergency/presentation/Widgets/Card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Raportpage extends StatelessWidget {
   Raportpage({super.key,required this.Title,required this.logo});
  final String Title;
  final String logo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(Title,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                ],
              ),
              SizedBox(height:10 ,),
              Image.asset(logo,width: 60,),
              SizedBox(height:30 ,),
              Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("اختر نوع الطوارئ التي تحتاج إلى الإبلاغ عنه",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                ],
              ),
              SizedBox(height: 35,),
             GestureDetector(
              onTap: () {
                  Get.to(Fasttelephone(),transition: Transition.zoom);
              },
              child: Cards(logo: "Assets/Images/svg1.svg", Text: "اتصال سريع", subtext: "إرسال صور أو تسجيل صوتي", width: 40,)),
              SizedBox(height: 15,),
             GestureDetector(
               onTap: () {
                 
                  Get.to(Message3(),transition: Transition.zoom);
              },
              child: Cards(logo: "Assets/Images/svg2.svg", Text: "رسالة نصية قصيرة", subtext: "أجب عن الأسئلة لتحديد حالة الطارئ بسرعة", width: 40,)),
               SizedBox(height: 15,),
             GestureDetector(
              onTap: () {
                   
                    Get.to( Reporttext(),transition: Transition.zoom);
              },
              child: Cards(logo: "Assets/Images/svg3.svg", Text: "ابلاغ", subtext: "وصف الطارئ بالتفصيل", width: 40,))
            ],
          ),
        ),
      ),
    );
  }
}