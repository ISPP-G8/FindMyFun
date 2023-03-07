import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:findmyfun/services/page_view_service.dart';
import 'package:findmyfun/widgets/widgets.dart';

import '../../themes/colors.dart';
import '../../themes/styles.dart';

class UpdateEventView extends StatelessWidget {
  const UpdateEventView({super.key});

  @override
  Widget build(BuildContext context) {
    final pageViewController =
        Provider.of<PageViewService>(context).pageController;

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
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
            title: Text('MODIFICAR EVENTO',
                textAlign: TextAlign.center, style: Styles.appBar),
          ),
          backgroundColor: ProjectColors.primary,
          body: const SingleChildScrollView(
            child: LoginContainer(
              child: _FormsColumn(),
            ),
          )),
    );
  }
}

class _FormsColumn extends StatelessWidget {
  const _FormsColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        EventPhotoPicker(),
        const CustomTextForm(
          hintText: 'Nombre del evento',
        ),
        const CustomTextForm(
          hintText: 'Lugar',
        ),
        const CustomTextForm(
          hintText: 'Descripción',
          maxLines: 5,
          type: TextInputType.multiline,
        ),
        const CustomTextForm(
          hintText: 'Fecha',
          type: TextInputType.datetime,
        ),
        const CategoryDropdown(),
        const CustomCheckbox(
          checkboxText: '¿Evento privado?',
        ),
        SubmitButton(
            text: 'CONTINUAR',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator()),
                    ]),
              );
            })
      ],
    );
  }
}
