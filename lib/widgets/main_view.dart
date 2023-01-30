import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/utils/common_utils.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/settings/preferences.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dialog.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_tool.dart';
import 'package:gc_wizard/widgets/common/gcw_toollist.dart';
import 'package:gc_wizard/widgets/favorites.dart';
import 'package:gc_wizard/widgets/main_menu.dart';
import 'package:gc_wizard/widgets/main_menu/changelog.dart';
import 'package:gc_wizard/widgets/registry.dart';
import 'package:gc_wizard/widgets/selector_lists/babylon_numbers_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/base_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/bcd_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/beaufort_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/braille_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/cistercian_numbers_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/coords_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/cryptography_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/e_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/easter_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/games_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/general_codebreakers_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/hash_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/icecodes_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/imagesandfiles_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/keyboard_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/maya_calendar_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/maya_numbers_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/morse_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/number_sequences/numbersequence_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/numeral_words_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/phi_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/pi_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/predator_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/primes_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/resistor_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/rsa_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/scienceandtechnology_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/scrabble_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/shadoks_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/silverratio_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/sqrt2_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/sqrt3_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/sqrt5_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/symbol_table_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/teletypewriter_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/tomtom_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/vanity_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/wherigo_urwigo_selection.dart';
import 'package:gc_wizard/widgets/tools/coords/antipodes.dart';
import 'package:gc_wizard/widgets/tools/coords/center_three_points.dart';
import 'package:gc_wizard/widgets/tools/coords/center_two_points.dart';
import 'package:gc_wizard/widgets/tools/coords/centroid_arithmetic_mean.dart';
import 'package:gc_wizard/widgets/tools/coords/centroid_center_of_gravity.dart';
import 'package:gc_wizard/widgets/tools/coords/coordinate_averaging.dart';
import 'package:gc_wizard/widgets/tools/coords/cross_bearing.dart';
import 'package:gc_wizard/widgets/tools/coords/distance_and_bearing.dart';
import 'package:gc_wizard/widgets/tools/coords/ellipsoid_transform.dart';
import 'package:gc_wizard/widgets/tools/coords/equilateral_triangle.dart';
import 'package:gc_wizard/widgets/tools/coords/format_converter.dart';
import 'package:gc_wizard/widgets/tools/coords/intersect_bearing_and_circle.dart';
import 'package:gc_wizard/widgets/tools/coords/intersect_bearings.dart';
import 'package:gc_wizard/widgets/tools/coords/intersect_four_points.dart';
import 'package:gc_wizard/widgets/tools/coords/intersect_three_circles.dart';
import 'package:gc_wizard/widgets/tools/coords/intersect_two_circles.dart';
import 'package:gc_wizard/widgets/tools/coords/intersection.dart';
import 'package:gc_wizard/widgets/tools/coords/map_view/map_view.dart';
import 'package:gc_wizard/widgets/tools/coords/resection.dart';
import 'package:gc_wizard/widgets/tools/coords/variable_coordinate/variable_coordinate_formulas.dart';
import 'package:gc_wizard/widgets/tools/coords/waypoint_projection.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/abaddon.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/adfgvx.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/affine.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/algol.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/alphabet_values.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/amsco.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/atbash.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/bacon.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/beghilos.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/bifid.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/book_cipher.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/bundeswehr_talkingboard/bundeswehr_auth.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/bundeswehr_talkingboard/bundeswehr_code.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/burrows_wheeler.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/caesar.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/chao.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/charsets/ascii_values.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/cipher_wheel.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/enclosed_areas.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/enigma/enigma.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/esoteric_programming_languages/beatnik_language.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/esoteric_programming_languages/befunge.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/esoteric_programming_languages/brainfk.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/esoteric_programming_languages/chef_language.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/esoteric_programming_languages/cow.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/esoteric_programming_languages/deadfish.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/esoteric_programming_languages/hohoho.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/esoteric_programming_languages/karol_robot.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/esoteric_programming_languages/malbolge.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/esoteric_programming_languages/ook.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/esoteric_programming_languages/piet.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/esoteric_programming_languages/whitespace_language.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/fox.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/gade.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/gc_code.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/general_codebreakers/multi_decoder/multi_decoder.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/general_codebreakers/substitution_breaker.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/gray.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/gronsfeld.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/hashes/hash_breaker.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/homophone.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/houdini.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/illiac.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/kamasutra.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/kenny.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/language_games/chicken_language.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/language_games/duck_speak.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/language_games/pig_latin.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/language_games/robber_language.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/language_games/spoon_language.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/mexican_army_cipher_wheel.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/navajo.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/one_time_pad.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/playfair.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/pokemon.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/polybios.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/prime_alphabet.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/rabbit.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/rail_fence.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/rc4.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/reverse.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/roman_numbers/chronogram.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/roman_numbers/roman_numbers.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/rotation/rot123.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/rotation/rot13.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/rotation/rot18.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/rotation/rot47.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/rotation/rot5.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/rotation/rotation_general.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/skytale.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/solitaire.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/straddling_checkerboard.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/substitution.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/tap_code.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/tapir.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/telegraphs/chappe.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/telegraphs/edelcrantz.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/telegraphs/gauss_weber_telegraph.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/telegraphs/murray.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/telegraphs/ohlsen_telegraph.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/telegraphs/pasley_telegraph.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/telegraphs/popham_telegraph.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/telegraphs/prussiatelegraph.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/telegraphs/schilling_canstatt_telegraph.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/telegraphs/semaphore.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/telegraphs/wheatstone_cooke_5_needles.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/telegraphs/wigwag.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/teletypewriter/punchtape.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/text_analysis.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/trifid.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/trithemius.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/tts.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/vigenere.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/wasd.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/wherigo_urwigo/earwigo_text_deobfuscation.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/wherigo_urwigo/urwigo_hashbreaker.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/wherigo_urwigo/urwigo_text_deobfuscation.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/z22.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/zamonian_numbers.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/zc1.dart';
import 'package:gc_wizard/widgets/tools/formula_solver/formula_solver_formulagroups.dart';
import 'package:gc_wizard/widgets/tools/games/catan.dart';
import 'package:gc_wizard/widgets/tools/games/bowling.dart';
import 'package:gc_wizard/widgets/tools/games/sudoku/sudoku_solver.dart';
import 'package:gc_wizard/widgets/tools/games/alphametics.dart';
import 'package:gc_wizard/widgets/tools/images_and_files/animated_image.dart';
import 'package:gc_wizard/widgets/tools/images_and_files/animated_image_morse_code.dart';
import 'package:gc_wizard/widgets/tools/images_and_files/binary2image.dart';
import 'package:gc_wizard/widgets/tools/images_and_files/exif_reader.dart';
import 'package:gc_wizard/widgets/tools/images_and_files/hex_viewer.dart';
import 'package:gc_wizard/widgets/tools/images_and_files/hexstring2file.dart';
import 'package:gc_wizard/widgets/tools/images_and_files/hidden_data.dart';
import 'package:gc_wizard/widgets/tools/images_and_files/image_colorcorrections.dart';
import 'package:gc_wizard/widgets/tools/images_and_files/image_flip_rotate.dart';
import 'package:gc_wizard/widgets/tools/images_and_files/magic_eye_solver.dart';
import 'package:gc_wizard/widgets/tools/images_and_files/qr_code.dart';
import 'package:gc_wizard/widgets/tools/images_and_files/stegano.dart';
import 'package:gc_wizard/widgets/tools/images_and_files/visual_cryptography.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/alcohol_mass.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/apparent_temperature/heat_index.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/apparent_temperature/humidex.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/apparent_temperature/summer_simmer.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/apparent_temperature/windchill.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/apparent_temperature/wet_bulb_temperature.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/astronomy/moon_position.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/astronomy/moon_rise_set.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/astronomy/seasons.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/astronomy/shadow_length.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/astronomy/sun_position.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/astronomy/sun_rise_set.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/binary.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/blood_alcohol_content.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/colors/color_tool.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/colors/pantone_color_codes.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/combinatorics/combination.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/combinatorics/combination_permutation.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/combinatorics/permutation.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/complex_numbers.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/compound_interest.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/countries/countries_calling_codes.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/countries/countries_ioc_codes.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/countries/countries_iso_codes.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/countries/countries_vehicle_codes.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/countries/country_flags.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/cross_sums/cross_sum.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/cross_sums/cross_sum_range.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/cross_sums/cross_sum_range_frequency.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/cross_sums/iterated_cross_sum_range.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/cross_sums/iterated_cross_sum_range_frequency.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/date_and_time/calendar.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/date_and_time/day_calculator.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/date_and_time/day_of_the_year.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/date_and_time/time_calculator.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/date_and_time/weekday.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/decabit.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/divisor.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/dna/dna_aminoacids.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/dna/dna_aminoacids_table.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/dna/dna_nucleicacidsequence.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/dtmf.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/hexadecimal.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/iata_icao_search.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/ip_codes.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/mathematical_constants.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/music_notes/music_notes.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/numeralbases.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/periodic_table/atomic_numbers_to_text.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/periodic_table/periodic_table.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/periodic_table/periodic_table_data_view.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/physical_constants.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/piano.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/projectiles.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/quadratic_equation.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/recycling.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/segment_display/fourteen_segments.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/segment_display/seven_segments.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/segment_display/sixteen_segments.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/unit_converter.dart';
import 'package:gc_wizard/widgets/tools/symbol_tables/symbol_replacer/symbol_replacer.dart';
import 'package:gc_wizard/widgets/tools/uncategorized/zodiac.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';
import 'package:gc_wizard/widgets/utils/no_animation_material_page_route.dart';
import 'package:gc_wizard/widgets/utils/search_strings.dart';
import 'package:prefs/prefs.dart';

