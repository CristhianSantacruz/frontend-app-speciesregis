import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/constant/constant.dart';
import 'package:frontend_spaceregis/presentation/widget/text_form_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {}

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.black],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: mediaSize.height * 0.05,
                child: Container(
                  width: mediaSize.width,
                  decoration: BoxDecoration(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Regresar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Container(
                            width: mediaSize.width,
                            height: 100,
                            decoration: BoxDecoration(),
                            child: Center(child: Image.asset(logoPng)),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              "Registrate",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(bottom: 0, child: _buildBottom(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: mediaSize.height * 0.80),
      child: SizedBox(
        width: mediaSize.width,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Card(
            margin: const EdgeInsets.all(0),
            color: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _buildLoginForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Center(
                child: const Text(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  "\"En Fehierro, combinamos experiencias,calidad y compromiso\"",
                ),
              ),
              const SizedBox(height: 5),

              const SizedBox(height: 8),

              SecondTextFormField(
                validatorForm: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
                hintText: "Nombre",
                controller: firstNameController,
                focusNodeForm: _firstNameFocusNode,
                onFieldSubmittedForm: (value) {
                  FocusScope.of(context).requestFocus(_lastNameFocusNode);
                },
              ),
              const SizedBox(height: 12),
              SecondTextFormField(
                validatorForm: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El apellido es obligatorio';
                  }
                  return null;
                },
                hintText: "Apellido",
                controller: lastNameController,
                focusNodeForm: _lastNameFocusNode,
                onFieldSubmittedForm: (value) {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
              ),
              const SizedBox(height: 12),
              SecondTextFormField(
                validatorForm: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El correo es obligatorio';
                  }
                  final emailRegex = RegExp(
                    r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                  );

                  if (!emailRegex.hasMatch(value)) {
                    return 'Ingresa un correo válido';
                  }
                  return null;
                },
                hintText: 'Correo electrónico',
                controller: emailController,
                focusNodeForm: _emailFocusNode,
                onFieldSubmittedForm: (value) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
              const SizedBox(height: 12),
              SecondTextFormField(
                isPassword: true,
                validatorForm: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La contraseña es obligatoria';
                  }
                  if (value != confirmPasswordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
                hintText: 'Contraseña',
                controller: passwordController,
                focusNodeForm: _passwordFocusNode,
                onFieldSubmittedForm: (value) {
                  FocusScope.of(
                    context,
                  ).requestFocus(_confirmPasswordFocusNode);
                },
              ),
              const SizedBox(height: 12),
              SecondTextFormField(
                isPassword: true,
                validatorForm: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirmar la contraseña es obligatoria';
                  }
                  if (value != passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
                hintText: 'Confirmar contraseña',
                controller: confirmPasswordController,
                focusNodeForm: _confirmPasswordFocusNode,
                onFieldSubmittedForm: (value) {
                  FocusScope.of(context).unfocus();
                },
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 10),
              // Botón de Login
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _register().then((value) {});
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Llena todos los campos'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Registrate'),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
