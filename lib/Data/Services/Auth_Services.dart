import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
    
 String BasicApi = "https://nejda.onrender.com/api/";

Future<String> Register(String email, String password, String fullName, 
    String phoneNumber, File? imageFile) async {
  final uri = Uri.parse(BasicApi+"user/register");
  
  try {
    
    if (imageFile != null) {
      var request = http.MultipartRequest('POST', uri);
      
     
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['fullName'] = fullName;
      request.fields['phoneNumber'] = phoneNumber;
      
      
     
       
    if (await imageFile.exists()) {
  var file = await http.MultipartFile.fromPath('image', imageFile.path);
      request.files.add(file);
     
        print("Added image file:");
      print("  Field name: ${file.field}");
      print("  Filename: ${file.filename}");
      print("  Content type: ${file.contentType}");
      print("  Length: ${file.length} bytes");
 
} else {
    print("Warning: Image file doesn't exist at path: ${imageFile.path}");
   
  }
      
        print("\nCHECKING FOR MULTIPLE IMAGE FILES:");
    int imageFileCount = 0;
    for (var file in request.files) {
      if (file.field == 'image') {
        imageFileCount++;
        print("  Image file #$imageFileCount:");
        print("    Filename: ${file.filename}");
        print("    Content type: ${file.contentType}");
        print("    Length: ${file.length} bytes");
      }
    }
    print("Total files with field name 'image': $imageFileCount");
    
    // Print entire request details
    print("\nFULL REQUEST DETAILS:");
    print("URL: ${request.url}");
    print("Method: ${request.method}");
    print("Headers: ${request.headers}");
    print("Fields count: ${request.fields.length}");
    print("Files count: ${request.files.length}");
      
      
      var streamedResponse = await request.send();     
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.body.isEmpty) {
        return "Error: Empty response from server.";
      }
      
      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        getId(data["data"]?["addNewuser"]?["_id"] ?? "Unknown ID");
        getnameUser(data["data"]?["addNewuser"]?["fullName"] ?? "Unknown User");
        getPicture(data["data"]?["addNewuser"]?["image"] ?? "Unknown User");
        getEmail(data["data"]?["addNewuser"]?["email"] ?? "Unknown User");
        return data["status"]?.toString() ?? "Success";
      } else {
        return data["msg"]?.toString() ?? "Unknown error occurred";
      }
    } else {
     
      final response = await http.post(
        uri,
        body: {
          "email": email,
          "password": password,
          "fullName": fullName,
          "phoneNumber": phoneNumber
        }
      );
      
      if (response.body.isEmpty) {
        return "Error: Empty response from server.";
      }
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        getId(data["data"]?["addNewuser"]?["_id"] ?? "Unknown ID");
        getnameUser(data["data"]?["addNewuser"]?["fullName"] ?? "Unknown User");
        getPicture(data["data"]?["addNewuser"]?["image"] ?? "Unknown User");
        getEmail(data["data"]?["addNewuser"]?["email"] ?? "Unknown User");
        
        return data["status"]?.toString() ?? "Success";
      } else {
        return data["msg"]?.toString() ?? "Unknown error occurred";
      }
    }
  } catch (e) {
    print(e);
    return "Probleme de serveur,try again";
  }
}
  Future<String> login(String Email,String Password ) async{
     final uri = Uri.parse("https://nejda.onrender.com/api/user/login");
    try {
    final response = await http.post(
      uri,
      body: {
        "email": Email,
        "password": Password,
       
      }
    );
      
        final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {

      getId(data["data"]["id"]);
      getnameUser(data["data"]["fullName"]);
      getPicture(data["data"]["image"]);
      getEmail(data["data"]["email"]);

     return data["status"];
    } else {
    
     return data["error"];
    
    }
  } catch (e) {
  
    return "Problem de servere ";
    
  }

 }
  Future<void> logout() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('User_id');
      await prefs.remove('User_name');
      await prefs.remove('Image');
      await prefs.remove('Email');

  } 



 Future<void> getId(String id) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('User_id', id);
 }
 Future<void> getnameUser(String Name_User) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('User_name', Name_User);
 }
  Future<void> getPicture(String image) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('Image', image);
 }
 Future<void> getEmail(String email) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('Email', email);
 }



Future<String> sendImageWithEmail(File imageFile) async {
  final uri = Uri.parse("https://nejda.onrender.com/api/user/addImage");
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   String? email = await prefs.getString('Email');
  try {
    var request = await http.MultipartRequest('PATCH',uri);
print(email)  ;  
request.fields['email'] = email!; 
request.files.add(
  await http.MultipartFile.fromPath(
    'image',
    imageFile.path,
  ),
);
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
   
   


    if (response.statusCode == 200 || response.statusCode == 201) {
      
     final data = jsonDecode(respStr);
     final image = data["user"]["image"];
      getPicture(image);
       return "Files uploaded successfully!";
    } else {
      print("Upload failed: ${response.reasonPhrase}");
       return "Upload failed: ";
    }
  } catch (e) {
    print("Error: $e");
     return "Probleme de server try again";
  }
}





}