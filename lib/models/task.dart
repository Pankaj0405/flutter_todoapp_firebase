import 'package:cloud_firestore/cloud_firestore.dart';

class Task{
  String? id;
  String?uid;
  String? username;
  String? title;
  String?  note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  String? category;
  String? priority;
  String? repeat;
  double? latitude;
   double? longitude;

  Task({
    this.id,
    this.uid,this.username,
    this.title,
  this.note,
  this.isCompleted,
  this.date,
  this.startTime,
  this.endTime,
  this.color,
  this.category,
    this.priority,
    this.repeat,
    this.latitude,
    this.longitude
});

  static Task fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Task(
        id:snapshot['id'],
        uid:snapshot['uid'],
        username:snapshot['username'],
        title:snapshot['title'],
        note:snapshot['note'],
        isCompleted:snapshot['isCompleted'],
        date:snapshot['date'],
        startTime:snapshot['startTime'],
        endTime:snapshot['endTime'],
        color:snapshot['color'],
        category:snapshot['category'],
        priority:snapshot['priority'],
        repeat:snapshot['repeat'],
    latitude:snapshot['latitude'],
    longitude:snapshot['longitude'],
    );
  }

  Task.fromJson(Map<String,dynamic> json){

    id=json['id'];
    uid=json['uid'];
    username=json['username'];
    title=json['title'];
    note=json['note'];
    isCompleted=json['isCompleted'];
    date=json['date'];
    startTime=json['startTime'];
    endTime=json['endTime'];
    color=json['color'];
    category=json['category'];
    priority=json['priority'];
    repeat=json['repeat'];
    latitude=json['latitude'];
    longitude=json['longitude'];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data =new Map<String,dynamic>();
    data['id']=this.id;
    data['uid']=this.uid;
    data['username']=this.username;
    data['title']=this.title;
    data['date']=this.date;
    data['note']=this.note;
    data['isCompleted']=this.isCompleted;
    data['startTime']=this.startTime;
    data['endTime']=this.endTime;
    data['color']=this.color;
    data['category']=this.category;
    data['priority']=this.priority;
    data['repeat']=this.repeat;
    data['latitude']=this.latitude;
    data['longitude']=this.longitude;
    return data;
  }


}