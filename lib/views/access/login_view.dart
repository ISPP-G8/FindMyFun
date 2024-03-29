import 'package:auto_size_text/auto_size_text.dart';
import 'package:findmyfun/helpers/helpers.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/ui/custom_snackbars.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageViewController =
        Provider.of<PageViewService>(context).pageController;
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
          // Lo dejo comentado por si se quiere usar en el futuro para probar funcionalidades

          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: AutoSizeText(
              'INICIO DE SESIÓN',
              maxLines: 1,
              textAlign: TextAlign.center,
              style: Styles.appBar,
            ),
          ),
          // backgroundColor: ProjectColors.primary,
          body: SingleChildScrollView(
            child: Column(
              children: [
                //  LoginTitle(text: 'INICIO DE SESIÓN'),
                const ImageLogo(),
                SizedBox(
                  height: size.height * 0.05,
                ),
                SizedBox(
                    height: size.height * 0.1,
                    child: const AutoSizeText('¡Bienvenido a FindMyFun!',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 20))),

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
  const _FormsColumn();

  @override
  State<_FormsColumn> createState() => _FormsColumnState();
}

class _FormsColumnState extends State<_FormsColumn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final usersService = Provider.of<UsersService>(context);
    return Form(
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            CustomTextForm(
              hintText: 'Email',
              controller: _emailController,
              validator: (value) => Validators.validateEmail(value),
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

                    try {
                      UserCredential credential = await AuthService()
                          .signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text);

                      // ignore: avoid_print
                      print('User uid: ${credential.user?.uid}');
                      await usersService.getCurrentUserWithUid();
                    } on FirebaseAuthException catch (e) {
                      // ignore: avoid_print
                      print('Error al iniciar sesion $e');
                      Navigator.pop(context);
                      return;
                    } catch (e) {
                      // ignore: avoid_print
                      print('Error al iniciar sesion $e');
                      Navigator.pop(context);
                      return;
                    }

                    // await usersService.getUsers();

                    await Future.delayed(const Duration(seconds: 1));
                    // ignore: use_build_context_synchronously
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
