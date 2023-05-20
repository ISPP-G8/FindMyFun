import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

import '../../services/services.dart';
import '../../themes/colors.dart';

class PaymentViewBusiness extends StatefulWidget {
  const PaymentViewBusiness({super.key});

  @override
  State<PaymentViewBusiness> createState() => _PaymentViewBusinessState();
}

class _PaymentViewBusinessState extends State<PaymentViewBusiness> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ProjectColors.tertiary,
          title: const Text(
            'Pago por PayPal',
          ),
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
                              // ignore: avoid_print
                              print("onSuccess: $params");
                              await SubscriptionService().changePlanToCompany(
                                  await UsersService().getCurrentUserWithUid());
                            },
                            onError: (error) {
                              // ignore: avoid_print
                              print("onError: $error");
                              Navigator.pushNamed(context, 'middle');
                            },
                            onCancel: (params) {
                              // ignore: avoid_print
                              print('cancelled: $params');
                              Navigator.pushNamed(context, 'middle');
                            }),
                      ),
                    )
                  },
              child: const Text("Realizar pago")),
        ));
  }
}
