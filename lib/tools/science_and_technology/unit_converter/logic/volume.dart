import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Volume extends Unit {
  late double Function(double) toCubicMeter;
  late double Function(double) fromCubicMeter;

  Volume({
    required String name,
    required String symbol,
    bool isReference = false,
    required double inCubicMeters,
  }) : super(name, symbol, isReference, (e) => e * inCubicMeters, (e) => e / inCubicMeters) {
    toCubicMeter = toReference;
    fromCubicMeter = fromReference;
  }
}

final VOLUME_CUBICMETER =
    Volume(name: 'common_unit_volume_m3_name', symbol: 'm\u00B3', inCubicMeters: 1.0, isReference: true);

final _VOLUME_CUBICCENTIMETER =
    Volume(name: 'common_unit_volume_cm3_name', symbol: 'cm\u00B3', inCubicMeters: 0.01 * 0.01 * 0.01);

final _VOLUME_CUBICDECIMETER =
    Volume(name: 'common_unit_volume_dm3_name', symbol: 'dm\u00B3', inCubicMeters: 0.1 * 0.1 * 0.1);

final _VOLUME_CUBICMILLIMETER =
    Volume(name: 'common_unit_volume_mm3_name', symbol: 'mm\u00B3', inCubicMeters: 0.001 * 0.001 * 0.001);

final VOLUME_LITER = Volume(name: 'common_unit_volume_l_name', symbol: 'l', inCubicMeters: 0.001);

final _VOLUME_HECTOLITER = Volume(name: 'common_unit_volume_hl_name', symbol: 'hl', inCubicMeters: 100 * 0.001);

final _VOLUME_DECILITER = Volume(name: 'common_unit_volume_dl_name', symbol: 'dl', inCubicMeters: 0.1 * 0.001);

final _VOLUME_CENTILITER = Volume(name: 'common_unit_volume_cl_name', symbol: 'cl', inCubicMeters: 0.01 * 0.001);

final VOLUME_MILLILITER = Volume(name: 'common_unit_volume_ml_name', symbol: 'ml', inCubicMeters: 0.001 * 0.001);

final _VOLUME_MILLIMETERPERSQUAREMETER =
    Volume(name: 'common_unit_volume_mmm2_name', symbol: 'mm/m\u00B2', inCubicMeters: 0.001);

final _VOLUME_CUBICFOOT =
    Volume(name: 'common_unit_volume_cuft_name', symbol: 'cu ft', inCubicMeters: 0.3048 * 0.3048 * 0.3048);

final _VOLUME_CUBICINCH = Volume(
    name: 'common_unit_volume_cuin_name',
    symbol: 'cu in',
    inCubicMeters: 0.3048 * 0.3048 * 0.3048 / (12.0 * 12.0 * 12.0));

final _VOLUME_CUBICYARD =
    Volume(name: 'common_unit_volume_cuyd_name', symbol: 'cu yd', inCubicMeters: 0.3048 * 0.3048 * 0.3048 * 27.0);

final _VOLUME_IMPERIALMINIM =
    Volume(name: 'common_unit_volume_impmin_name', symbol: 'imp.min', inCubicMeters: 0.001 * 4.54609 / 76800.0);

final _VOLUME_IMPERIALFLUIDDRAM =
    Volume(name: 'common_unit_volume_impfldr_name', symbol: 'imp.fl.dr', inCubicMeters: 0.001 * 4.54609 / 1280.0);

final _VOLUME_IMPERIALFLUIDOUNCE =
    Volume(name: 'common_unit_volume_impfloz_name', symbol: 'imp.fl.oz', inCubicMeters: 0.001 * 4.54609 / 160.0);

final _VOLUME_IMPERIALGILL =
    Volume(name: 'common_unit_volume_impgi_name', symbol: 'imp.gi', inCubicMeters: 0.001 * 4.54609 / 32.0);

final _VOLUME_IMPERIALCUP =
    Volume(name: 'common_unit_volume_impcup_name', symbol: 'imp.cup', inCubicMeters: 0.001 * 4.54609 / 16.0);

final _VOLUME_IMPERIALPINT =
    Volume(name: 'common_unit_volume_imppt_name', symbol: 'imp.pt', inCubicMeters: 0.001 * 4.54609 / 8.0);

final _VOLUME_IMPERIALQUART =
    Volume(name: 'common_unit_volume_impqt_name', symbol: 'imp.qt', inCubicMeters: 0.001 * 4.54609 / 4.0);

final _VOLUME_IMPERIALGALLON =
    Volume(name: 'common_unit_volume_impgal_name', symbol: 'imp.gal', inCubicMeters: 0.001 * 4.54609);

