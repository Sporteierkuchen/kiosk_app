import 'package:flutter/material.dart';

class HeaderImage extends StatelessWidget {
  final String assetPath;
  const HeaderImage({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      color: Colors.transparent,
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
