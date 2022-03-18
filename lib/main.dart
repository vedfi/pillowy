import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:pillowy/helpers/dateStringHelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pillowy',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _dateTime = DateTime.now();
  DateTime _defaultTime = new DateTime(DateTime.now().year,
      DateTime.now().month, DateTime.now().day, 7, 0, 0, 0, 0);
  late List<DateTime> dates = _calculateTimes();

  void _pickDate(DateTime dateTime) {
    setState(() {
      _dateTime = dateTime;
      dates = _calculateTimes();
    });
  }

  List<DateTime> _calculateTimes() {
    List<DateTime> times = <DateTime>[];
    for (int i = 6; i > 0; i--) {
      times.add(_dateTime.subtract(new Duration(minutes: (90 * (i + 1)) + 15)));
      //log('Adding time: ${times[(6 - i)]}');
    }
    return times;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Stack(
      children: [
        Container(color: Color.fromRGBO(10, 0, 46, 1)),
        SvgPicture.asset(
          'assets/images/night.svg',
          fit: BoxFit.cover,
          allowDrawingOutsideViewBox: true,
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                // Column is also a layout widget. It takes a list of children and
                // arranges them vertically. By default, it sizes itself to fit its
                // children horizontally, and tries to be as tall as its parent.
                //
                // Invoke "debug painting" (press "p" in the console, choose the
                // "Toggle Debug Paint" action from the Flutter Inspector in Android
                // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                // to see the wireframe for each widget.
                //
                // Column has various properties to control how it sizes itself and
                // how it positions its children. Here we use mainAxisAlignment to
                // center the children vertically; the main axis here is the vertical
                // axis because Columns are vertical (the cross axis would be
                // horizontal).
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(flex: 4),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Choose the time you want to wake up.',
                          style:
                              TextStyle(color: Color.fromRGBO(255, 211, 77, 1)))
                    ],
                  ),
                  Expanded(
                      flex: 8,
                      child: TimePickerSpinner(
                          time: _defaultTime,
                          is24HourMode: true,
                          isForce2Digits: true,
                          itemHeight: 75,
                          minutesInterval: 5,
                          spacing: 36,
                          normalTextStyle: TextStyle(
                              fontSize: 36,
                              color: Color.fromRGBO(255, 211, 77, 0.2)),
                          highlightedTextStyle: TextStyle(
                              fontSize: 36,
                              color: Color.fromRGBO(255, 211, 77, 1)),
                          onTimeChange: (dateTime) => _pickDate(dateTime))),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.nights_stay_outlined,
                          color: Color.fromRGBO(255, 211, 77, 1),
                          size: 28,
                        ),
                        Text('Suggested times to go to bed.',
                            style: TextStyle(
                                color: Color.fromRGBO(255, 211, 77, 1))),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: PageView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 211, 77, 0.1),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${DateStringHelper.HourMinute2Digits(dates[index])}',
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 211, 77, 1),
                                  fontSize: 24),
                            ),
                          );
                        },
                        itemCount: 6,
                      )),
                  Spacer(
                    flex: 2,
                  )
                ],
              ),
            ))
      ],
    );
  }
}
