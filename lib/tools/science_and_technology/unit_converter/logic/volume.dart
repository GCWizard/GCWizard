import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Volume extends Unit {
  Function toCubicMeter;
  Function fromCubicMeter;

  Volume({
    String name,
    String symbol,
    bool isReference: false,
    double inCubicMeters: 1.0,
  }) : super(name, symbol, isReference, (e) => e * inCubicMeters, (e) => e / inCubicMeters) {
    toCubicMeter = this.toReference;
    fromCubicMeter = this.fromReference;
  }
}

final VOLUME_CUBICMETER = Volume(name: 'common_unit_volume_m3_name', symbol: 'm\u00B3', isReference: true);

final VOLUME_CUBICCENTIMETER =
    Volume(name: 'common_unit_volume_cm3_name', symbol: 'cm\u00B3', inCubicMeters: 0.01 * 0.01 * 0.01);

final VOLUME_CUBICDECIMETER =
    Volume(name: 'common_unit_volume_dm3_name', symbol: 'dm\u00B3', inCubicMeters: 0.1 * 0.1 * 0.1);

final VOLUME_CUBICMILLIMETER =
    Volume(name: 'common_unit_volume_mm3_name', symbol: 'mm\u00B3', inCubicMeters: 0.001 * 0.001 * 0.001);

final VOLUME_LITER = Volume(name: 'common_unit_volume_l_name', symbol: 'l', inCubicMeters: 0.001);

final VOLUME_HECTOLITER = Volume(name: 'common_unit_volume_hl_name', symbol: 'hl', inCubicMeters: 100 * 0.001);

final VOLUME_DECILITER = Volume(name: 'common_unit_volume_dl_name', symbol: 'dl', inCubicMeters: 0.1 * 0.001);

final VOLUME_CENTILITER = Volume(name: 'common_unit_volume_cl_name', symbol: 'cl', inCubicMeters: 0.01 * 0.001);

final VOLUME_MILLILITER = Volume(name: 'common_unit_volume_ml_name', symbol: 'ml', inCubicMeters: 0.001 * 0.001);

final VOLUME_MILLIMETERPERSQUAREMETER =
    Volume(name: 'common_unit_volume_mmm2_name', symbol: 'mm/m\u00B2', inCubicMeters: 0.001);

final VOLUME_CUBICFOOT =
    Volume(name: 'common_unit_volume_cuft_name', symbol: 'cu ft', inCubicMeters: 0.3048 * 0.3048 * 0.3048);

final VOLUME_CUBICINCH = Volume(
    name: 'common_unit_volume_cuin_name',
    symbol: 'cu in',
    inCubicMeters: 0.3048 * 0.3048 * 0.3048 / (12.0 * 12.0 * 12.0));

final VOLUME_CUBICYARD =
    Volume(name: 'common_unit_volume_cuyd_name', symbol: 'cu yd', inCubicMeters: 0.3048 * 0.3048 * 0.3048 * 27.0);

final VOLUME_IMPERIALMINIM =
    Volume(name: 'common_unit_volume_impmin_name', symbol: 'imp.min', inCubicMeters: 0.001 * 4.54609 / 76800.0);

final VOLUME_IMPERIALFLUIDDRAM =
    Volume(name: 'common_unit_volume_impfldr_name', symbol: 'imp.fl.dr', inCubicMeters: 0.001 * 4.54609 / 1280.0);

final VOLUME_IMPERIALFLUIDOUNCE =
    Volume(name: 'common_unit_volume_impfloz_name', symbol: 'imp.fl.oz', inCubicMeters: 0.001 * 4.54609 / 160.0);

final VOLUME_IMPERIALGILL =
    Volume(name: 'common_unit_volume_impgi_name', symbol: 'imp.gi', inCubicMeters: 0.001 * 4.54609 / 32.0);

final VOLUME_IMPERIALCUP =
    Volume(name: 'common_unit_volume_impcup_name', symbol: 'imp.cup', inCubicMeters: 0.001 * 4.54609 / 16.0);

final VOLUME_IMPERIALPINT =
    Volume(name: 'common_unit_volume_imppt_name', symbol: 'imp.pt', inCubicMeters: 0.001 * 4.54609 / 8.0);

final VOLUME_IMPERIALQUART =
    Volume(name: 'common_unit_volume_impqt_name', symbol: 'imp.qt', inCubicMeters: 0.001 * 4.54609 / 4.0);

final VOLUME_IMPERIALGALLON =
    Volume(name: 'common_unit_volume_impgal_name', symbol: 'imp.gal', inCubicMeters: 0.001 * 4.54609);

