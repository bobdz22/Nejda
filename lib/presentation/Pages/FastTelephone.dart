import 'dart:async';
import 'dart:io';


import 'package:emergency/Core/Colors/Constante.dart';
import 'package:emergency/Data/Services/SendRaport.dart';
import 'package:emergency/Data/Services/TypeEmergency.dart';
import 'package:emergency/presentation/Pages/HomePage.dart';
import 'package:emergency/presentation/Pages/ImageTelephone.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
class Fasttelephone extends StatefulWidget {
  const Fasttelephone({super.key});

  @override
  State<Fasttelephone> createState() => _FasttelephoneState();
}

class _FasttelephoneState extends State<Fasttelephone> {
  final TextEditingController nameRecord = TextEditingController();
  final record = AudioRecorder();
  final audioPlayer = AudioPlayer();

  Timer? timer;
  int time = 0;
  int time2 = 0;
  bool isRecording = false;
  String? audioPath;
  bool isPlaying = false;
  List<FileSystemEntity> audioFiles = [];

  @override
  void initState() {
    requestPermission();
    loadRecordings();
    super.initState();
  }

  requestPermission() async {
    await record.hasPermission();
  }

  Future<void> loadRecordings() async {
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
      audioFiles = files.where((file) => file.path.endsWith('.m4a')).toList();
    });
  }

  void startTimer() {
    
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timers) {
      setState(() {
        time++;
      });
    });
  }
  Future<void> deleteAllRecordings() async {
  Directory? dir;
  if (Platform.isIOS) {
    dir = await getApplicationDocumentsDirectory();
  } else {
    dir = Directory('/storage/emulated/0/Download/');
    if (!await dir.exists()) {
      dir = (await getExternalStorageDirectory())!;
    }
  }

  // Get all audio files
  final files = await dir.list().toList();
  for (var file in files) {
    if (file.path.endsWith('.m4a')) {
      await file.delete();
    }
  }


  setState(() {
    audioFiles.clear();
    audioPath = null;
  });
}

  String formatTime(int seconds) {
    return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }


 Future<void> stopRecording() async {
  try {
    timer?.cancel();
    final path = await record.stop();

    setState(() {
      audioPath = path;
      isRecording = false;
      time2=time;
      time =0;  
    });

    if (audioPath?.isNotEmpty ?? false) {
      _showNameInputDialog(); 
    }
  } catch (e) {
    print('Error stopping recording: $e');
  }
}
void _showNameInputDialog() {
  TextEditingController nameController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) { 
      return WillPopScope(
        onWillPop: () async{
          await deleteAllRecordings();
            setState(() {
            audioPath = null;
            isRecording = false;
            isPlaying = false;
            time = 0;
          });
          timer?.cancel();
          return true;
        },
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "أضف عنوان للتسجيل",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "أدخل العنوان هنا",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () async{
                          await deleteAllRecordings();
                        setState(() {
                                audioPath = null;
                                isRecording = false;
                                isPlaying = false;
                                time = 0;
                              });
                              timer?.cancel();
                              audioPlayer.stop();
                        Navigator.of(dialogContext).pop(); 
                      },
                      child: Text(
                        "إلغاء",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () async {
                          String enteredName = nameController.text.trim();
                          if (enteredName.isNotEmpty) {
                            await saveRecordingWithName(enteredName);
                            Navigator.of(dialogContext).pop(); 
                            await loadRecordings(); 
        
                            // Show SnackBar using the original context
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('تم حفظ التسجيل باسم: $enteredName'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          "حفظ",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
Future<void> saveRecordingWithName(String name) async {
  if (audioPath == null) return;
  
  File file = File(audioPath!);
  String newPath = '${file.parent.path}/$name.m4a'; 
  
  await file.rename(newPath);
  audioPath = newPath;
}

  Future<void> playRecording() async {
    if (audioPath != null) {
      try {
        await audioPlayer.setFilePath(audioPath!);
        audioPlayer.play();
        
        setState(() {
          isPlaying = true;
        });
        
        audioPlayer.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            setState(() {
              isPlaying = false;
            });
          }
        });
      } catch (e) {
        print('Error playing recording: $e');
      }
    }
  }

  Future<void> stopPlaying() async {
    try {
      await audioPlayer.stop();
      
      setState(() {
        isPlaying = false;
      });
    } catch (e) {
      print('Error stopping playback: $e');
    }
  }
  bool isLoading = false;
   Future<void> sendReport(String audioPath, BuildContext context) async {
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
            Text("جاري إرسال التسجيل..."),
          ],
        ),
      ),
    );

   
   String response =    await sendraport.SentFastCall(
        File(audioPath),
        "vocal",
        Provider.of<Typeemergency>(context, listen: false).TypeEmergency,
      );

      await deleteAllRecordings();

    
      Navigator.pop(context);

      
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(response == "Files uploaded successfully!"
        ? 'تم الإرسال بنجاح!'
        : 'فشل في الإرسال، حاول مرة أخرى!')),
  );

  if (response == "Files uploaded successfully!") {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Homepage()));
  }
    
  }

  @override
  void dispose() {
    timer?.cancel();
    record.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Color get mainColor => const Color(0xffFF4848);
  Sendraport sendraport= Sendraport();
bool isPaused = false;


Future<void> startRecording() async {
  try {
    if (await record.hasPermission()) {
      Directory? dir;
      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      } else {
        dir = Directory('/storage/emulated/0/Download/');
        if (!await dir.exists()) {
          dir = (await getExternalStorageDirectory())!;
        }
      }
      
      String fileName = nameRecord.text.isEmpty ? 
          'recording_${DateTime.now().millisecondsSinceEpoch}' : 
          nameRecord.text;
          
      await record.start(
        RecordConfig(),
        path: '${dir.path}/$fileName.m4a',
      );
      
      startTimer();
      
      setState(() {
        isRecording = true;
        isPaused = false;
      });
    }
  } catch (e) {
    print('Error starting recording: $e');
  }
}
Timer? timer2;
Future<void> pauseRecording() async {
  try {
   
    timer?.cancel();
    await record.pause();
    
    setState(() {
      isPaused = true;
    });
  } catch (e) {
    print('Error pausing recording: $e');
  }
}

