import 'package:flutter/material.dart';

class RequestString extends StatefulWidget {
  final String displayMessage;
  RequestString(this.displayMessage);
  @override
  _RequestStringState createState() => _RequestStringState();
}

class _RequestStringState extends State<RequestString> {
  String inputValue = '';
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
            leading: IconButton(
              icon:Icon(Icons.keyboard_backspace),
              tooltip: 'Go Back',
              onPressed: (){
                Navigator.of(context).pop(null);
//                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                  return UpdateProductDetails();
//                }));
              },
            ),
          ),
            body:Container(
                width:MediaQuery.of(context).size.width,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child:Text(widget.displayMessage),
                    ),
                    Container(
                      height:100.0,
                      child: TextField(
                        textCapitalization: TextCapitalization.characters,
                        keyboardType: TextInputType.text,
                    minLines: 3,
                    maxLines: 3,
//                    keyboardType: TextInputType.text,
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
                            print('RequestValue:inputValue:' + inputValue);
                            Navigator.of(context).pop(inputValue);
                          },
                          child:Text('CONFIRM',
                              style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight:FontWeight.bold,
                                fontSize: 24.0,
                                color:Colors.white,
                              ))
                      ),
                    )
                  ],
                )

            )
        ),
      );

  }
}
