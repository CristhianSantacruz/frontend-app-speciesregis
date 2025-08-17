
import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/constant/constant.dart';
import 'package:frontend_spaceregis/core/routes/app_routes.dart';
import 'package:frontend_spaceregis/data/model/intro_model.dart';
import 'package:frontend_spaceregis/presentation/widget/button_app.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  List<IntroPageModel> introPageModels = [
    IntroPageModel(
      title: "CONSTRUCCIÓN EFICIENTE",
      description:
          "Facilita cálculos precisos y optimiza cada etapa de tu proyecto. Genera reportes y resúmenes en PDF para mantener todo bajo control.",
      image: imageParrot
    ),
    IntroPageModel(
      title: "PLANEA Y GESTIONA TUS PROYECTOS",
      description:
          "Crea y organiza proyectos de construcción desde la idea hasta la ejecución. Lleva el seguimiento completo de cada etapa desde una sola plataforma.",
      image: imageParrot
    ),
    IntroPageModel(
      title: "CONSEJOS Y RECURSOS",
      description:
          "Accede a recomendaciones prácticas y soporte técnico profesional. Aprende sobre distintos tipos de construcción y mejora tus procesos día a día.",
      image: imageParrot
    ),
  ];

  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int page = _pageController.page!.round();
      if (page != currentPage) {
        setState(() {
          currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (currentPage < introPageModels.length - 1) {
      _pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
       Navigator.pushReplacementNamed(context, dashboardScreen);
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      _pageController.animateToPage(
        currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipIntro() {
     Navigator.pushReplacementNamed(context, dashboardScreen);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // boton de saltar en la esquina derecha

          // Imagen de fondo
          SizedBox(
            height: size.height * 0.55,
            width: size.width,
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _pageController,
              itemCount: introPageModels.length,
              itemBuilder: (context, index) {
                final introPageModel = introPageModels[index];
                return Image.asset(introPageModel.image, fit: BoxFit.fill);
              },
            ),
          ),
          // Contenido desde abajo
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! < 0) {
                  _previousPage();
                } else if (details.primaryVelocity! > 0) {
                  _nextPage();
                }
              }
            },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: size.width,
                height: size.height * 0.55,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Column(
                          key: ValueKey(currentPage),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                introPageModels[currentPage].title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: greenColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Text(
                                introPageModels[currentPage].description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            SmoothPageIndicator(
                              controller: _pageController,
                              count: introPageModels.length,
                              effect: ExpandingDotsEffect(
                                activeDotColor: Colors.black,
                                dotColor: Colors.grey,
                                dotHeight: 4,
                                dotWidth: 8,
                                expansionFactor: 3.5,
                                spacing: 10,
                              ),
                              onDotClicked: (index) {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ButtonApp(
                              text: currentPage == 0 ? "Saltar" : "Anterior",
                              colorText: Colors.black,
                              backgroundColor: Colors.white,
                              onPressed: currentPage == 0
                                  ? _skipIntro
                                  : _previousPage,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ButtonApp(
                              text: currentPage == introPageModels.length - 1
                                  ? "Comenzar"
                                  : "Siguiente",
                              colorText: Colors.white,
                              backgroundColor: greenColor,
                              onPressed: _nextPage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 20,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: greenColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                _skipIntro();
              },
              child: Text(
                "Saltar",
                style: TextStyle(color: greenColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Empieza desde abajo a la izquierda
    path.moveTo(0, 60);

    // Dibuja curva hacia la derecha
    path.quadraticBezierTo(
      size.width / 2,
      -40, // punto de control
      size.width,
      60, // punto final
    );

    // Completa el rectángulo
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}