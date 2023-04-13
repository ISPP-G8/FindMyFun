import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

void main() {
  runApp(const PaymentViewUser());
}

class PaymentViewUser extends StatelessWidget {
  const PaymentViewUser({Key? key}) : super(key: key);

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
                                "AbX16roLECw5HbqfLI9Jap8DXi1dTLwPJVctqpaxDVlk6XI-rK_k6vnRZ4QRPBJmK4xxCdiqAoiDDEM3",
                            secretKey:
                                "EMzKeOeVxBcaSvhX9yQSrBlkW0mpOMxGOxcGjS_IKUNfXNOlZ_7WaJ_iS1-aNsjbMt2ouEepBchgUJ8L",
                            returnURL: "https://samplesite.com/return",
                            cancelURL: "https://samplesite.com/cancel",
                            transactions: const [
                              {
                                "amount": {
                                  "total": '3.99',
                                  "currency": "EUR",
                                  "details": {
                                    "subtotal": '3.99',
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
                                      "name": "Plan de usuario premium",
                                      "quantity": 1,
                                      "price": '3.99',
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
                              Navigator.pushNamed(context, 'middle');
                              // Poner la subscripcion aqui cuando se haga
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
              child: const Text("Make Payment")),
        ));
  }
}
