import 'package:expense_tracker/data/provider/provider_.dart';
import 'package:expense_tracker/presentation/components/btn.dart';
import 'package:expense_tracker/presentation/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<UiProvider>(
                builder: (context, UiProvider notifier, child) {
              return Btn(
                  label: "SIGN OUT",
                  press: () {
                    notifier.logout(context);
                  },
                  txtColor: bgColor,
                  fontWeight: FontWeight.bold,
                  backgroundColor: primaryColor);
            })
          ],
        ),
      ),
    );
  }
}
