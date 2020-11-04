import 'package:flutter/material.dart';

class CheckListWidget extends StatefulWidget {

  final Function onLongPress;
  final String title;

  CheckListWidget({
    @required this.onLongPress,
    @required this.title,
  });

  @override
  _CheckListWidgetState createState() => _CheckListWidgetState();
}

class _CheckListWidgetState extends State<CheckListWidget> {

//  @required
//  void initState() {
//    super.initState();
//  }

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListTile(
          onLongPress: () async{
            widget.onLongPress(widget);
            print('Delete');
          },
          title: Text(
            widget.title,
            style: TextStyle(
              decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          trailing: Checkbox(
            onChanged: (bool value) async{
              setState(() {
                this.isChecked = value;
              });
            },
            value: isChecked,
          ),

        ),
      ),
    );
  }
}