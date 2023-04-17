import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

import '../../services/services.dart';

void main() {
  runApp(const PaymentViewBusiness());
}

class PaymentViewBusiness extends StatelessWidget {
  const PaymentViewBusiness({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Paypal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Paypal'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: TextButton(
              onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => UsePaypal(
                            sandboxMode: true,
                            clientId:
                                "AVms00YqTZIS903hvPbYKGuSa2r2VqoIxTYwLPrAC9qzf8WURLrIhDLC0tSj9oxzqIMv7yARU3EQFfk3",
                            secretKey:
                                "EGEtmyXGE3pLlgwFsvMTZH1Jl90c-g2y3DzOx8Hb9OtwGvHK3QNgh6zwz7uZUPFEXmBj6RH9ZDew8fHP",
                            returnURL: "https://samplesite.com/return",
                            cancelURL: "https://samplesite.com/cancel",
                            transactions: const [
                              {
                                "amount": {
                                  "total": '19.99',
                                  "currency": "EUR",
                                  "details": {
                                    "subtotal": '19.99',
                                    "shipping": '0',
                                    "shipping_discount": 0
                                  }
                                },
                                "description":
                                    "The payment transaction description.",
                                // "payment_options": {
                                //   "allowed_payment_method":
                                //       "INSTANT_FUNDING_SOURCE"
                                // },
                                "item_list": {
                                  "items": [
                                    {
                                      "name": "Plan de empresa premium",
                                      "quantity": 1,
                                      "price": '19.99',
                                      "currency": "EUR"
                                    }
                                  ],

                                  // shipping address is not required though
                                }
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              print("onSuccess: $params");
                              await SubscriptionService().changePlanToCompany(
                                  await UsersService().getUserWithUid(
                                      AuthService().currentUser!.uid));
                            },
                            onError: (error) {
                              print("onError: $error");
                              Navigator.pushNamed(context, 'middle');
                            },
                            onCancel: (params) {
                              print('cancelled: $params');
                              Navigator.pushNamed(context, 'middle');
                            }),
                      ),
                    )
                  },
              child: const Text("Make Payment")),
        ));
  }
}
