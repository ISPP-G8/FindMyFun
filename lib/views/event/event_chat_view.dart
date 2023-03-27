import 'package:findmyfun/helpers/validators.dart';
import 'package:findmyfun/models/event.dart';
import 'package:findmyfun/models/messages.dart';
import 'package:findmyfun/models/user.dart';
import 'package:findmyfun/services/auth_service.dart';
import 'package:findmyfun/services/messages_service.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/widgets/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChatScreenState();
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
    final userService = Provider.of<UsersService>(context, listen: false);
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
                return Container(
                  margin:
                      const EdgeInsets.all(8.0), // Margen exterior de la caja
                  padding:
                      const EdgeInsets.all(16.0), // Margen interior de la caja
                  decoration: BoxDecoration(
                    color: Colors.blueGrey, // Color de fondo de la caja
                    borderRadius: BorderRadius.circular(
                        8.0), // Bordes redondeados de la caja
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.userId,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                      const SizedBox(
                          height:
                              8.0), // Agrega un espacio vertical de 8.0 píxeles
                      Text(
                        message.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          CustomTextForm(
            hintText: 'Escribe tu mensaje aquí...',
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
                if (m.text != "") {
                  messagesService.saveMessage(m, selectedEvent);
                  Navigator.popAndPushNamed(context, "chat",
                      arguments: selectedEvent);
                }
              },
              child: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
