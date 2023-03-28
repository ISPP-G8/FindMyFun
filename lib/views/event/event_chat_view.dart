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
                final bool isMe = message.userId == activeUserId;
                return Container(
                  margin: EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    left: isMe ? 50.0 : 0.0,
                    right: isMe ? 0.0 : 50.0,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Color.fromARGB(255, 46, 84, 252)
                        : Color.fromARGB(255, 104, 102, 102),
                    borderRadius: isMe
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            bottomLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0),
                          )
                        : const BorderRadius.only(
                            topRight: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                            topLeft: Radius.circular(15.0),
                          ),
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                color: Colors.lightBlue,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextForm(
                        hintText: 'Escribe tu mensaje aquí...',
                        //maxLines: 5,
                        type: TextInputType.multiline,
                        controller: messageToSend,
                        validator: (value) =>
                            Validators.validateNotEmpty(value),
                      ),
                    ),
                    IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.send),
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
                        messageToSend.clear();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
