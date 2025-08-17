import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/constant/constant.dart';
import 'package:frontend_spaceregis/core/routes/app_routes.dart';
import 'package:frontend_spaceregis/presentation/screen/fragment/create_species.dart';
import 'package:frontend_spaceregis/presentation/screen/fragment/home_screen.dart';
import 'package:frontend_spaceregis/presentation/screen/fragment/personal_account.dart';

class DashboardScreen extends StatefulWidget {
  final int? currentIndex;
  const DashboardScreen({super.key, this.currentIndex = 0});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const CreateSpecies(),
    const PersonalAccount(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setIndexCurrent(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(logoPng),
                        ),

                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Hola, Cristhian",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, loginScreen);
            },
            icon: const Icon(Icons.login,color: Colors.white,),
          ),  
        ],  
      ),
      body: _pages[currentIndex],

      bottomNavigationBar: BottomAppBar(
        
        color: greenColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Botón Home
            GestureDetector(
              onTap: () {
                _setIndexCurrent(0);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child:
                    currentIndex == 0
                        ? ActiveContainer(iconData: Icons.home)
                        : Icon(
                          Icons.home,
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          size: 35,
                        ),
              ),
            ),

            const SizedBox(width: 40), // Espacio para el FAB
            // Botón Profile
            GestureDetector(
              onTap: () {
                _setIndexCurrent(2);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child:
                    currentIndex == 2
                        ? ActiveContainer(iconData: Icons.person)
                        : Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 35,
                        ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          shape: StadiumBorder(),
          onPressed: () {
            _setIndexCurrent(1);
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.add, color: greenColorLow3, size: 40),
        ),
      ),
    );
  }
}

class ActiveContainer extends StatelessWidget {
  final IconData? iconData;
  final String? imageAsset;
  const ActiveContainer({super.key, this.iconData, this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child:
          iconData != null
              ? Icon(iconData, color: Colors.white, size: 35)
              : Image.asset(
                imageAsset ?? "",
                fit: BoxFit.contain,
                height: 20,
                color: Colors.white,
              ),
    );
  }
}
