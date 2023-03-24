import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/countries/countries/widget/countries.dart';
import 'package:gc_wizard/tools/science_and_technology/countries/logic/countries.dart';

class CountriesISOCodes extends Countries {
  CountriesISOCodes({Key? key}) : super(key: key,
  fields: [CountryProperties.iso3166_1_2, CountryProperties.iso3166_1_3, CountryProperties.iso3166_1_n]);
}
