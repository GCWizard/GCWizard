import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/utils/constants.dart';

enum ElementsOfGeocachingType { GEO_MAG, CONTAINERS, GPS, TYPES, INERT, GROUND_SPEAK, VARIATIONS }

enum ElementsOfGeocachingCategory {
  ELEMENT_NAME,
  CHEMICAL_SYMBOL,
  ATOMIC_NUMBER,
  GROUP,
  PERIOD,
  TYPE
}

class ElementsOfGeocachingColor {
  Color color;
  String name;

  ElementsOfGeocachingColor(this.color, this.name);
}

final elementsOfGeocachingTypeToString = {
  ElementsOfGeocachingType.GEO_MAG: 'elementsofgeocaching_attribute_group_geomag',
  ElementsOfGeocachingType.CONTAINERS: 'elementsofgeocaching_attribute_group_containers',
  ElementsOfGeocachingType.GPS: 'elementsofgeocaching_attribute_group_gps',
  ElementsOfGeocachingType.TYPES: 'elementsofgeocaching_attribute_group_types',
  ElementsOfGeocachingType.INERT: 'elementsofgeocaching_attribute_group_inert',
  ElementsOfGeocachingType.GROUND_SPEAK: 'elementsofgeocaching_attribute_group_groundspeak',
  ElementsOfGeocachingType.VARIATIONS: 'elementsofgeocaching_attribute_group_variations',
};

final elementsOfGeocachingTypeToColor = {
  ElementsOfGeocachingType.GEO_MAG: ElementsOfGeocachingColor(const Color.fromARGB(255, 114, 179, 145), 'common_color_green'),
  ElementsOfGeocachingType.CONTAINERS: ElementsOfGeocachingColor(const Color.fromARGB(255, 252, 249, 106), 'common_color_yellow'),
  ElementsOfGeocachingType.GPS: ElementsOfGeocachingColor(const Color.fromARGB(255, 180, 147, 194), 'common_color_purple'),
  ElementsOfGeocachingType.TYPES: ElementsOfGeocachingColor(const Color.fromARGB(255, 154, 212, 226), 'common_color_light_blue'),
  ElementsOfGeocachingType.INERT: ElementsOfGeocachingColor(const Color.fromARGB(255, 70, 175, 207), 'common_color_blue'),
  ElementsOfGeocachingType.GROUND_SPEAK: ElementsOfGeocachingColor(const Color.fromARGB(255, 226, 58, 145), 'common_color_pink'),
  ElementsOfGeocachingType.VARIATIONS: ElementsOfGeocachingColor(const Color.fromARGB(255, 236, 158, 197), 'common_color_light_red'),
};

class ElementsOfGeocachingElement {
  final String name;
  final String chemicalSymbol;
  final int atomicNumber;
  final int group;
  final int period;
  final ElementsOfGeocachingType type;

  ElementsOfGeocachingElement(
      this.name,
      this.chemicalSymbol,
      this.atomicNumber,
      this.group,
      this.period,
      this.type);

  @override
  String toString() {
    return 'name: $name ($chemicalSymbol, $atomicNumber)';
  }
}

