part 'package:gc_wizard/tools/uncategorized/wedding_anniversaries/logic/wedding_anniversaries_data.dart';

enum WeddingCountries { DE, UK, US, NL, DK, SW, FR, IT, ES }

String localizationName (WeddingCountries country) {
  switch (country) {
    case WeddingCountries.DE: return "common_country_Germany";
    case WeddingCountries.UK: return "common_country_UnitedKingdom";
    case WeddingCountries.US: return "common_country_USA";
    case WeddingCountries.NL: return "common_country_Netherlands";
    case WeddingCountries.DK: return "common_country_Denmark";
    case WeddingCountries.SW: return "common_country_Sweden";
    case WeddingCountries.FR: return "common_country_France";
    case WeddingCountries.IT: return "common_country_Italy";
    case WeddingCountries.ES: return "common_country_Spain";
  }
}

Map<String, List<String>> countryAnniversaries (WeddingCountries country) {
  switch (country) {
    case WeddingCountries.DE: return _anniversariesDE;
    case WeddingCountries.UK: return _anniversariesUK;
    case WeddingCountries.US: return _anniversariesUS;
    case WeddingCountries.NL: return _anniversariesNL;
    case WeddingCountries.DK: return _anniversariesDK;
    case WeddingCountries.SW: return _anniversariesSW;
    case WeddingCountries.FR: return _anniversariesFR;
    case WeddingCountries.IT: return _anniversariesIT;
    case WeddingCountries.ES: return _anniversariesES;
  }
}

String getItems(WeddingCountries country, String year) {
  var anniversaryList = countryAnniversaries(country);
  var items = anniversaryList[year];
  return (items != null) ? items.join(", ") : '';
}
