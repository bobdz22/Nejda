

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Sendraport {
  String BasicApi = "https://nejda.onrender.com/api/";

 Future<String> SentFastCall(File file,String Type,String emergency) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String?  name = await prefs.getString('User_id') ;
  String? addres1 = await prefs.getString('User_address');
  final uri = Uri.parse("https://nejda.onrender.com/api/fastcall/$name");
  
  try {
    var request = http.MultipartRequest('POST', uri);
    
  
    request.files.add(
      await http.MultipartFile.fromPath(
        Type, 
        file.path,
      ),
    );
     request.fields['Needs'] = emergency; 
     request.fields['gps'] = addres1 ?? '';

    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("File uploaded successfully!");
       return "Files uploaded successfully!";
    } else {
      print("Upload failed: ${response.reasonPhrase}");
       return "Upload failed: ${response.reasonPhrase}";
    }
  } catch (e) {
    print("Error: $e");
     return "Error: $e";
  }
}
Future<String> SentmultipeMedia(List<FileSystemEntity> mediaFiles, String emergency) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? name = await prefs.getString('User_id');
  String? addres1 = await prefs.getString('User_address');
  final uri = Uri.parse("https://nejda.onrender.com/api/fastcall/$name");

  try {
    var request = http.MultipartRequest('POST', uri);

    for (var entity in mediaFiles) {
      if (entity is File) {
        String fileType = entity.path.endsWith('.mp4') ? 'video' : 'image';

        request.files.add(
          await http.MultipartFile.fromPath(fileType , entity.path),
        );
      }
    }

    request.fields['Needs'] = emergency;
    request.fields['gps'] = addres1 ?? '';

    var response = await request.send();
   

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Files uploaded successfully!");
      return "Files uploaded successfully!";
    } else {
      print("Upload failed: ${mediaFiles}");
       return "Upload failed: ${mediaFiles}";
    }
  } catch (e) {
    print("Error: $e");
     return "Error: $e";
  }
}
Future<String> SentMessages(String type , bool injured , bool inThesence,String Type) async{
 final SharedPreferences prefs = await SharedPreferences.getInstance();
  String?  name = await prefs.getString('User_id') ;
  String? addres1 = await prefs.getString('User_address');
 final uri = Uri.parse("https://nejda.onrender.com/api/msg/$name");

 final response = await http.post(uri,
 body: {
    "emergencyType" : type,
    "injured" : injured.toString(),
    "inTheSence" : inThesence.toString(),
    "Needs": Type,
    "gps" : addres1
 }
 );
  final data = jsonDecode(response.body);
 if(response.statusCode == 201){

 print(data["message"]);
 return data["message"];
 
 }
 print(data["message"]);
 return "message dosent created";

}
Future<String> SentRaport(String description,String Type) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String?  name = await prefs.getString('User_id') ;
  String? addres1 = await prefs.getString('User_address');
 final uri = Uri.parse("https://nejda.onrender.com/api/raport/$name");

 final response = await http.post(uri,
 body: {
     "description" : description,
     "Needs": Type,
     "gps" : addres1
 }
 );
  final data = jsonDecode(response.body);
 if(response.statusCode == 201){

 print(data["message"]);
 return data["message"];
 
 }
 print(data["message"]);
 return data["message"];

}









}