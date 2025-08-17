import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/constant/constant.dart';
import 'package:frontend_spaceregis/data/model/species_model.dart';

class SpeciesDetailPage extends StatefulWidget {
  final SpeciesModel speciesModel;

  const SpeciesDetailPage({super.key, required this.speciesModel});

  @override
  State<SpeciesDetailPage> createState() => _SpeciesDetailPageState();
}

class _SpeciesDetailPageState extends State<SpeciesDetailPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text('Species Detail Page')));
}}