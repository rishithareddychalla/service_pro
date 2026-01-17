import 'package:flutter/material.dart';

class Professional {
  final String name;
  final String role;
  final double rating;
  final double hourlyRate;
  final String imageAsset;

  Professional({
    required this.name,
    required this.role,
    required this.rating,
    required this.hourlyRate,
    required this.imageAsset,
  });
}



class Category {
  final String name;
  final IconData icon;
  final Color color;

  Category({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class Promotion {
  final String title;
  final String subtitle;
  final String discount;

  Promotion({
    required this.title,
    required this.subtitle,
    required this.discount,
  });
}
