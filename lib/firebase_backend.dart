import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseBackend {

  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  createTodoItem(String title) async{
    await _firebaseFirestore.collection('tasks').add({
      'title': title,
      'isDone': false,
    });
  }

  updateTodoItem(bool isDone, String uid) async{
    await _firebaseFirestore.collection('tasks').doc(uid).update(
        {
          'isDone': isDone,
        }
    );
  }

  deleteTodoItem(String uid) async {
    await _firebaseFirestore.collection('tasks').doc(uid).delete();
  }

}