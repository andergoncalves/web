import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo_api/pages/tasks_page.dart'; // <-- certifique-se do caminho

void main() {
  testWidgets('TasksPage smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: TasksPage(),
      ), // ⚡ Use MaterialApp para fornecer contexto
    );

    // Verifique se o TextField e botão estão presentes
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Adicionar'), findsOneWidget);
  });
}