import 'package:gc_wizard/widgets/tools/science_and_technology/astronomy/right_ascension_to_degree.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/colors/ral_color_codes.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  var _isSearching = false;
  final _searchController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _searchText = '';
  final _SHOW_SUPPORT_HINT_EVERY_N = 50;

  @override
  void initState() {
    super.initState();
    Prefs.init();

    _searchController.addListener(() {
      setState(() {
        if (_searchController.text.isEmpty) {
          _searchText = '';
        } else if (_searchText != _searchController.text) {
          _searchText = _searchController.text;
        }
      });
    });

    _showWhatsNewDialog() {
      const _MAX_ENTRIES = 10;

      var mostRecentChangelogVersion = CHANGELOG.keys.first;
      var entries = i18n(context, 'changelog_' + mostRecentChangelogVersion)
          .split('\n')
          .map((entry) => entry.split('(')[0])
          .toList();
      if (entries.length > _MAX_ENTRIES) {
        entries = entries.sublist(0, _MAX_ENTRIES);
        entries.add('...');
      }

      showGCWDialog(
          context,
          i18n(context, 'common_newversion_title', parameters: [mostRecentChangelogVersion]),
          Text(entries.join('\n')),
          [
            GCWDialogButton(
                text: i18n(context, 'common_newversion_showchangelog'),
                onPressed: () {
                  Navigator.push(
                      context,
                      NoAnimationMaterialPageRoute(
                          builder: (context) =>
                              registeredTools.firstWhere((tool) => className(tool.tool) == className(Changelog()))));
                }),
            GCWDialogButton(text: i18n(context, 'common_ok'))
          ],
          cancelButton: false);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var countAppOpened = Prefs.getInt(PREFERENCE_APP_COUNT_OPENED);

      if (countAppOpened > 1 && Prefs.getString(PREFERENCE_CHANGELOG_DISPLAYED) != CHANGELOG.keys.first) {
        _showWhatsNewDialog();
        Prefs.setString(PREFERENCE_CHANGELOG_DISPLAYED, CHANGELOG.keys.first);
        return;
      }

      if (countAppOpened > 0 && (countAppOpened == 10 || countAppOpened % _SHOW_SUPPORT_HINT_EVERY_N == 0)) {
        showGCWAlertDialog(
          context,
          i18n(context, 'common_support_title'),
          i18n(context, 'common_support_text', parameters: [Prefs.getInt(PREFERENCE_APP_COUNT_OPENED)]),
          () => launchUrl(Uri.parse(i18n(context, 'common_support_link'))),
        );
      }
    });
  }

  @override
  void dispose() {
    Prefs.dispose();
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (registeredTools == null) initializeRegistry(context);
    if (_mainToolList == null) _initStaticToolList();
    Favorites.initialize();

    var toolList = (_isSearching && _searchText.length > 0) ? _getSearchedList() : null;
    return DefaultTabController(
      length: 3,
      initialIndex: Prefs.getBool(PREFERENCE_TABS_USE_DEFAULT_TAB)
          ? Prefs.get(PREFERENCE_TABS_DEFAULT_TAB)
          : Prefs.get(PREFERENCE_TABS_LAST_VIEWED_TAB),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            bottom: TabBar(
              onTap: (value) {
                Prefs.setInt(PREFERENCE_TABS_LAST_VIEWED_TAB, value);
              },
              tabs: [
                Tab(icon: Icon(Icons.category)),
                Tab(icon: Icon(Icons.list)),
                Tab(icon: Icon(Icons.star)),
              ],
            ),
            leading: _buildIcon(),
            title: _buildTitleAndSearchTextField(),
            actions: <Widget>[_buildSearchActionButton()]),
        drawer: buildMainMenu(context),
        body: TabBarView(
          children: [
            GCWToolList(toolList: toolList ?? _categoryList),
            GCWToolList(toolList: toolList ?? _mainToolList),
            GCWToolList(toolList: toolList ?? Favorites.favoritedGCWTools()),
          ],
        ),
      ),
    );
  }

  _buildSearchActionButton() {
    return IconButton(
      icon: Icon(_isSearching ? Icons.close : Icons.search),
      onPressed: () {
        setState(() {
          if (_isSearching) {
            _searchController.clear();
            _searchText = '';
          }

          _isSearching = !_isSearching;
        });
      },
    );
  }

  _buildTitleAndSearchTextField() {
    return _isSearching
        ? GCWTextField(
            autofocus: true,
            controller: _searchController,
            icon: Icon(Icons.search, color: themeColors().mainFont()),
            hintText: i18n(context, 'common_search') + '...')
        : Text(i18n(context, 'common_app_title'));
  }

  _buildIcon() {
    return IconButton(
        icon: Image.asset(
          'assets/logo/circle_border_128.png',
          width: 35.0,
          height: 35.0,
        ),
        onPressed: () => _scaffoldKey.currentState.openDrawer());
  }

  List<GCWTool> _getSearchedList() {
    var _sanitizedSearchText = removeAccents(_searchText.toLowerCase()).replaceAll(ALLOWED_SEARCH_CHARACTERS, '');

    if (_sanitizedSearchText.length == 0) return <GCWTool>[];

    Set<String> _queryTexts = _sanitizedSearchText.split(REGEXP_SPLIT_STRINGLIST).toSet();

    return registeredTools.where((tool) {
      if (tool.indexedSearchStrings == null) return false;

      //Search result as AND result of separated words
      for (final q in _queryTexts) {
        if (!tool.indexedSearchStrings.contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();
  }
}

List<GCWTool> _categoryList;
List<GCWTool> _mainToolList;

refreshToolLists() {
  _categoryList = null;
  _mainToolList = null;
}

void _initStaticToolList() {
  _mainToolList = registeredTools.where((element) {
    return [
      className(Abaddon()),
      className(ADFGVX()),
      className(Affine()),
      className(AlcoholMass()),
      className(ALGOL()),
      className(AlphabetValues()),
      className(Alphametics()),
      className(Amsco()),
      className(AnimatedImage()),
      className(AnimatedImageMorseCode()),
      className(Antipodes()),
      className(ASCIIValues()),
      className(Atbash()),
      className(AtomicNumbersToText()),
      className(BabylonNumbersSelection()),
      className(Bacon()),
      className(BaseSelection()),
      className(BCDSelection()),
      className(Beatnik()),
      className(BeaufortSelection()),
      className(Befunge()),
      className(Beghilos()),
      className(Bifid()),
      className(Binary()),
      className(Binary2Image()),
      className(BloodAlcoholContent()),
      className(BookCipher()),
      className(Bowling()),
      className(BrailleSelection()),
      className(Brainfk()),
      className(BundeswehrTalkingBoardAuthentification()),
      className(BundeswehrTalkingBoardObfuscation()),
      className(BurrowsWheeler()),
      className(Caesar()),
      className(Calendar()),
      className(Catan()),
      className(CenterThreePoints()),
      className(CenterTwoPoints()),
      className(CentroidArithmeticMean()),
      className(CentroidCenterOfGravity()),
      className(Chao()),
      className(ChappeTelegraph()),
      className(Chef()),
      className(ChickenLanguage()),
      className(Chronogram()),
      className(CipherWheel()),
      className(CistercianNumbersSelection()),
      className(ColorTool()),
      className(Combination()),
      className(CombinationPermutation()),
      className(ComplexNumbers()),
      className(CompoundInterest()),
      className(CoordinateAveraging()),
      className(CountriesCallingCodes()),
      className(CountriesFlags()),
      className(CountriesIOCCodes()),
      className(CountriesISOCodes()),
      className(CountriesVehicleCodes()),
      className(Cow()),
      className(CrossBearing()),
      className(CrossSum()),
      className(CrossSumRange()),
      className(CrossSumRangeFrequency()),
      className(DayCalculator()),
      className(DayOfTheYear()),
      className(Deadfish()),
      className(Decabit()),
      className(DistanceBearing()),
      className(Divisor()),
      className(DTMF()),
      className(DNAAminoAcids()),
      className(DNAAminoAcidsTable()),
      className(DNANucleicAcidSequence()),
      className(SilverRatioSelection()),
      className(DuckSpeak()),
      className(EasterSelection()),
      className(EarwigoTextDeobfuscation()),
      className(EdelcrantzTelegraph()),
      className(EllipsoidTransform()),
      className(EnclosedAreas()),
      className(Enigma()),
      className(ExifReader()),
      className(EquilateralTriangle()),
      className(ESelection()),
      className(FormatConverter()),
      className(FormulaSolverFormulaGroups()),
      className(FourteenSegments()),
      className(Fox()),
      className(Gade()),
      className(GaussWeberTelegraph()),
      className(GCCode()),
      className(Gray()),
      className(Gronsfeld()),
      className(HeatIndex()),
      className(HashBreaker()),
      className(HashSelection()),
      className(Hexadecimal()),
      className(HexString2File()),
      className(HexViewer()),
      className(HiddenData()),
      className(Hohoho()),
      className(Homophone()),
      className(Houdini()),
      className(Humidex()),
      className(IATAICAOSearch()),
      className(IceCodesSelection()),
      className(ILLIAC()),
      className(ImageColorCorrections()),
      className(ImageFlipRotate()),
      className(IntersectBearings()),
      className(IntersectFourPoints()),
      className(IntersectGeodeticAndCircle()),
      className(Intersection()),
      className(IntersectThreeCircles()),
      className(IntersectTwoCircles()),
      className(IPCodes()),
      className(IteratedCrossSumRange()),
      className(IteratedCrossSumRangeFrequency()),
      className(Kamasutra()),
      className(KarolRobot()),
      className(Kenny()),
      className(KeyboardSelection()),
      className(MagicEyeSolver()),
      className(MathematicalConstants()),
      className(Malbolge()),
      className(MapView()),
      className(MayaCalendarSelection()),
      className(MayaNumbersSelection()),
      className(MexicanArmyCipherWheel()),
      className(MoonPosition()),
      className(MoonRiseSet()),
      className(MorseSelection()),
      className(MurrayTelegraph()),
      className(MusicNotes()),
      className(Navajo()),
      className(NumberSequenceSelection()),
      className(MultiDecoder()),
      className(NumeralBases()),
      className(NumeralWordsSelection()),
      className(OhlsenTelegraph()),
      className(OneTimePad()),
      className(Ook()),
      className(PantoneColorCodes()),
      className(PasleyTelegraph()),
      className(PophamTelegraph()),
      className(PeriodicTable()),
      className(PeriodicTableDataView()),
      className(Permutation()),
      className(PhiSelection()),
      className(PhysicalConstants()),
      className(Piano()),
      className(Piet()),
      className(PiSelection()),
      className(PigLatin()),
      className(Playfair()),
      className(Pokemon()),
      className(Polybios()),
      className(PredatorSelection()),
      className(PrimeAlphabet()),
      className(PrimesSelection()),
      className(Projectiles()),
      className(PrussiaTelegraph()),
      className(QrCode()),
      className(QuadraticEquation()),
      className(Rabbit()),
      className(RailFence()),
      className(RALColorCodes()),
      className(RC4()),
      className(Recycling()),
      className(Resection()),
      className(ResistorSelection()),
      className(Reverse()),
      className(RightAscensionToDegree()),
      className(RobberLanguage()),
      className(RomanNumbers()),
      className(Rot123()),
      className(Rot13()),
      className(Rot18()),
      className(Rot5()),
      className(Rot47()),
      className(RotationGeneral()),
      className(RSASelection()),
      className(SchillingCanstattTelegraph()),
      className(ScrabbleSelection()),
      className(ShadowLength()),
      className(ShadoksSelection()),
      className(Seasons()),
      className(SemaphoreTelegraph()),
      className(SevenSegments()),
      className(SixteenSegments()),
      className(Skytale()),
      className(Solitaire()),
      className(SpoonLanguage()),
      className(SQRT2Selection()),
      className(SQRT3Selection()),
      className(SQRT5Selection()),
      className(Stegano()),
      className(StraddlingCheckerboard()),
      className(Substitution()),
      className(SubstitutionBreaker()),
      className(SudokuSolver()),
      className(SummerSimmerIndex()),
      className(SunPosition()),
      className(SunRiseSet()),
      className(SymbolReplacer()),
      className(SymbolTableSelection()),
      className(TapCode()),
      className(Tapir()),
      className(TeletypewriterSelection()),
      className(TeletypewriterPunchTape()),
      className(TextAnalysis()),
      className(TimeCalculator()),
      className(TomTomSelection()),
      className(Trifid()),
      className(Trithemius()),
      className(TTS()),
      className(UnitConverter()),
      className(UrwigoHashBreaker()),
      className(UrwigoTextDeobfuscation()),
      className(VanitySelection()),
      className(VariableCoordinateFormulas()),
      className(Vigenere()),
      className(VigenereBreaker()),
      className(VisualCryptography()),
      className(WASD()),
      className(WaypointProjection()),
      className(Weekday()),
      className(WetBulbTemperature()),
      className(WherigoSelection()),
      className(WheatstoneCookeNeedleTelegraph()),
      className(WhitespaceLanguage()),
      className(WigWagSemaphoreTelegraph()),
      className(Windchill()),
      className(Z22()),
      className(ZamonianNumbers()),
      className(ZC1()),
      className(Zodiac()),
    ].contains(className(element.tool));
  }).toList();
  _mainToolList.sort((a, b) => sortToolList(a, b));

  _categoryList = registeredTools.where((element) {
    return [
      className(CoordsSelection()),
      className(CryptographySelection()),
      className(FormulaSolverFormulaGroups()),
      className(GamesSelection()),
      className(GeneralCodebreakersSelection()),
      className(ImagesAndFilesSelection()),
      className(ScienceAndTechnologySelection()),
      className(SymbolTableSelection()),
    ].contains(className(element.tool));
  }).toList();

  _categoryList.sort((a, b) => sortToolList(a, b));
}
