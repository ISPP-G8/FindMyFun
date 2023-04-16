import 'package:findmyfun/helpers/validators.dart';
import 'package:findmyfun/models/event.dart';
import 'package:findmyfun/models/messages.dart';
import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/widgets/custom_banner_ad.dart';
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
    final size = MediaQuery.of(context).size;
    final selectedEvent = ModalRoute.of(context)!.settings.arguments as Event;
    messages = selectedEvent.messages;
    final messagesService = Provider.of<MessagesService>(context);
    final userService = UsersService();
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
          SizedBox(height: size.height * 0.005),
          const CustomAd(),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                messages.sort((a, b) => a.date.compareTo(b.date));
                final message = messages[index];
                final bool isMe = message.userId == activeUserId;
                Future<String> getUserName() async {
                  final User user =
                      await userService.getUserWithUid(message.userId);
                  return user.username;
                }

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
                        ? const Color.fromARGB(255, 46, 84, 252)
                        : const Color.fromARGB(255, 104, 102, 102),
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
                      Row(
                        children: [
                          Expanded(
                            child: FutureBuilder<String>(
                              future: getUserName()
                                  .timeout(const Duration(seconds: 1)),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                    ),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                          Text(
                            message.date.toString().substring(
                                0, (message.date.toString().length - 7)),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        Messages m = Messages(
                            userId: activeUserId,
                            date: DateTime.now(),
                            text: messageToSend.text);
                        if (m.text.isNotEmpty) {
                          messagesService.saveMessage(
                              context, m, selectedEvent);
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
