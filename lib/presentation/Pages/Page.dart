import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class page extends StatefulWidget {
  const page({super.key});

  @override
  State<page> createState() => _pageState();
}

class _pageState extends State<page> {
  Future<Uint8List> uploadimage() async{
 
 final uri = Uri.parse("https://nejda.onrender.com/uploads/1741446193154.jpg");

 final response = await http.get(uri,
 );

 if(response.statusCode == 200){

   return   response.bodyBytes;
 
 
 }
throw Exception('Failed to load image');


}
@override
  void initState() {
    // TODO: implement initState
    uploadimage();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder<Uint8List>(
  future: uploadimage(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text("Error loading image");
    } else {
      return Image.memory(snapshot.data!);
    }
  },
)
        ],
      ),
    );
  }
}