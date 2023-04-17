import 'package:findmyfun/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';

class RegisterUserPlan extends StatelessWidget {
  const RegisterUserPlan({
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
  SubscriptionService subscriptionService = SubscriptionService();
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
          title: 'Soy un usuario premium',
          subtitle:
              'Crea y únete a eventos creados por empresas u otros usuarios con total libertad',
          firstPrice: '6.99€ al mes',
          secondPrice: '',
          selected: !isCompany,
        ),
      ),
      GestureDetector(
        onTap: () => setState(() {
          isCompany = true;
        }),
        child: _PlanContainer(
          title: 'Soy una usuario normal',
          subtitle:
              'Crea y únete a eventos creados por empresas u otros usuarios con limitaciones',
          firstPrice: '0€ al mes',
          secondPrice: '',
          selected: isCompany,
        ),
      ),
      SubmitButton(
        text: 'CONTINUAR',
        onTap: () async {
          if (isCompany) {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, 'middle');
          } else {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, 'paymentUser');
          }
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
