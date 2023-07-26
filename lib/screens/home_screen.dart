import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_todoapp_firebase/controllers/auth_controller.dart';
import 'package:flutter_todoapp_firebase/controllers/task_controller.dart';
import 'package:flutter_todoapp_firebase/models/task.dart';
import 'package:flutter_todoapp_firebase/screens/add_task_bar.dart';
import 'package:flutter_todoapp_firebase/screens/map_view_screen.dart';
import 'package:flutter_todoapp_firebase/services/notification_services.dart';
import 'package:flutter_todoapp_firebase/services/theme_services.dart';
import 'package:flutter_todoapp_firebase/theme.dart';
import 'package:flutter_todoapp_firebase/widgets/button.dart';
import 'package:flutter_todoapp_firebase/widgets/task_tile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var authController = AuthController.instance;
  var notifyHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController.getUserData();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: pageIdx == 0
          ? Column(
              children: [
                _addTaskBar(),
                _addDateBar(),
                SizedBox(
                  height: 10,
                ),
                _showTasks(),
              ],
            )
          : MapViewScreen(tasks: _taskController.tasks),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (idx) {
            setState(() {
              pageIdx = idx;
            });
          },
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          currentIndex: pageIdx,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 30,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.map_outlined,
                  size: 30,
                ),
                label: 'Map View'),
          ]),
    );
  }

  _showTasks() {
    return Expanded(child: Obx(() {
      return ListView.builder(
          itemCount: _taskController.tasks.length,
          itemBuilder: (_, index) {
            print(_taskController.tasks.length);
            Task task = _taskController.tasks[index];
            if (task.repeat == 'Daily') {
              try {
                String myTime = task.startTime.toString().split(" ")[0];

                notifyHelper.scheduledNotification(
                    int.parse(myTime.toString().split(":")[0]),
                    int.parse(myTime.toString().split(":")[1]),
                    task);
              } catch (e) {
                print(e.toString());
              }
              return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: _taskController.tasks.length,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(
                              task: task,
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
            }
            if (task.date == DateFormat.yMd().format(_selectedDate)) {
              return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: _taskController.tasks.length,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(
                              task: task,
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
            } else {
              return Container();
            }
          });
    }));
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.32,
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: "Task Completed",
                  onTap: () {
                    _taskController.markTaskAsCompleted(task.id.toString(), 1);
                    Get.back();
                  },
                  clr: primaryClr,
                  context: context),
          _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.deleteTask(task.id.toString());
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context),
          SizedBox(
            height: 20,
          ),
          _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.red[300]!,
              isClose: true,
              context: context),
          SizedBox(
            height: 10,
          )
        ],
      ),
    ));
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: isClose == true
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
            child: Text(
          label,
          style:
              isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
        )),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                )
              ],
            ),
          ),
          MyButton(
              label: '+ Add Task',
              onTap: () async {
                await Get.to(AddTaskPage());
                // _taskController.getTasks();
              })
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
              title: 'theme Changed',
              body: Get.isDarkMode
                  ? "Activated Light Theme"
                  : "Activated Dark Theme");
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        Obx(() => CircleAvatar(
            backgroundImage: authController.profilePhotoget.value != null
                ? NetworkImage(authController.profilePhotoget.value!)
                : NetworkImage(
                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'))),
        SizedBox(
          width: 20,
        )
      ],
    );
  }
}
