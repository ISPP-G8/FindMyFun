import 'package:findmyfun/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';

class RegisterViewPlan extends StatelessWidget {
  const RegisterViewPlan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          LoginTitle(text: 'REGISTRO'),
          ImageLogo(),
          LoginContainer(
            child: _RegisterFormContainer(),
          )
        ],
      ),
    );
  }
}

class _RegisterFormContainer extends StatefulWidget {
  const _RegisterFormContainer();

  @override
  State<_RegisterFormContainer> createState() => _RegisterFormContainerState();
}

class _RegisterFormContainerState extends State<_RegisterFormContainer> {
  bool isCompany = false;
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print(isCompany);
    return Column(children: [
      GestureDetector(
        onTap: () => setState(() {
          isCompany = false;
        }),
        child: _PlanContainer(
          title: 'Soy un usuario',
          subtitle:
              'Crea y únete a eventos creados por empresas u otros usuarios',
          firstPrice: '0€ al mes',
          secondPrice: '6,99€ al mes',
          selected: !isCompany,
        ),
      ),
      GestureDetector(
        onTap: () => setState(() {
          isCompany = true;
        }),
        child: _PlanContainer(
          title: 'Soy una empresa',
          subtitle:
              'Crea eventos como empresa sin ningún límite y registra tu establecimiento como punto de interés',
          firstPrice: '29,99,€ al mes',
          secondPrice: '',
          selected: isCompany,
        ),
      ),
      SubmitButton(
        text: 'CONTINUAR',
        onTap: () async {
          if (isCompany) {
            final userService =
                Provider.of<UsersService>(context, listen: false);
            if (userService.currentUser != null) {
              userService.currentUser!.isCompany = true;
              await userService.addItem(userService.currentUser!);
            }
          }
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, 'main');
        },
      )
    ]);
  }
}

class _PlanContainer extends StatelessWidget {
  const _PlanContainer({
    required this.title,
    required this.subtitle,
    required this.firstPrice,
    required this.secondPrice,
    required this.selected,
  });
  final String title;
  final String subtitle;
  final String firstPrice;

  final String secondPrice;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return LoginContainer(
        child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border.all(color: Colors.black, width: selected ? 5 : 0)),
            child: Column(
              children: [
                _CustomPlan(
                  title: title,
                  subtitle: subtitle,
                  firstPrice: firstPrice,
                  secondPrice: secondPrice,
                ),
              ],
            )));
  }
}

class _CustomPlan extends StatelessWidget {
  const _CustomPlan({
    required this.title,
    required this.subtitle,
    required this.firstPrice,
    required this.secondPrice,
  });

  final String title;
  final String subtitle;
  final String firstPrice;
  final String secondPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              firstPrice,
              style: const TextStyle(fontSize: 18),
            ),
            if (secondPrice.isNotEmpty)
              const Text(
                'o',
                style: TextStyle(fontSize: 18),
              ),
            if (secondPrice.isNotEmpty)
              Text(
                secondPrice,
                style: const TextStyle(fontSize: 18),
              ),
          ],
        )
      ],
    );
  }
}
