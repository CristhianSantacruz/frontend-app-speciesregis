import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/constant/constant.dart';
import 'package:frontend_spaceregis/data/model/species_model.dart';
import 'package:frontend_spaceregis/data/services/species_services.dart';
import 'package:frontend_spaceregis/presentation/screen/fragment/species_details.dart';
import 'package:frontend_spaceregis/presentation/widget/category_item.dart';
import 'package:frontend_spaceregis/presentation/widget/species_card.dart';

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
    _fetchHabitats();

  }

  final List<String> habitats = [];
  bool _isLoadingHabitats = true;

  final List<SpeciesModel> species = [
    SpeciesModel(
      characteristic: "Este animal es de la familia de los lagos",
      description:
          "Este animal es de la familia de los lagos, son los lagos de agua y el agua de los lagos. Son los lagos de agua y el agua de los lagos.",
      habitat: "Lago",
      imageBase64: imageMonkey,
      name: "Monkey Monkey",
      scientificName: "Lago",
    ),
    SpeciesModel(
      characteristic: "Este animal es de la familia de los lagos",
      description:
          "Este animal es de la familia de los lagos, son los lagos de agua y el agua de los lagos. Son los lagos de agua y el agua de los lagos.",
      habitat: "Lago",
      imageBase64: imageMonkey,
      name: "Monkey Monkey",
      scientificName: "Lago",
    ),
  ];

  Future<void> _fetchHabitats() async {
    setState(() {
      _isLoadingHabitats = true;
    });
    final habitats = await _speciesServices.fetchHabitats();
    setState(() {
      this.habitats.addAll(habitats);
      _isLoadingHabitats = false;
    });
  }
  


  @override
  Widget build(BuildContext context) {
    return _isLoadingHabitats ? const Center(child: CircularProgressIndicator()) : Padding(
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
                    onChanged: (value) {},
                    onFieldSubmitted: (value) {
                      _focusNodeSearch.unfocus();
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
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
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(DEFFAULT_RADIUS),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: greenColor, width: 1),
                        borderRadius: BorderRadius.circular(DEFFAULT_RADIUS),
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
                onPressed: () {},
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
                return GestureDetector(
                  onTap: () {},
                  child: CategoryItem(
                    name: habitats[index],
                    onTapButon: () {},
                    color: greenColor,
                  ),
                );
              },
            ),
          ),

          
        

          const SizedBox(height: 10),
          Text(
            "Especies (115)",
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
                    (MediaQuery.of(context).size.height / 1.58),
                crossAxisSpacing: 10,
                mainAxisSpacing: 16,
              ),
              itemCount: species.length,
              itemBuilder: (context, index) {
                return SpeciesCard(
                  speciesModel: species[index],
                  onTapDetails: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:(context) =>
                                SpeciesDetailPage(speciesModel: species[index]),
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
