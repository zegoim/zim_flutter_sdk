import 'dart:ui';

import 'package:flutter/material.dart';

Widget TextBubble(String content,Color colors,Color txtColor,double bottomleft,double bottomRight){
  return ConstrainedBox(
    constraints: BoxConstraints(
        maxWidth: 250
    ),
    child: Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(bottomleft), bottomRight: Radius.circular(bottomRight),topRight: Radius.circular(0.0),topLeft: Radius.circular(5.0)),
        color: colors,
      ),
      child: Text(content,style: TextStyle(color:txtColor,fontSize: 18),),
    ),
  );
}

