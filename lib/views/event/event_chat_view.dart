import 'package:findmyfun/helpers/validators.dart';
import 'package:findmyfun/models/event.dart';
import 'package:findmyfun/models/messages.dart';
import 'package:findmyfun/services/auth_service.dart';
import 'package:findmyfun/services/messages_service.dart';
import 'package:findmyfun/widgets/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  late List<Messages> messages;

  @override
  Widget build(BuildContext context) {
    final selectedEvent = ModalRoute.of(context)!.settings.arguments as Event;
    messages = selectedEvent.messages;
    final messagesService = Provider.of<MessagesService>(context);
    String activeUserId = AuthService().currentUser?.uid ?? "";
    final messageToSend = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.chevron_left,
              size: 45,
              color: ProjectColors.secondary,
            )),
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
          CustomTextForm(
            hintText: 'Descripción',
            maxLines: 5,
            type: TextInputType.multiline,
            controller: messageToSend,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          ElevatedButton(
              onPressed: () {
                Messages m = Messages(
                    userId: activeUserId,
                    date: DateTime.now(),
                    text: messageToSend.text);
                messagesService.saveMessage(m, selectedEvent);
                Navigator.popAndPushNamed(context, "middle",
                    arguments: selectedEvent);
              },
              child: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
