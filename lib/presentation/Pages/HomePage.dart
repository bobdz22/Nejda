import 'dart:io';
import 'dart:typed_data';

import 'package:emergency/Core/Colors/Constante.dart';
import 'package:emergency/Data/Services/Auth_Services.dart';
import 'package:emergency/Data/Services/SendRaport.dart';
import 'package:emergency/Data/Services/TypeEmergency.dart';
import 'package:emergency/presentation/AuthPages/LoginPage.dart';
import 'package:emergency/presentation/Pages/BuyPage.dart';
import 'package:emergency/presentation/Pages/RaportPage.dart';
import 'package:emergency/presentation/Widgets/Card.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:open_location_code/open_location_code.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? name;
  String plusCode = "جاري تحديد الموقع...";
  String addres1 ='';
  AuthServices authServices = AuthServices();
    Uint8List?  imageBytes;
    bool isLoading = false;
  void initState() {
  super.initState();
  getnameUser();
  firsttime();
  getSavedLocation(); // Load saved location
  _getLocation();
  fetchImage();
}
 File? _profileImage;
 
   Future<void> _getImage(ImageSource source) async {
  try {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
    );
    
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
       final SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
      isLoading = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from closing
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("جاري تعديل صورة..."),
          ],
        ),
      ),
    );
 
  String resulta =  await  authServices.sendImageWithEmail(_profileImage!);
  Navigator.pop(context);     
  setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: resulta == "Files uploaded successfully!" ? Text('تم تغيير صورة بنجاح') : Text('يعتذر تغيير الصورة') ),
                            );
    }
  } catch (e) {

   
  }
}
Widget _buildOptionButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: mainColor, size: 30),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}
Future<void> fetchImage() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String image;

   
    image = await prefs.getString('Image') ?? "";
   
    
      final bytes = await fetchImageBytes(image);
      setState(() {
        imageBytes = bytes;
      });
    } catch (e) {
      print('Error fetching image: $e');
    }
  }
Future<Uint8List> fetchImageBytes(String imageName) async {
  if (imageName.isEmpty) {
    throw Exception('Image name is empty');
  }

  final response = await http.get(Uri.parse("https://nejda.onrender.com/uploads/$imageName"));

  if (response.statusCode == 200) {

      imageBytes= await response.bodyBytes;
      setState(() {});
    print(response.bodyBytes);
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load image: $imageName');
  }
}
Future<void> getSavedLocation() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    plusCode = prefs.getString('User_location') ?? "جاري تحديد الموقع...";
    addres1 = prefs.getString('User_address') ?? "جاري تحديد العنوان...";
  });

  print("📍 Loaded Plus Code: $plusCode");
  print("🏠 Loaded Address: $name");
  print(prefs.getString('Email'));
}

  Future<void> getnameUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('User_name') ?? '';
    });
    print(prefs.getString('User_id'));
  }

  Future<void> firsttime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("firstTime", true);
  }

