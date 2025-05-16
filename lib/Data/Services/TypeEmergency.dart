import 'package:flutter/cupertino.dart';

class Typeemergency extends ChangeNotifier {
 String _TypeEmergency ='';
 String get TypeEmergency => _TypeEmergency;

 void setType(String type){
   _TypeEmergency=type;
   notifyListeners();

 }



}