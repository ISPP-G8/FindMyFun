import 'package:findmyfun/helpers/helpers.dart';
import 'package:findmyfun/services/page_view_service.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/ui/custom_snackbars.dart';
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
          // Lo dejo comentado por si se quiere usar en el futuro para probar funcionalidades
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {

          //   },
          // ),

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
          body: SingleChildScrollView(
            child: Column(
              children: [
                //  LoginTitle(text: 'INICIO DE SESIÓN'),
                const ImageLogo(),
                const SizedBox(
                  height: 100,
                ),
          
                const LoginContainer(
                  child: _FormsColumn(),
                ),
                TextButton(
                    onPressed: () => Navigator.pushNamed(context, 'register'),
                    child: const Text('¿No tienes cuenta?'))
              ],
            ),
          )),
    );
  }
}

class _FormsColumn extends StatefulWidget {
  const _FormsColumn({
    super.key,
  });

  @override
  State<_FormsColumn> createState() => _FormsColumnState();
}

class _FormsColumnState extends State<_FormsColumn> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            CustomTextForm(
              hintText: 'Usuario',
              controller: _userController,
              validator: (value) => Validators.validateNotEmpty(value),
            ),
            CustomTextForm(
              hintText: 'Contraseña',
              obscure: true,
              controller: _passwordController,
              validator: (value) => Validators.validateNotEmpty(value),
            ),
            SubmitButton(
                text: 'CONTINUAR',
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Iniciar sesión y mandar al home page

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
                    await Future.delayed(Duration(seconds: 1));
                    Navigator.pushReplacementNamed(context, 'main');
                  } else {
                    CustomSnackbars.showCustomSnackbar(
                      context,
                      const Text('Rellene los campos'),
                    );
                  }
                })
          ],
        ));
  }
}
