
import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/constant/constant.dart';

class CategoryItem extends StatelessWidget {
  final String name;
  final Color color;
  final bool? isSelected;
  final void Function()? onTapButon;
  const CategoryItem(
      {super.key,
      required this.name,
      required this.onTapButon,
      required this.color,
      this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapButon,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(DEFFAULT_RADIUS),
        ),
        child: Center(
          child: Row(
            children: [
              Text(name, style: TextStyle(color: Colors.white, fontSize: 13)),
              if (isSelected == true && name != "Todas")
                Icon(Icons.arrow_right, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