final _VOLUME_IMPERIALPECK =
    Volume(name: 'common_unit_volume_imppk_name', symbol: 'imp.pk', inCubicMeters: 0.001 * 4.54609 * 2.0);

final _VOLUME_IMPERIALBUSHEL =
    Volume(name: 'common_unit_volume_impbu_name', symbol: 'imp.bu', inCubicMeters: 0.001 * 4.54609 * 8.0);

final _VOLUME_IMPERIALBARREL_OIL =
    Volume(name: 'common_unit_volume_impbbl_oil_name', symbol: 'imp.bbl', inCubicMeters: 0.001 * 4.54609 * 35.0);

final _VOLUME_IMPERIALBARREL_BEER =
    Volume(name: 'common_unit_volume_impbbl_beer_name', symbol: 'imp.bbl', inCubicMeters: 0.001 * 4.54609 * 36.0);

final _VOLUME_USMINIM =
    Volume(name: 'common_unit_volume_usmin_name', symbol: 'US.min', inCubicMeters: 0.001 * 3.785411784 / 61440.0);

final _VOLUME_USFLUIDDRAM =
    Volume(name: 'common_unit_volume_usfldr_name', symbol: 'US.fl.dr', inCubicMeters: 0.001 * 3.785411784 / 1024.0);

final _VOLUME_USFLUIDOUNCE =
    Volume(name: 'common_unit_volume_usfloz_name', symbol: 'US.fl.oz', inCubicMeters: 0.001 * 3.785411784 / 128.0);

final _VOLUME_USLIQUIDGILL =
    Volume(name: 'common_unit_volume_usliqgi_name', symbol: 'US.liq.gi', inCubicMeters: 0.001 * 3.785411784 / 32.0);

final _VOLUME_USCUP =
    Volume(name: 'common_unit_volume_uscup_name', symbol: 'US.cup', inCubicMeters: 0.001 * 3.785411784 / 16.0);

final _VOLUME_USLIQUIDPINT =
    Volume(name: 'common_unit_volume_usliqpt_name', symbol: 'US.liq.pt', inCubicMeters: 0.001 * 3.785411784 / 8.0);

final _VOLUME_USLIQUIDQUART =
    Volume(name: 'common_unit_volume_usliqqt_name', symbol: 'US.liq.qt', inCubicMeters: 0.001 * 3.785411784 / 4.0);

final _VOLUME_USLIQUIDGALLON =
    Volume(name: 'common_unit_volume_usliqgal_name', symbol: 'US.liq.gal', inCubicMeters: 0.001 * 3.785411784);

final _VOLUME_USBARREL_OIL =
    Volume(name: 'common_unit_volume_usbbl_oil_name', symbol: 'bbl', inCubicMeters: 0.001 * 3.785411784 * 42.0);

final _VOLUME_USBARREL_BEER =
    Volume(name: 'common_unit_volume_usbbl_beer_name', symbol: 'bl', inCubicMeters: 0.001 * 3.785411784 * 31.5);

final _VOLUME_USDRYPINT =
    Volume(name: 'common_unit_volume_usdrypt_name', symbol: 'US.dry.pt', inCubicMeters: 0.001 * 4.40488377086 / 8.0);

final _VOLUME_USDRYQUART =
    Volume(name: 'common_unit_volume_usdryqt_name', symbol: 'US.dry.qt', inCubicMeters: 0.001 * 4.40488377086 / 4.0);

final _VOLUME_USDRYGALLON =
    Volume(name: 'common_unit_volume_usdrygal_name', symbol: 'US.dry.gal', inCubicMeters: 0.001 * 4.40488377086);

final _VOLUME_USPECK =
    Volume(name: 'common_unit_volume_uspk_name', symbol: 'US.pk', inCubicMeters: 0.001 * 4.40488377086 * 2);

final _VOLUME_USBUSHEL =
    Volume(name: 'common_unit_volume_usbu_name', symbol: 'US.bu', inCubicMeters: 0.001 * 4.40488377086 * 8.0);

final _VOLUME_BATHTUB = Volume(name: 'common_unit_volume_bathtub_name', symbol: '', inCubicMeters: 0.001 * 150.0);

final _VOLUME_USSALTSPOON =
    Volume(name: 'common_unit_volume_tsp_name', symbol: 'ssp', inCubicMeters: 0.001 * 0.001 * 4.928922 / 4.0);

final _VOLUME_USCOFFEESPOON =
    Volume(name: 'common_unit_volume_csp_name', symbol: 'csp', inCubicMeters: 0.001 * 0.001 * 4.928922 / 2.0);

