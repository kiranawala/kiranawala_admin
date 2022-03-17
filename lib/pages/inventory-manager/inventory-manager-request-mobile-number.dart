import 'package:flutter/material.dart';

class RequestMobileNumber extends StatefulWidget {
  RequestMobileNumber();
  @override
  _RequestMobileNumberState createState() => _RequestMobileNumberState();
}

class _RequestMobileNumberState extends State<RequestMobileNumber> {
  String inputValue = '';
  String displayMessage = '10-DIGIT MOBILE NUMBER';
  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
      onWillPop:(){
        Navigator.of(context).pop(inputValue);
        return;
      },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
          ),
            body:Container(
                width:MediaQuery.of(context).size.width,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child:Text(displayMessage,
                      style:TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                    Container(
                      height:100.0,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style:TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight:FontWeight.bold,
                          fontSize: 24.0,
                          color:Colors.black,
                        ),
                        autofocus: true,
                        textAlign: TextAlign.center,
                        cursorColor: Colors.black,
                        cursorWidth: 8.0,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold)),
                        onChanged: (value) {
                          inputValue = value;
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                          color:Colors.blue,
                          onPressed:(){
                            if(inputValue.length == 10) {
                              Navigator.of(context).pop(inputValue);
                            }
                            else
                              {
                                setState(() {
                                  displayMessage = "INVALID NUMBER";
                                });
                              }
                          },
                          child:Text('CONFIRM',
                              style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight:FontWeight.bold,
                                fontSize: 24.0,
                                color:Colors.white,
                              ))
                      ),
                    ),
                  ],
                )

            )
        ),
      );

  }
}
