import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leafy_app_flutter/providers/notification_provider.dart';

class AddNotificationForm extends StatefulWidget {
  const AddNotificationForm({super.key});

  @override
  State<AddNotificationForm> createState() => _AddNotificationFormState();
}

class _AddNotificationFormState extends State<AddNotificationForm> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      Provider.of<NotificationProvider>(context, listen: false)
          .addNotification(text);
      _controller.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notificación añadida'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Añadir notificación',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _submit,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