final _VOLUME_USDESSERTSPOON =
    Volume(name: 'common_unit_volume_tsp_name', symbol: 'dsp', inCubicMeters: 0.001 * 0.001 * 4.928922 * 2.0);

final _VOLUME_USTEASPOON =
    Volume(name: 'common_unit_volume_tsp_name', symbol: 'tsp', inCubicMeters: 0.001 * 0.001 * 4.928922);

final _VOLUME_USTABLESPOON =
    Volume(name: 'common_unit_volume_tbsp_name', symbol: 'tbsp', inCubicMeters: 0.001 * 0.001 * 14.78676);

final _VOLUME_USTEACUP =
    Volume(name: 'common_unit_volume_tc_name', symbol: 'tc', inCubicMeters: 0.001 * 3.785411784 / 32.0);

final _VOLUME_USDASH =
    Volume(name: 'common_unit_volume_ds_name', symbol: 'ds', inCubicMeters: 0.001 * 0.001 * 4.928922 / 8.0);

final _VOLUME_USPINCH =
    Volume(name: 'common_unit_volume_pn_name', symbol: 'pn', inCubicMeters: 0.001 * 0.001 * 4.928922 / 16.0);

final _VOLUME_USSMIDGEN =
    Volume(name: 'common_unit_volume_smi_name', symbol: 'smi', inCubicMeters: 0.001 * 0.001 * 4.928922 / 32.0);

final _VOLUME_USDROP =
    Volume(name: 'common_unit_volume_dr_name', symbol: 'dr', inCubicMeters: 0.001 * 0.001 * 4.928922 / 96.0);

final _VOLUME_WOODKLAFTER = Volume(name: 'common_unit_volume_woodklafter_name', symbol: 'klafter', inCubicMeters: 3.0);

final _VOLUME_STERE = Volume(name: 'common_unit_volume_stere_name', symbol: 'st', inCubicMeters: 1.0);

final _VOLUME_WASHINGMACHINE =
    Volume(name: 'common_unit_volume_washingmachine_name', symbol: 'wm', inCubicMeters: 0.85 * 0.60 * 0.60);

// https://webmadness.net/blog/?post=knuth
final _VOLUME_NGOGN =
    Volume(name: 'common_unit_volume_ngogn_name', symbol: 'n', inCubicMeters: 0.022633 * 0.022633 * 0.022633);

// https://de.wikipedia.org/wiki/Alte_Ma%C3%9Fe_und_Gewichte_(r%C3%B6mische_Antike)
// https://en.wikipedia.org/wiki/Ancient_Roman_units_of_measurement
double _sester = 0.296 * 0.296 * 0.296 / 48;

final _VOLUME_ROMAN_LIGULA = Volume(name: 'common_unit_volume_roman_ligulum_name', symbol: 'ligula', inCubicMeters: _sester / 48);
final _VOLUME_ROMAN_CYATHUS = Volume(name: 'common_unit_volume_roman_cyathus_name', symbol: 'cyathus', inCubicMeters: _sester / 12);
final _VOLUME_ROMAN_ACETABULUM = Volume(name: 'common_unit_volume_roman_acetabulum_name', symbol: 'acetabulum', inCubicMeters: _sester / 8);
final _VOLUME_ROMAN_SEXTANS = Volume(name: 'common_unit_volume_roman_sextans_name', symbol: 'sextans', inCubicMeters: _sester / 6);
final _VOLUME_ROMAN_TRIENS = Volume(name: 'common_unit_volume_roman_triens_name', symbol: 'triens', inCubicMeters: _sester / 3);
final _VOLUME_ROMAN_HEMINA = Volume(name: 'common_unit_volume_roman_hemina_name', symbol: 'hemina', inCubicMeters: _sester / 2);
final _VOLUME_ROMAN_CHEONIX = Volume(name: 'common_unit_volume_roman_cheonix_name', symbol: 'cheonix', inCubicMeters: _sester * 2 / 3);
final _VOLUME_ROMAN_SEXTARIUS = Volume(name: 'common_unit_volume_roman_sextarius_name', symbol: 'sextarius', inCubicMeters: _sester);
final _VOLUME_ROMAN_CONGIUS = Volume(name: 'common_unit_volume_roman_congius_name', symbol: 'congius', inCubicMeters: _sester * 6);
final _VOLUME_ROMAN_URNA = Volume(name: 'common_unit_volume_roman_urna_name', symbol: 'urna', inCubicMeters: _sester * 24);
final _VOLUME_ROMAN_AMPHORA = Volume(name: 'common_unit_volume_roman_amphora_name', symbol: 'amphora', inCubicMeters: _sester * 48);
final _VOLUME_ROMAN_CULLEUS = Volume(name: 'common_unit_volume_roman_culleus_name', symbol: 'culleus', inCubicMeters: _sester * 960);