final VOLUME_IMPERIALPECK =
    Volume(name: 'common_unit_volume_imppk_name', symbol: 'imp.pk', inCubicMeters: 0.001 * 4.54609 * 2.0);

final VOLUME_IMPERIALBUSHEL =
    Volume(name: 'common_unit_volume_impbu_name', symbol: 'imp.bu', inCubicMeters: 0.001 * 4.54609 * 8.0);

final VOLUME_IMPERIALBARREL_OIL =
    Volume(name: 'common_unit_volume_impbbl_oil_name', symbol: 'imp.bbl', inCubicMeters: 0.001 * 4.54609 * 35.0);

final VOLUME_IMPERIALBARREL_BEER =
    Volume(name: 'common_unit_volume_impbbl_beer_name', symbol: 'imp.bbl', inCubicMeters: 0.001 * 4.54609 * 36.0);

final VOLUME_USMINIM =
    Volume(name: 'common_unit_volume_usmin_name', symbol: 'US.min', inCubicMeters: 0.001 * 3.785411784 / 61440.0);

final VOLUME_USFLUIDDRAM =
    Volume(name: 'common_unit_volume_usfldr_name', symbol: 'US.fl.dr', inCubicMeters: 0.001 * 3.785411784 / 1024.0);

final VOLUME_USFLUIDOUNCE =
    Volume(name: 'common_unit_volume_usfloz_name', symbol: 'US.fl.oz', inCubicMeters: 0.001 * 3.785411784 / 128.0);

final VOLUME_USLIQUIDGILL =
    Volume(name: 'common_unit_volume_usliqgi_name', symbol: 'US.liq.gi', inCubicMeters: 0.001 * 3.785411784 / 32.0);

final VOLUME_USCUP =
    Volume(name: 'common_unit_volume_uscup_name', symbol: 'US.cup', inCubicMeters: 0.001 * 3.785411784 / 16.0);

final VOLUME_USLIQUIDPINT =
    Volume(name: 'common_unit_volume_usliqpt_name', symbol: 'US.liq.pt', inCubicMeters: 0.001 * 3.785411784 / 8.0);

final VOLUME_USLIQUIDQUART =
    Volume(name: 'common_unit_volume_usliqqt_name', symbol: 'US.liq.qt', inCubicMeters: 0.001 * 3.785411784 / 4.0);

final VOLUME_USLIQUIDGALLON =
    Volume(name: 'common_unit_volume_usliqgal_name', symbol: 'US.liq.gal', inCubicMeters: 0.001 * 3.785411784);

final VOLUME_USBARREL_OIL =
    Volume(name: 'common_unit_volume_usbbl_oil_name', symbol: 'bbl', inCubicMeters: 0.001 * 3.785411784 * 42.0);

final VOLUME_USBARREL_BEER =
    Volume(name: 'common_unit_volume_usbbl_beer_name', symbol: 'bl', inCubicMeters: 0.001 * 3.785411784 * 31.5);

final VOLUME_USDRYPINT =
    Volume(name: 'common_unit_volume_usdrypt_name', symbol: 'US.dry.pt', inCubicMeters: 0.001 * 4.40488377086 / 8.0);

final VOLUME_USDRYQUART =
    Volume(name: 'common_unit_volume_usdryqt_name', symbol: 'US.dry.qt', inCubicMeters: 0.001 * 4.40488377086 / 4.0);

final VOLUME_USDRYGALLON =
    Volume(name: 'common_unit_volume_usdrygal_name', symbol: 'US.dry.gal', inCubicMeters: 0.001 * 4.40488377086);

final VOLUME_USPECK =
    Volume(name: 'common_unit_volume_uspk_name', symbol: 'US.pk', inCubicMeters: 0.001 * 4.40488377086 * 2);

final VOLUME_USBUSHEL =
    Volume(name: 'common_unit_volume_usbu_name', symbol: 'US.bu', inCubicMeters: 0.001 * 4.40488377086 * 8.0);

final VOLUME_BATHTUB = Volume(name: 'common_unit_volume_bathtub_name', symbol: null, inCubicMeters: 0.001 * 150.0);

final VOLUME_USSALTSPOON =
    Volume(name: 'common_unit_volume_tsp_name', symbol: 'ssp', inCubicMeters: 0.001 * 0.001 * 4.928922 / 4.0);

final VOLUME_USCOFFEESPOON =
    Volume(name: 'common_unit_volume_csp_name', symbol: 'csp', inCubicMeters: 0.001 * 0.001 * 4.928922 / 2.0);

final VOLUME_USDESSERTSPOON =
    Volume(name: 'common_unit_volume_tsp_name', symbol: 'dsp', inCubicMeters: 0.001 * 0.001 * 4.928922 * 2.0);

