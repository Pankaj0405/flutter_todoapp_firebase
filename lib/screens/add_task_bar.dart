import 'package:flutter/material.dart';
import 'package:flutter_todoapp_firebase/controllers/home_controller.dart';
import 'package:flutter_todoapp_firebase/controllers/task_controller.dart';
import 'package:flutter_todoapp_firebase/models/task.dart';
import 'package:flutter_todoapp_firebase/screens/map_view.dart';
import 'package:flutter_todoapp_firebase/theme.dart';
import 'package:flutter_todoapp_firebase/widgets/button.dart';
import 'package:flutter_todoapp_firebase/widgets/input_field.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final HomeController homeController = Get.put(HomeController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _selectedcategory = "Personal";
  List<String> categoryList = ["Personal", "Work", "Shopping"];
  String _selectedpriority = "High";
  List<String> priorityList = ["High", "Medium", "Low"];
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Montly"];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyInputField(
                title: "Title",
                hint: "Enter your title",
                controller: _titleController,
              ),
              MyInputField(
                title: "Note",
                hint: "Enter your note",
                controller: _noteController,
              ),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                    title: "Start Time",
                    hint: _startTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: true);
                      },
                      icon: Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: MyInputField(
                    title: "End Time",
                    hint: _endTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: false);
                      },
                      icon: Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ))
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(() => Expanded(
                          child: MyInputField(
                        title: "Latitude",
                        hint: homeController.latitude.value.toString() != null
                            ? homeController.latitude.value.toString()
                            : "",
                        controller: latitudeController,
                      ))),
                  SizedBox(
                    width: 12,
                  ),
                  Obx(() => Expanded(
                          child: MyInputField(
                        title: 'Longitude',
                        hint: homeController.longitude.value.toString() != null
                            ? homeController.longitude.value.toString()
                            : "",
                        controller: longitudeController,
                      ))),
                  SizedBox(
                    width: 10,
                  ),
                  MyButton(
                      label: "Open Map", onTap: () => Get.to(() => MapPage()))
                ],
              ),
              MyInputField(
                  title: "Choose Category",
                  hint: "$_selectedcategory",
                  widget: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedcategory = newValue!;
                      });
                    },
                    items: categoryList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
              MyInputField(
                  title: "Choose Priority",
                  hint: "$_selectedpriority",
                  widget: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedpriority = newValue!;
                      });
                    },
                    items: priorityList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
              MyInputField(
                  title: "Repeat",
                  hint: "$_selectedRepeat",
                  widget: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    },
                    items: repeatList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                            Text(value!, style: TextStyle(color: Colors.grey)),
                      );
                    }).toList(),
                  )),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(label: "Create Task", onTap: () => _validateData())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.pinkAccent,
          icon: Icon(Icons.warning_amber_rounded));
    }
  }

  _addTaskToDb() async {
    await _taskController.uploadtask(
      _titleController.text,
      _noteController.text,
      0,
      DateFormat.yMd().format(_selectedDate),
      _startTime,
      _endTime,
      _selectedColor,
      _selectedcategory,
      _selectedpriority,
      _selectedRepeat,
      homeController.latitude.value,
      homeController.longitude.value,
    );
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
        Wrap(
            children: List<Widget>.generate(3, (int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? Colors.blueAccent
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  child: _selectedColor == index
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : Container()),
            ),
          );
        }))
      ],
    );
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var _pickTime = await _showTimePicker();
    String _formatedTime = _pickTime.format(context);
    DateFormat inputFormat = DateFormat('h:mm a');
    DateFormat outputFormat = DateFormat('HH:mm');
    DateTime dateTime = inputFormat.parse(_formatedTime);
    String time24HourFormat = outputFormat.format(dateTime);

    print(time24HourFormat);
    if (_pickTime == null) {
      print("Time canceled");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = time24HourFormat;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = time24HourFormat;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0])));
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2121));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      print("It is null or somthing is wrong");
    }
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
