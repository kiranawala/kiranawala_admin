import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/main.dart';

class RequestDate extends StatefulWidget {
  final String displayMessage;
  RequestDate(this.displayMessage);
  @override
  _RequestDateState createState() => _RequestDateState();
}

class _RequestDateState extends State<RequestDate> {

  String selectedDate = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.white,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width:MediaQuery.of(context).size.width,
            padding:EdgeInsets.all(8.0),
            child:getTextWidget(widget.displayMessage, 30.0, Colors.black)
          ),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(8.0),
        child: FlatButton(
        color:Colors.grey,
          onPressed: () {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: DateTime(2019, 11, 01),
                maxTime: DateTime.now(),
                onChanged: (date) {
                  print('change $date');
                },
                onConfirm: (date) {
                  selectedDate = DateFormat('dd-MM-yyyy').format(date);
                  print(selectedDate);
                  setState(() {});
                },
                currentTime: DateTime.now(), locale: LocaleType.en);
          },
          child: Text(
            selectedDate.toUpperCase(),
            style: TextStyle(color: Colors.white,
                fontSize: 30.0,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8.0),
            child: FlatButton(
              color:Colors.blue,
              onPressed: () {
               Navigator.of(context).pop(selectedDate);
              },
              child: Text(
                'CONFIRM',
                style: TextStyle(color: Colors.white,
                    fontSize: 30.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
          ])
    );
  }
}
