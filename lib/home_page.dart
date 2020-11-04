import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterappfirebase/check_list_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

//  @override
//  void initState() {
//    super.initState();
//  }

  List<CheckListWidget> _tasks = [];
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  removeTask(CheckListWidget task) {
    setState(() {
      _tasks.remove(task);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO-List'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {

            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: (){
//          debugPrint('Added a new task');
          showDialog(
              context: context,
              builder: (context) {
                TextEditingController _textEditingController = TextEditingController();
                return AlertDialog(
                  title: Text(
                    'Add New Task',
                    textAlign: TextAlign.center,
                  ),
                  content: TextFormField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      hintText: 'Add your task here.',
                    ),
                  ),
                  actions: [
                    FlatButton(
                      child: Text('Back'),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                        child: Text('Add'),
                        onPressed: () {
                        if(_textEditingController.text.length != 0) {
                          setState(() {
                            _tasks.add(
                              CheckListWidget(
                                title: _textEditingController.text,
                                onLongPress: (CheckListWidget task){
                                  //onLongPress: Delete the task
                                  removeTask(task);
                                }
                              ),
                            );
                          });
                          Navigator.pop(context);
                        }
                      }
                    )
                  ],
                );
              }
          );
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final taskListFromFirebase = snapshot.data.docs;
          List<CheckListWidget> dataList = [];
          for(var tasksData in taskListFromFirebase) {
            var taskDetails = tasksData.data();
            print(taskDetails);
            dataList.add(
              CheckListWidget(
                  isDone: taskDetails['isDone'],
                  title: taskDetails['title'],
                  onLongPress: (CheckListWidget task){
                    //onLongPress: Delete the task
                    removeTask(task);
                  }
              ),
            );
          }
          return ListView.separated(
            itemCount: dataList.length,
            itemBuilder: (context, index){
              return dataList[index];
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 2.0,
              );
            },
          );
        },
      ),

    );
  }
}


class CheckListWidget extends StatefulWidget {

  final Function onLongPress;
  final String title;
  final bool isDone;

  CheckListWidget({
    @required this.onLongPress,
    @required this.title,
    @required this.isDone,
  });

  @override
  _CheckListWidgetState createState() => _CheckListWidgetState();
}

class _CheckListWidgetState extends State<CheckListWidget> {

  @required
  void initState() {
    super.initState();
    isChecked = widget.isDone;
  }

  bool isChecked;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListTile(
          onLongPress: () {
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
            onChanged: (bool value){
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


