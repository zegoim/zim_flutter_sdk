import 'package:flutter/material.dart';

class UserAvatarItem extends StatefulWidget {
  UserAvatarItem();

  @override
  State<StatefulWidget> createState() => UserAvatarState();
}

class UserAvatarState extends State<UserAvatarItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(width: 1, color: Colors.grey)),
        child: Icon(
          Icons.person,
          size: 40,
        )
        //Image(image: NetworkImage(widget.url)),
        );
  }
}
