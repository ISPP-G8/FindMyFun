import 'package:findmyfun/services/page_view_service.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

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
            title: Text('INICIO DE SESIÓN',
                textAlign: TextAlign.center, style: Styles.appBar),
          ),
          backgroundColor: ProjectColors.primary,
          body: Column(
            children: [
              //  LoginTitle(text: 'INICIO DE SESIÓN'),
              const ImageLogo(),
              const SizedBox(
                height: 20,
              ),
              const LoginContainer(
                child: _FormsColumn(),
              ),
              TextButton(
                  onPressed: () => Navigator.pushNamed(context, 'register'),
                  child: const Text('¿No tienes cuenta?'))
            ],
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
        const CustomTextForm(
          hintText: 'Usuario',
        ),
        const CustomTextForm(
          hintText: 'Contraseña',
          obscure: true,
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
