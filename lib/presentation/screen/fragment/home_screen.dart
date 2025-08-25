import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/constant/constant.dart';
import 'package:frontend_spaceregis/data/model/species_model.dart';
import 'package:frontend_spaceregis/data/services/species_services.dart';
import 'package:frontend_spaceregis/presentation/screen/fragment/species_details.dart';
import 'package:frontend_spaceregis/presentation/widget/category_item.dart';
import 'package:frontend_spaceregis/presentation/widget/species_card.dart';
import 'package:frontend_spaceregis/presentation/widget/toast/toast_service.dart';
import 'package:frontend_spaceregis/presentation/widget/toast/toast_types.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _focusNodeSearch = FocusNode();
  final _speciesServices = SpeciesServices();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  bool _isLoading = true;

  final List<String> habitats = [];
  List<SpeciesModel> species = [];
  List<SpeciesModel> allSpecies = [];
  List<SpeciesModel> filteredSpecies = [];

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Ejecutar ambas peticiones en paralelo para optimizar
      final results = await Future.wait([
        _speciesServices.fetchHabitats(),
        _speciesServices.fetchAllSpecies(),
      ]);
      setState(() {
        habitats.clear();
        habitats.addAll(results[0] as List<String>);
        allSpecies = results[1] as List<SpeciesModel>;
        species = List.from(allSpecies); // Cambiar esta línea
        filteredSpecies = List.from(allSpecies); // Agregar esta línea
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _filterSpecies(String habitat) async {
    setState(() {
      _isLoading = true;
    });

    try {
     
      final results = await _speciesServices.fetchHabitatsByHabitat(habitat);

      setState(() {
        species = results;
        filteredSpecies = List.from(results); 
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _performSearch(String searchText) {
  if (searchText.isEmpty) {
    setState(() {
      filteredSpecies = List.from(species);
    });
    return;
  }

  setState(() {
    filteredSpecies = species.where((specie) {
      return specie.name != null && 
             specie.name!.toLowerCase().contains(searchText.toLowerCase());
    }).toList();
  });
}

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Parte del buscador de especies y boton de filtros
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        style: TextStyle(fontSize: 14),
                        textCapitalization: TextCapitalization.characters,
                        controller: _searchController,
                        focusNode: _focusNodeSearch,
                        onChanged: (value) {
                          _performSearch(value);
                        },
                        onFieldSubmitted: (value) {
                          _focusNodeSearch.unfocus();
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                          ),
                          label: Text(
                            '¿Qué buscas hoy?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          hintText: 'Buscar...',
                          prefixIcon: GestureDetector(
                            child: const Icon(Icons.search, color: Colors.grey),
                            onTap: () {
                              _focusNodeSearch.unfocus();
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(
                              DEFFAULT_RADIUS,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: greenColor, width: 1),
                            borderRadius: BorderRadius.circular(
                              DEFFAULT_RADIUS,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // mostrar una list horizontal mostrando las categorias
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Habitat",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _fetchData();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      minimumSize: const Size(0, 40),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text("Ver todas"),
                  ),
                ],
              ),

              SizedBox(
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: habitats.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final habitat = habitats[index];
                    return CategoryItem(
                      name: habitats[index],
                      onTapButon: () {
                        if (habitat == "Todas") {
                          ToastService.show(
                            context: context,
                            type: ToastType.success,
                            title: 'Perfecto',
                            message: 'Mostrando todas las especies',
                          );
                          _fetchData();
                        } else {
                          ToastService.show(
                            context: context,
                            type: ToastType.success,
                            title: 'Habitat',
                            message: 'Habitat seleccionado $habitat',
                          );
                          _filterSpecies(habitat);
                        }
                      },
                      color: greenColor,
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),
              Text(
                "Especies ${filteredSpecies.length}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:
                        MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.50),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 16,
                  ),
                itemCount: filteredSpecies.length,
                  itemBuilder: (context, index) {
                    return SpeciesCard(
                      speciesModel: filteredSpecies[index],
                      onTapDetails: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => SpeciesDetailPage(
                                  speciesId: filteredSpecies[index].id!,
                                ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
  }
}
