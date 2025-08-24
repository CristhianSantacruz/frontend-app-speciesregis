class SpeciesModel {
  final String? characteristic;
  final String? description;
  final String? habitat;
  final String? imageBase64;
  final String? name;
  final String? scientificName;
  final String? id;

  SpeciesModel({
    this.characteristic,
    this.description,
   this.habitat,
     this.imageBase64,
     this.name,
     this.scientificName,
     this.id,
  });

  factory SpeciesModel.fromJson(Map<String, dynamic> json) {
    return SpeciesModel(
      characteristic: json['characteristic'] ?? '',
       name: json['name'] ?? '',
      scientificName: json['scientific_name'] ?? '',
      description: json['description'] ?? '',
      habitat: json['habitat'] ?? '',
      imageBase64: json['image_base64'] ?? '',
      id : json['id'] ?? '',
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'characteristic': characteristic,
      'name': name,
      'scientific_name': scientificName,
      'description': description,
      'habitat': habitat,
      'image_base64': imageBase64,
    };
  }
}
