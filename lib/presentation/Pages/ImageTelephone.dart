import 'package:emergency/Core/Colors/Constante.dart';
import 'package:emergency/Data/Services/SendRaport.dart';
import 'package:emergency/Data/Services/TypeEmergency.dart';
import 'package:emergency/presentation/Pages/FastTelephone.dart';
import 'package:emergency/presentation/Pages/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class Imagetelephone extends StatefulWidget {
  const Imagetelephone({super.key});

  @override
  State<Imagetelephone> createState() => _ImagetelephoneState();
}

class _ImagetelephoneState extends State<Imagetelephone> {
  final TextEditingController nameImage = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<FileSystemEntity> mediaFiles = [];
  File? currentMedia;
  bool isVideo = false;

  @override
  void initState() {
    loadMedia();
    super.initState();
  }
  Future<void> deleteAllMediaFiles() async {
  try {
    Directory? dir;
    if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
    } else {
      dir = Directory('/storage/emulated/0/Download/');
      if (!await dir.exists()) {
        dir = (await getExternalStorageDirectory())!;
      }
    }

    // List all files in directory
    final files = await dir.list().toList();

    // Filter and delete images & videos
    for (var file in files) {
      if (file.path.endsWith('.jpg') ||
          file.path.endsWith('.jpeg') ||
          file.path.endsWith('.png') ||
          file.path.endsWith('.mp4')) {
        await file.delete();
      }
    }

    // Clear media list in UI
    setState(() {
      mediaFiles.clear();
      currentMedia = null;
    });
  } catch (e) {
    print('Error deleting media files: $e');
  }
}

  Future<void> loadMedia() async {
    Directory? dir;
    if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
    } else {
      dir = Directory('/storage/emulated/0/Download/');
      if (!await dir.exists()) {
        dir = (await getExternalStorageDirectory())!;
      }
    }

    final files = await dir.list().toList();
    setState(() {
      mediaFiles = files.where((file) =>
        file.path.endsWith('.jpg') ||
        file.path.endsWith('.jpeg') ||
        file.path.endsWith('.png') ||
        file.path.endsWith('.mp4')).toList();
    });
  }

  Future<void> _pickMedia(ImageSource source, {required bool video}) async {
    try {
      Directory? dir;
      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      } else {
        dir = Directory('/storage/emulated/0/Download/');
        if (!await dir.exists()) {
          dir = (await getExternalStorageDirectory())!;
        }
      }

      String fileName = nameImage.text.isEmpty
          ? '${video ? "video" : "image"}_${DateTime.now().millisecondsSinceEpoch}'
          : nameImage.text;

      final XFile? media = video
          ? await _picker.pickVideo(source: source, maxDuration: Duration(seconds: 30))
          : await _picker.pickImage(source: source, imageQuality: 80);

      if (media != null) {
        final File mediaFile = File(media.path);
        final File savedMedia = await mediaFile.copy('${dir.path}/$fileName.${video ? "mp4" : "jpg"}');

        setState(() {
          currentMedia = savedMedia;
          isVideo = video;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(video ? 'تم حفظ الفيديو' : 'تم حفظ الصورة')),
        );

        await loadMedia();
      }
    } catch (e) {
      print('Error picking media: $e');
    }
  }

  void _showMediaPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('التقاط صورة جديدة'),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.camera, video: false);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('اختيار من المعرض'),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.gallery, video: false);
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('تسجيل فيديو'),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.camera, video: true);
                },
              ),
              ListTile(
                leading: Icon(Icons.video_library),
                title: Text('اختيار فيديو من المعرض'),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.gallery, video: true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Color get mainColor => const Color(0xffFF4848);
  Sendraport sendraport = Sendraport();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset("Assets/Images/indare.png",width: 33,),
                    ),
                    SizedBox(height: 10),
                    Text("اتصال سريع", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                   
                          
                          Container(
                            width: 150,
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              color: mainColor ,
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: Center(child: Text(" إرفاق صورة و فيديو", style: TextStyle(fontSize: 15,color: Colors.white))),
                          ),
                        
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Fasttelephone()));
                          },
                          child: Container(
                            width: 150,
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: Center(child: Text("تسجيل الصوت", style: TextStyle(color: Colors.black, fontSize: 15))),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                  
                    SizedBox(
                      height: 320,
                      child: mediaFiles.isEmpty
                          ? Center(child: Text("لا توجد ملفات متاحة"))
                          : ListView.builder(
                              itemCount: mediaFiles.length,
                              itemBuilder: (context, index) {
                                final file = mediaFiles[index];
                                final fileName = file.path.split('/').last.split('.').first;

                                return ListTile(
                                  leading: file.path.endsWith('.mp4')
                                      ? Icon(Icons.video_file, size: 50, color: Colors.blue)
                                      : ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.file(
                                            File(file.path),
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                  title: Text(fileName),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      await file.delete();
                                      loadMedia();
                                    },
                                  ),
                                  onTap: () {
                                    setState(() {
                                      currentMedia = File(file.path);
                                      isVideo = file.path.endsWith('.mp4');
                                    });
                                  },
                                );
                              },
                            ),
                    ),

                  
                  ],
                ),
                  
                  GestureDetector(
                      onTap: () {
                       _showMediaPickerOptions();
                      },
                      child: CircleAvatar(
                        backgroundColor: mainColor.withOpacity(0.1),
                        radius: 50,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor:  mainColor,
                          child:  
                              Icon(Icons.camera_alt, color: Colors.white, size: 40)
                              
                        ),
                      ),
                    ),
                Row(
                  children: [
                    Container(
                      width: 100,
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                                        mediaFiles.clear(); // مسح جميع الصور والفيديوهات
                                        currentMedia = null;
                            });
                           
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Homepage()));
                          },
                          child: Text("الغاء", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                       onPressed: currentMedia != null 
    ? () async {
     int videoCount = mediaFiles.where((file) => file.path.endsWith('.mp4')).length;
int imageCount = mediaFiles.where((file) =>
    file.path.endsWith('.jpg') ||
    file.path.endsWith('.jpeg') ||
    file.path.endsWith('.png')).length;

// Ensure max 5 images and max 1 video
if (imageCount <= 5 && videoCount <= 1) {
  showDialog(
    context: context,
    barrierDismissible: false, 
    builder: (context) {
      return AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text(videoCount == 1 ? 'جاري إرسال الفيديو...' : 'جاري إرسال الصور...'),
          ],
        ),
      );
    },
  );


  String response = await sendraport.SentmultipeMedia(
    mediaFiles,
    Provider.of<Typeemergency>(context, listen: false).TypeEmergency,
  );
  await deleteAllMediaFiles();

  Navigator.pop(context);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(response == "Files uploaded successfully!"
        ? 'تم الإرسال بنجاح!'
        : 'فشل في الإرسال، حاول مرة أخرى!')),
  );

  if (response == "Files uploaded successfully!") {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Homepage()));
  }
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("يمكنك إرسال 5 صور كحد أقصى وفيديو واحد فقط!")),
  );
}
       
      }
    : null,
                        child: Text("إرسال", style: TextStyle(color: Colors.white, fontSize: 24)),
                        color: currentMedia != null ? mainColor : Colors.grey,
                        shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}