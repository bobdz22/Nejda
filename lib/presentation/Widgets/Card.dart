import 'package:emergency/Core/Colors/Constante.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Cards extends StatefulWidget {
   Cards({super.key,required this.logo,required this.Text,required this.subtext ,required this.width});

    final String logo;
    final String Text;
    final String subtext;
    final double width;
  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
    BoxShadow(
      spreadRadius: 1,
      color: Colors.black.withOpacity(0.08),
      blurRadius: 4,
      offset: Offset(0, 2)
    )
  ]
      ),
      child: Row(
      
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset("Assets/Images/mingcute_right-fill.png"),
          SizedBox(width: 5,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(widget.Text,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              Text(widget.subtext,style: TextStyle(fontSize: 10,color: Colors.grey),),
            ],
                   ),
          ),
         SizedBox(width: 5,),
         Container(
          width: 80,
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(12)
          ),
          child: SvgPicture.asset(widget.logo,width: widget.width,),
         ),       
        ],
      ),
    );
  }
}