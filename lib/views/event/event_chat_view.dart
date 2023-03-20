import 'package:findmyfun/models/messages.dart';
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
    final messagesService =
        Provider.of<MessagesService>(context, listen: false);
    Future.delayed(
        Duration.zero, () async => await messagesService.getMessages());
    super.initState();
  }

  Widget build(BuildContext context) {
    final messagesService = Provider.of<MessagesService>(context);
    final List<Messages> messages = messagesService.messages;
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
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Escribe un mensaje',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  // implementar la logica para enviar el mensaje
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
