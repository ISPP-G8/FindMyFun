import 'package:flutter/material.dart';

class PaymentPlanView extends StatefulWidget {
  const PaymentPlanView({super.key});

  @override
  _PaymentPlanViewState createState() => _PaymentPlanViewState();
}

class _PaymentPlanViewState extends State<PaymentPlanView> {
  final _formKey = GlobalKey<FormState>();
  String _cardNumber = '';
  String _expirationDate = '';
  String _cvv = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Introducir Credenciales'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Introducir credenciales',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 35.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Número de tarjeta',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el número de la tarjeta';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _cardNumber = value;
                  });
                },
              ),
              Row(children: [
                Expanded(
                    child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Fecha de expiración',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese la fecha de expiración';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _expirationDate = value;
                    });
                  },
                )),
                SizedBox(width: 12.0),
                Expanded(
                    child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'CVV',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese el CVV';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _cvv = value;
                    });
                  },
                ))
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Validación pasada, hacer algo con los datos
                      print('Número de tarjeta: $_cardNumber');
                      print('Fecha de expiración: $_expirationDate');
                      print('CVV: $_cvv');
                    }
                  },
                  child: Text('Procesar Pago'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
