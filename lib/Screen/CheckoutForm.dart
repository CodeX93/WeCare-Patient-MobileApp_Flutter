import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:wecare_patient_mobile/Widgets/CustomScreenAppBar.dart';

import '../Functions/Payment/stripe.dart';

class CheckOutForm extends StatelessWidget {
  const CheckOutForm({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomScreenAppBar(title: 'Make Payment'),
      body: Column(
        children: [
          CardFormField(
            controller: CardFormEditController(),
          ),
          ElevatedButton(
              onPressed: () {
              },
              child: const Text('Pay Now')),
        ],
      ),
    );
  }
}
