import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EventDetailsView extends StatelessWidget {
  const EventDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            flexibleSpace: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 50),
              child: FittedBox(
                child: Text(
                  'CONCIERTO DE LOS MORANCOS',
                  textAlign: TextAlign.center,
                  style: Styles.appBar,
                  maxLines: 3,
                ),
              ),
            ),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.chevron_left,
                size: 45,
              ),
            ),
            backgroundColor: ProjectColors.primary,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        backgroundColor: ProjectColors.primary,
        body: const SingleChildScrollView(
          child: LoginContainer(
            child: _FormsColumn(),
          ),
        ),
      ),
    );
  }
}

class _FormsColumn extends StatelessWidget {
  const _FormsColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            'assets/no-image-available.png',
            fit: BoxFit.cover,
          ),
        ),
        const CustomTextForm(
          hintText: 'Nombre del evento',
        ),
        const CustomTextForm(
          hintText: 'Fecha y hora',
          type: TextInputType.datetime,
        ),
        const CustomTextForm(
          hintText: 'Descripción',
          maxLines: 5,
          type: TextInputType.multiline,
        ),
        const EventCreator(
          creatorUsername: 'Creador',
        ),
      ],
    );
  }
}
