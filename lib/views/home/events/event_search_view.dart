import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventSearchView extends StatefulWidget {
  const EventSearchView({super.key});

  @override
  _EventSearchViewState createState() => _EventSearchViewState();
}

class _EventSearchViewState extends State<EventSearchView> {
  final TextEditingController _searchController = TextEditingController();
  String _inputText = ' ';
  String _searchedText = '';

  @override
  Widget build(BuildContext context) {
    final eventsService = Provider.of<EventsService>(context);
    final size = MediaQuery.of(context).size;
    eventsService.searchForEvents(_searchedText);
    final events = eventsService.eventsFound;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ProjectColors.primary,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                  child: Text(
                'BUSCAR EVENTOS',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )),
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.white,
                  child: Column(
                    children: [
                      TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: '¿Qué estás buscando?',
                          ),
                          onChanged: (text) {
                            setState(() {
                              _inputText = text;
                            });
                          }),
                      CustomButton(
                        text: 'Buscar',
                        onTap: () => {
                          _searchedText = _inputText,
                        },
                      )
                    ],
                  )),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: size.height),
                child: RefreshIndicator(
                  onRefresh: () async => await eventsService.getEvents(),
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (_, index) => EventContainer(
                      event: events[index],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   throw UnimplementedError();
  // }
}
