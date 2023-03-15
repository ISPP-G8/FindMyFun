import 'package:findmyfun/screens/access_screen.dart';
import 'package:findmyfun/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:findmyfun/widgets/widgets.dart';

class EventCreator extends StatefulWidget {
  final String creatorUsername;
  const EventCreator({super.key, required this.creatorUsername});

  @override
  State<EventCreator> createState() => _EventCreator();
}

class _EventCreator extends State<EventCreator> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            widget.creatorUsername,
            style: const TextStyle(
              color: Color(0xff545454),
              fontWeight: FontWeight.w500,
            ),
          ),
          CustomButton(
            text: 'Visitar perfil',
            width: 100,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const ProfileDetailsView()),
            ),
          ),
        ],
      ),
    );
  }
}
