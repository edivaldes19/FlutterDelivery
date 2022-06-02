import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  String text = '';
  NoDataWidget({Key? key, this.text = ''}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset('assets/img/cero-items.png', height: 150, width: 150),
      SizedBox(height: 15),
      Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
    ]);
  }
}
