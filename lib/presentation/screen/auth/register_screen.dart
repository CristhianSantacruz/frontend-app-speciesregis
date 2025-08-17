
import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/constant/constant.dart';
import 'package:frontend_spaceregis/presentation/widget/text_form_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Register Page')));
  }
}