import 'package:flutter/material.dart';
import 'package:gc_wizard/application/category_views/favorites.dart';
import 'package:gc_wizard/application/category_views/selector_lists/babylon_numbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/base_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/bcd_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/beaufort_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/braille_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/cistercian_numbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/coords_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/cryptography_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/e_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/easter_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/games_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/general_codebreakers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/hash_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/icecodes_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/imagesandfiles_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/keyboard_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/maya_calendar_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/maya_numbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/miscellaneous_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/morse_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/numeral_words_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/phi_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/pi_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/predator_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/primes_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/resistor_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/rsa_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/scienceandtechnology_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/scrabble_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/shadoks_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/silverratio_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/sqrt2_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/sqrt3_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/sqrt5_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/symbol_table_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/teletypewriter_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/tomtom_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/uic_wagoncode_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/vanity_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/wherigo_urwigo_selection.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/main_menu/changelog.dart';
import 'package:gc_wizard/application/main_menu/main_menu.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/searchstrings/logic/search_strings.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/application/webapi/deeplinks/deeplinks.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/common_widgets/gcw_web_statefulwidget.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/coords/antipodes/widget/antipodes.dart';
import 'package:gc_wizard/tools/coords/centerpoint/center_three_points/widget/center_three_points.dart';
import 'package:gc_wizard/tools/coords/centerpoint/center_two_points/widget/center_two_points.dart';
import 'package:gc_wizard/tools/coords/centroid/centroid_arithmetic_mean/widget/centroid_arithmetic_mean.dart';
import 'package:gc_wizard/tools/coords/centroid/centroid_center_of_gravity/widget/centroid_center_of_gravity.dart';
import 'package:gc_wizard/tools/coords/coordinate_averaging/widget/coordinate_averaging.dart';
import 'package:gc_wizard/tools/coords/cross_bearing/widget/cross_bearing.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/widget/distancebearing_geodetic.dart';
import 'package:gc_wizard/tools/coords/ellipsoid_transform/widget/ellipsoid_transform.dart';
import 'package:gc_wizard/tools/coords/equilateral_triangle/widget/equilateral_triangle.dart';
import 'package:gc_wizard/tools/coords/format_converter/widget/format_converter.dart';
import 'package:gc_wizard/tools/coords/geohashing/widget/geohashing.dart';
import 'package:gc_wizard/tools/coords/intersect_bearing_and_circle/widget/intersect_bearing_and_circle.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_bearings/widget/intersect_bearings.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_four_points/widget/intersect_four_points.dart';
import 'package:gc_wizard/tools/coords/intersect_three_circles/widget/intersect_three_circles.dart';
import 'package:gc_wizard/tools/coords/intersect_two_circles/widget/intersect_two_circles.dart';
import 'package:gc_wizard/tools/coords/intersection/widget/intersection.dart';
import 'package:gc_wizard/tools/coords/map_view/widget/map_view.dart';
import 'package:gc_wizard/tools/coords/resection/widget/resection.dart';
import 'package:gc_wizard/tools/coords/rhumb_line/widget/rhumbline_distancebearing.dart';
import 'package:gc_wizard/tools/coords/rhumb_line/widget/rhumbline_waypoint_projection.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/widget/variable_coordinate_formulas.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/widget/waypoint_projection_geodetic.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/abaddon/widget/abaddon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/adfgvx/widget/adfgvx.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/affine/widget/affine.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/widget/alphabet_values.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/amsco/widget/amsco.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/atbash/widget/atbash.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/avemaria/widget/avemaria.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bacon/widget/bacon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bacon/widget/bacon_analyze.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/battleship/widget/battleship.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/beghilos/widget/beghilos.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bifid/widget/bifid.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/book_cipher/widget/book_cipher.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bundeswehr_talkingboard/bundeswehr_auth/widget/bundeswehr_auth.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bundeswehr_talkingboard/bundeswehr_code/widget/bundeswehr_code.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/burrows_wheeler/widget/burrows_wheeler.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/caesar/widget/caesar.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/chao/widget/chao.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/charsets/ascii_values/widget/ascii_values.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/cipher_wheel/widget/cipher_wheel.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/enclosed_areas/widget/enclosed_areas.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/enigma/widget/enigma.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/beatnik_language/widget/beatnik_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/befunge/widget/befunge.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/brainfk/widget/brainfk.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/widget/chef_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/cow/widget/cow.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/deadfish/widget/deadfish.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/hohoho/widget/hohoho.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/karol_robot/widget/karol_robot.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/malbolge/widget/malbolge.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/ook/widget/ook.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/piet/widget/piet.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/whitespace_language/widget/whitespace_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/fox/widget/fox.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/gade/widget/gade.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/gc_code/widget/gc_code.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/widget/substitution_breaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/widget/vigenere_breaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/gray/widget/gray.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/gronsfeld/widget/gronsfeld.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/hash_breaker/widget/hash_breaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/homophone/widget/homophone.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/houdini/widget/houdini.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/kamasutra/widget/kamasutra.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/kenny/widget/kenny.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/chicken_language/widget/chicken_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/duck_speak/widget/duck_speak.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/judoon/widget/judoon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/pig_latin/widget/pig_latin.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/robber_language/widget/robber_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/spoon_language/widget/spoon_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/mexican_army_cipher_wheel/widget/mexican_army_cipher_wheel.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/morbit/widget/morbit.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/navajo/widget/navajo.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/navajo/widget/navajo_list.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/one_time_pad/widget/one_time_pad.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/playfair/widget/playfair.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/pokemon/widget/pokemon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/pollux/widget/pollux.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/porta/widget/porta.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/widget/polybios.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/prime_alphabet/widget/prime_alphabet.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rabbit/widget/rabbit.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/ragbaby/widget/ragbaby.dart';
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
import 'package:gc_wizard/tools/crypto_and_encodings/slash_and_pipe/widget/slash_and_pipe.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/solitaire/widget/solitaire.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/straddling_checkerboard/widget/straddling_checkerboard.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/widget/substitution.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/tap_code/widget/tap_code.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/tapir/widget/tapir.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/text_analysis/widget/text_analysis.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/trifid/widget/trifid.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/trithemius/widget/trithemius.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/universal_product_code/widget/universal_product_code.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/widget/vigenere.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/wasd/widget/wasd.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/zamonian_numbers/widget/zamonian_numbers.dart';
import 'package:gc_wizard/tools/formula_solver/widget/formula_solver_formulagroups.dart';
import 'package:gc_wizard/tools/games/bowling/widget/bowling.dart';
import 'package:gc_wizard/tools/games/catan/widget/catan.dart';
import 'package:gc_wizard/tools/games/logical_supporter/widget/logical_supporter.dart';
import 'package:gc_wizard/tools/games/nonogram/widget/nonogram_solver.dart';
import 'package:gc_wizard/tools/games/number_pyramid/widget/number_pyramid_solver.dart';
import 'package:gc_wizard/tools/games/sudoku/sudoku_solver/widget/sudoku_solver.dart';
import 'package:gc_wizard/tools/games/tower_of_hanoi/widget/tower_of_hanoi.dart';
import 'package:gc_wizard/tools/games/word_search/widget/word_search.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_selection.dart';
import 'package:gc_wizard/tools/images_and_files/animated_image/widget/animated_image.dart';
import 'package:gc_wizard/tools/images_and_files/animated_image_morse_code/widget/animated_image_morse_code.dart';
import 'package:gc_wizard/tools/images_and_files/binary2image/widget/binary2image.dart';
import 'package:gc_wizard/tools/images_and_files/exif_reader/widget/exif_reader.dart';
import 'package:gc_wizard/tools/images_and_files/hex_viewer/widget/hex_viewer.dart';
import 'package:gc_wizard/tools/images_and_files/hexstring2file/widget/hexstring2file.dart';
import 'package:gc_wizard/tools/images_and_files/hidden_data/widget/hidden_data.dart';
import 'package:gc_wizard/tools/images_and_files/image_colorcorrections/widget/image_colorcorrections.dart';
import 'package:gc_wizard/tools/images_and_files/image_flip_rotate/widget/image_flip_rotate.dart';
import 'package:gc_wizard/tools/images_and_files/image_stretch_shrink/widget/image_stretch_shrink.dart';
import 'package:gc_wizard/tools/images_and_files/magic_eye_solver/widget/magic_eye_solver.dart';
import 'package:gc_wizard/tools/images_and_files/qr_code/widget/qr_code.dart';
import 'package:gc_wizard/tools/images_and_files/stegano/widget/stegano.dart';
import 'package:gc_wizard/tools/images_and_files/visual_cryptography/widget/visual_cryptography.dart';
import 'package:gc_wizard/tools/general_tools/gcwizardscript/widget/gcwizard_script.dart';
import 'package:gc_wizard/tools/science_and_technology/alcohol_mass/widget/alcohol_mass.dart';
import 'package:gc_wizard/tools/science_and_technology/alphabet_number_systems/hebrew/widget/hebrew_number_system.dart';
import 'package:gc_wizard/tools/science_and_technology/alphabet_number_systems/milesian/widget/milesian_number_system.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/heat_index/widget/heat_index.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/humidex/widget/humidex.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/summer_simmer/widget/summer_simmer.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/wet_bulb_temperature/widget/wet_bulb_temperature.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/windchill/widget/windchill.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/iau_constellation/widget/iau_all_constellations.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/iau_constellation/widget/iau_single_constellations.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/moon_position/widget/moon_position.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/moon_rise_set/widget/moon_rise_set.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/right_ascension_to_degree/widget/right_ascension_to_degree.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/seasons/widget/seasons.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/shadow_length/widget/shadow_length.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/sun_position/widget/sun_position.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/sun_rise_set/widget/sun_rise_set.dart';
import 'package:gc_wizard/tools/science_and_technology/binary/widget/binary.dart';
import 'package:gc_wizard/tools/science_and_technology/blood_alcohol_content/widget/blood_alcohol_content.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/color_tool/widget/color_tool.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/pantone_color_codes/widget/pantone_color_codes.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/ral_color_codes/widget/ral_color_codes.dart';
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
import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar_week/widget/calendar_week.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/day_calculator/widget/day_calculator.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/day_of_the_year/widget/day_of_the_year.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/excel_time/widget/excel_time.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/time_calculator/widget/time_calculator.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/epoch_time/unix_time/widget/unix_time.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/weekday/widget/weekday.dart';
import 'package:gc_wizard/tools/science_and_technology/decabit/widget/decabit.dart';
import 'package:gc_wizard/tools/science_and_technology/divisor/widget/divisor.dart';
import 'package:gc_wizard/tools/science_and_technology/dna/dna_aminoacids/widget/dna_aminoacids.dart';
import 'package:gc_wizard/tools/science_and_technology/dna/dna_aminoacids_table/widget/dna_aminoacids_table.dart';
import 'package:gc_wizard/tools/science_and_technology/dna/dna_nucleicacidsequence/widget/dna_nucleicacidsequence.dart';
import 'package:gc_wizard/tools/science_and_technology/dtmf/widget/dtmf.dart';
import 'package:gc_wizard/tools/science_and_technology/gcd/widget/gcd.dart';
import 'package:gc_wizard/tools/science_and_technology/hexadecimal/widget/hexadecimal.dart';
import 'package:gc_wizard/tools/science_and_technology/iata_icao_search/widget/iata_icao_search.dart';
import 'package:gc_wizard/tools/science_and_technology/ieee754/widget/ieee754.dart';
import 'package:gc_wizard/tools/science_and_technology/ip_codes/widget/ip_codes.dart';
import 'package:gc_wizard/tools/science_and_technology/lcm/widget/lcm.dart';
import 'package:gc_wizard/tools/science_and_technology/mathematical_constants/widget/mathematical_constants.dart';
import 'package:gc_wizard/tools/science_and_technology/music_notes/music_notes/widget/music_notes.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/widget/numeral_bases.dart';
import 'package:gc_wizard/tools/science_and_technology/paperformat/widget/paperformat.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/atomic_numbers_to_text/widget/atomic_numbers_to_text.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/periodic_table/widget/periodic_table.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/periodic_table_data_view/widget/periodic_table_data_view.dart';
import 'package:gc_wizard/tools/science_and_technology/physical_constants/widget/physical_constants.dart';
import 'package:gc_wizard/tools/science_and_technology/piano/widget/piano.dart';
import 'package:gc_wizard/tools/science_and_technology/postcode/widget/postcode.dart';
import 'package:gc_wizard/tools/science_and_technology/projectiles/widget/projectiles.dart';
import 'package:gc_wizard/tools/science_and_technology/quadratic_equation/widget/quadratic_equation.dart';
import 'package:gc_wizard/tools/science_and_technology/recycling/widget/recycling.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/14_segment_display/widget/fourteen_segments.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/16_segment_display/widget/sixteen_segments.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/7_segment_display/widget/seven_segments.dart';
import 'package:gc_wizard/tools/science_and_technology/sort/widget/sort.dart';
import 'package:gc_wizard/tools/science_and_technology/spelling_alphabets/spelling_alphabets_crypt/widget/spelling_alphabets_crypt.dart';
import 'package:gc_wizard/tools/science_and_technology/spelling_alphabets/spelling_alphabets_list/widget/spelling_alphabets_list.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/chappe/widget/chappe.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/edelcrantz/widget/edelcrantz.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/gauss_weber_telegraph/widget/gauss_weber_telegraph.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/murray/widget/murray.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/ohlsen_telegraph/widget/ohlsen_telegraph.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/pasley_telegraph/widget/pasley_telegraph.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/popham_telegraph/widget/popham_telegraph.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/prussia_telegraph/widget/prussia_telegraph.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/schilling_canstatt_telegraph/widget/schilling_canstatt_telegraph.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/semaphore/widget/semaphore.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/steinheil/widget/steinheil.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/wheatstone_cooke_5_needles/widget/wheatstone_cooke_5_needles.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/wigwag/widget/wigwag.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/algol/widget/algol.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/illiac/widget/illiac.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/punchtape/widget/punchtape.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/tts/widget/tts.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/z22/widget/z22.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/zc1/widget/zc1.dart';
import 'package:gc_wizard/tools/science_and_technology/ufi/widget/ufi.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/widget/unit_converter.dart';
import 'package:gc_wizard/tools/science_and_technology/velocity_acceleration/widget/velocity_acceleration.dart';
import 'package:gc_wizard/tools/symbol_tables/symbol_replacer/widget/symbol_replacer.dart';
import 'package:gc_wizard/tools/uncategorized/wedding_anniversaries/widget/wedding_anniversaries.dart';
import 'package:gc_wizard/tools/uncategorized/zodiac/widget/zodiac.dart';
import 'package:gc_wizard/tools/wherigo/earwigo_text_deobfuscation/widget/earwigo_text_deobfuscation.dart';
import 'package:gc_wizard/tools/wherigo/urwigo_hashbreaker/widget/urwigo_hashbreaker.dart';
import 'package:gc_wizard/tools/wherigo/urwigo_text_deobfuscation/widget/urwigo_text_deobfuscation.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';
import 'package:prefs/prefs.dart';

