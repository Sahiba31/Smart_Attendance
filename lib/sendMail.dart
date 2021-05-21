import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SendMail extends StatefulWidget {
  SendMail({Key key}) : super(key: key);

  @override
  _SendMailState createState() => _SendMailState();
}

class _SendMailState extends State<SendMail> {
  final _email = TextEditingController();
  final _course = TextEditingController();
  String studentMail = "";
  String studentCourse = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text("Send an Email"),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Mail",
                        style:
                            new TextStyle(color: Colors.black, fontSize: 25.0),
                      ),
                      Icon(
                        Icons.email,
                        size: 30,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _email,
                    decoration: new InputDecoration(
                      labelText: "Enter Email ID",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'This Field Cannot be Empty!';
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Invalid Email-ID!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _course,
                    decoration: InputDecoration(
                      labelText: "Course Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'This Field Cannot be Empty!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    style: TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: FlatButton(
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          studentMail = _email.text;
                          studentCourse = _course.text;
                          await sendEmail(studentMail, studentCourse);
                          Navigator.pushNamed(context, "/");
                        }
                      },
                      child: new Text(
                        "Send",
                        style: TextStyle(fontSize: 25.0, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendEmail(mail, course) async {
    var url = Uri.parse(
        "http://18.212.212.161/cgi-bin/smartAttendance/automail.py?x=$mail&y=$course");
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SpinKitDualRing(
              color: Colors.blue,
              size: 60,
            ));
    var response = await http.get(url);
    _showToast();
    print('Response body: ${response.body}');
  }

  void _showToast() {
    Fluttertoast.showToast(
      msg: 'Email Sent',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