final List<ElementsOfGeocachingElement> allElementsOfGeocachingTableElements = [
  ElementsOfGeocachingElement('elementsofgeocaching_element_geocachermagazine', 'Gm', 1, 1, 1, ElementsOfGeocachingType.GEO_MAG),
  ElementsOfGeocachingElement('elementsofgeocaching_element_geocaching', 'Gc', 2, 9, 1, ElementsOfGeocachingType.GROUND_SPEAK),
  ElementsOfGeocachingElement('elementsofgeocaching_element_nano', 'Na', 3, 1, 2, ElementsOfGeocachingType.CONTAINERS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_micro', 'Mi', 4, 2, 2, ElementsOfGeocachingType.CONTAINERS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_waymarking', 'Wy', 5, 8, 2, ElementsOfGeocachingType.GROUND_SPEAK),
  ElementsOfGeocachingElement('elementsofgeocaching_element_wherigo', 'Wi', 6, 9, 2, ElementsOfGeocachingType.GROUND_SPEAK),
  ElementsOfGeocachingElement('elementsofgeocaching_element_small', 'Sm', 7, 1, 3, ElementsOfGeocachingType.CONTAINERS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_regular', 'Re', 8, 2, 3, ElementsOfGeocachingType.CONTAINERS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_garmin', 'G', 9, 3, 3, ElementsOfGeocachingType.GPS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_magellan', 'M', 10, 4, 3, ElementsOfGeocachingType.GPS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_tomtom', 'Tt', 11, 5, 3, ElementsOfGeocachingType.GPS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_traditional', 'Tr', 12, 6, 3, ElementsOfGeocachingType.TYPES),
  ElementsOfGeocachingElement('elementsofgeocaching_element_multicache', 'Mu', 13, 7, 3, ElementsOfGeocachingType.TYPES),
  ElementsOfGeocachingElement('elementsofgeocaching_element_letterbox', 'Lb', 14, 8, 3, ElementsOfGeocachingType.VARIATIONS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_navicache', 'Nc', 15, 9, 3, ElementsOfGeocachingType.VARIATIONS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_ammobox', 'Ab', 16, 1, 4, ElementsOfGeocachingType.CONTAINERS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_mystery', 'My', 17, 2, 4, ElementsOfGeocachingType.CONTAINERS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_navigon', 'Nv', 18, 3, 4, ElementsOfGeocachingType.GPS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_bushnell', 'Bu', 19, 4, 4, ElementsOfGeocachingType.GPS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_nextar', 'Ne', 20, 5, 4, ElementsOfGeocachingType.GPS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_letterboxhybrid', 'Lh', 21, 6, 4, ElementsOfGeocachingType.TYPES),
  ElementsOfGeocachingElement('elementsofgeocaching_element_cacheintrashout', 'Ci', 22, 7, 4, ElementsOfGeocachingType.TYPES),
  ElementsOfGeocachingElement('elementsofgeocaching_element_terracache', 'Tc', 23, 8, 4, ElementsOfGeocachingType.VARIATIONS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_earthcache', 'Ec', 24, 9, 4, ElementsOfGeocachingType.VARIATIONS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_event', 'E', 25, 1, 5, ElementsOfGeocachingType.CONTAINERS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_megaevent', 'Me', 26, 2, 5, ElementsOfGeocachingType.CONTAINERS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_sanyo', 'Sa', 27, 3, 5, ElementsOfGeocachingType.GPS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_miodigiwalker', 'Md', 28, 4, 5, ElementsOfGeocachingType.GPS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_xog', 'Xo', 29, 5, 5, ElementsOfGeocachingType.GPS),
  ElementsOfGeocachingElement('elementsofgeocaching_element_locationless', 'Ls', 30, 6, 5, ElementsOfGeocachingType.INERT),
  ElementsOfGeocachingElement('elementsofgeocaching_element_webcam', 'Wc', 31, 7, 5, ElementsOfGeocachingType.INERT),
  ElementsOfGeocachingElement('elementsofgeocaching_element_virtual', 'Vi', 32, 8, 5, ElementsOfGeocachingType.INERT),
  ElementsOfGeocachingElement('elementsofgeocaching_element_degreeconfluence', 'Dc', 33, 9, 5, ElementsOfGeocachingType.VARIATIONS),
];

String elementsOfGeocachingAtomicNumbersToText(List<int> atomicNumbers) {
  if (atomicNumbers.isEmpty) return '';

  return atomicNumbers.map((atomicNumber) {
    var element = allElementsOfGeocachingTableElements.firstWhereOrNull((element) => element.atomicNumber == atomicNumber);
    return element != null ? element.chemicalSymbol : UNKNOWN_ELEMENT;
  }).join();
}

List<int?> elementsOfGeocachingTextToAtomicNumbers(String input) {
  if (input.isEmpty) return <int>[];
  input = input.replaceAll(RegExp(r'[^A-Za-z]'), '');
  if (input.isEmpty) return <int>[];

  var chemSymbol = RegExp(r'[A-Z][a-z]*');
  return chemSymbol.allMatches(input).map((symbol) {
    ElementsOfGeocachingElement? element =
        allElementsOfGeocachingTableElements.firstWhereOrNull((element) => element.chemicalSymbol == symbol.group(0));
    if (element == null) return null;

    return element.atomicNumber;
  }).toList();
}
