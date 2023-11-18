import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productivity App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: Colors.purple[600],
      ),
      home: TaskListScreen(),
    );
  }
}

/*
class TaskController extends TextEditingController{
    String name;
    String description;
    DateTime date;
    
    void openCalendar(BuildContext context) async {
      table_calendar.
    }
}
*/

class TaskController {
  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController dateController;
  late DateTime selectedTime;
  
  TextEditingController get name => nameController;
  TextEditingController get description => descriptionController;
  TextEditingController get date => dateController;

  TaskController() {
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    dateController = TextEditingController();
    selectedTime = DateTime.now();
  }
}

class Task { // Define Task
 String name;
 String description;
 DateTime date;
 bool isCompleted;

 Task({required this.name, required this.description, required this.date, this.isCompleted = false});
}

class TaskListScreen extends StatefulWidget { // Define TaskListScreen
 @override
 _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  DateTime _selectedDay = DateTime.now();
  DateTime _dates = DateTime.now();

  //TextEditingController dateController = TextEditingController();
  TaskController taskController = TaskController();

  @override
Widget build(BuildContext context) {
 return Scaffold(
   appBar: AppBar(
     title: Text('Task List'),
   ),
   body: ListView.builder(
     itemCount: tasks.length,
     itemBuilder: (context, index) {
       return ListTile(
         title: Row(
            children: <Widget>[
              Text(
                tasks[index].name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ', ' + DateFormat('MM/dd/yyyy').format(tasks[index].date) + ', ',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                tasks[index].description,
              ),
            ]
          ),
         leading: Checkbox(
           value: tasks[index].isCompleted,
           onChanged: (value) {
             setState(() {
               tasks[index].isCompleted = value!;
             });
           },
         ),
       );
     },
   ),
   floatingActionButton: FloatingActionButton(
     onPressed: () {
       _addTask(context);
     },
     tooltip: 'Add Task',
     child: Icon(Icons.add),
   )
 );
}
  
  
  // Task Interface
  Future<void> _addTask(BuildContext context) async {
    //TaskController taskController = TaskController();
    taskController.dateController.text = '';
    taskController.descriptionController.text = '';
    taskController.nameController.text = '';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            children: [
              Text('Task Name'),
              TextField(
                controller: taskController.nameController,
                decoration: InputDecoration(hintText: 'Name'),
              ),
              SizedBox(height: 16.0), // Adding some space between fields
              Text('Description'),
              TextField(
                controller: taskController.descriptionController,
                decoration: InputDecoration(hintText: 'Description'),
              ),
              SizedBox(height: 16.0), // Adding some space between fields
              Text('Date'),
              TextField(
                controller: taskController.dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple)
                  ),
                ),
                readOnly: true,
                onTap: (){
                  _selectDate();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tasks.add(Task(name: taskController.nameController.text, 
                                 description: taskController.descriptionController.text,
                                 date: DateTime.parse(taskController.dateController.text)));
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100)
    );

    if (_picked != null) {
      setState(() {
        taskController.dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }
}
