import 'package:findmyfun/services/page_view_service.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/preferences_container.dart';
import '../../widgets/submit_button.dart';

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
                onTap: () => pageViewController.animateToPage(0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut),
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
          body: Column(
            children:  const [
              SizedBox(
                height: 20,
              ),
              PreferencesContainer(
                child: PreferencesColumn(),
              )
            ]
          )),
    );
  }
}

class PreferencesColumn extends StatefulWidget {
  const PreferencesColumn({super.key});

  @override
  _PreferencesColumnState createState() => _PreferencesColumnState();
}

class _PreferencesColumnState extends State<PreferencesColumn> {

  List prefSelec = [0, 2, 7, 8, 13]; //Lista de ejemplo de las preferencias seleccionadas

  @override
  Widget build(BuildContext context) {
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
                      child:
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: 
                            SizedBox(
                              height: 100,
                              width: 325,
                              child: 
                            	  ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0)
                                    )),
                                    backgroundColor: MaterialStateProperty.all(
                                      prefSelec.contains(index) ? Colors.green : Colors.white //Si la preferencia se encuentra en la lista se pone en verde
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if(prefSelec.contains(index)){ //Si una preferencia seleccionada se presiona, es eliminada de la lista
                                        prefSelec.remove(index);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Preferencia ${index+1} se ha eliminado de tus preferencias'))
                                         );
                                      } else { //Si una preferencia sin seleccionar se presiona, es añadida a la lista
                                        prefSelec.add(index);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Preferencia ${index+1} se ha añadido a tus preferencias'))
                                        );
                                      }
                                    });
                                  },
                                  child: Text('Preferencia ${index+1}', style: const TextStyle(color: Colors.black)) //Nombre de la preferencia
                                ),
                            ),
                        ),
                    );
                  },
                  childCount: 15,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const SubmitButton(text: 'CONTINUAR') //Botón para volver al perfil y confirmar los cambios
      ],
    );
  }
}