//Römische Getreidemaße
double _modius = 0.296 * 0.296 * 0.296;
final _VOLUME_ROMAN_QUARTARIUS = Volume(name: 'common_unit_volume_roman_quartarius_name', symbol: 'quartarius', inCubicMeters: _modius / 64);
final _VOLUME_ROMAN_SEMODIUS = Volume(name: 'common_unit_volume_roman_semodius_name', symbol: 'semodius', inCubicMeters: _modius / 2);
final _VOLUME_ROMAN_MODIUS = Volume(name: 'common_unit_volume_roman_modius_name', symbol: 'modius', inCubicMeters: _modius);
final _VOLUME_ROMAN_QUADRANTAL = Volume(name: 'common_unit_volume_roman_quadrantal_name', symbol: 'quadrantal', inCubicMeters: _modius * 3);

final List<Volume> volumes = [
  _VOLUME_CUBICMILLIMETER,
  _VOLUME_CUBICCENTIMETER,
  _VOLUME_CUBICDECIMETER,
  VOLUME_CUBICMETER,
  VOLUME_MILLILITER,
  _VOLUME_CENTILITER,
  _VOLUME_DECILITER,
  VOLUME_LITER,
  _VOLUME_HECTOLITER,
  _VOLUME_MILLIMETERPERSQUAREMETER,
  _VOLUME_CUBICINCH,
  _VOLUME_CUBICFOOT,
  _VOLUME_CUBICYARD,
  _VOLUME_IMPERIALMINIM,
  _VOLUME_IMPERIALFLUIDDRAM,
  _VOLUME_IMPERIALFLUIDOUNCE,
  _VOLUME_IMPERIALGILL,
  _VOLUME_IMPERIALCUP,
  _VOLUME_IMPERIALPINT,
  _VOLUME_IMPERIALQUART,
  _VOLUME_IMPERIALGALLON,
  _VOLUME_IMPERIALPECK,
  _VOLUME_IMPERIALBUSHEL,
  _VOLUME_IMPERIALBARREL_OIL,
  _VOLUME_IMPERIALBARREL_BEER,
  _VOLUME_USMINIM,
  _VOLUME_USFLUIDDRAM,
  _VOLUME_USFLUIDOUNCE,
  _VOLUME_USLIQUIDGILL,
  _VOLUME_USCUP,
  _VOLUME_USLIQUIDPINT,
  _VOLUME_USLIQUIDQUART,
  _VOLUME_USLIQUIDGALLON,
  _VOLUME_USBARREL_OIL,
  _VOLUME_USBARREL_BEER,
  _VOLUME_USDRYPINT,
  _VOLUME_USDRYQUART,
  _VOLUME_USDRYGALLON,
  _VOLUME_USPECK,
  _VOLUME_USBUSHEL,
  _VOLUME_BATHTUB,
  _VOLUME_USTEASPOON,
  _VOLUME_USCOFFEESPOON,
  _VOLUME_USTABLESPOON,
  _VOLUME_USDESSERTSPOON,
  _VOLUME_USSALTSPOON,
  _VOLUME_USTEACUP,
  _VOLUME_USDROP,
  _VOLUME_USSMIDGEN,
  _VOLUME_USPINCH,
  _VOLUME_USDASH,
  _VOLUME_STERE,
  _VOLUME_WOODKLAFTER,
  _VOLUME_WASHINGMACHINE,
  _VOLUME_NGOGN,
  _VOLUME_ROMAN_LIGULA,
  _VOLUME_ROMAN_CYATHUS,
  _VOLUME_ROMAN_ACETABULUM,
  _VOLUME_ROMAN_SEXTANS,
  _VOLUME_ROMAN_TRIENS,
  _VOLUME_ROMAN_HEMINA,
  _VOLUME_ROMAN_CHEONIX,
  _VOLUME_ROMAN_SEXTARIUS,
  _VOLUME_ROMAN_CONGIUS,
  _VOLUME_ROMAN_URNA,
  _VOLUME_ROMAN_AMPHORA,
  _VOLUME_ROMAN_CULLEUS,
  _VOLUME_ROMAN_QUARTARIUS,
  _VOLUME_ROMAN_SEMODIUS,
  _VOLUME_ROMAN_MODIUS,
  _VOLUME_ROMAN_QUADRANTAL,
];