Future<void> resumeRecording() async {
  try {
    await record.resume();
    
    startTimer();
    
    setState(() {
      isPaused = false;
    });
  } catch (e) {
    print('Error resuming recording: $e');
  }
}


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
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Image.asset("Assets/Images/indare.png",width: 33,),
                  ),
                  SizedBox(height: 10),
                  Text("اتصال سريع", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Imagetelephone()));
                        },
                        child: Container(
                          width: 150,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child:  Center(child: Text(" إرفاق صورة و فيديو", style: TextStyle(fontSize: 15))),
                        ),
                      ),
                      Container(
                        width: 150,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: Center(child: Text("تسجيل الصوت", style: TextStyle(color: Colors.white, fontSize: 15))),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("جميع التسجيلات", style: TextStyle(fontSize: 18))
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 270,
                    child: audioFiles.isEmpty
                        ? Center(child: Text("لا توجد تسجيلات متاحة"))
                        : ListView.builder(
                            itemCount: audioFiles.length,
                            itemBuilder: (context, index) {
                              final file = audioFiles[index];
                              final fileName = file.path.split('/').last.replaceAll('.m4a', '');

                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        await file.delete();
                                        audioPath = null;
                                        loadRecordings();
                                      },
                                    ),
                                    SizedBox(width: 10),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            fileName,
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "حجم الملف: ${(file.statSync().size / 1024).toStringAsFixed(1)} كيلوبايت",
                                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        color: mainColor,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          audioPath == file.path && isPlaying ? Icons.pause : Icons.play_arrow,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        onPressed: () async {
                                          if (audioPath == file.path && isPlaying) {
                                            await stopPlaying();
                                          } else {
                                            setState(() {
                                              audioPath = file.path;
                                            });
                                            await playRecording();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  
                  if (isRecording || audioPath != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        isRecording ? formatTime(time) : (audioPath != null ? "مدة التسجيل: ${formatTime(time2)}" : ""),
                        style: TextStyle(
                          fontSize: 24, 
                          fontWeight: FontWeight.bold,
                          color: isRecording ? (isPaused ? Colors.orange : Colors.red) : Colors.black
                        ),
                      ),
                    ),

                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                 
                      GestureDetector(
                        onTap: () {
                          if (audioPath == null) {
                            if (isRecording) {
                              stopRecording();
                            } else {
                              startRecording();
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("يمكنك ارسال فقط تسجيل واحد")),
                            );
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: mainColor.withOpacity(0.1),
                          radius: isRecording ? 30 : 50,
                          child: CircleAvatar(
                            radius: isRecording ? 30 : 40,
                            backgroundColor: isRecording ? Colors.red : mainColor,
                            child: isRecording 
                                ? Icon(Icons.stop, color: Colors.white, size: 40)
                                : Image.asset(
                                    "Assets/Images/mingcute_mic-fill.png",
                                    width: 40,
                                  ),
                          ),
                        ),
                      ),
                      
                  
                      if (isRecording)
                        SizedBox(width: 20),
                        
                      if (isRecording)
                        GestureDetector(
                          onTap: () {
                            if (isPaused) {
                              resumeRecording();
                            } else {
                              pauseRecording();
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: mainColor.withOpacity(0.1),
                            radius: 30,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor:  Color(0xffDCDCDC),
                              child: Icon(
                                isPaused ? Icons.play_arrow : Icons.pause,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                ],
              ),

              Row(
                children: [
                  Container(
                    width: 100,
                    child: Center(
                      child: TextButton(
                        onPressed: () async {
                          await deleteAllRecordings();
                          setState(() {
                            audioPath = null;
                            isRecording = false;
                            isPlaying = false;
                            isPaused = false;
                            time = 0;
                          });
                          timer?.cancel();
                          audioPlayer.stop();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Homepage()));
                        },
                        child: Text("الغاء", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: MaterialButton(
                        onPressed: () async {
                          if (audioPath == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('الرجاء تسجيل أو اختيار تسجيل أولاً')),
                            );
                            return;
                          }

                          sendReport(audioPath!, context);
                        },
                        child: Text("ارسال", style: TextStyle(color: Colors.white, fontSize: 24)),
                        color: mainColor,
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
    ),
  );
}
}