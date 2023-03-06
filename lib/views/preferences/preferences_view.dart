import 'package:findmyfun/services/page_view_service.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              LoginContainer(
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ), 
        SizedBox(
          height: 400,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverFixedExtentList(
                itemExtent: 100.0,
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
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('ein?? $index'))
                                    );
                                  },
                                  child: Text('ein?? ${index+1}')
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
      ],
    );
  }
}


