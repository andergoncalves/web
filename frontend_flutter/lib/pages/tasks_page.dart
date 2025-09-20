import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<String> tasks = [];
  bool loading = true;
  final TextEditingController taskController = TextEditingController();

  Future<void> fetchTasks() async {
    if (mounted) setState(() => loading = true);
    try {
      tasks = await ApiService.getTasks();
    } catch (e) {
      if (!mounted) return; // 🔒 Protege o uso do context
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar tarefas: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> addTask() async {
    final title = taskController.text;
    if (title.isEmpty) return;

    try {
      final newTask = await ApiService.createTask(title);
      if (!mounted) return; // 🔒 Protege o uso do context
      taskController.clear();
      tasks.add(newTask);
      setState(() {}); // Já sabemos que está montado
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao criar tarefa: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarefas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: taskController,
              decoration: const InputDecoration(labelText: 'Nova tarefa'),
            ),
            ElevatedButton(onPressed: addTask, child: const Text('Adicionar')),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) =>
                          ListTile(title: Text(tasks[index])),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
