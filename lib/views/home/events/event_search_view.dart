import 'package:auto_size_text/auto_size_text.dart';
import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventSearchView extends StatefulWidget {
  const EventSearchView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EventSearchViewState createState() => _EventSearchViewState();
}

class _EventSearchViewState extends State<EventSearchView> {
  final TextEditingController _searchController = TextEditingController();
  String _inputText = '';
  String _searchedText = '';

  @override
  Widget build(BuildContext context) {
    final eventsService = Provider.of<EventsService>(context);
    final usersService = Provider.of<UsersService>(context);
    final comp =
        usersService.currentUser!.subscription.type == SubscriptionType.company;
    debugPrint('WWWWWWWWWWWWW: ${comp}');
    final size = MediaQuery.of(context).size;
    try {
      eventsService.searchForEvents(_searchedText);
    } on Exception catch (e) {
      showErrorDialog(context, e.toString());
    }

    final events = eventsService.eventsFound;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ProjectColors.primary,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.005),
              const AdPlanLoader(),
              const Center(
                child: AutoSizeText(
                  'BUSCAR EVENTOS',
                  maxLines: 1,
                  style: TextStyle(
                      color: ProjectColors.tertiary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5),
              const Text(
                'RECUERDA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 158, 13, 13),
                  fontSize: 18,
                ),
              ),
              if (comp == true)
                const Text(
                  'Si ningún evento incluye el texto que buscas, se mostrarán todos los eventos a los que puedes unirte.\n (Las cuentas de empresa no pueden unirse a ningún evento).',
                  textAlign: TextAlign.center,
                ),
              if (comp != true)
                const Text(
                  'Si ningún evento incluye el texto que buscas, se mostrarán todos los eventos a los que puedes unirte.',
                  textAlign: TextAlign.center,
                ),
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
                constraints: BoxConstraints(maxHeight: size.height * 0.4),
                child: RefreshIndicator(
                  onRefresh: () async => await eventsService.getEvents(),
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (_, index) => EventContainer(
                      event: events[index],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> showErrorDialog(BuildContext context, String exception) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Algo ha ido mal...'),
          content: Text(exception),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
