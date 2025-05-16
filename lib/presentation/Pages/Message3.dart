import 'package:emergency/Core/Colors/Constante.dart';
import 'package:emergency/Data/Services/SendRaport.dart';
import 'package:emergency/Data/Services/TypeEmergency.dart';
import 'package:emergency/presentation/Pages/HomePage.dart';
import 'package:emergency/presentation/Pages/Message2.dart';
import 'package:emergency/presentation/Pages/Message4.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Message3 extends StatefulWidget {
      Message3({super.key});


  @override
  State<Message3> createState() => _Message3State();
}

class _Message3State extends State<Message3> {
   int? isSelected; 
   Sendraport sendraport =Sendraport();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Column(
              children: [
                 Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 5,
                      margin: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                  ),
                   Expanded(
                     child: Container(
                      height: 5,
                            margin: EdgeInsets.only(right: 5),            
                      decoration: BoxDecoration(
                          color: Color(0xffDCDCDC),
                        borderRadius: BorderRadius.circular(30)
                      ),
                                     ),
                   ),
                   Expanded(
                     child: Container(
                      height: 5,
                            margin: EdgeInsets.only(right: 5),            
                      decoration: BoxDecoration(
                        color: Color(0xffDCDCDC),
                        borderRadius: BorderRadius.circular(30)
                      ),
                                     ),
                   ),
                ],
              ),
              SizedBox(height: 15,),
              Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Image.asset("Assets/Images/Vector (3).png",width:25,),
                    ),
                    SizedBox(height: 10),
                    Text("رسالة نصية قصيرة", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),

                    SizedBox(height: 30),
                    Text("هل انت في مكان الحادث؟", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                     SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end ,
                      children: [
                        Column(
            crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("اختر إجابات تناسب حالتك من بين الخيارات المتاحة",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            Text("يمكنك اختيار إجابات عدة ",style: TextStyle(fontSize: 12,color: Colors.grey),),
          ],
                 ),
                 SizedBox(width: 10,),
                        Container(
                          width: 5,
                          height: 40,
                          color: mainColor,
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
GestureDetector(
                                      onTap: ()  async {
                                       

setState(() {
  isSelected = 0;
});

Get.off( Message2(inTheSence: true,),transition: Transition.rightToLeft
                          );
                                      },
                                       child: Container(
                                         padding: EdgeInsets.symmetric(horizontal: 70,vertical: 10),
                                         decoration: BoxDecoration(
                                           color:isSelected == 0 ? mainColor : Color(0xffF2F2F2),
                                           borderRadius: BorderRadius.circular(30),
                                         ),
                                         child: Center(
                                           child: Text(
                                            'نعم' ,
                                             style: TextStyle(color: isSelected == 0 ? Colors.white : Colors.black, fontSize: 18),
                                             textDirection: TextDirection.rtl, 
                                           ),
                                         ),
                                       ),
                                     ),
                                     GestureDetector(
                                      onTap: () async{
                                                                                

                                          setState(() {
                                            isSelected = 1;
                                          });
Get.off( Message2(inTheSence:false,),transition: Transition.rightToLeft
                          );
                                      },
                                       child: Container(
                                         padding: EdgeInsets.symmetric(horizontal: 70,vertical: 10),
                                         decoration: BoxDecoration(
                                           color:isSelected == 1 ? mainColor : Color(0xffF2F2F2),
                                           borderRadius: BorderRadius.circular(30),
                                         ),
                                         child: Center(
                                           child: Text(
                                            "لا" ,
                                             style: TextStyle(color: isSelected == 1 ? Colors.white : Colors.black, fontSize: 18),
                                             textDirection: TextDirection.rtl, 
                                           ),
                                         ),
                                       ),
                                     )
                   ],),
              ],
             ),
                     SizedBox(
                  width: double.infinity,
                  child: MaterialButton(onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Homepage()));},child: Text("الغاء",style: TextStyle(color: Colors.white,fontSize: 24),),color: mainColor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),padding: EdgeInsets.all(10),))
                ,

      

            ],
          ),
        ),
      ),
    );
  }
}