Future<void> _getLocation() async {
  try {
    Position? position = await _determinePosition();

    if (position != null) {
       
       final code = PlusCode.encode(
      LatLng( position.latitude, position.longitude),
  );


      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude
      );

      String address = "تعذر الحصول على العنوان"; // Default message
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        address = "${place.street} ${place.locality} , ${place.country}"; 
      }

      
      setState(() {
        this.plusCode = plusCode;
        addres1 = address;
      });

     
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('User_location', plusCode);
      await prefs.setString('User_address', addres1);

   
      print(name);
    } else {
      setState(() {
        plusCode = "تعذر الحصول على الموقع";
      });
    }
  } catch (e) {
 
    setState(() {
      plusCode = "خطأ في تحديد الموقع";
    });
  }
}

  Future<Position?> _determinePosition() async {
    try {
      
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled){
        await Geolocator.openLocationSettings();
        await  _determinePosition();
      } 

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("Error in _determinePosition: $e");
      return null;
    }
  }
 Future<void> _launchURL() async {
    final Uri url = Uri.parse("https://docs.google.com/forms/u/0/d/e/1FAIpQLScwwnpIbLLLdHfcEeQYOCGo3vYi9EZHkUO7ZYj-Gz5gxkPgcQ/formResponse?pli=1");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = Provider.of<Typeemergency>(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("Assets/Images/notification.png", width: 30),
                  GestureDetector(
                    onLongPress: () async {
                      final RenderBox overlay =
                          Overlay.of(context).context.findRenderObject() as RenderBox;

                      await showMenu(
                        color: Colors.white,
                        context: context,
                        position: RelativeRect.fromLTRB(
                          overlay.size.width - 150,
                          kToolbarHeight + 10,
                          overlay.size.width,
                          overlay.size.height,
                        ),
                        items: [
                          PopupMenuItem(
                            child: Text("تسجيل الخروج"),
                            value: "logout",
                          ),
                          PopupMenuItem(
                            child: Text("غير صورتك الشخصية"),
                            value: "settings",
                          ),
                        ],
                      ).then((value) {
                        if (value == "logout") {
                          authServices.logout();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => Loginpage()),
                          );
                        }
                        if (value == "settings") {
                          showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Profile Photo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionButton(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(ImageSource.camera);
                    },
                  ),
                  _buildOptionButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
                        }
                      });
                    },
                    child: CircleAvatar(
  backgroundImage: _profileImage == null 
    ? (imageBytes != null 
      ? MemoryImage(imageBytes!) 
      : null) 
    : FileImage(File(_profileImage!.path)),
  radius: 25,
),
                  )
                ],
              ),
             
        
              SizedBox(height: 15),
             Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    Expanded( 
      child: Text(
        "! مرحبًا ${name ?? ''}",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis, 
        maxLines: 1, 
        textAlign: TextAlign.end,
      ),
    ),
  ],
),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("اختر نوع الطوارئ الذي تود الابلاغ عنه", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                ],
              ),
          
              GestureDetector(
                onTap: () {
                  type.setType("الشرطة");
                  Get.to( Raportpage(Title: "( توجيه بلاغ للشرطة الجزائرية-( 1548", logo: "Assets/Images/75af91bb4cc6fedbd3eb4f254336089c.png"),transition: Transition.zoom);
                },
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height/5.5,
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xff7C92FF),Color(0xFF8A6F87)],begin: Alignment.topCenter,end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Image.asset("Assets/Images/Vector.png"),
                      Positioned(
                        right: 0,
                        child: Image.asset("Assets/Images/Vector (1).png")),
                      Positioned(
                        top: 20,
                        right: 10,
                        child: Image.asset("Assets/Images/4c9685f63d418c2f38f61949c3bd019a.png",width: 100)),
                      Positioned(
                        top: 20,
                        right: MediaQuery.of(context).size.width/2-40,
                        child: Center(child: Image.asset("Assets/Images/75af91bb4cc6fedbd3eb4f254336089c.png",width: 45))),
                      Positioned(
                        bottom:MediaQuery.of(context).size.width/12,
                        right: MediaQuery.of(context).size.width/2-55,
                        child: Center(child: Text("الشرطة",style: TextStyle(color: Colors.white,fontSize: 25)))),
                      Positioned(
                        bottom: MediaQuery.of(context).size.width/20,
                        right: MediaQuery.of(context).size.width/2-40,
                        child: Center(child: Text("الجزائرية",style: TextStyle(color: Colors.white)))),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Row(children: [
                          Image.asset("Assets/Images/Vector (2).png",width: 20),
                          SizedBox(width: 5),
                          Text("1548",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
                        ]),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  type.setType("إسعاف");
                  Get.to(Raportpage(Title: "( توجيه بلاغ للحماية المدنية الجزائرية-( 1021", logo: "Assets/Images/images (2) 1.png"),transition: Transition.zoom);
                },
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height/5.5,
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xffFF7C7C),Color(0xff994A4A)],begin: Alignment.topCenter,end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Image.asset("Assets/Images/Vector.png",color: Color(0xffFFFFFF)),
                      Positioned(
                        right: 0,
                        child: Image.asset("Assets/Images/Vector (1).png",color: Color(0xffFFFFFF))),
                      Positioned(
                        bottom: 0,
                        right: 10,
                        child: Transform.scale(
                          scaleX: -1,
                          child: Image.asset("Assets/Images/1e793c08ea6d6eb0a1a9284c875d3fa8.png",width: 100))),
                      Positioned(
                        top: 20,
                        right: MediaQuery.of(context).size.width/2-40,
                        child: Center(child: Image.asset("Assets/Images/images (2) 1.png",width: 60))),
                      Positioned(
                        bottom:MediaQuery.of(context).size.width/11,
                        right: MediaQuery.of(context).size.width/2-85,
                        child: Center(child: Text("الحماية المدنية",style: TextStyle(color: Colors.white,fontSize: 25)))),
                      Positioned(
                        bottom: MediaQuery.of(context).size.width/18,
                        right: MediaQuery.of(context).size.width/2-35,
                        child: Center(child: Text("الجزائرية",style: TextStyle(color: Colors.white)))),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Row(children: [
                          Image.asset("Assets/Images/Vector (2).png",width: 20),
                          SizedBox(width: 5),
                          Text("1021",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
                        ]),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  type.setType("الدرك");
                  Get.to( Raportpage(Title: "( توجيه بلاغ للدرك الجزائرية-( 1055", logo: "Assets/Images/images 1.png"),transition: Transition.zoom);
                },
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height/5.5,
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xff899E8A), Color(0xff313831)],begin: Alignment.topCenter,end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Image.asset("Assets/Images/Vector.png",color: Color(0xffFFFFFF)),
                      Positioned(
                        right: 0,
                        child: Image.asset("Assets/Images/Vector (1).png",color: Color(0xffFFFFFF))),
                      Positioned(
                        top: 20,
                        right: -130,
                        child: Image.asset("Assets/Images/d2f2ce9b1b16702b80330dd9394269b1.png",width: 250)),
                      Positioned(
                        top: 20,
                        right: MediaQuery.of(context).size.width/2-40,
                        child: Center(child: Image.asset("Assets/Images/images 1.png",width: 58))),
                      Positioned(
                        bottom: MediaQuery.of(context).size.width/11,
                        right: MediaQuery.of(context).size.width/2-40,
                        child: Center(child: Text("الدرك",style: TextStyle(color: Colors.white,fontSize: 25)))),
                      Positioned(
                        bottom: MediaQuery.of(context).size.width/18,
                        right: MediaQuery.of(context).size.width/2-38,
                        child: Center(child: Text("الجزائرية",style: TextStyle(color: Colors.white)))),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Row(children: [
                          Image.asset("Assets/Images/Vector (2).png",width: 20),
                          SizedBox(width: 5),
                          Text("1055",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
                        ]),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.02),
              GestureDetector(
                onTap: () {
                  Get.to(Buypage(),transition: Transition.rightToLeft);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [mainColor, mainColor.withOpacity(0.2)]),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Center(child: Text("املأ استمارة", style: TextStyle(color: Colors.white, fontSize: 18))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

