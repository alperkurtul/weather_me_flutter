import 'package:flutter/material.dart';

class WeatherOnTime extends StatelessWidget {
  final String time;
  final int degree;
  final String icon;
  final bool selected;

  WeatherOnTime(
      {this.time, this.degree, this.icon = '🌤', this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 5.0, left: 5.0),
      child: Container(
        decoration: BoxDecoration(
            color:
                selected ? Theme.of(context).primaryColor : Color(0x606B84F2),
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(
              color: Color(0xFFCCCCCC),
            )),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(time,
                  style: TextStyle(
                      color: selected
                          ? Color(0xFF565EEA)
                          : Theme.of(context).primaryColor)),
              CircleAvatar(
                backgroundColor: Color(0xFF829BF4).withOpacity(1),
                radius: 30.0,
                child: Text(icon, style: TextStyle(fontSize: 45.0)),
              ),
              Text('$degree°',
                  style: TextStyle(
                      color: selected
                          ? Color(0xFF565EEA)
                          : Theme.of(context).primaryColor)),
            ],
          ),
        ),
      ),
    );
  }
}
