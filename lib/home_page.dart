import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterappfirebase/check_list_widget.dart';
import 'package:flutterappfirebase/firebase_backend.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

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
                        onPressed: () async{
                        if(_textEditingController.text.length != 0) {
                          FirebaseBackend _firebaseBackend = FirebaseBackend();
                          await _firebaseBackend.createTodoItem(_textEditingController.text);
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
                uid: tasksData.id,
                isDone: taskDetails['isDone'],
                title: taskDetails['title'],
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


