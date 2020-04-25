import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import '../main.dart';
import 'nila-point-of-sale.dart';

class SendBillToWhatsapp extends StatefulWidget {
  @override
  _SendBillToWhatsappState createState() => _SendBillToWhatsappState();
}

class _SendBillToWhatsappState extends State<SendBillToWhatsapp> {
  String hintMessage = 'Mobile Number';

  bool isNumeric(String str) {
    if(str == null) {
      return false;
    }
    return int.tryParse(str) != null;
  }

  @override
  void initState() {
    super.initState();
    whatsappNumber = '';
  }

  @override
  Widget build(BuildContext context) {

  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Send Bill',
        style:TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      ),
      automaticallyImplyLeading: false,
    ),
    body:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          textAlign: TextAlign.center,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hintMessage,
            ),
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 16.0
          ),
          onChanged: (value)
          {
            whatsappNumber = '';
            if(value.length == 10 && isNumeric(value))
            {
              whatsappNumber = value;
            }
            else
            {
              setState(() {
              hintMessage = 'Must be 10 digits';  
              });              
            }
          }
        ,),
        FlatButton(
          color:Colors.blue,
          child: Text('SEND'),
          onPressed:(){
            if(whatsappNumber != null && isNumeric(whatsappNumber))
            {
              FlutterOpenWhatsapp.sendSingleMessage('+91' + whatsappNumber, billAsString);
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context){
                    return NilaPointOfSale();
                  }
                ));
            }
          }
        )
      ],
      )
  );
    
  }
}