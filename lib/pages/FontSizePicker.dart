import 'package:flutter/material.dart';


class FontSizePickerDialog extends StatefulWidget {
  /// initial selection for the slider
  final double initialFontSize;

  const FontSizePickerDialog({Key key, this.initialFontSize}) : super(key: key);

  @override
  _FontSizePickerDialogState createState() => _FontSizePickerDialogState();
}

class _FontSizePickerDialogState extends State<FontSizePickerDialog> {
  /// current selection of the slider
  double _fontSize;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Font Size'),
      content: Container(
        child: Slider(
          value: _fontSize,
          min: 10,
          max: 100,
          divisions: 9,
          onChanged: (value) {
            setState(() {
              _fontSize = value;
            });
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            // Use the second argument of Navigator.pop(...) to pass
            // back a result to the page that opened the dialog
            Navigator.pop(context, _fontSize);
          },
          child: Text('DONE'),
        )
      ],
    );
  }
}