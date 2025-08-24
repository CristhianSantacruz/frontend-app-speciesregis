import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/constant/constant.dart';
import 'package:frontend_spaceregis/data/services/species_services.dart';
import 'package:frontend_spaceregis/presentation/screen/dashboard/dashboard_screen.dart';
import 'package:frontend_spaceregis/presentation/widget/primary_text_form_widget.dart';
import 'package:frontend_spaceregis/presentation/widget/toast/toast_service.dart';
import 'package:frontend_spaceregis/presentation/widget/toast/toast_types.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateSpecies extends StatefulWidget {
  const CreateSpecies({super.key});

  @override
  State<CreateSpecies> createState() => _CreateSpeciesState();
}

class _CreateSpeciesState extends State<CreateSpecies> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Variables para manejo de imagen
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoadingImage = false;

  // key del formulario
  final _formKey = GlobalKey<FormState>();

  // tex form filed  para el registro de una especie
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _scientificNameController =
      TextEditingController();
  final TextEditingController _habitatController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _characteristicController =
      TextEditingController();

  // FOCUS NODES
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _scientificNameFocusNode = FocusNode();
  final FocusNode _habitatFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _characteristicFocusNode = FocusNode();

  List<String> _habitats = [];
  bool _isLoadingHabitats = true;

  @override
  void initState() {
    super.initState();
    _loadHabitats();
  }

  Future<void> _loadHabitats() async {
    try {
      _habitats = await SpeciesServices().fetchHabitats();
      _isLoadingHabitats = false;
      setState(() {});
    } catch (e) {
      // Maneja el error
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _scientificNameController.dispose();
    _habitatController.dispose();
    _descriptionController.dispose();
    _characteristicController.dispose();
  }

  void _nextStep() {
    if (_currentStep < 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // método de creación de la especie
      _createSpecies();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Método para solicitar permisos
  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> permissions =
        await [Permission.camera, Permission.photos].request();

    return permissions[Permission.camera]!.isGranted ||
        permissions[Permission.photos]!.isGranted;
  }

  // Método para mostrar opciones de imagen
  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Seleccionar imagen',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Tomar foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: greenColor),
                title: const Text('Seleccionar de galería'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_selectedImage != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Eliminar imagen'),
                  onTap: () {
                    Navigator.pop(context);
                    _removeImage();
                  },
                ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Método para seleccionar imagen
  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _isLoadingImage = true;
      });

      // Solicitar permisos
      bool hasPermission = await _requestPermissions();
      if (!hasPermission) {
        _showPermissionDialog();
        return;
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showErrorDialog('Error al seleccionar imagen: $e');
    } finally {
      setState(() {
        _isLoadingImage = false;
      });
    }
  }

  // Método para eliminar imagen
  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  // Método para mostrar diálogo de permisos
  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permisos necesarios'),
          content: const Text(
            'Para usar esta función, necesitas conceder permisos de cámara y galería en la configuración de la aplicación.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              child: const Text('Configuración'),
            ),
          ],
        );
      },
    );
  }

  // Método para mostrar errores
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Método para crear la especie (implementar según tu lógica)
  void _createSpecies() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una imagen para la especie'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      final bool = await SpeciesServices().registerSpecies(
        name: _nameController.text,
        scientificName: _scientificNameController.text,
        description: _descriptionController.text,
        characteristic: _characteristicController.text,
        habitat: _habitatController.text,
        imagePath: _selectedImage!.path,
      );
      if (bool == true) {
        ToastService.show(
          context: context,
          type: ToastType.success,
          title: 'Especie creada',
          message: 'Especie creada con éxito',
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen(currentIndex: 0,)));
      } else {
        ToastService.show(
          context: context,
          type: ToastType.error,
          title: '!Ups!',
          message: 'Ocurrió un error al crear la especie',
        );
      }
    } catch (e) {
       ToastService.show(
          context: context,
          type: ToastType.error,
          title: '!Ups!',
          message: 'Ocurrió un error al crear la especie',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadingHabitats
        ? const Center(child: CircularProgressIndicator())
        : Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  for (int i = 0; i < 2; i++)
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: i < 1 ? 8 : 0),
                        height: 4,
                        decoration: BoxDecoration(
                          color: i <= _currentStep ? greenColor : Colors.grey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _currentStep == 0
                    ? "Datos de la especie"
                    : 'Imagen de la especie',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [_buildStep1(), _buildStep2()],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.blue[600]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Anterior',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _currentStep == 1 ? 'Finalizar' : 'Siguiente',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
  }

  Widget _buildStep1() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              PrimaryTextForm(
                focusNode: _nameFocusNode,
                controller: _nameController,
                label: 'Nombre',
                hintText: 'Nombre de la especie',
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_scientificNameFocusNode);
                },
              ),
              const SizedBox(height: 15),
              PrimaryTextForm(
                focusNode: _scientificNameFocusNode,
                controller: _scientificNameController,
                label: 'Nombre científico',
                hintText: 'Nombre científico de la especie',
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_habitatFocusNode);
                },
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value:
                    _habitatController.text.isNotEmpty
                        ? _habitatController.text
                        : null,
                items:
                    _habitats
                        .map(
                          (habitat) => DropdownMenuItem(
                            value: habitat,
                            child: Text(habitat),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  _habitatController.text = value ?? '';
                },
                decoration: InputDecoration(labelText: 'Hábitat'),
              ),
              const SizedBox(height: 15),
              PrimaryTextForm(
                focusNode: _descriptionFocusNode,
                controller: _descriptionController,
                label: 'Descripción',
                hintText: 'Descripción de la especie',
                maxLines: 6,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_characteristicFocusNode);
                },
              ),
              const SizedBox(height: 15),
              PrimaryTextForm(
                focusNode: _characteristicFocusNode,
                controller: _characteristicController,
                label: 'Características',
                hintText: 'Características de la especie',
                maxLines: 6,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Contenedor para mostrar la imagen o placeholder
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[50],
              ),
              child:
                  _isLoadingImage
                      ? const Center(child: CircularProgressIndicator())
                      : _selectedImage != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay imagen seleccionada',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Toca el botón de abajo para agregar una imagen',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
            ),
          ),

          const SizedBox(height: 30),

          // Botón para seleccionar imagen
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoadingImage ? null : _showImageSourceDialog,
              icon: Icon(
                _selectedImage != null ? Icons.edit : Icons.add_a_photo,
              ),
              label: Text(
                _selectedImage != null ? 'Cambiar imagen' : 'Agregar imagen',
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: greenColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          if (_selectedImage != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _removeImage,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      'Eliminar imagen',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
