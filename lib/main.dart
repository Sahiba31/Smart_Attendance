import 'package:SmartAttendance/captureMultiple.dart';
import 'package:SmartAttendance/home.dart';
import 'package:SmartAttendance/imagePicker.dart';
import 'package:SmartAttendance/sendMail.dart';
import 'package:SmartAttendance/takeAttendance.dart';
import 'package:SmartAttendance/trainData.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.last;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => MyHome(),
        "/captureMultiple": (context) => TakeMultiplePictures(
              camera: firstCamera,
            ),
        "/trainData": (context) => TrainData(),
        "/recognize": (context) => Recognize(
              camera: firstCamera,
            ),
        "/sendMail": (context) => SendMail(),
        "/picker": (context) => MyImagePicker(),
      },
    ),
  );
}
