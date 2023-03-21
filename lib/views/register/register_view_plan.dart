import 'package:flutter/material.dart';

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

class _RegisterFormContainer extends StatelessWidget {
  const _RegisterFormContainer();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const _PlanContainer(
        title: 'Soy un usuario',
        subtitle:
            'Crea y únete a eventos creados por empresas u otros usuarios',
        firstPrice: '0€ al mes',
        secondPrice: '3,99€ al mes',
      ),
      const _PlanContainer(
          title: 'Soy una empresa',
          subtitle:
              'Crea eventos como empresa sin ningún límite y registra tu establecimiento como punto de interés',
          firstPrice: '9,99€ al mes',
          secondPrice: ''),
      SubmitButton(
        text: 'CONTINUAR',
        onTap: () => Navigator.pushReplacementNamed(context, 'main'),
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
  });
  final String title;
  final String subtitle;
  final String firstPrice;

  final String secondPrice;

  @override
  Widget build(BuildContext context) {
    return LoginContainer(
        child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.white),
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