final VOLUME_USTEASPOON =
    Volume(name: 'common_unit_volume_tsp_name', symbol: 'tsp', inCubicMeters: 0.001 * 0.001 * 4.928922);

final VOLUME_USTABLESPOON =
    Volume(name: 'common_unit_volume_tbsp_name', symbol: 'tbsp', inCubicMeters: 0.001 * 0.001 * 14.78676);

final VOLUME_USTEACUP =
    Volume(name: 'common_unit_volume_tc_name', symbol: 'tc', inCubicMeters: 0.001 * 3.785411784 / 32.0);

final VOLUME_USDASH =
    Volume(name: 'common_unit_volume_ds_name', symbol: 'ds', inCubicMeters: 0.001 * 0.001 * 4.928922 / 8.0);

final VOLUME_USPINCH =
    Volume(name: 'common_unit_volume_pn_name', symbol: 'pn', inCubicMeters: 0.001 * 0.001 * 4.928922 / 16.0);

final VOLUME_USSMIDGEN =
    Volume(name: 'common_unit_volume_smi_name', symbol: 'smi', inCubicMeters: 0.001 * 0.001 * 4.928922 / 32.0);

final VOLUME_USDROP =
    Volume(name: 'common_unit_volume_dr_name', symbol: 'dr', inCubicMeters: 0.001 * 0.001 * 4.928922 / 96.0);

final VOLUME_WOODKLAFTER = Volume(name: 'common_unit_volume_woodklafter_name', symbol: 'klafter', inCubicMeters: 3.0);

final VOLUME_STERE = Volume(name: 'common_unit_volume_stere_name', symbol: 'st', inCubicMeters: 1.0);

final VOLUME_WASHINGMACHINE =
    Volume(name: 'common_unit_volume_washingmachine_name', symbol: 'wm', inCubicMeters: 0.85 * 0.60 * 0.60);

// https://webmadness.net/blog/?post=knuth
final VOLUME_NGOGN =
    Volume(name: 'common_unit_volume_ngogn_name', symbol: 'n', inCubicMeters: 0.022633 * 0.022633 * 0.022633);

final List<Unit> volumes = [
  VOLUME_CUBICMILLIMETER,
  VOLUME_CUBICCENTIMETER,
  VOLUME_CUBICDECIMETER,
  VOLUME_CUBICMETER,
  VOLUME_MILLILITER,
  VOLUME_CENTILITER,
  VOLUME_DECILITER,
  VOLUME_LITER,
  VOLUME_HECTOLITER,
  VOLUME_MILLIMETERPERSQUAREMETER,
  VOLUME_CUBICINCH,
  VOLUME_CUBICFOOT,
  VOLUME_CUBICYARD,
  VOLUME_IMPERIALMINIM,
  VOLUME_IMPERIALFLUIDDRAM,
  VOLUME_IMPERIALFLUIDOUNCE,
  VOLUME_IMPERIALGILL,
  VOLUME_IMPERIALCUP,
  VOLUME_IMPERIALPINT,
  VOLUME_IMPERIALQUART,
  VOLUME_IMPERIALGALLON,
  VOLUME_IMPERIALPECK,
  VOLUME_IMPERIALBUSHEL,
  VOLUME_IMPERIALBARREL_OIL,
  VOLUME_IMPERIALBARREL_BEER,
  VOLUME_USMINIM,
  VOLUME_USFLUIDDRAM,
  VOLUME_USFLUIDOUNCE,
  VOLUME_USLIQUIDGILL,
  VOLUME_USCUP,
  VOLUME_USLIQUIDPINT,
  VOLUME_USLIQUIDQUART,
  VOLUME_USLIQUIDGALLON,
  VOLUME_USBARREL_OIL,
  VOLUME_USBARREL_BEER,
  VOLUME_USDRYPINT,
  VOLUME_USDRYQUART,
  VOLUME_USDRYGALLON,
  VOLUME_USPECK,
  VOLUME_USBUSHEL,
  VOLUME_BATHTUB,
  VOLUME_USTEASPOON,
  VOLUME_USCOFFEESPOON,
  VOLUME_USTABLESPOON,
  VOLUME_USDESSERTSPOON,
  VOLUME_USSALTSPOON,
  VOLUME_USTEACUP,
  VOLUME_USDROP,
  VOLUME_USSMIDGEN,
  VOLUME_USPINCH,
  VOLUME_USDASH,
  VOLUME_STERE,
  VOLUME_WOODKLAFTER,
  VOLUME_WASHINGMACHINE,
  VOLUME_NGOGN,
];
