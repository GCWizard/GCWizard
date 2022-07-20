import 'package:gc_wizard/main.reflectable.dart';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/utils/common_utils.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/tools/common/base/gcw_dialog/widget/gcw_dialog.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_tool/widget/gcw_tool.dart';
import 'package:gc_wizard/tools/common/gcw_toollist/widget/gcw_toollist.dart';
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
import 'package:gc_wizard/widgets/selector_lists/symbol_table_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/teletypewriter_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/tomtom_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/vanity_selection.dart';
import 'package:gc_wizard/widgets/selector_lists/wherigo_urwigo_selection.dart';
import 'package:gc_wizard/tools/coords/antipodes/widget/antipodes.dart';
import 'package:gc_wizard/tools/coords/center_three_points/widget/center_three_points.dart';
import 'package:gc_wizard/tools/coords/center_two_points/widget/center_two_points.dart';
import 'package:gc_wizard/tools/coords/centroid_arithmetic_mean/widget/centroid_arithmetic_mean.dart';
import 'package:gc_wizard/tools/coords/centroid_center_of_gravity/widget/centroid_center_of_gravity.dart';
import 'package:gc_wizard/tools/coords/coordinate_averaging/widget/coordinate_averaging.dart';
import 'package:gc_wizard/tools/coords/cross_bearing/widget/cross_bearing.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/widget/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/ellipsoid_transform/widget/ellipsoid_transform.dart';
import 'package:gc_wizard/tools/coords/equilateral_triangle/widget/equilateral_triangle.dart';
import 'package:gc_wizard/tools/coords/format_converter/widget/format_converter.dart';
import 'package:gc_wizard/tools/coords/intersect_bearing_and_circle/widget/intersect_bearing_and_circle.dart';
import 'package:gc_wizard/tools/coords/intersect_bearings/widget/intersect_bearings.dart';
import 'package:gc_wizard/tools/coords/intersect_four_points/widget/intersect_four_points.dart';
import 'package:gc_wizard/tools/coords/intersect_three_circles/widget/intersect_three_circles.dart';
import 'package:gc_wizard/tools/coords/intersect_two_circles/widget/intersect_two_circles.dart';
import 'package:gc_wizard/tools/coords/intersection/widget/intersection.dart';
import 'package:gc_wizard/tools/coords/map_view/map_view/widget/map_view.dart';
import 'package:gc_wizard/tools/coords/resection/widget/resection.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/variable_coordinate_formulas/widget/variable_coordinate_formulas.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/widget/waypoint_projection.dart';
import '../tools/crypto_and_encodings/abaddon/widget/abaddon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/adfgvx/widget/adfgvx.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/affine/widget/affine.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/algol/widget/algol.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/widget/alphabet_values.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/amsco/widget/amsco.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/atbash/widget/atbash.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bacon/widget/bacon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/beghilos/widget/beghilos.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bifid/widget/bifid.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/book_cipher/widget/book_cipher.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/burrows_wheeler/widget/burrows_wheeler.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/caesar/widget/caesar.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/chao/widget/chao.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/charsets/ascii_values/widget/ascii_values.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/cipher_wheel/widget/cipher_wheel.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/enclosed_areas/widget/enclosed_areas.dart';
import '../tools/crypto_and_encodings/enigma/widget/enigma.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/beatnik_language/widget/beatnik_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/brainfk/widget/brainfk.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/widget/chef_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/cow/widget/cow.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/deadfish/widget/deadfish.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/hohoho/widget/hohoho.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/karol_robot/widget/karol_robot.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/malbolge/widget/malbolge.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/ook/widget/ook.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/whitespace_language/widget/whitespace_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/fox/widget/fox.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/gade/widget/gade.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/gc_code/widget/gc_code.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/widget/substitution_breaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/widget/vigenere_breaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/gray/widget/gray.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/gronsfeld/widget/gronsfeld.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/hash_breaker/widget/hash_breaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/homophone/widget/homophone.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/houdini/widget/houdini.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/illiac/widget/illiac.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/kamasutra/widget/kamasutra.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/kenny/widget/kenny.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/chicken_language/widget/chicken_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/duck_speak/widget/duck_speak.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/pig_latin/widget/pig_latin.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/robber_language/widget/robber_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/spoon_language/widget/spoon_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/mexican_army_cipher_wheel/widget/mexican_army_cipher_wheel.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/navajo/widget/navajo.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/one_time_pad/widget/one_time_pad.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/playfair/widget/playfair.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/pokemon/widget/pokemon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/widget/polybios.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/prime_alphabet/widget/prime_alphabet.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rail_fence/widget/rail_fence.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rc4/widget/rc4.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/reverse/widget/reverse.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/roman_numbers/chronogram/widget/chronogram.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/roman_numbers/roman_numbers/widget/roman_numbers.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/rot123/widget/rot123.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/rot13/widget/rot13.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/rot18/widget/rot18.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/rot47/widget/rot47.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/rot5/widget/rot5.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/rotation_general/widget/rotation_general.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/skytale/widget/skytale.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/solitaire/widget/solitaire.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/straddling_checkerboard/widget/straddling_checkerboard.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/widget/substitution.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/tap_code/widget/tap_code.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/tapir/widget/tapir.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/telegraphs/chappe/widget/chappe.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/telegraphs/edelcrantz/widget/edelcrantz.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/telegraphs/gauss_weber_telegraph/widget/gauss_weber_telegraph.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/telegraphs/murray/widget/murray.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/telegraphs/ohlsen_telegraph/widget/ohlsen_telegraph.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/telegraphs/pasley_telegraph/widget/pasley_telegraph.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/telegraphs/popham_telegraph/widget/popham_telegraph.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/telegraphs/prussiatelegraph/widget/prussiatelegraph.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/telegraphs/schilling_canstatt_telegraph/widget/schilling_canstatt_telegraph.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/telegraphs/semaphore/widget/semaphore.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/telegraphs/wheatstone_cooke_5_needles/widget/wheatstone_cooke_5_needles.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/telegraphs/wigwag/widget/wigwag.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/teletypewriter/punchtape/widget/punchtape.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/trifid/widget/trifid.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/trithemius/widget/trithemius.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/tts/widget/tts.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/widget/vigenere.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/wasd/widget/wasd.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/wherigo_urwigo/earwigo_text_deobfuscation/widget/earwigo_text_deobfuscation.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/wherigo_urwigo/urwigo_hashbreaker/widget/urwigo_hashbreaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/wherigo_urwigo/urwigo_text_deobfuscation/widget/urwigo_text_deobfuscation.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/z22/widget/z22.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/zamonian_numbers/widget/zamonian_numbers.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/zc1/widget/zc1.dart';
import 'package:gc_wizard/tools/formula_solver/formula_solver_formulagroups/widget/formula_solver_formulagroups.dart';
import 'package:gc_wizard/tools/games/catan/widget/catan.dart';
import 'package:gc_wizard/tools/games/sudoku/sudoku_solver/widget/sudoku_solver.dart';
import 'package:gc_wizard/tools/images_and_files/animated_image/widget/animated_image.dart';
import 'package:gc_wizard/tools/images_and_files/animated_image_morse_code/widget/animated_image_morse_code.dart';
import 'package:gc_wizard/tools/images_and_files/binary2image/widget/binary2image.dart';
import 'package:gc_wizard/tools/images_and_files/exif_reader/widget/exif_reader.dart';
import 'package:gc_wizard/tools/images_and_files/hex_viewer/widget/hex_viewer.dart';
import 'package:gc_wizard/tools/images_and_files/hexstring2file/widget/hexstring2file.dart';
import 'package:gc_wizard/tools/images_and_files/hidden_data/widget/hidden_data.dart';
import 'package:gc_wizard/tools/images_and_files/image_colorcorrections/widget/image_colorcorrections.dart';
import 'package:gc_wizard/tools/images_and_files/image_flip_rotate/widget/image_flip_rotate.dart';
import 'package:gc_wizard/tools/images_and_files/qr_code/widget/qr_code.dart';
import 'package:gc_wizard/tools/images_and_files/stegano/widget/stegano.dart';
import 'package:gc_wizard/tools/images_and_files/visual_cryptography/widget/visual_cryptography.dart';
import 'package:gc_wizard/tools/science_and_technology/alcohol_mass/widget/alcohol_mass.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/heat_index/widget/heat_index.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/humidex/widget/humidex.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/summer_simmer/widget/summer_simmer.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/windchill/widget/windchill.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/moon_position/widget/moon_position.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/moon_rise_set/widget/moon_rise_set.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/seasons/widget/seasons.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/shadow_length/widget/shadow_length.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/sun_position/widget/sun_position.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/sun_rise_set/widget/sun_rise_set.dart';
import 'package:gc_wizard/tools/science_and_technology/binary/widget/binary.dart';
import 'package:gc_wizard/tools/science_and_technology/blood_alcohol_content/widget/blood_alcohol_content.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/color_tool/widget/color_tool.dart';
import 'package:gc_wizard/tools/science_and_technology/combinatorics/combination/widget/combination.dart';
import 'package:gc_wizard/tools/science_and_technology/combinatorics/combination_permutation/widget/combination_permutation.dart';
import 'package:gc_wizard/tools/science_and_technology/combinatorics/permutation/widget/permutation.dart';
import 'package:gc_wizard/tools/science_and_technology/complex_numbers/widget/complex_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/compound_interest/widget/compound_interest.dart';
import 'package:gc_wizard/tools/science_and_technology/countries/countries_calling_codes/widget/countries_calling_codes.dart';
import 'package:gc_wizard/tools/science_and_technology/countries/countries_ioc_codes/widget/countries_ioc_codes.dart';
import 'package:gc_wizard/tools/science_and_technology/countries/countries_iso_codes/widget/countries_iso_codes.dart';
import 'package:gc_wizard/tools/science_and_technology/countries/countries_vehicle_codes/widget/countries_vehicle_codes.dart';
import 'package:gc_wizard/tools/science_and_technology/countries/country_flags/widget/country_flags.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/cross_sum/widget/cross_sum.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/cross_sum_range/widget/cross_sum_range.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/cross_sum_range_frequency/widget/cross_sum_range_frequency.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/iterated_cross_sum_range/widget/iterated_cross_sum_range.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/iterated_cross_sum_range_frequency/widget/iterated_cross_sum_range_frequency.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/widget/calendar.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/day_calculator/widget/day_calculator.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/time_calculator/widget/time_calculator.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/weekday/widget/weekday.dart';
import 'package:gc_wizard/tools/science_and_technology/decabit/widget/decabit.dart';
import 'package:gc_wizard/tools/science_and_technology/divisor/widget/divisor.dart';
import 'package:gc_wizard/tools/science_and_technology/dna/dna_aminoacids/widget/dna_aminoacids.dart';
import 'package:gc_wizard/tools/science_and_technology/dna/dna_aminoacids_table/widget/dna_aminoacids_table.dart';
import 'package:gc_wizard/tools/science_and_technology/dna/dna_nucleicacidsequence/widget/dna_nucleicacidsequence.dart';
import 'package:gc_wizard/tools/science_and_technology/dtmf/widget/dtmf.dart';
import 'package:gc_wizard/tools/science_and_technology/hexadecimal/widget/hexadecimal.dart';
import 'package:gc_wizard/tools/science_and_technology/iata_icao_search/widget/iata_icao_search.dart';
import 'package:gc_wizard/tools/science_and_technology/ip_codes/widget/ip_codes.dart';
import 'package:gc_wizard/tools/science_and_technology/numeralbases/widget/numeralbases.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/atomic_numbers_to_text/widget/atomic_numbers_to_text.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/periodic_table/widget/periodic_table.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/periodic_table_data_view/widget/periodic_table_data_view.dart';
import 'package:gc_wizard/tools/science_and_technology/physical_constants/widget/physical_constants.dart';
import 'package:gc_wizard/tools/science_and_technology/piano/widget/piano.dart';
import 'package:gc_wizard/tools/science_and_technology/projectiles/widget/projectiles.dart';
import 'package:gc_wizard/tools/science_and_technology/quadratic_equation/widget/quadratic_equation.dart';
import 'package:gc_wizard/tools/science_and_technology/ral_color_codes/widget/ral_color_codes.dart';
import 'package:gc_wizard/tools/science_and_technology/recycling/widget/recycling.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/fourteen_segments/widget/fourteen_segments.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/seven_segments/widget/seven_segments.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/sixteen_segments/widget/sixteen_segments.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/widget/unit_converter.dart';
import 'package:gc_wizard/tools/symbol_tables/symbol_replacer/symbol_replacer/widget/symbol_replacer.dart';
import 'package:gc_wizard/tools/uncategorized/zodiac/widget/zodiac.dart';
import 'package:gc_wizard/tools/utils/common_widget_utils/widget/common_widget_utils.dart';
import 'package:gc_wizard/tools/utils/no_animation_material_page_route/widget/no_animation_material_page_route.dart';
import 'package:prefs/prefs.dart';
import 'package:url_launcher/url_launcher.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  var _isSearching = false;
  final _searchController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _searchText = '';
  final _showSupportHintEveryN = 50;

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
      var countAppOpened = Prefs.getInt('app_count_opened');

      if (countAppOpened > 1 && Prefs.getString('changelog_displayed') != CHANGELOG.keys.first) {
        _showWhatsNewDialog();
        Prefs.setString('changelog_displayed', CHANGELOG.keys.first);
        return;
      }

      if (countAppOpened == 10 || countAppOpened % _showSupportHintEveryN == 0) {
        showGCWAlertDialog(
          context,
          i18n(context, 'common_support_title'),
          i18n(context, 'common_support_text', parameters: [Prefs.getInt('app_count_opened')]),
          () => launch(i18n(context, 'common_support_link')),
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
    initializeReflectable();

    if (registeredTools == null) initializeRegistry(context);
    if (_mainToolList == null) _initStaticToolList();
    Favorites.initialize();

    var toolList = (_isSearching && _searchText.length > 0) ? _getSearchedList() : null;

    return DefaultTabController(
      length: 3,
      initialIndex:
          Prefs.getBool('tabs_use_default_tab') ? Prefs.get('tabs_default_tab') : Prefs.get('tabs_last_viewed_tab'),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            bottom: TabBar(
              onTap: (value) {
                Prefs.setInt('tabs_last_viewed_tab', value);
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
            GCWToolList(toolList: toolList ?? Favorites.toolList),
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
    Set<String> _queryTexts = removeAccents(_searchText.toLowerCase()).split(REGEXP_SPLIT_STRINGLIST).toSet();

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
  refreshRegistry();
  _categoryList = null;
  _mainToolList = null;
}

void _initStaticToolList() {
  _mainToolList = registeredTools.where((element) {
    return [
      // className(Abaddon()),
      className(ADFGVX()),
      className(Affine()),
      className(AlcoholMass()),
      className(ALGOL()),
      className(AlphabetValues()),
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
      className(Beghilos()),
      className(Bifid()),
      className(Binary()),
      className(Binary2Image()),
      className(BloodAlcoholContent()),
      className(BookCipher()),
      className(BrailleSelection()),
      className(Brainfk()),
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
      className(Malbolge()),
      className(MapView()),
      className(MayaCalendarSelection()),
      className(MayaNumbersSelection()),
      className(MexicanArmyCipherWheel()),
      className(MoonPosition()),
      className(MoonRiseSet()),
      className(MorseSelection()),
      className(MurrayTelegraph()),
      className(Navajo()),
      className(NumberSequenceSelection()),
      className(MultiDecoder()),
      className(NumeralBases()),
      className(NumeralWordsSelection()),
      className(OhlsenTelegraph()),
      className(OneTimePad()),
      className(Ook()),
      className(PasleyTelegraph()),
      className(PophamTelegraph()),
      className(PeriodicTable()),
      className(PeriodicTableDataView()),
      className(Permutation()),
      className(PhiSelection()),
      className(PhysicalConstants()),
      className(Piano()),
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
      className(RailFence()),
      className(RALColorCodes()),
      className(RC4()),
      className(Recycling()),
      className(Resection()),
      className(ResistorSelection()),
      className(Reverse()),
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

  _mainToolList.sort((a, b) => sortToolListAlphabetically(a, b));

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

  _categoryList.sort((a, b) => sortToolListAlphabetically(a, b));
}
