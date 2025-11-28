import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
   bool _messageReceived=false;


  bool get Messagement => _messageReceived;

void messagerecieved(bool message){
  _messageReceived = message;
  notifyListeners();
}

void messageaccepted(bool recieved){
  _messageReceived = recieved;
  notifyListeners();
}

}