import 'package:emergency/Core/Colors/Constante.dart';
import 'package:emergency/presentation/Pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class Verifynumberpage extends StatefulWidget {
  const Verifynumberpage({super.key});

  @override
  State<Verifynumberpage> createState() => _VerifynumberpageState();
}

class _VerifynumberpageState extends State<Verifynumberpage> {
  final defaultpintheme = PinTheme(
       height: 60,
       width: 56,
       textStyle: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold
       ),
       decoration: BoxDecoration(
        color: Colors.grey.shade100,
  
        borderRadius: BorderRadius.circular(12)
       )
  );
   final focuspintheme = PinTheme(
       height: 60,
       width: 56,
       textStyle: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold
       ),
       decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12)
       )
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 10),
            child: Column(
              children: [
                  Image.asset("Assets/Images/8251994_3873101.jpg",width: 300,),
                        const Text(
                            "تأكيد رقم هاتفك",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0, ),
                            child: Text(
                             "سنرسل لك رمز تحقق غير رسالة نصية للتاكيد رقم هاتفك",
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Pinput(
                            length: 4,
                            defaultPinTheme:defaultpintheme,
                            focusedPinTheme: focuspintheme ,
                            onCompleted: (value) => print(value),
                          ),
                          SizedBox(height: 20,),
                          SizedBox(
                  width: double.infinity,
                  child: MaterialButton(onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Homepage()));},child: Text("تأكيد",style: TextStyle(color: Colors.white,fontSize: 24),),color: mainColor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),padding: EdgeInsets.all(10),))
                ,
                     SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Text("مرة أخرى",style: TextStyle(color: mainColor,)),
                    Text("اذا لم تصلك الرسالة يمكنك المحاولة")
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}