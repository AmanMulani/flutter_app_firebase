import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  List<CheckListWidget> _tasks = [];

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
            onPressed: () async {

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
          print('Added a new task');
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
                        onPressed: () async {
                        if(_textEditingController.text.length != 0) {
                          setState(() {
                            _tasks.add(
                              CheckListWidget(
                                title: _textEditingController.text,
                                onLongPress: (CheckListWidget task){
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
      body: ListView.separated(
        itemCount: _tasks.length,
        itemBuilder: (context, index){
          return _tasks[index];
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 2.0,
          );
        },
      ),

    );
  }
}

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

  @required
  void initState() {
    super.initState();
  }

  bool value = false;
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
              decoration: value ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          trailing: Checkbox(
            onChanged: (bool value) async{
              setState(() {
                this.value = value;
              });
            },
            value: value,
          ),

        ),
      ),
    );
  }
}

