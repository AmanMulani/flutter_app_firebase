import 'package:flutter/material.dart';
import 'package:flutterappfirebase/firebase_backend.dart';

class CheckListWidget extends StatefulWidget {

  final String uid;
  final String title;
  final bool isDone;

  CheckListWidget({
    @required this.uid,
    @required this.title,
    @required this.isDone,
  });

  @override
  _CheckListWidgetState createState() => _CheckListWidgetState();
}

class _CheckListWidgetState extends State<CheckListWidget> {

  FirebaseBackend _firebaseBackend = FirebaseBackend();
  @required
  void initState() {
    isChecked = widget.isDone;
    super.initState();
  }

  bool isChecked;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListTile(
          onLongPress: () async{
            await _firebaseBackend.deleteTodoItem(widget.uid);
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
              await _firebaseBackend.updateTodoItem(value, widget.uid);
              setState(() {
                isChecked = value;
              });
            },
            value: isChecked,
          ),

        ),
      ),
    );
  }
}


