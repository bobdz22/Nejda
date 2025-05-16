import 'package:emergency/Core/Colors/Constante.dart';
import 'package:emergency/presentation/AuthPages/LoginPage.dart';
import 'package:emergency/presentation/AuthPages/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onbardingpage extends StatefulWidget {
  const Onbardingpage({super.key});

  @override
  State<Onbardingpage> createState() => _OnbardingpageState();
}

class _OnbardingpageState extends State<Onbardingpage> {
  final PageController _pageController = PageController();
  bool isChanged =false;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      bottom: true,
      top: false,
      child: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                isChanged = index == 2;
              });
            },
            children: [
              // First screen
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            top: -70,
                            child: SvgPicture.asset("Assets/Images/Group 1.svg"),
                          ),
                          Positioned(
                            top: 120,
                            left: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.white))
                              ),
                              child: Text("Nejda app",style: TextStyle(color: Colors.white,fontSize: 24, ),))),
                          Padding(
                            padding: EdgeInsets.only(top: 300),
                            child: Column(
                              children: [
                                Image.asset(
                                  "Assets/Images/9411475 1.png",
                                  width: 200,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "المساعدة السريعة",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    "احصل على الدعم فورا في حالات الطوارئ الطبيةأو الامنية نحن هنا لمساعدتك على مدار الساعة",
                                    style: TextStyle(fontSize: 20, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
             
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            top: -5,
                            child: SvgPicture.asset("Assets/Images/Shape.svg"),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 300),
                            child: Column(
                              children: [
                                Image.asset(
                                  "Assets/Images/5461837_2811888 (1) 1.png",
                                  width: 300,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "تحديد موقعك بسهولة",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    "شارك موقعك بدقة مع فريق الانقاذ للحصول على مساعدة سريعة و فعالة",
                                    style: TextStyle(fontSize: 20, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Third screen
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            top: -152,
                            child: SvgPicture.asset("Assets/Images/Shape 3.svg"),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: SvgPicture.asset("Assets/Images/Sub shape 1.svg"),
                          ),
                           Positioned(
                            top: 110,
                            left: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.white))
                              ),
                              child: Text("Nejda app",style: TextStyle(color: Colors.white,fontSize: 24, ),))),
                          Padding(
                            padding: EdgeInsets.only(top: 400),
                            child: Column(
                              children: [
                                Image.asset(
                                  "Assets/Images/8251994_3873101.jpg",
                                  width: 220,
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "أمان عائلتك و أحبائك",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                                  child: Text(
                                    "أضف جهات اتصال طوارئ لتبقى مطمئنا على كل احبائك في كل الاوقات",
                                    style: TextStyle(fontSize: 15, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.90),
            child: isChanged 
                ? MaterialButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Loginpage()),
                      );
                    },
                    child: Text(
                      "ابدا الان",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                  ) 
                : SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: WormEffect(
                      spacing: 16,
                      dotColor: mainColor.withOpacity(0.3),
                      activeDotColor: mainColor,
                    ),
                  ),
          ),
        ],
      ),
    ),
  );
}}