import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/constant/constant.dart';
import 'package:frontend_spaceregis/core/routes/app_routes.dart';
import 'package:frontend_spaceregis/data/model/species_model.dart';
import 'package:frontend_spaceregis/data/services/species_services.dart';
import 'package:frontend_spaceregis/presentation/widget/button_app.dart';
import 'package:frontend_spaceregis/presentation/widget/toast/toast_service.dart';
import 'package:frontend_spaceregis/presentation/widget/toast/toast_types.dart';

class SpeciesDetailPage extends StatefulWidget {
  final String? speciesId;

  const SpeciesDetailPage({super.key, required this.speciesId});

  @override
  State<SpeciesDetailPage> createState() => _SpeciesDetailPageState();
}

class _SpeciesDetailPageState extends State<SpeciesDetailPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;
  final _speciesServices = SpeciesServices();
  SpeciesModel? speciesModel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchSpecies();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showAppBarTitle) {
      setState(() => _showAppBarTitle = true);
    } else if (_scrollController.offset <= 200 && _showAppBarTitle) {
      setState(() => _showAppBarTitle = false);
    }
  }

  void _fetchSpecies() async {
    final species = await _speciesServices.fetchSpeciesDetail(
      widget.speciesId!,
    );
    setState(() {
      speciesModel = species;
      _isLoading = false;
    });
  }

  void _deleteSpecies() async {
    final bool = await _speciesServices.deleteSpecies(widget.speciesId!);
    if (bool) {
      ToastService.show(
        context: context,
        type: ToastType.success,
        title: 'Especie eliminada',
        message: 'Especie eliminada con éxito',
      );
      Navigator.pushReplacementNamed(context, dashboardScreen);
    } else {
      ToastService.show(
        context: context,
        type: ToastType.error,
        title: '!Ups!',
        message: 'Ocurrió un error al eliminar la especie',
      );
    }
  }

  // este debemos poner cuando ya se conecte con la base de datos

  Widget _buildImageWidget() {
    if (speciesModel?.imageBase64 != null) {
      try {
        final bytes = base64Decode(speciesModel!.imageBase64!);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } catch (e) {
        return _buildPlaceholderImage();
      }
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green[100]!, Colors.green[200]!],
        ),
      ),
      child: const Center(
        child: Icon(Icons.pets, size: 80, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // AppBar con imagen hero
                  SliverAppBar(
                    expandedHeight: 350,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.white,
                    title: AnimatedOpacity(
                      opacity: _showAppBarTitle ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        speciesModel?.name ?? 'Especie',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    leading: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: greenColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Imagen principal
                          Hero(
                            tag: 'species_${speciesModel?.name}',
                            child: _buildImageWidget(),
                          ),
                          // Gradiente overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                                stops: const [0.6, 1.0],
                              ),
                            ),
                          ),
                          // Nombre en la parte inferior
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (speciesModel?.name != null)
                                  Text(
                                    speciesModel?.name! ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0, 2),
                                          blurRadius: 4,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                  ),
                                if (speciesModel?.scientificName != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      speciesModel?.scientificName ?? '',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        shadows: const [
                                          Shadow(
                                            offset: Offset(0, 1),
                                            blurRadius: 2,
                                            color: Colors.black54,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Contenido principal
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Información básica
                            _buildInfoSection(),

                            if (speciesModel?.description != null) ...[
                              const SizedBox(height: 32),
                              _buildDescriptionSection(),
                            ],

                            if (speciesModel?.characteristic != null) ...[
                              const SizedBox(height: 32),
                              _buildCharacteristicsSection(),
                            ],
                            const SizedBox(height: 15),
                            ButtonApp(
                              text: "Eliminar",
                              colorText: Colors.white,
                              backgroundColor: Colors.red,
                              onPressed: () {
                                _deleteSpecies();
                              },
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, color: greenColor, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Información General',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (speciesModel?.habitat != null)
          _buildInfoCard(
            icon: Icons.location_on,
            title: 'Hábitat',
            content: speciesModel?.habitat! ?? "",
            color: Colors.teal,
          ),

        if (speciesModel?.scientificName != null)
          _buildInfoCard(
            icon: Icons.science,
            title: 'Nombre Científico',
            content: speciesModel?.scientificName! ?? "",
            color: Colors.lightGreen,
          ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.description, color: greenColor, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Descripción',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            speciesModel?.description! ?? "",

            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCharacteristicsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome, color: greenColor, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Características',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Text(
            speciesModel?.characteristic! ?? "",

            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required MaterialColor color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color[700]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
