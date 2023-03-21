import 'package:findmyfun/models/event.dart';
import 'package:findmyfun/models/messages.dart';
import 'package:findmyfun/services/auth_service.dart';
import 'package:findmyfun/services/messages_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final selectedEvent = ModalRoute.of(context)!.settings.arguments as Event;
    final messagesService = Provider.of<MessagesService>(context);
    final List<Messages> messages = selectedEvent.messages;
    String activeUserId = AuthService().currentUser?.uid ?? "";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.text),
                );
              },
            ),
          ),
          FloatingActionButton(
              onPressed: () {
                int setId = selectedEvent.messages.length + 1;
                Messages m = Messages(
                    id: String.fromCharCode(setId),
                    userId: activeUserId,
                    date: DateTime.now(),
                    text: "Pepe");
                messagesService.saveMessage(m, selectedEvent);
                Navigator.pop(context, "chat");
              },
              child: const Icon(Icons.send)),
        ],
      ),
    );
  }
}