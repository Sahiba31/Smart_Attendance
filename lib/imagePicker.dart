import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import 'dart:convert';
import 'package:async/async.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyImagePicker extends StatefulWidget {
  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  File _image;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    getImage();
  }

  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 25);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(
              // Pass the automatically generated path to
              // the DisplayPictureScreen widget.
              imagePath: _image,
            ),
          ),
        );
      } else {
        Navigator.pushNamed(context, "/");
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final File imagePath;
  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _markAttendance() async {
      var url = Uri.parse(
          "http://18.212.212.161/cgi-bin/smartAttendance/markAttend.py");

      var response = await http.get(url);
      print('Response body: ${response.body}');
    }

    _upload(imageFile) async {
      var uri = Uri.parse('http://18.212.212.161:3000/upload');

      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: Path.basename(imageFile.path));
      //contentType: new MediaType('image', 'png'));

      request.files.add(multipartFile);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SpinKitDualRing(
                color: Colors.blue,
                size: 60,
              ));
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
      await _markAttendance();
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/picker');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Preview'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .75,
                width: MediaQuery.of(context).size.width,
                child: Image.file(imagePath),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 50,
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () => Navigator.pushNamed(context, "/picker"),
                    iconSize: 80,
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () async {
                      await _upload(imagePath);

                      Navigator.pushNamed(context, "/sendMail");
                    },
                    iconSize: 80,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
