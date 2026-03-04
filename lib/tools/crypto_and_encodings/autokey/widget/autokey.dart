import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/widget/vigenere.dart';

class Autokey extends StatefulWidget {
  const Autokey({super.key});

  @override
  _AutokeyState createState() => _AutokeyState();
}

class _AutokeyState extends State<Autokey> {
  @override
  Widget build(BuildContext context) {
    return Vigenere(autoKey: true);
  }
}
