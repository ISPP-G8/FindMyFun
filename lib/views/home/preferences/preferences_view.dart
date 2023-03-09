import 'package:findmyfun/services/page_view_service.dart';
import 'package:findmyfun/services/preferences_service.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/preferences_container.dart';
import '../../../widgets/submit_button.dart';

class PreferencesView extends StatelessWidget {
  const PreferencesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageViewController =
        Provider.of<PageViewService>(context).pageController;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.chevron_left,
                  size: 45,
                )),
            backgroundColor: ProjectColors.primary,
            elevation: 0,
            centerTitle: true,
            title: Text('PREFERENCIAS',
                textAlign: TextAlign.center, style: Styles.appBar),
          ),
          backgroundColor: ProjectColors.primary,
          body: Column(children: const [
            SizedBox(
              height: 20,
            ),
            PreferencesContainer(
              child: PreferencesColumn(),
            )
          ])),
    );
  }
}

class PreferencesColumn extends StatefulWidget {
  const PreferencesColumn({super.key});

  @override
  _PreferencesColumnState createState() => _PreferencesColumnState();
}

class _PreferencesColumnState extends State<PreferencesColumn> {
  @override
  Widget build(BuildContext context) {
    final preferencesService = Provider.of<PreferencesService>(context);
    final preferences = preferencesService.preferences;
    final preferencesByUserId = preferencesService.preferencesByUserId;
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 600,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: SizedBox(
                          height: 100,
                          width: 325,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          side: BorderSide(
                                            color: preferencesByUserId
                                                    .contains(index)
                                                ? Colors.black
                                                : Colors
                                                    .white, //Si la preferencia se encuentra en la lista se señala con un borde negro
                                            width: 4,
                                          ))),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              onPressed: () {
                                setState(() {
                                  if (preferencesByUserId.contains(index)) {
                                    //Si una preferencia seleccionada se presiona, es eliminada de la lista
                                    preferencesByUserId.remove(index);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Se ha seleccionado la preferencia ${index + 1}')));
                                  } else {
                                    //Si una preferencia sin seleccionar se presiona, es añadida a la lista
                                    preferencesByUserId.add(index);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Se ha deseleccionado la preferencia ${index + 1}')));
                                  }
                                });
                              },
                              child: Text('Preferencia ${index + 1}',
                                  style: const TextStyle(
                                      color: Colors
                                          .black)) //Nombre de la preferencia
                              ),
                        ),
                      ),
                    );
                  },
                  childCount: 15, //Número de preferencias
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const SubmitButton(
            text:
                'CONTINUAR') //Botón para volver al perfil y confirmar los cambios
      ],
    );
  }
}