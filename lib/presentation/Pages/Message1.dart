import 'package:emergency/Core/Colors/Constante.dart';
import 'package:emergency/Data/Services/SendRaport.dart';
import 'package:emergency/Data/Services/TypeEmergency.dart';
import 'package:emergency/presentation/Pages/HomePage.dart';
import 'package:emergency/presentation/Pages/Message2.dart';
import 'package:emergency/presentation/Pages/Message4.dart';
import 'package:emergency/presentation/Pages/RaportPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Message1 extends StatefulWidget {
    Message1({super.key,required this.inTheSence,required this.injured});
    bool inTheSence;
    bool injured;
  @override
  State<Message1> createState() => _Message1State();
}

class _Message1State extends State<Message1> {
  Map<String, List<String>> list = {
    'الشرطة': ['اعتداء', 'اختطاف', 'جريمة قتل', 'تحت التهديد', 'حادث مرور', 'سرقة','التهديد الإلكتروني'],
    'إسعاف': ['انتحار', 'حالة مرضية', 'البحث عن مفقود', 'حريق', 'حادث مرور', 'فيضانات'],
    'الدرك': ['جريمة قتل', 'جرائم إلكترونية', 'اعتداء', 'اختطاف', 'حادث مرور', 'تهريب'],
  };

  int? selectedIndex;
  String? selectedCategory = ""; 
   Sendraport sendraport =Sendraport();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   selectedCategory = Provider.of<Typeemergency>(context,listen: false).TypeEmergency;
   print(selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    List<String> emergencyOptions = list[selectedCategory] ?? [];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              // Progress Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 5,
                      margin: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 5,
                      margin: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 5,
                      margin: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15),

              // Icon
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: mainColor, 
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset("Assets/Images/Vector (3).png", width: 22),
              ),

              SizedBox(height: 10),
              Text("رسالة نصية قصيرة", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),

              SizedBox(height: 30),
              Text("ما نوع الطارئ؟", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

              SizedBox(height: 30),

              // Instruction Text
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("اختر إجابات تناسب حالتك من بين الخيارات المتاحة",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      Text("يمكنك اختيار إجابات عدة ", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: 5,
                    height: 40,
                    color: mainColor, 
                  ),
                ],
              ),
             SizedBox(height: 30),
          
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3,
                  ),
                  itemCount: emergencyOptions.length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () async{
                        setState(() {
                          selectedIndex = index;
                        });

                        // Navigate to Message2 screen
                   /*     Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Message2(emergencyType: emergencyOptions[index]),
                          ),
                        );*/
                          showDialog(
  context: context,
  barrierDismissible: false, 
  builder: (context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
                       Text("الرجاء الانتظار..."), // نص توضيحي

          ],
        ),
      ),
    );
  },
);



String message = await sendraport.SentMessages(
  emergencyOptions[index],
  widget.injured,
  widget.inTheSence,
  Provider.of<Typeemergency>(context, listen: false).TypeEmergency,
);


Navigator.pop(context);

ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(message)),
);


Navigator.pushReplacement(
  context,
  message == "Message created successfully"
      ? MaterialPageRoute(builder: (_) => Message4())
      : MaterialPageRoute(builder: (_) => Homepage()),
);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? mainColor : Color(0xffF2F2F2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            emergencyOptions[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 18,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Homepage()));
                  },
                  child: Text("الغاء", style: TextStyle(color: Colors.white, fontSize: 24)),
                  color: mainColor, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.all(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}