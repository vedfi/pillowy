import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:pillowy/helpers/dateStringHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late DateTime _dateTime = DateHelper(7,0);
  late List<DateTime> dates = _calculateTimes();
  PageController _pageController = PageController();
  int currentPage = 0;

  void _pickDate(DateTime dateTime) {
    setState(() {
      _dateTime = DateHelper(dateTime.hour, dateTime.minute);
      setLastConfig();
      dates = _calculateTimes();
      _pageController.jumpToPage(0);
      currentPage = 0;
    });
  }

  Future<void> getLastConfig() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    int hour = sharedPreferences.getInt('hour') ?? 7;
    int minute = sharedPreferences.getInt('minute') ?? 0;
    if(hour != 7 || minute != 0){
      _pickDate(DateHelper(hour, minute));
    }
  }
  
  DateTime DateHelper(int hour, int minute){
    DateTime now = DateTime.now();
    if(hour < now.hour || (hour == now.hour && minute < now.minute)){
      return new DateTime(now.year, now.month, now.day, hour, minute).add(new Duration(days: 1));
    }
    return new DateTime(now.year, now.month, now.day, hour, minute);
  }

  Future<void> setLastConfig() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    if(_dateTime.hour != 7 || _dateTime.minute != 0){
      sharedPreferences.setInt("hour", _dateTime.hour);
      sharedPreferences.setInt("minute", _dateTime.minute);
    }
  }

  List<DateTime> _calculateTimes() {
    List<DateTime> times = <DateTime>[];
    for (int i = 8; i > 0; i--) {
      DateTime goal = _dateTime.subtract(new Duration(minutes: (90 * i) + 15));
      if(!goal.difference(DateTime.now()).isNegative){
        times.add(goal);
      }
    }
    if(times.isEmpty){
      times.add(DateTime.now());
    }
    return times;
  }

  @override
  void initState() {
    getLastConfig();
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!.round();
      });
    });
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
          'assets/images/night-less-stars.svg',
          fit: BoxFit.fill,
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
                      child: TimePickerSpinner(key: ValueKey(_dateTime.hour+_dateTime.minute),
                          time: _dateTime,
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
                        controller: _pageController,
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
                        itemCount: dates.length,
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: dates
                          .map((e) => Container(
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                width: dates.indexOf(e) == currentPage ? 11 : 8,
                                height: dates.indexOf(e) == currentPage ? 11 : 8,
                                decoration: BoxDecoration(
                                    boxShadow: (dates.indexOf(e) == currentPage)
                                        ? [
                                            BoxShadow(
                                              color: Color.fromRGBO(
                                                  255, 211, 77, 0.6),
                                              blurRadius: 4.0,
                                              spreadRadius: 1.0,
                                              offset: Offset(
                                                0.0,
                                                0.0,
                                              ),
                                            )
                                          ]
                                        : [],
                                    color: (dates.indexOf(e) == currentPage)
                                        ? Color.fromRGBO(255, 211, 77, 1)
                                        : Color.fromRGBO(255, 211, 77, 0.3),
                                    shape: BoxShape.circle),
                              ))
                          .toList(),
                    ),
                  ),
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
