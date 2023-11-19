// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'player.dart';
import 'enemy.dart';
import 'shop.dart';
import 'database.dart';
import 'dart:io';

Player user = Player();
int starRating = 1;

void main() {
  initializeGame();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

void initializeGame() {}

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

class Task {
  // Define Task
  late String name;
  late String description;
  late DateTime date;
  late bool isCompleted;
  late Enemy enemy;
  late int priority; // 0 1 2 3 4, 0 is highest

  Task(
      {required this.name,
      required this.description,
      required this.date,
      required this.enemy,
      required this.priority,
      this.isCompleted = false}) {
    enemy = Enemy.generateEnemy(name, description, date, priority);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'enemy': enemy.toJson(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        name: json['name'],
        description: json['description'],
        date: DateTime.parse(json['date']),
        isCompleted: json['isCompleted'],
        enemy: Enemy.fromJson(json['enemy']),
        priority: json["priority"]);
  }

  bool isCompletedOnTime() {
    // Compare the current time with the due date
    DateTime currentTime = DateTime.now();
    return isCompleted || currentTime.isBefore(date);
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  // Define TaskListScreen
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  final DateTime _selectedDay = DateTime.now();
  final DateTime _dates = DateTime.now();

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
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    tasks[index].name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ', ${DateFormat('MM/dd/yyyy').format(tasks[index].date)}, ',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    tasks[index].description,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: enemyWidget(context, tasks[index].enemy, user),
                  ),
                ],
              ),
            ),
            leading: Checkbox(
              value: tasks[index].isCompleted,
              onChanged: (value) {
                setState(() {
                  tasks[index].isCompleted = value!;
                  Player player = Player();
                  tasks[index].enemy.battle(
                      player); // temporary - makes battle occur when task is completed
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: FloatingActionButton(
              onPressed: () {
                _addTask(context);
              },
              tooltip: 'Add Task',
              child: Icon(Icons.add_task),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: FloatingActionButton(
              onPressed: () {
                // player code
                _addPlayerScreen(context);
              },
              tooltip: 'Player Info',
              child: Icon(Icons.person),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: FloatingActionButton(
              onPressed: () {
                // shop code
                _showShop(context);
              },
              tooltip: 'Item Shop',
              child: Icon(Icons.shopping_cart),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
          ),
        ],
      ),
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
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;
                  return SizedBox(
                    height: height - 400,
                    width: width - 400,
                    child: Column(
                      children: <Widget>[
                        Text('Task Name'),
                        TextField(
                          controller: taskController.nameController,
                          decoration: InputDecoration(hintText: 'Name'),
                        ),
                        SizedBox(
                            height: 16.0), // Adding some space between fields
                        Text('Description'),
                        TextField(
                          controller: taskController.descriptionController,
                          decoration: InputDecoration(hintText: 'Description'),
                        ),
                        SizedBox(
                            height: 16.0), // Adding some space between fields
                        Text('Due Date'),
                        TextField(
                          controller: taskController.dateController,
                          decoration: InputDecoration(
                            labelText: 'Date',
                            filled: true,
                            prefixIcon: Icon(Icons.calendar_today),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple)),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectDate();
                          },
                        ),
                        Text('Difficulty'),
                        RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            starRating = (rating.truncateToDouble()).toInt();
                            //print(starRating);
                          },
                        ),
                      ],
                    ),
                  );
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                },
              ),
              title: Text('Add Task'),
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
                      tasks.add(Task(
                        name: taskController.nameController.text,
                        description: taskController.descriptionController.text,
                        date:
                            DateTime.parse(taskController.dateController.text),
                        enemy: Enemy.generateEnemy(
                            taskController.nameController.text,
                            taskController.descriptionController.text,
                            DateTime.parse(taskController.dateController.text),
                            starRating),
                        priority: starRating,
                      ));
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Add'),
                ),
              ],
            ));
  }

  Future<void> _addPlayerScreen(BuildContext context) async {
    PlayerScreen screen = PlayerScreen(user);
    screen.show(context);
  }

  Future<void> _showShop(BuildContext context) async {
    Shop shop = Shop.namedConstructor(user);
    shop.displayShop(context, user);
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        taskController.dateController.text = picked.toString().split(" ")[0];
      });
    }
  }
}
