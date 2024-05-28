import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/to_do.dart'; // Ensure this is the correct path to your Todo model
import '../main.dart'; // Ensure this is the correct path to your MyApp widget
import 'form_page.dart'; // Ensure this is the correct path to your MyFormPage widget

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  late Future<List<Todo>> futureTodos;

  @override
  void initState() {
    super.initState();
    futureTodos = fetchTodos();
  }

  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/todos?_start=0&_limit=10'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((json) => Todo.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'To Do',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              title: const Text('Counter'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
            ),
            ListTile(
              title: const Text('Form'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyFormPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.check, color: Colors.blueAccent),
              title: const Text('To Do'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ToDoPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Todo>>(
        future: futureTodos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ada to do list :(",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Todo todo = snapshot.data![index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Completed: ${todo.completed}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
