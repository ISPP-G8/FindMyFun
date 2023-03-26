import 'package:findmyfun/services/auth_service.dart';
import 'package:findmyfun/services/preferences_service.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/models.dart';
import '../../../widgets/preferences_container.dart';

class PreferencesView extends StatelessWidget {
  const PreferencesView({super.key});

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.chevron_left,
                  color: ProjectColors.secondary,
                  size: 45,
                )),
            // backgroundColor: ProjectColors.primary,
            elevation: 0,
            centerTitle: true,
            title: Text('PREFERENCIAS',
                textAlign: TextAlign.center, style: Styles.appBar),
          ),
          // backgroundColor: ProjectColors.primary,
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
  State<StatefulWidget> createState() => _PreferencesColumnState();
}

class _PreferencesColumnState extends State<PreferencesColumn> {
  late Future preferencesFuture;
  @override
  void initState() {
    super.initState();

    preferencesFuture = _getPreferences();
  }

  _getPreferences() async{
    PreferencesService preferencesService = PreferencesService();
    
    return await preferencesService.getPreferencesByUserId();
  }

  @override
  Widget build(BuildContext context) {
    final preferencesService = Provider.of<PreferencesService>(context);
    final preferences = preferencesService.preferences;
    final preferencesNames = preferences.map((e) => e.name).toList();
    List<Preferences> selectedPreferences = [];

    String activeUserId = AuthService().currentUser?.uid ?? "";
    return FutureBuilder<dynamic>(
      future: preferencesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          selectedPreferences = snapshot.data;
          
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 480,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: preferences.length, //Número de preferencias
                        (BuildContext context, int index) {
                          return Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: SizedBox(
                                height: 80,
                                width: 325,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                side: BorderSide(
                                          color: selectedPreferences
                                                  .contains(preferences[index])
                                              ? Colors.black
                                              : Colors
                                                  .white, //Si la preferencia se encuentra en la lista se señala con un borde negro
                                          width: 4,
                                        ))),
                                        backgroundColor:
                                            MaterialStateProperty.all(Colors.white)),
                                    onPressed: () {
                                      setState(() {
                                        if (selectedPreferences
                                            .contains(preferences[index])) {
                                          //Si una preferencia seleccionada se presiona, es eliminada de la lista
                                          selectedPreferences
                                              .remove(preferences[index]);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Se ha deseleccionado la preferencia ${preferences[index].name}')));
                                        } else {
                                          //Si una preferencia sin seleccionar se presiona, es añadida a la lista
                                          selectedPreferences.add(preferences[index]);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Se ha seleccionado la preferencia ${preferences[index].name}')));
                                        }
                                      });
                                    },
                                    child: Text(preferencesNames[index],
                                        style: const TextStyle(
                                            color: Colors
                                                .black)) //Nombre de la preferencia
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                onPressed: () {
                  // When merge, change first option by current user id
                  if(selectedPreferences.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Debes seleccionar al menos una preferencia')));

                  } else {
                      preferencesService.savePreferences(
                      activeUserId, selectedPreferences);
                      Navigator.pop(context, "main");
                  }
                },
                child: const Icon(Icons.save),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Recuerda guardar para que se actualize tu perfil',
                      
                      textAlign: TextAlign.center, style: TextStyle( 
                        color: ProjectColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)
                      ) 
            ],
          );
        } else {
          return Column(children: const [
            SizedBox(height: 100),
            Center(child: CircularProgressIndicator())
          ]);
        }
      },
    );
  }
}
