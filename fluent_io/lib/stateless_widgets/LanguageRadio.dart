import 'package:flutter/material.dart'; // base package

import 'package:fluent_io/data/record.dart';

class LanguageRadio extends StatelessWidget {
  LanguageRadio({Key key, this.option, this.onChange}) : super(key: key);
  final String option;
  final Function onChange;
  final languages = FakeDatabase.getLanguages();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: languages[0],
          groupValue: option,
          onChanged: onChange,
        ),
        Text(languages[0]),
        Radio(
          value: languages[1],
          groupValue: option,
          onChanged: onChange,
        ),
        Text(languages[1]),
      ],
    );
  }
}