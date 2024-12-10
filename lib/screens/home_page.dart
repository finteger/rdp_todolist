import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore db =
      FirebaseFirestore.instance; //new firestore instance
  final TextEditingController nameController =
      TextEditingController(); //captures textform input
  final List<Map<String, dynamic>> tasks = [];

  //Function that adds new tasks to local state & firestore database
  Future<void> addTask() async {
    final taskName = nameController.text.trim();

    if (taskName.isNotEmpty) {
      final newTask = {
        'name': taskName,
        'completed': false,
        'timestamp': FieldValue.serverTimestamp(),
      };

      //docRef gives us the insertion id of the task from the database
      final docRef = await db.collection('tasks').add(newTask);

      //Adding tasks locally
      setState(() {
        tasks.add({
          'id': docRef.id,
          ...newTask,
        });
      });
      nameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Image.asset('assets/rdplogo.png', height: 80),
            ),
            const Text(
              'Daily Planner',
              style: TextStyle(
                  fontFamily: 'Caveat', fontSize: 32, color: Colors.white),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TableCalendar(
                    calendarFormat: CalendarFormat.month,
                    focusedDay: DateTime.now(),
                    firstDay: DateTime(2024),
                    lastDay: DateTime(2025),
                  ),
                  buildTaskList(tasks)
                ],
              ),
            ),
          ),
          buildAddTaskSection(nameController, addTask),
        ],
      ),
      drawer: Drawer(),
    );
  }
}

//Build the section for adding tasks
Widget buildAddTaskSection(nameController, addTask) {
  return Row(
    children: [
      Expanded(
        child: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Add Task',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      ElevatedButton(
        onPressed: addTask, //Adds tasks when pressed
        child: Text('Add Task'),
      ),
    ],
  );
}

//Widget that displays the task item on the UI
Widget buildTaskList(tasks) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      final task = tasks[index];

      return ListTile(
        leading: Icon(
          task['completed'] ? Icons.check_circle : Icons.circle_outlined,
        ),
        title: Text(
          task['name'],
          style: TextStyle(
            decoration: task['completed'] ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: task['completed'],
              onChanged: null,
            ),
            const IconButton(
              icon: Icon(Icons.delete),
              onPressed: null,
            ),
          ],
        ),
      );
    },
  );
}
