import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/constant/constant.dart';
import 'package:frontend_spaceregis/core/routes/app_routes.dart';
import 'package:frontend_spaceregis/data/services/auth_service.dart';
import 'package:frontend_spaceregis/presentation/widget/text_form_widget.dart';

class LoginScreen extends StatefulWidget {
  final String? emailUserRegistered;
  final String? passwordUserRegistered;
  const LoginScreen({
    super.key,
    this.emailUserRegistered,
    this.passwordUserRegistered,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  bool osbcureText = true;

  @override
  void initState() {
    super.initState();
    if (widget.emailUserRegistered != null &&
        widget.passwordUserRegistered != null) {
      _emailController.text = widget.emailUserRegistered!;
      _passwordController.text = widget.passwordUserRegistered!;
    }
  }

  void _login() async {
    final authService = AuthService();

    try {
      final response = await authService.loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (response.isSuccess && mounted) {
        // Login exitoso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bienvenido ${response.userData?.fullName}'),
            backgroundColor: Colors.green,
          ),
        );

        // Navegar al dashboard
        Navigator.pushReplacementNamed(context, dashboardScreen);
      } else {
        // Error en el login
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
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
                top: mediaSize.height * 0.1,
                child: Container(
                  width: mediaSize.width,
                  height: mediaSize.height * 0.15,
                  decoration: BoxDecoration(),
                  child: Center(child: Image.asset(logoPng)),
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
    return SizedBox(
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
            padding: const EdgeInsets.all(34),
            child: _buildLoginForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Center(
              child: const Text(
                'Accede a tu cuenta',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: const Text(
                'Inicia sesión para continuar',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 5),

            const SizedBox(height: 8),

            SecondTextFormField(
              validatorForm: (value) {
                if (value == null || value.isEmpty) {
                  return 'El correo es obligatorio';
                }
                final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

                if (!emailRegex.hasMatch(value)) {
                  return 'Ingresa un correo válido';
                }
                return null;
              },
              hintText: 'Correo electrónico',
              controller: _emailController,
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
                return null;
              },
              hintText: 'Contraseña',
              controller: _passwordController,
              focusNodeForm: _passwordFocusNode,
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
                    _login();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Iniciar sesión'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, dashboardScreen);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Iniciar sesión sin registrarme'),
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, registerScreen);
                },
                child: RichText(
                  text: TextSpan(
                    text: "¿Aún no tienes una cuenta? ",
                    style: TextStyle(color: Colors.grey.shade600),
                    children: const [
                      TextSpan(
                        text: 'Registrate aquí',
                        style: TextStyle(
                          fontSize: 12,
                          color: greenColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