class MainView extends GCWWebStatefulWidget {
  MainView({Key? key, Map<String, String>? webParameter})
      : super(key: key, webParameter: webParameter, apiSpecification: null);

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
                      NoAnimationMaterialPageRoute<GCWTool>(
                          builder: (context) => registeredTools
                              .firstWhere((tool) => className(tool.tool) == className(const Changelog()))));
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
    if (registeredTools.isEmpty) {
      initializeRegistry(context);

      var deepLink = _checkDeepLink();
      if (deepLink != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(context, deepLink);
        });
        widget.webParameter = null;
      }
    }
    if (_mainToolList.isEmpty) _initStaticToolList();
    Favorites.initialize();

    var toolList = (_isSearching && _searchText.isNotEmpty) ? _getSearchedList() : null;

    return DefaultTabController(
      length: 3,
      initialIndex: Prefs.getBool(PREFERENCE_TABS_USE_DEFAULT_TAB)
          ? Prefs.getInt(PREFERENCE_TABS_DEFAULT_TAB)
          : Prefs.getInt(PREFERENCE_TABS_LAST_VIEWED_TAB),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            bottom: TabBar(
              onTap: (value) {
                Prefs.setInt(PREFERENCE_TABS_LAST_VIEWED_TAB, value);
              },
              tabs: const [
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

  NoAnimationMaterialPageRoute<GCWTool>? _checkDeepLink() {
    if (widget.hasWebParameter()) {
      return createStartDeepLinkRoute(context, widget.webParameter!);
    }
    return null;
  }

  IconButton _buildSearchActionButton() {
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

  Widget _buildTitleAndSearchTextField() {
    return _isSearching
        ? GCWTextField(
            autofocus: true,
            controller: _searchController,
            icon: Icon(Icons.search, color: themeColors().mainFont()),
            hintText: i18n(context, 'common_search') + '...')
        : Text(i18n(context, 'common_app_title'));
  }

  IconButton _buildIcon() {
    return IconButton(
        icon: Image.asset(
          applogoFilename(),
          width: 35.0,
          height: 35.0,
        ),
        onPressed: () => _scaffoldKey.currentState?.openDrawer());
  }

  List<GCWTool> _getSearchedList() {
    var _sanitizedSearchText = removeAccents(_searchText.toLowerCase()).replaceAll(NOT_ALLOWED_SEARCH_CHARACTERS, '');

    if (_sanitizedSearchText.isEmpty) return <GCWTool>[];

    Set<String> _queryTexts = _sanitizedSearchText.split(REGEXP_SPLIT_STRINGLIST).toSet();

    return registeredTools.where((tool) {
      if (tool.indexedSearchStrings.isEmpty) return false;

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

List<GCWTool> _categoryList = [];
List<GCWTool> _mainToolList = [];

void refreshToolLists() {
  _categoryList = [];
  _mainToolList = [];
}

void _initStaticToolList() {
  _mainToolList = registeredTools.where((element) {
    return [
      className(const Abaddon()),
      className(const ADFGVX()),
      className(const Affine()),
      className(const AlcoholMass()),
      className(const ALGOL()),
      className(AlphabetValues()),
      className(const Amsco()),
      className(const AnimatedImage()),
      className(const AnimatedImageMorseCode()),
      className(const Antipodes()),
      className(const ASCIIValues()),
      className(Atbash()),
      className(const AtomicNumbersToText()),
      className(const AveMaria()),
      className(const BabylonNumbersSelection()),
      className(const Bacon()),
      className(const BaconAnalyze()),
      className(const BaseSelection()),
      className(const Battleship()),
      className(const BCDSelection()),
      className(const Beatnik()),
      className(const BeaufortSelection()),
      className(const Befunge()),
      className(const Beghilos()),
      className(const Bifid()),
      className(const Binary()),
      className(const Binary2Image()),
      className(const BloodAlcoholContent()),
      className(const BookCipher()),
      className(const Bowling()),
      className(const BrailleSelection()),
      className(const Brainfk()),
      className(const BundeswehrTalkingBoardAuthentification()),
      className(const BundeswehrTalkingBoardObfuscation()),
      className(const BurrowsWheeler()),
      className(Caesar()),
      className(const Calendar()),
      className(const CalendarWeek()),
      className(const Catan()),
      className(const CenterThreePoints()),
      className(const CenterTwoPoints()),
      className(const CentroidArithmeticMean()),
      className(const CentroidCenterOfGravity()),
      className(const Chao()),
      className(const ChappeTelegraph()),
      className(const CheckDigitsSelection()),
      className(const Chef()),
      className(const ChickenLanguage()),
      className(const Chronogram()),
      className(const CipherWheel()),
      className(const CistercianNumbersSelection()),
      className(const ColorTool()),
      className(const Combination()),
      className(const CombinationPermutation()),
      className(const ComplexNumbers()),
      className(const CompoundInterest()),
      className(const CoordinateAveraging()),
      className(CountriesCallingCodes()),
      className(const CountriesFlags()),
      className(CountriesIOCCodes()),
      className(CountriesISOCodes()),
      className(CountriesVehicleCodes()),
      className(const Cow()),
      className(const CrossBearing()),
      className(const CrossSum()),
      className(const CrossSumRange()),
      className(const CrossSumRangeFrequency()),
      className(const DayCalculator()),
      className(const DayOfTheYear()),
      className(const Deadfish()),
      className(const Decabit()),
      className(const DistanceBearingGeodetic()),
      className(const DistanceBearingRhumbline()),
      className(const Divisor()),
      className(const DTMF()),
      className(const DNAAminoAcids()),
      className(const DNAAminoAcidsTable()),
      className(const DNANucleicAcidSequence()),
      className(const SilverRatioSelection()),
      className(const DuckSpeak()),
      className(const EasterSelection()),
      className(const EarwigoTextDeobfuscation()),
      className(const EdelcrantzTelegraph()),
      className(const EllipsoidTransform()),
      className(const EnclosedAreas()),
      className(const Enigma()),
      className(const ExcelTime()),
      className(const ExifReader()),
      className(const EquilateralTriangle()),
      className(const ESelection()),
      className(const FormatConverter()),
      className(const FormulaSolverFormulaGroups()),
      className(const FourteenSegments()),
      className(const Fox()),
      className(const Gade()),
      className(const GaussWeberTelegraph()),
      className(const GCCode()),
      className(const GCWizardScript()),
      className(const GCD()),
      className(const Geohashing()),
      className(const Gray()),
      className(const Gronsfeld()),
      className(const HeatIndex()),
      className(const HebrewNumberSystem()),
      className(const HashBreaker()),
      className(const HashSelection()),
      className(const Hexadecimal()),
      className(const HexString2File()),
      className(const HexViewer()),
      className(const HiddenData()),
      className(const Hohoho()),
      className(const Homophone()),
      className(const Houdini()),
      className(const Humidex()),
      className(const IATAICAOSearch()),
      className(const IAUAllConstellations()),
      className(const IAUSingleConstellation(
        ConstellationName: 'Andromeda',
      )),
      className(const IceCodesSelection()),
      className(const IEEE754()),
      className(const ILLIAC()),
      className(const ImageColorCorrections()),
      className(const ImageFlipRotate()),
      className(const ImageStretchShrink()),
      className(const IntersectBearings()),
      className(const IntersectFourPoints()),
      className(const IntersectGeodeticAndCircle()),
      className(const Intersection()),
      className(const IntersectThreeCircles()),
      className(const IntersectTwoCircles()),
      className(const IPCodes()),
      className(const IteratedCrossSumRange()),
      className(const IteratedCrossSumRangeFrequency()),
      className(const Judoon()),
      className(const Kamasutra()),
      className(const KarolRobot()),
      className(const Kenny()),
      className(const KeyboardSelection()),
      className(const LCM()),
      className(const LogicalSupporter()),
      className(const MagicEyeSolver()),
      className(const MathematicalConstants()),
      className(const Malbolge()),
      className(MapView()),
      className(const MayaCalendarSelection()),
      className(const MayaNumbersSelection()),
      className(const MexicanArmyCipherWheel()),
      className(const MilesianNumberSystem()),
      className(const MoonPosition()),
      className(const MoonRiseSet()),
      className(const Morbit()),
      className(const MorseSelection()),
      className(const MurrayTelegraph()),
      className(const MusicNotes()),
      className(const NonogramSolver()),
      className(const NumberPyramidSolver()),
      className(const Navajo()),
      className(const NavajoList()),
      className(const NumberSequenceSelection()),
      className(MultiDecoder()),
      className(const NumeralBases()),
      className(const NumeralWordsSelection()),
      className(const OhlsenTelegraph()),
      className(OneTimePad()),
      className(Ook()),
      className(const PantoneColorCodes()),
      className(const PaperFormats()),
      className(const PasleyTelegraph()),
      className(const PophamTelegraph()),
      className(const PeriodicTable()),
      className(const PeriodicTableDataView(
        atomicNumber: 1,
      )),
      className(const Permutation()),
      className(const PhiSelection()),
      className(const PhysicalConstants()),
      className(const Piano()),
      className(const Postcode()),
      className(const Piet()),
      className(const PiSelection()),
      className(const PigLatin()),
      className(Playfair()),
      className(const Pokemon()),
      className(const Pollux()),
      className(const Polybios()),
      className(const Porta()),
      className(const PredatorSelection()),
      className(const PrimeAlphabet()),
      className(const PrimesSelection()),
      className(const Projectiles()),
      className(const PrussiaTelegraph()),
      className(const QrCode()),
      className(const QuadraticEquation()),
      className(const Rabbit()),
      className(const Ragbaby()),
      className(const RailFence()),
      className(const RALColorCodes()),
      className(const RandomizerSelection()),
      className(const RC4()),
      className(const Recycling()),
      className(const Resection()),
      className(const ResistorSelection()),
      className(const Reverse()),
      className(const RightAscensionToDegree()),
      className(const RobberLanguage()),
      className(RomanNumbers()),
      className(const Rot123()),
      className(Rot13()),
      className(Rot18()),
      className(Rot5()),
      className(Rot47()),
      className(RotationGeneral()),
      className(const RSASelection()),
      className(const SchillingCanstattTelegraph()),
      className(const ScrabbleSelection()),
      className(const ShadowLength()),
      className(const ShadoksSelection()),
      className(const Seasons()),
      className(const SemaphoreTelegraph()),
      className(const SevenSegments()),
      className(const SixteenSegments()),
      className(const Skytale()),
      className(const SlashAndPipe()),
      className(const Solitaire()),
      className(const Sort()),
      className(const SpellingAlphabetsCrypt()),
      className(const SpellingAlphabetsList()),
      className(const SpoonLanguage()),
      className(const SQRT2Selection()),
      className(const SQRT3Selection()),
      className(const SQRT5Selection()),
      className(const Stegano()),
      className(const SteinheilTelegraph()),
      className(const StraddlingCheckerboard()),
      className(const Substitution()),
      className(SubstitutionBreaker()),
      className(const SudokuSolver()),
      className(const SummerSimmerIndex()),
      className(const SunPosition()),
      className(const SunRiseSet()),
      className(const SymbolReplacer()),
      className(const SymbolTableSelection()),
      className(const TapCode()),
      className(Tapir()),
      className(const TeletypewriterSelection()),
      className(const TeletypewriterPunchTape()),
      className(const TextAnalysis()),
      className(const TimeCalculator()),
      className(const TomTomSelection()),
      className(const TowerOfHanoi()),
      className(const Trifid()),
      className(const Trithemius()),
      className(const TTS()),
      className(const UFI()),
      className(const UICWagonCodeSelection()),
      className(const UniversalProductCode()),
      className(const UnitConverter()),
      className(const UnixTime()),
      className(const UrwigoHashBreaker()),
      className(const UrwigoTextDeobfuscation()),
      className(const VanitySelection()),
      className(const VariableCoordinateFormulas()),
      className(const VelocityAcceleration()),
      className(Vigenere()),
      className(const VigenereBreaker()),
      className(const VisualCryptography()),
      className(const WASD()),
      className(const WaypointProjectionGeodetic()),
      className(const WaypointProjectionRhumbline()),
      className(const WeddingAnniversaries()),
      className(const Weekday()),
      className(const WetBulbTemperature()),
      className(const WherigoSelection()),
      className(const WheatstoneCookeNeedleTelegraph()),
      className(const WhitespaceLanguage()),
      className(const WigWagSemaphoreTelegraph()),
      className(const Windchill()),
      className(const WordSearch()),
      className(const Z22()),
      className(ZamonianNumbers()),
      className(const ZC1()),
      className(const Zodiac()),
    ].contains(className(element.tool));
  }).toList();
  _mainToolList.sort((a, b) => sortToolList(a, b));

  _categoryList = registeredTools.where((element) {
    return [
      className(const CoordsSelection()),
      className(const CryptographySelection()),
      className(const FormulaSolverFormulaGroups()),
      className(const GamesSelection()),
      className(const GeneralCodebreakersSelection()),
      className(const ImagesAndFilesSelection()),
      className(const ScienceAndTechnologySelection()),
      className(const SymbolTableSelection()),
      className(const MiscellaneousSelection()),
    ].contains(className(element.tool));
  }).toList();

  _categoryList.sort((a, b) => sortToolList(a, b));
}
