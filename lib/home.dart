import 'package:flutter/material.dart';
import 'dart:io';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  Widget noInternetPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text(
        'No Internet Connection!!!',
        style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Please check your Internet Connection. If the problem still exists, contact us at smartattendance@gmail.com",
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text(
            'Close',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        title: Text("Smart Attendance"),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 210,
                height: 100,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  onPressed: () async {
                    try {
                      final result = await InternetAddress.lookup('google.com');
                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        Navigator.pushNamed(context, "/captureMultiple");
                      }
                    } on SocketException catch (_) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            noInternetPopupDialog(context),
                      );
                    }
                  },
                  textColor: Colors.white,
                  color: Colors.blueAccent,
                  /*child: new Text(
                    "Train Data",
                    style: TextStyle(fontSize: 25.0),
                  ),*/
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(4, 0, 10, 0),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                        Container(
                            color: Colors.blueAccent,
                            padding: EdgeInsets.fromLTRB(10, 4, 4, 4),
                            child: Text(
                              'Train Data',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: 210,
                height: 100,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  onPressed: () async {
                    try {
                      final result = await InternetAddress.lookup('google.com');
                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              cameraOption(context),
                        );
                      }
                    } on SocketException catch (_) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            noInternetPopupDialog(context),
                      );
                    }
                  },
                  textColor: Colors.white,
                  color: Colors.blueAccent,
                  /*child: new Text(
                    "Take Attendance",
                    style: TextStyle(fontSize: 25.0),
                  ),*/
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(4, 0, 10, 0),
                          child: Icon(
                            Icons.description,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                        Container(
                          color: Colors.blueAccent,
                          padding: EdgeInsets.fromLTRB(10, 4, 4, 4),
                          child: Text(
                            'Take Attendance',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cameraOption(BuildContext context) {
    return new AlertDialog(
      title: const Text(
        'Choose...',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      content: new Container(
        width: 300,
        height: 140,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width: 300,
              height: 50,
              child: RaisedButton(
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                child: Text(
                  "Take a Photo",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => {
                  Navigator.pushNamed(context, "/recognize"),
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 300,
              height: 50,
              child: RaisedButton(
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                child: Text(
                  "Choose From Gallery",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => {
                  Navigator.pushNamed(context, "/picker"),
                },
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Colors.blueAccent,
          child: const Text(
            'Cancel',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
