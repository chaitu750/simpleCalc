import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorPage extends StatefulWidget {
  CalculatorPage({Key key, this.title}) : super(key: key);
  final String title;

  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String displayString = '';
  String answerString = '';

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    var calcItems = List<String>();
    calcItems = [
      'AC',
      '+/-',
      '%',
      '/',
      '7',
      '8',
      '9',
      'x',
      '4',
      '5',
      '6',
      '-',
      '1',
      '2',
      '3',
      '+',
      '0',
      '<-',
      '.',
      '=',
    ];
    var calcWidgets = List<Widget>();

    double calculator(String x, String y, String z) {
      double parser(String x) => double.parse(x);
      double calc(String x, String y, String z) => y == '+'
          ? parser(x) + parser(z)
          : y == '-'
              ? parser(x) - parser(z)
              : y == 'x'
                  ? parser(x) * parser(z)
                  : y == '/' ? parser(x) / parser(z) : parser(x) / parser(z);
      double a = calc(x, y, z);
      return a;
    }

    String stringifier(double a) {
      if (a == a.round()) {
        return a.round().toString().length > 11
            ? a.round().toStringAsExponential(5)
            : a.round().toString();
      } else {
        return a.toString().length > 11
            ? a.toStringAsExponential(5)
            : a.toString();
      }
    }

    void equalsTo(String s) {
      try {
        List strList = displayString.split(' ');
        if (strList.length > 2 && s == '=') {
          answerString =
              stringifier(calculator(strList[0], strList[1], strList[2]));
        } else if (strList.length > 2 && s == '%') {
          answerString =
              stringifier(calculator(strList[0], strList[1], strList[2]) / 100);
        } else if (strList.length == 1 && s == '%') {
          answerString = stringifier(calculator(strList[0], s, '100'));
        }
      } catch (e) {
        answerString = 'Error';
      }
    }

    void aggregator(String string) {
      setState(() {
        if (string == 'AC') {
          displayString = '';
          answerString = '';
        } else if (string == '<-') {
          if (displayString.length > 0) {
            int rem = displayString.endsWith(' ') ? 3 : 1;
            displayString =
                displayString.substring(0, displayString.length - rem);
          }
        } else if (string == '+/-') {
          displayString = displayString.startsWith('-')
              ? displayString.substring(1)
              : '-' + displayString;
        } else if (string == '=') {
          equalsTo('=');
        } else if (string == '%') {
          equalsTo('%');
        } else if (string == '.') {
          displayString += string;
        } else {
          try {
            double _ = double.parse(string);
            if (displayString.length < 19) {
              displayString += string;
            }
          } catch (e) {
            if (displayString.endsWith(' ')) {
              displayString = answerString == ''
                  ? displayString.substring(0, displayString.length - 2) +
                      '$string '
                  : answerString + ' $string ';
            } else if (displayString != '') {
              int strListLen = displayString.split(' ').length;
              displayString = answerString == '' && strListLen < 2
                  ? displayString + ' $string '
                  : answerString == '' && strListLen >= 2
                      ? displayString
                      : answerString + ' $string ';
            }
          }
        }
      });
    }

    for (int i = 0; i < calcItems.length; i++) {
      var string = calcItems[i];
      var backgroundColor = (i + 1) % 4 == 0
          ? const Color.fromARGB(255, 255, 149, 0)
          : i < 4
              ? Color.fromARGB(255, 212, 212, 210)
              : Color.fromARGB(255, 80, 80, 80);
      var textColor =
          (i + 1) % 4 == 0 ? Colors.white : i < 4 ? Colors.black : Colors.white;
      var fontSize =
          string == '<-' ? 20.0 : (i + 1) % 4 == 0 ? 35.0 : i < 4 ? 25.0 : 33.0;
      calcWidgets.add(
        RaisedButton(
          key: Key(string),
          hoverColor: Colors.black,
          shape: StadiumBorder(),
          onPressed: () {
            aggregator(string);
          },
          color: backgroundColor,
          textColor: textColor,
          child: Text(
            string != '<-' ? string : 'DEL',
            style: TextStyle(fontSize: fontSize),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  displayString,
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  answerString == '' ? '0' : answerString,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 45.0,
                  ),
                ),
              ),
            ],
          )),
          GridView.count(
            crossAxisCount: 4,
            children: calcWidgets.toList(),
            shrinkWrap: true,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
          ),
        ],
      )),
    );
  }
}
