import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import '../../dto/CategoryDTO.dart';

class CategoryList extends StatelessWidget {
  final List<CategoryDTO> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const CategoryList({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final c = categories[index];

        return GestureDetector(
          onTap: () => onSelect(index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: index == selectedIndex ? Colors.grey[350] : Colors.white,
            ),
            margin: const EdgeInsets.symmetric(vertical: 1),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: Platform.isAndroid ? 10 : 35,
                horizontal: 2,
              ),
              child: Column(
                children: [
                  Image.asset(
                    c.icon.toString(),
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      c.name.toString(),
                      softWrap: true,
                      style: TextStyle(
                        height: 0,
                        fontWeight: index == selectedIndex
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
