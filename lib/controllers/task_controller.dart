import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_todoapp_firebase/models/task.dart' as task;
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class TaskController extends GetxController {
  var firebaseAuth = FirebaseAuth.instance;
  var firebaseStorage = FirebaseStorage.instance;
  var firestore = FirebaseFirestore.instance;
  final Rx<List<task.Task>> _tasks = Rx<List<task.Task>>([]);
  List<task.Task> get tasks => _tasks.value;
  @override
  void onReady() {
    // TODO: implement onReady
    getTasks();
    super.onReady();
  }

  uploadtask(
      String? title,
      String? note,
      int? isCompleted,
      String? date,
      String? startTime,
      String? endTime,
      int? color,
      String? category,
      String? priority,
      String? repeat,
      double? latitude,
      double? longitude) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;

      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
// get id
      var allDocs = await firestore.collection('tasks').get();
      String taskId = Uuid().v1();
      task.Task taskadd = task.Task(
          id: taskId,
          uid: uid,
          username: (userDoc.data()! as Map<String, dynamic>)['name'],
          title: title,
          note: note,
          isCompleted: isCompleted,
          date: date,
          startTime: startTime,
          endTime: endTime,
          color: color,
          category: category,
          priority: priority,
          repeat: repeat,
          latitude: latitude,
          longitude: longitude);
      await firestore.collection('tasks').doc(taskId).set(taskadd.toJson());
    } catch (e) {
      Get.snackbar('Error uploading task', e.toString());
    }
  }
// get task to show on home screen
  getTasks() {
    String uid = firebaseAuth.currentUser!.uid;
    _tasks.bindStream(firestore
        .collection('tasks')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot query) {
      List<task.Task> retValue = [];
      for (var element in query.docs) {
        retValue.add(task.Task.fromSnap(element));
      }
      return retValue;
    }));
  }
// delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await firestore.collection('tasks').doc(taskId).delete();
      // Refresh the tasks list after deletion
      getTasks();
    } catch (e) {
      Get.snackbar('Error deleting task', e.toString());
    }
  }
// update method to mark task as completed
  Future<void> markTaskAsCompleted(String taskId, int isCompleted) async {
    try {
      await firestore.collection('tasks').doc(taskId).update({
        'isCompleted': isCompleted,
      });
      // Refresh the tasks list after updating the task
      getTasks();
    } catch (e) {
      Get.snackbar('Error updating task', e.toString());
    }
  }
}
