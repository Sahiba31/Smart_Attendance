import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TrainData extends StatefulWidget {
  @override
  _TrainDataState createState() => _TrainDataState();
}

class _TrainDataState extends State<TrainData> {
  final _regn = TextEditingController();
  final _name = TextEditingController();
  String studentName = "";
  String studentReg = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void _deleteExtras() async {
      var url = Uri.parse(
          "http://18.212.212.161/cgi-bin/smartAttendance/deleteExtras.py");
      var response = await http.get(url);
      print('Response body: ${response.body}');
    }

    return WillPopScope(
      onWillPop: () async {
        _deleteExtras();
        Navigator.pushNamed(context, '/');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text("Train Data"),
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
                  new Text(
                    'Fill Details',
                    style: new TextStyle(color: Colors.black, fontSize: 25.0),
                  ),
                  new Padding(padding: EdgeInsets.only(top: 30.0)),
                  new TextFormField(
                    controller: _name,
                    decoration: new InputDecoration(
                      labelText: "Enter Name",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'This Field Cannot be Empty!';
                      } else if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                          .hasMatch(value)) {
                        return 'Invalid Characters!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  new TextFormField(
                    controller: _regn,
                    decoration: new InputDecoration(
                      labelText: "Enter Registration No.",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'This Field Cannot be Empty!';
                      } else if (RegExp(
                              r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s-a-zA-Z]')
                          .hasMatch(value)) {
                        return 'Invalid Characters!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    style: new TextStyle(
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
                          studentName = _name.text;
                          studentReg = _regn.text;
                          await trainData(studentName, studentReg);
                          Navigator.pushNamed(context, "/");
                        }
                      },
                      child: new Text(
                        "Submit",
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

  Future<void> trainData(name, reg) async {
    var url = Uri.parse(
        "http://18.212.212.161/cgi-bin/smartAttendance/trainData.py?x=$name&y=$reg");
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
      msg: 'Data Trained',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
