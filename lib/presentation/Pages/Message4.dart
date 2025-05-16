import 'package:emergency/Core/Colors/Constante.dart';
import 'package:emergency/presentation/Pages/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Message4 extends StatelessWidget {
  const Message4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
             Spacer(),   
             Column(
              children: [
                  CircleAvatar(
                radius: 80,
                backgroundColor: mainColor.withOpacity(0.1),
                child: CircleAvatar(
                   radius: 70,
                    backgroundColor: mainColor.withOpacity(0.2),
                  child: CircleAvatar(
                     radius: 60,
                     backgroundColor: mainColor,
                     child: Icon(Icons.check,color: Colors.white,size: 40,),
                  ),
                ),
               ),
            Text(
              "تم استلام بلاغك بنجاح. سنصل إليك في أقرب وقت ممكن.\nنرجو منك التزام الهدوء وعدم الذعر.",
              textAlign: TextAlign.center, 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textDirection: TextDirection.rtl, 
            )
              ],
             ),
              Spacer(),   
              SizedBox(
                    width: double.infinity,
                    child: MaterialButton(onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Homepage()));},child: Text("عودة",style: TextStyle(color: Colors.white,fontSize: 24),),color: mainColor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),padding: EdgeInsets.all(10),))
                  ,
        
            
            ],),
          ),
        ),
      ),
    );
  }
}