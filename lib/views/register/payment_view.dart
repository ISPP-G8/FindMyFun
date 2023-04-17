import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

import '../../services/services.dart';

void main() {
  runApp(const PaymentViewUser());
}

class PaymentViewUser extends StatelessWidget {
  const PaymentViewUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pago por PayPal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Pago por PayPal'),
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
        body: Column(
          children: [
            Center(
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
                                  "total": '6.99',
                                  "currency": "EUR",
                                  "details": {
                                    "subtotal": '6.99',
                                    "shipping": '0',
                                    "shipping_discount": 0
                                  }
                                },
                                "description":
                                    "The payment transaction description.",
                                "item_list": {
                                  "items": [
                                    {
                                      "name": "Plan de usuario premium",
                                      "quantity": 1,
                                      "price": '6.99',
                                      "currency": "EUR"
                                    }
                                  ],

                                }
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              print("onSuccess: $params");
                              SubscriptionService().changePlanToPremium(
                                  await UsersService().getUserWithUid(
                                      AuthService().currentUser!.uid));
                            },
                            onError: (error) {
                              print("onError: $error");
                            },
                            onCancel: (params) {
                              print('cancelled: $params');
                            }),
                      ),
                    )
                  },
              child: const Text("Realizar pago"))),
          ],
          )
        );
  }
}
