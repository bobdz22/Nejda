import 'package:emergency/Core/Colors/Constante.dart';
import 'package:emergency/Data/Services/Auth_Services.dart';
import 'package:emergency/Data/Services/SendRaport.dart';
import 'package:emergency/Data/Services/TypeEmergency.dart';
import 'package:emergency/presentation/Pages/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Reporttext extends StatefulWidget {
  const Reporttext({super.key});

  @override
  State<Reporttext> createState() => _ReporttextState();
}

class _ReporttextState extends State<Reporttext> {
  final TextEditingController reportController = TextEditingController();
  Sendraport sendraport = Sendraport();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Column(
              children: [
                  Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: Image.asset("Assets/Images/material-symbols_report-rounded.png",width:25,),
                        ),
                        SizedBox(height: 10),
                        Text("ابلاغ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
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
                        SizedBox(height: 15,),
                         Container(
  width: double.infinity,
  height: 300, 
  decoration: BoxDecoration(
    border: Border.all(color: Color(0xff75757580)),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [

          Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12), 
          child: TextField(
            controller: reportController,
            maxLength: 400,
            expands: true, 
            maxLines: null, 
            minLines: null, 
            textAlignVertical: TextAlignVertical.top, 
            decoration: InputDecoration(
              counterText: "", 
              border: InputBorder.none,
            ),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(right: 12, bottom: 8), // Aligns counter correctly
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "${reportController.text.length}/400",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ),
      ),
    ],
  ),
),

              ],
            ),
              Row(
                  children: [
                    Container(
                      width: 100,
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                           
                            });
                         
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Homepage()));
                          },
                          child: Text("الغاء", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: MaterialButton(
                          onPressed:  () async{
                           if (reportController.text.isNotEmpty) {
  // عرض مربع حوار التحميل
  showDialog(
    context: context,
    barrierDismissible: false, // منع إغلاق الحوار أثناء التحميل
    builder: (context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(), // مؤشر تحميل
              SizedBox(width: 20),
              Text("جاري إرسال التقرير..."), // نص توضيحي
            ],
          ),
        ),
      );
    },
  );

  // تنفيذ العملية غير المتزامنة
  String message = await sendraport.SentRaport(
    reportController.text,
    Provider.of<Typeemergency>(context, listen: false).TypeEmergency,
  );

  // إغلاق مربع التحميل بعد انتهاء العملية
  Navigator.pop(context);

  // عرض رسالة تأكيد
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );

  // التنقل إلى الصفحة الرئيسية
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => Homepage()),
  );
} else {
  // عرض رسالة خطأ في حال كان الحقل فارغًا
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("من فضلك املأ الفراغ")),
  );
}
                             
                          } ,
                          child: Text("ارسال", style: TextStyle(color: Colors.white, fontSize: 24)),
                          color: mainColor ,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                          padding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  ],
                )
            
          
            ],
          ),
        ),
      ),
    );
  }
}