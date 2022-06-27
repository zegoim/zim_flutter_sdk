import 'package:flutter/material.dart';

class TransferGroupOwnershipItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TransferGroupOwnershipState();
}

class TransferGroupOwnershipState extends State<TransferGroupOwnershipItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
      margin: EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(width: 0.5, color: Color(0xFFd9d9d9)),
            top: BorderSide(width: 0.5, color: Color(0xFFd9d9d9))),
      ),
      // color: Colors.white,
      child: Row(
        children: <Widget>[
          Text(
                'Transfer Ownership',
                style: TextStyle(),
                textScaleFactor: 1.2,
              ),
          Expanded(
              child: Container(),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.chevron_right_outlined,color: Colors.grey,)),
          
        ],
      ),
    );
  }
}
