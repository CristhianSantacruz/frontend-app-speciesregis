import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/constant/constant.dart';
import 'package:frontend_spaceregis/core/routes/app_routes.dart';
import 'package:frontend_spaceregis/data/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalAccount extends StatefulWidget {
 

  const PersonalAccount({super.key});

  @override
  State<PersonalAccount> createState() => _PersonalAccountState();
}

class _PersonalAccountState extends State<PersonalAccount> {
  UserData? currentUser;
  bool isLoadingUser = true;
  bool isLogged = false;
  @override
  void initState() {
    super.initState();
    checkLogged();
  }

  void checkLogged()  async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isLoggedIn") == true) {
       _loadUserData();
    } else {
      setState(() => isLogged = false);
    }
  }

  Future<void> _loadUserData() async {
    
   

    try {
      final authService = AuthService();
      final userProfile = await authService.getUserProfile();

      if (userProfile.isSuccess && mounted) {
        setState(() {
          currentUser = userProfile.userData;
          isLoadingUser = false;
          isLogged = true;
        });
      } else {
        setState(() => isLoadingUser = false);
      }
    } catch (e) {
      setState(() => isLoadingUser = false);
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", false);
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingUser) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isLogged == false) {
      return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Debes iniciar sesión para ver tu perfil."),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text("Ir a Iniciar Sesión"),
              ),
            ],
          ),
        
      );
    }

    // Si está logeado y tenemos datos del usuario
    final user = currentUser;
    if (user == null) {
      return const Center(child: Text("No se pudieron cargar los datos."));
    }

    return  Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar con la inicial
            CircleAvatar(
              radius: 40,
              backgroundColor: greenColorLow1,
              child: Text(
                user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : "?",
                style: const TextStyle(fontSize: 32,color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            // Nombre completo
            Text(
              user.fullName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Email
            Row(
              children: [
                const Icon(Icons.email, size: 20),
                const SizedBox(width: 8),
                Text(user.email),
              ],
            ),
            const SizedBox(height: 10),

            // Teléfono
            Row(
              children: [
                const Icon(Icons.phone, size: 20),
                const SizedBox(width: 8),
                Text(user.phone),
              ],
            ),

            const SizedBox(height: 40,),

            // Botón Cerrar Sesión
            ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text("Cerrar sesión"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
  }

}
