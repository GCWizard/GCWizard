import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/main_menu/about.dart';
import 'package:gc_wizard/application/main_menu/call_for_contribution.dart';
import 'package:gc_wizard/application/main_menu/changelog.dart';
import 'package:gc_wizard/application/main_menu/licenses.dart';
import 'package:gc_wizard/application/search_strings.dart';
import 'package:gc_wizard/application/category_views/selector_lists/apparent_temperature_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/astronomy_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/babylon_numbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/base_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/bcd_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/beaufort_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/braille_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/bundeswehr_talkingboard.dart';
import 'package:gc_wizard/application/category_views/selector_lists/ccitt_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/cistercian_numbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/colors_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/combinatorics_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/coords_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/countries_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/crosssum_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/cryptography_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/dates_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/dna_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/e_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/easter_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/esoteric_programminglanguages_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/games_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/general_codebreakers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/hash_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/icecodes_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/imagesandfiles_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/keyboard_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/language_games_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/maya_calendar_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/maya_numbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/morse_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_bell_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_catalan_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_factorial_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_fermat_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_fibonacci_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_happynumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_jacobsthal_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_jacobsthallucas_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_jacobsthaloblong_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_lucas_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_luckynumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_lychrel_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_mersenne_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_mersenneexponents_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_mersennefermat_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_mersenneprimes_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_pell_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_pelllucas_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_perfectnumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_permutableprimes_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_primarypseudoperfectnumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_recaman_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_sublimenumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_superperfectnumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_weirdnumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/numeral_words_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/periodic_table_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/phi_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/pi_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/predator_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/primes_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/resistor_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/roman_numbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/rotation_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/rsa_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/scienceandtechnology_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/scrabble_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/segmentdisplay_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/shadoks_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/silverratio_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/sqrt2_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/sqrt3_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/sqrt5_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/symbol_table_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/telegraph_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/teletypewriter_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/tomtom_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/vanity_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/vigenere_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/wherigo_urwigo_selection.dart';
import 'package:gc_wizard/application/settings/widget/settings_coordinates.dart';
import 'package:gc_wizard/application/settings/widget/settings_general.dart';
import 'package:gc_wizard/application/settings/widget/settings_saverestore.dart';
import 'package:gc_wizard/application/settings/widget/settings_tools.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/tools/coords/antipodes/widget/antipodes.dart';
import 'package:gc_wizard/tools/coords/centerpoint/center_three_points/widget/center_three_points.dart';
import 'package:gc_wizard/tools/coords/centerpoint/center_two_points/widget/center_two_points.dart';
import 'package:gc_wizard/tools/coords/centroid/centroid_arithmetic_mean/widget/centroid_arithmetic_mean.dart';
import 'package:gc_wizard/tools/coords/centroid/centroid_center_of_gravity/widget/centroid_center_of_gravity.dart';
import 'package:gc_wizard/tools/coords/coordinate_averaging/widget/coordinate_averaging.dart';
import 'package:gc_wizard/tools/coords/cross_bearing/widget/cross_bearing.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/widget/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/dmm_offset/widget/dmm_offset.dart';
import 'package:gc_wizard/tools/coords/ellipsoid_transform/widget/ellipsoid_transform.dart';
import 'package:gc_wizard/tools/coords/equilateral_triangle/widget/equilateral_triangle.dart';
import 'package:gc_wizard/tools/coords/format_converter/widget/format_converter.dart';
import 'package:gc_wizard/tools/coords/intersect_bearing_and_circle/widget/intersect_bearing_and_circle.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_bearings/widget/intersect_bearings.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_four_points/widget/intersect_four_points.dart';
import 'package:gc_wizard/tools/coords/intersect_three_circles/widget/intersect_three_circles.dart';
import 'package:gc_wizard/tools/coords/intersect_two_circles/widget/intersect_two_circles.dart';
import 'package:gc_wizard/tools/coords/intersection/widget/intersection.dart';
import 'package:gc_wizard/tools/coords/map_view/widget/map_view.dart';
import 'package:gc_wizard/tools/coords/resection/widget/resection.dart';
import 'package:gc_wizard/tools/coords/segment_bearings/widget/segment_bearings.dart';
import 'package:gc_wizard/tools/coords/segment_line/widget/segment_line.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/widget/variable_coordinate_formulas.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/widget/waypoint_projection.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/abaddon/widget/abaddon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/adfgvx/widget/adfgvx.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/affine/widget/affine.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/widget/alphabet_values.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/amsco/widget/amsco.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/atbash/widget/atbash.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/babylon_numbers/widget/babylon_numbers.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bacon/widget/bacon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/base122/widget/base122.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/base16/widget/base16.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/base32/widget/base32.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/base58/widget/base58.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/base64/widget/base64.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/base85/widget/base85.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/base91/widget/base91.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcd1of10/widget/bcd1of10.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcd20f5postnet/widget/bcd20f5postnet.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcd2of5/widget/bcd2of5.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcd2of5planet/widget/bcd2of5planet.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdaiken/widget/bcdaiken.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdbiquinary/widget/bcdbiquinary.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdglixon/widget/bcdglixon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdgray/widget/bcdgray.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdgrayexcess/widget/bcdgrayexcess.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdhamming/widget/bcdhamming.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdlibawcraig/widget/bcdlibawcraig.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdobrien/widget/bcdobrien.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdoriginal/widget/bcdoriginal.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdpetherick/widget/bcdpetherick.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdstibitz/widget/bcdstibitz.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdtompkins/widget/bcdtompkins.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/beghilos/widget/beghilos.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bifid/widget/bifid.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/book_cipher/widget/book_cipher.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/braille/braille/widget/braille.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/braille/braille_dot_numbers/widget/braille_dot_numbers.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bundeswehr_talkingboard/bundeswehr_auth/widget/bundeswehr_auth.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bundeswehr_talkingboard/bundeswehr_code/widget/bundeswehr_code.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/burrows_wheeler/widget/burrows_wheeler.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/caesar/widget/caesar.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/chao/widget/chao.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/charsets/ascii_values/widget/ascii_values.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/cipher_wheel/widget/cipher_wheel.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/cistercian_numbers/widget/cistercian_numbers.dart';
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
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/hashes/widget/hashes.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/hashes_identification/widget/hashes_identification.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/hashes_overview/widget/hashes_overview.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/homophone/widget/homophone.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/houdini/widget/houdini.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/kamasutra/widget/kamasutra.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/kenny/widget/kenny.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/chicken_language/widget/chicken_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/duck_speak/widget/duck_speak.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/pig_latin/widget/pig_latin.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/robber_language/widget/robber_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/spoon_language/widget/spoon_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/maya_numbers/widget/maya_numbers.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/mexican_army_cipher_wheel/widget/mexican_army_cipher_wheel.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/morse/widget/morse.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/navajo/widget/navajo.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/numeral_words_converter/widget/numeral_words_converter.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/numeral_words_identify_languages/widget/numeral_words_identify_languages.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/numeral_words_lists/widget/numeral_words_lists.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/numeral_words_text_search/widget/numeral_words_text_search.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/one_time_pad/widget/one_time_pad.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/playfair/widget/playfair.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/pokemon/widget/pokemon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/widget/polybios.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/predator/widget/predator.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/prime_alphabet/widget/prime_alphabet.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rabbit/widget/rabbit.dart';
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
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa/widget/rsa.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_d_calculator/widget/rsa_d_calculator.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_d_checker/widget/rsa_d_checker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_e_checker/widget/rsa_e_checker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_n_calculator/widget/rsa_n_calculator.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_phi_calculator/widget/rsa_phi_calculator.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_primes_calculator/widget/rsa_primes_calculator.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/shadoks_numbers/widget/shadoks_numbers.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/skytale/widget/skytale.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/solitaire/widget/solitaire.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/straddling_checkerboard/widget/straddling_checkerboard.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/widget/substitution.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/tap_code/widget/tap_code.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/tapir/widget/tapir.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/text_analysis/widget/text_analysis.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/tomtom/widget/tomtom.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/trifid/widget/trifid.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/trithemius/widget/trithemius.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/widget/vigenere.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/wasd/widget/wasd.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/zamonian_numbers/widget/zamonian_numbers.dart';
import 'package:gc_wizard/tools/formula_solver/widget/formula_solver_formulagroups.dart';
import 'package:gc_wizard/tools/games/bowling/widget/bowling.dart';
import 'package:gc_wizard/tools/games/catan/widget/catan.dart';
import 'package:gc_wizard/tools/games/game_of_life/widget/game_of_life.dart';
import 'package:gc_wizard/tools/games/scrabble/scrabble/widget/scrabble.dart';
import 'package:gc_wizard/tools/games/scrabble/scrabble_overview/widget/scrabble_overview.dart';
import 'package:gc_wizard/tools/games/sudoku/sudoku_solver/widget/sudoku_solver.dart';
import 'package:gc_wizard/tools/general_tools/grid_generator/grid/widget/grid.dart';
import 'package:gc_wizard/tools/images_and_files/animated_image/widget/animated_image.dart';
import 'package:gc_wizard/tools/images_and_files/animated_image_morse_code/widget/animated_image_morse_code.dart';
import 'package:gc_wizard/tools/images_and_files/binary2image/widget/binary2image.dart';
import 'package:gc_wizard/tools/images_and_files/exif_reader/widget/exif_reader.dart';
import 'package:gc_wizard/tools/images_and_files/hex_viewer/widget/hex_viewer.dart';
import 'package:gc_wizard/tools/images_and_files/hexstring2file/widget/hexstring2file.dart';
import 'package:gc_wizard/tools/images_and_files/hidden_data/widget/hidden_data.dart';
import 'package:gc_wizard/tools/images_and_files/image_colorcorrections/widget/image_colorcorrections.dart';
import 'package:gc_wizard/tools/images_and_files/image_flip_rotate/widget/image_flip_rotate.dart';
import 'package:gc_wizard/tools/images_and_files/magic_eye_solver/widget/magic_eye_solver.dart';
import 'package:gc_wizard/tools/images_and_files/qr_code/widget/qr_code.dart';
import 'package:gc_wizard/tools/images_and_files/stegano/widget/stegano.dart';
import 'package:gc_wizard/tools/images_and_files/visual_cryptography/widget/visual_cryptography.dart';
import 'package:gc_wizard/tools/science_and_technology/alcohol_mass/widget/alcohol_mass.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/heat_index/widget/heat_index.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/humidex/widget/humidex.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/summer_simmer/widget/summer_simmer.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/wet_bulb_temperature/widget/wet_bulb_temperature.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/windchill/widget/windchill.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/easter/easter_date/widget/easter_date.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/easter/easter_years/widget/easter_years.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/moon_position/widget/moon_position.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/moon_rise_set/widget/moon_rise_set.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/right_ascension_to_degree/widget/right_ascension_to_degree.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/seasons/widget/seasons.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/shadow_length/widget/shadow_length.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/sun_position/widget/sun_position.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/sun_rise_set/widget/sun_rise_set.dart';
import 'package:gc_wizard/tools/science_and_technology/beaufort/widget/beaufort.dart';
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
import 'package:gc_wizard/tools/science_and_technology/date_and_time/day_calculator/widget/day_calculator.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/day_of_the_year/widget/day_of_the_year.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/time_calculator/widget/time_calculator.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/weekday/widget/weekday.dart';
import 'package:gc_wizard/tools/science_and_technology/decabit/widget/decabit.dart';
import 'package:gc_wizard/tools/science_and_technology/divisor/widget/divisor.dart';
import 'package:gc_wizard/tools/science_and_technology/dna/dna_aminoacids/widget/dna_aminoacids.dart';
import 'package:gc_wizard/tools/science_and_technology/dna/dna_aminoacids_table/widget/dna_aminoacids_table.dart';
import 'package:gc_wizard/tools/science_and_technology/dna/dna_nucleicacidsequence/widget/dna_nucleicacidsequence.dart';
import 'package:gc_wizard/tools/science_and_technology/dtmf/widget/dtmf.dart';
import 'package:gc_wizard/tools/science_and_technology/guitar_strings/widget/guitar_strings.dart';
import 'package:gc_wizard/tools/science_and_technology/hexadecimal/widget/hexadecimal.dart';
import 'package:gc_wizard/tools/science_and_technology/iata_icao_search/widget/iata_icao_search.dart';
import 'package:gc_wizard/tools/science_and_technology/icecodes/widget/icecodes.dart';
import 'package:gc_wizard/tools/science_and_technology/ip_codes/widget/ip_codes.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/e/widget/e.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/phi/widget/phi.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/pi/widget/pi.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/silver_ratio/widget/silver_ratio.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/sqrt2/widget/sqrt2.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/sqrt3/widget/sqrt3.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/sqrt5/widget/sqrt5.dart';
import 'package:gc_wizard/tools/science_and_technology/keyboard/keyboard_layout/widget/keyboard_layout.dart';
import 'package:gc_wizard/tools/science_and_technology/keyboard/keyboard_numbers/widget/keyboard_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/mathematical_constants/widget/mathematical_constants.dart';
import 'package:gc_wizard/tools/science_and_technology/maya_calendar/widget/maya_calendar.dart';
import 'package:gc_wizard/tools/science_and_technology/music_notes/music_notes/widget/music_notes.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/bell/widget/bell.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/catalan/widget/catalan.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/factorial/widget/factorial.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/fermat/widget/fermat.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/fibonacci/widget/fibonacci.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/happy_numbers/widget/happy_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/jacobsthal/widget/jacobsthal.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/jacobsthal_lucas/widget/jacobsthal_lucas.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/jacobsthal_oblong/widget/jacobsthal_oblong.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/lucas/widget/lucas.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/lucky_numbers/widget/lucky_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/lychrel/widget/lychrel.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/mersenne/widget/mersenne.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/mersenne_exponents/widget/mersenne_exponents.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/mersenne_primes/widget/mersenne_primes.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/mersennefermat/widget/mersennefermat.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/pell/widget/pell.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/pell_lucas/widget/pell_lucas.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/perfect_numbers/widget/perfect_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/permutable_primes/widget/permutable_primes.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/primarypseudoperfect_numbers/widget/primarypseudoperfect_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/recaman/widget/recaman.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/sublime_numbers/widget/sublime_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/superperfect_numbers/widget/superperfect_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/weird_numbers/widget/weird_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/widget/numeral_bases.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/atomic_numbers_to_text/widget/atomic_numbers_to_text.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/periodic_table/widget/periodic_table.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/periodic_table_data_view/widget/periodic_table_data_view.dart';
import 'package:gc_wizard/tools/science_and_technology/physical_constants/widget/physical_constants.dart';
import 'package:gc_wizard/tools/science_and_technology/piano/widget/piano.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/primes_integerfactorization/widget/primes_integerfactorization.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/primes_isprime/widget/primes_isprime.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/primes_nearestprime/widget/primes_nearestprime.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/primes_nthprime/widget/primes_nthprime.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/primes_primeindex/widget/primes_primeindex.dart';
import 'package:gc_wizard/tools/science_and_technology/projectiles/widget/projectiles.dart';
import 'package:gc_wizard/tools/science_and_technology/quadratic_equation/widget/quadratic_equation.dart';
import 'package:gc_wizard/tools/science_and_technology/recycling/widget/recycling.dart';
import 'package:gc_wizard/tools/science_and_technology/resistor/resistor_colorcodecalculator/widget/resistor_colorcodecalculator.dart';
import 'package:gc_wizard/tools/science_and_technology/resistor/resistor_eia96/widget/resistor_eia96.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/14_segment_display/widget/fourteen_segments.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/16_segment_display/widget/sixteen_segments.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/7_segment_display/widget/seven_segments.dart';
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
import 'package:gc_wizard/tools/science_and_technology/telegraphs/wheatstone_cooke_5_needles/widget/wheatstone_cooke_5_needles.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/wigwag/widget/wigwag.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/algol/widget/algol.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/ancient_teletypewriter/widget/ancient_teletypewriter.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/ccitt1/widget/ccitt1.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/ccitt2/widget/ccitt2.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/ccitt3/widget/ccitt3.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/ccitt4/widget/ccitt4.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/ccitt5/widget/ccitt5.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/ccitt_ccir476/widget/ccitt_ccir476.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/ccitt_teletypewriter/widget/ccitt_teletypewriter.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/illiac/widget/illiac.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/other_teletypewriter/widget/other_teletypewriter.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/punchtape/widget/punchtape.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/tts/widget/tts.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/z22/widget/z22.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/zc1/widget/zc1.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/widget/unit_converter.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/vanity_multitap/widget/vanity_multitap.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/vanity_singletap/widget/vanity_singletap.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/vanity_words_list/widget/vanity_words_list.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/vanity_words_search/widget/vanity_words_search.dart';
import 'package:gc_wizard/tools/science_and_technology/weather_symbols/widget/weather_symbols.dart';
import 'package:gc_wizard/tools/symbol_tables/symbol_replacer/widget/symbol_replacer.dart';
import 'package:gc_wizard/tools/symbol_tables/symbol_tables_examples_select/widget/symbol_tables_examples_select.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_table_tool.dart';
import 'package:gc_wizard/tools/uncategorized/zodiac/widget/zodiac.dart';
import 'package:gc_wizard/tools/wherigo/earwigo_text_deobfuscation/widget/earwigo_text_deobfuscation.dart';
import 'package:gc_wizard/tools/wherigo/urwigo_hashbreaker/widget/urwigo_hashbreaker.dart';
import 'package:gc_wizard/tools/wherigo/urwigo_text_deobfuscation/widget/urwigo_text_deobfuscation.dart';
import 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_analyze.dart';

List<GCWTool> registeredTools;

initializeRegistry(BuildContext context) {
  registeredTools = [
    //MainSelection
    GCWTool(tool: Abaddon(), i18nPrefix: 'abaddon', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'abaddon',
    ]),
    GCWTool(tool: ADFGVX(), i18nPrefix: 'adfgvx', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'adfgvx',
    ]),
    GCWTool(tool: Affine(), i18nPrefix: 'affine', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'affine',
    ]),
    GCWTool(tool: AlcoholMass(), i18nPrefix: 'alcoholmass', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'alcoholmass',
    ]),
    GCWTool(tool: ALGOL(), i18nPrefix: 'algol', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'algol',
    ]),
    GCWTool(tool: AlphabetValues(), i18nPrefix: 'alphabetvalues', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'alphabetvalues',
    ]),
    GCWTool(tool: Amsco(), i18nPrefix: 'amsco', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'amsco',
    ]),
    GCWTool(tool: AnimatedImage(), i18nPrefix: 'animated_image', isBeta: true, categories: [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: [
      'animated_images',
    ]),
    GCWTool(tool: AnimatedImageMorseCode(), i18nPrefix: 'animated_image_morse_code', isBeta: true, categories: [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: [
      'animated_images_morse_code',
      'animated_images',
    ]),
    GCWTool(
        tool: ApparentTemperatureSelection(),
        i18nPrefix: 'apparenttemperature_selection',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: []),
    GCWTool(tool: ASCIIValues(), i18nPrefix: 'asciivalues', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'asciivalues',
      'binary',
    ]),
    GCWTool(tool: AstronomySelection(), i18nPrefix: 'astronomy_selection', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'astronomy',
    ]),
    GCWTool(tool: Atbash(), i18nPrefix: 'atbash', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'atbash',
    ]),
    GCWTool(
        tool: BabylonNumbersSelection(),
        i18nPrefix: 'babylonnumbers_selection',
        categories: [ToolCategory.CRYPTOGRAPHY],
        searchKeys: []),
    GCWTool(tool: Bacon(), i18nPrefix: 'bacon', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'bacon',
      'binary',
    ]),
    GCWTool(
        tool: BaseSelection(), i18nPrefix: 'base_selection', categories: [ToolCategory.CRYPTOGRAPHY], searchKeys: []),
    GCWTool(tool: BCDSelection(), i18nPrefix: 'bcd_selection', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'binary',
    ]),
    GCWTool(tool: BloodAlcoholContent(), i18nPrefix: 'bloodalcoholcontent', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'alcoholmass',
      'bloodalcoholcontent',
    ]),
    GCWTool(
        tool: BrailleSelection(),
        i18nPrefix: 'braille_selection',
        categories: [ToolCategory.CRYPTOGRAPHY],
        searchKeys: []),
    GCWTool(
        tool: BeaufortSelection(),
        i18nPrefix: 'beaufort_selection',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: []),
    GCWTool(tool: Beghilos(), i18nPrefix: 'beghilos', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'beghilos',
      'segments',
      'segements_seven',
    ]),
    GCWTool(tool: Bifid(), i18nPrefix: 'bifid', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'bifid',
    ]),
    GCWTool(tool: Binary(), i18nPrefix: 'binary', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'binary',
    ]),
    GCWTool(tool: Binary2Image(), i18nPrefix: 'binary2image', isBeta: true, categories: [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: [
      'binary',
      'barcodes',
      'images',
    ]),
    GCWTool(tool: BookCipher(), i18nPrefix: 'book_cipher', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'bookcipher',
    ]),
    GCWTool(tool: Bowling(), i18nPrefix: 'bowling', categories: [
      ToolCategory.GAMES
    ], searchKeys: [
      'bowling',
    ]),
    GCWTool(
        tool: BundeswehrTalkingBoardSelection(),
        i18nPrefix: 'bundeswehr_talkingboard_selection',
        categories: [ToolCategory.CRYPTOGRAPHY],
        searchKeys: []),
    GCWTool(tool: BurrowsWheeler(), i18nPrefix: 'burrowswheeler', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'burroeswheeler',
    ]),
    GCWTool(tool: Caesar(), i18nPrefix: 'caesar', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'rotation',
      'caesar',
    ]),
    GCWTool(tool: Catan(), i18nPrefix: 'catan', categories: [
      ToolCategory.GAMES
    ], searchKeys: [
      'catan',
    ]),
    GCWTool(
        tool: CCITTSelection(), i18nPrefix: 'ccitt_selection', categories: [ToolCategory.CRYPTOGRAPHY], searchKeys: []),
    GCWTool(tool: Chao(), i18nPrefix: 'chao', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'chao',
    ]),
    GCWTool(tool: CipherWheel(), i18nPrefix: 'cipherwheel', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'cipherwheel',
    ]),
    GCWTool(
        tool: CistercianNumbersSelection(),
        i18nPrefix: 'cistercian_selection',
        categories: [ToolCategory.CRYPTOGRAPHY],
        searchKeys: []),
    GCWTool(
        tool: ColorsSelection(),
        i18nPrefix: 'colors_selection',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: []),
    GCWTool(
        tool: CombinatoricsSelection(),
        i18nPrefix: 'combinatorics_selection',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: []),
    GCWTool(tool: ComplexNumbers(), i18nPrefix: 'complex_numbers', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'complexnumbers',
    ]),
    GCWTool(tool: CompoundInterest(), i18nPrefix: 'compoundinterest', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'compoundinterest',
    ]),
    GCWTool(tool: CoordsSelection(), i18nPrefix: 'coords_selection', searchKeys: [
      'coordinates',
    ]),
    GCWTool(
        tool: CountriesSelection(),
        i18nPrefix: 'countries_selection',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: []),
    GCWTool(
        tool: CrossSumSelection(),
        i18nPrefix: 'crosssum_selection',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: []),
    GCWTool(tool: CryptographySelection(), i18nPrefix: 'cryptography_selection', searchKeys: [
      'cryptographyselection',
    ]),
    GCWTool(tool: DatesSelection(), i18nPrefix: 'dates_selection', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'dates',
    ]),
    GCWTool(tool: Decabit(), i18nPrefix: 'decabit', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'decabit',
    ]),
    GCWTool(tool: Divisor(), i18nPrefix: 'divisor', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'divisor',
    ]),
    GCWTool(
        tool: DNASelection(),
        i18nPrefix: 'dna_selection',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: []),
    GCWTool(tool: DTMF(), i18nPrefix: 'dtmf', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'dtmf',
    ]),
    GCWTool(tool: EnclosedAreas(), i18nPrefix: 'enclosedareas', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'enclosedareas',
    ]),
    GCWTool(tool: ESelection(), i18nPrefix: 'e_selection', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'e',
      'irrationalnumbers',
    ]),
    GCWTool(tool: Enigma(), i18nPrefix: 'enigma', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'enigma',
    ]),
    GCWTool(
        tool: EsotericProgrammingLanguageSelection(),
        i18nPrefix: 'esotericprogramminglanguages_selection',
        categories: [
          ToolCategory.CRYPTOGRAPHY
        ],
        searchKeys: [
          'esotericprogramminglanguage',
        ]),
    GCWTool(tool: ExifReader(), i18nPrefix: 'exif', isBeta: true, categories: [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: [
      'exif',
    ]),
    GCWTool(
      tool: FormulaSolverFormulaGroups(),
      i18nPrefix: 'formulasolver',
      searchKeys: [
        'formulasolver',
      ],
    ),
    GCWTool(tool: Fox(), i18nPrefix: 'fox', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'fox',
    ]),
    GCWTool(tool: Gade(), i18nPrefix: 'gade', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'gade',
    ]),
    GCWTool(
      tool: GamesSelection(),
      i18nPrefix: 'games_selection',
      searchKeys: [
        'games',
      ],
    ),
    GCWTool(tool: GameOfLife(), i18nPrefix: 'gameoflife', categories: [
      ToolCategory.GAMES
    ], searchKeys: [
      'gameoflife',
    ]),
    GCWTool(tool: GCCode(), i18nPrefix: 'gccode', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'gccode',
    ]),
    GCWTool(tool: GeneralCodebreakersSelection(), i18nPrefix: 'generalcodebreakers_selection', searchKeys: [
      'codebreaker',
    ]),
    GCWTool(tool: Gray(), i18nPrefix: 'gray', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'binary',
      'gray',
    ]),
    GCWTool(tool: Grid(), i18nPrefix: 'grid', categories: [
      ToolCategory.GAMES
    ], searchKeys: [
      'grid',
    ]),
    GCWTool(tool: GuitarStrings(), i18nPrefix: 'guitarstrings', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'music',
      'guitar',
    ]),
    GCWTool(
        tool: HashSelection(), i18nPrefix: 'hashes_selection', categories: [ToolCategory.CRYPTOGRAPHY], searchKeys: []),
    GCWTool(tool: Hexadecimal(), i18nPrefix: 'hexadecimal', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'hexadecimal',
    ]),
    GCWTool(tool: HexString2File(), i18nPrefix: 'hexstring2file', isBeta: true, categories: [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: [
      'hexadecimal',
      'hexstring2file',
    ]),
    GCWTool(tool: HexViewer(), i18nPrefix: 'hexviewer', categories: [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: [
      'hexadecimal',
      'hexviewer',
    ]),
    GCWTool(tool: HiddenData(), i18nPrefix: 'hiddendata', isBeta: true, categories: [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: [
      'hiddendata',
    ]),
    GCWTool(tool: Homophone(), i18nPrefix: 'homophone', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'homophone',
    ]),
    GCWTool(tool: Houdini(), i18nPrefix: 'houdini', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'houdini',
    ]),
    GCWTool(
      tool: IATAICAOSearch(),
      i18nPrefix: 'iataicao',
      categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
      searchKeys: [
        'iataicao',
      ],
    ),
    GCWTool(
      tool: IceCodesSelection(),
      i18nPrefix: 'icecodes_selection',
      categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
      searchKeys: [],
    ),
    GCWTool(tool: ILLIAC(), i18nPrefix: 'illiac', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'illiac',
    ]),
    GCWTool(tool: ImagesAndFilesSelection(), i18nPrefix: 'imagesandfiles_selection', isBeta: true, searchKeys: [
      'images',
      'imagesandfilesselection',
    ]),
    GCWTool(
        tool: ImageColorCorrections(),
        autoScroll: false,
        categories: [ToolCategory.IMAGES_AND_FILES],
        i18nPrefix: 'image_colorcorrections',
        isBeta: true,
        searchKeys: [
          'images',
          'color',
          'image_colorcorrections',
        ]),
    GCWTool(
        tool: ImageFlipRotate(),
        categories: [ToolCategory.IMAGES_AND_FILES],
        i18nPrefix: 'image_fliprotate',
        searchKeys: [
          'images',
          'image_fliprotate',
        ]),
    GCWTool(
        tool: IPCodes(),
        i18nPrefix: 'ipcodes',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: ['ipcodes']),
    GCWTool(tool: Kamasutra(), i18nPrefix: 'kamasutra', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'rotation',
      'kamasutra',
    ]),
    GCWTool(tool: Kenny(), i18nPrefix: 'kenny', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'kenny',
    ]),
    GCWTool(tool: KeyboardLayout(), i18nPrefix: 'keyboard_layout', searchKeys: [
      'keyboard',
    ]),
    GCWTool(tool: KeyboardNumbers(), i18nPrefix: 'keyboard_numbers', searchKeys: ['keyboard', 'keyboard_numbers']),
    GCWTool(
        tool: KeyboardSelection(),
        i18nPrefix: 'keyboard_selection',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: []),
    GCWTool(
        tool: LanguageGamesSelection(),
        i18nPrefix: 'languagegames_selection',
        categories: [ToolCategory.CRYPTOGRAPHY],
        searchKeys: []),
    GCWTool(
        tool: MagicEyeSolver(),
        i18nPrefix: 'magic_eye',
        isBeta: true,
        categories: [ToolCategory.IMAGES_AND_FILES],
        searchKeys: ['magic_eye', 'images']),
    GCWTool(tool: MathematicalConstants(), i18nPrefix: 'mathematical_constants', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'mathematical_constants',
    ]),
    GCWTool(
        tool: MayaCalendarSelection(),
        categories: [ToolCategory.CRYPTOGRAPHY],
        i18nPrefix: 'mayacalendar_selection',
        searchKeys: []),
    GCWTool(
        tool: MayaNumbersSelection(),
        i18nPrefix: 'mayanumbers_selection',
        categories: [ToolCategory.CRYPTOGRAPHY],
        searchKeys: []),
    GCWTool(tool: MexicanArmyCipherWheel(), i18nPrefix: 'mexicanarmycipherwheel', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'cipherwheel',
      'mexicanarmycipherwheel',
    ]),
    GCWTool(
        tool: MorseSelection(), i18nPrefix: 'morse_selection', categories: [ToolCategory.CRYPTOGRAPHY], searchKeys: []),
    GCWTool(tool: MultiDecoder(), i18nPrefix: 'multidecoder', categories: [
      ToolCategory.GENERAL_CODEBREAKERS
    ], searchKeys: [
      'multidecoder',
    ]),
    GCWTool(
        tool: MusicNotes(),
        i18nPrefix: 'music_notes',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: ['music', 'music_notes']),
    GCWTool(tool: Navajo(), i18nPrefix: 'navajo', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'navajo',
    ]),
    GCWTool(
        tool: NumberSequenceSelection(),
        i18nPrefix: 'numbersequence',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: []),
    GCWTool(tool: NumeralBases(), i18nPrefix: 'numeralbases', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'binary',
      'numeralbases',
    ]),
    GCWTool(
        tool: NumeralWordsSelection(),
        i18nPrefix: 'numeralwords_selection',
        categories: [ToolCategory.CRYPTOGRAPHY],
        searchKeys: []),
    GCWTool(tool: OneTimePad(), i18nPrefix: 'onetimepad', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'onetimepad',
    ]),
    GCWTool(tool: PeriodicTableSelection(), i18nPrefix: 'periodictable_selection', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'periodictable',
    ]),
    GCWTool(tool: PhiSelection(), i18nPrefix: 'phi_selection', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'phi',
      'irrationalnumbers',
    ]),
    GCWTool(tool: Piano(), i18nPrefix: 'piano', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'music'
          'music_notes',
      'piano',
    ]),
    GCWTool(tool: PiSelection(), i18nPrefix: 'pi_selection', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'pi',
      'irrationalnumbers',
    ]),
    GCWTool(tool: PhysicalConstants(), i18nPrefix: 'physical_constants', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'physical_constants',
    ]),
    GCWTool(tool: Playfair(), i18nPrefix: 'playfair', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'playfair',
    ]),
    GCWTool(tool: Pokemon(), i18nPrefix: 'pokemon_code', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'pokemon',
    ]),
    GCWTool(tool: Polybios(), i18nPrefix: 'polybios', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'polybios',
    ]),
    GCWTool(
        tool: PredatorSelection(),
        i18nPrefix: 'predator_selection',
        categories: [ToolCategory.CRYPTOGRAPHY],
        searchKeys: []),
    GCWTool(tool: PrimeAlphabet(), i18nPrefix: 'primealphabet', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'primes',
      'primealphabet',
    ]),
    GCWTool(
        tool: PrimesSelection(),
        i18nPrefix: 'primes_selection',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: []),
    GCWTool(tool: Projectiles(), i18nPrefix: 'projectiles', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'projectiles',
    ]),
    GCWTool(tool: QrCode(), i18nPrefix: 'qr_code', isBeta: true, categories: [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: [
      'qrcode',
    ]),
    GCWTool(tool: QuadraticEquation(), i18nPrefix: 'quadratic_equation', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'quadraticequation',
    ]),
    GCWTool(tool: Rabbit(), i18nPrefix: 'rabbit', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'rabbit',
    ]),
    GCWTool(tool: RailFence(), i18nPrefix: 'railfence', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'railfence',
    ]),
    GCWTool(tool: RC4(), i18nPrefix: 'rc4', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'rc4',
    ]),
    GCWTool(tool: Recycling(), i18nPrefix: 'recycling', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'recycling',
    ]),
    GCWTool(
        tool: ResistorSelection(),
        i18nPrefix: 'resistor_selection',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: []),
    GCWTool(tool: Reverse(), i18nPrefix: 'reverse', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'reverse',
    ]),
    GCWTool(
        tool: RomanNumbersSelection(),
        i18nPrefix: 'romannumbers',
        categories: [ToolCategory.CRYPTOGRAPHY],
        searchKeys: []),
    GCWTool(
        tool: RotationSelection(),
        i18nPrefix: 'rotation_selection',
        categories: [ToolCategory.CRYPTOGRAPHY],
        searchKeys: []),
    GCWTool(tool: RSASelection(), i18nPrefix: 'rsa_selection', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'primes',
    ]),
    GCWTool(tool: ScienceAndTechnologySelection(), i18nPrefix: 'scienceandtechnology_selection', searchKeys: [
      'scienceandtechnologyselection',
    ]),
    GCWTool(
        tool: ScrabbleSelection(),
        i18nPrefix: 'scrabble_selection',
        categories: [ToolCategory.GAMES],
        searchKeys: ['games']),
    GCWTool(
        tool: SegmentDisplaySelection(),
        i18nPrefix: 'segmentdisplay_selection',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: []),
    GCWTool(
        tool: ShadoksSelection(),
        i18nPrefix: 'shadoks_selection',
        categories: [ToolCategory.CRYPTOGRAPHY],
        searchKeys: []),
    GCWTool(tool: SilverRatioSelection(), i18nPrefix: 'silverratio_selection', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'silverratio',
      'irrationalnumbers',
    ]),
    GCWTool(tool: Skytale(), i18nPrefix: 'skytale', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'skytale',
    ]),
    GCWTool(tool: Solitaire(), i18nPrefix: 'solitaire', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'solitaire',
    ]),
    GCWTool(tool: SQRT2Selection(), i18nPrefix: 'sqrt2_selection', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'sqrt',
      'irrationalnumbers',
    ]),
    GCWTool(tool: SQRT3Selection(), i18nPrefix: 'sqrt3_selection', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'sqrt',
      'irrationalnumbers',
    ]),
    GCWTool(tool: SQRT5Selection(), i18nPrefix: 'sqrt5_selection', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'sqrt',
      'irrationalnumbers',
    ]),
    GCWTool(tool: Stegano(), i18nPrefix: 'stegano', isBeta: true, categories: [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: [
      'stegano',
    ]),
    GCWTool(tool: StraddlingCheckerboard(), i18nPrefix: 'straddlingcheckerboard', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'straddlingcheckerboard',
    ]),
    GCWTool(tool: Substitution(), i18nPrefix: 'substitution', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'substitution',
    ]),
    GCWTool(tool: SubstitutionBreaker(), i18nPrefix: 'substitutionbreaker', categories: [
      ToolCategory.GENERAL_CODEBREAKERS
    ], searchKeys: [
      'codebreaker',
      'substitutionbreaker',
    ]),
    GCWTool(tool: SudokuSolver(), i18nPrefix: 'sudokusolver', categories: [
      ToolCategory.GAMES
    ], searchKeys: [
      'games',
      'games_sudokusolver',
    ]),
    GCWTool(
      tool: SymbolTableSelection(),
      buttonList: [
        GCWToolActionButtonsEntry(
            showDialog: true,
            url: symboltablesDownloadLink(context),
            title: 'symboltables_selection_download_dialog_title',
            text: 'symboltables_selection_download_dialog_text',
            icon: Icons.file_download),
      ],
      i18nPrefix: 'symboltables_selection',
      searchKeys: [],
    ),
    GCWTool(tool: TapCode(), i18nPrefix: 'tapcode', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'tapcode',
    ]),
    GCWTool(tool: Tapir(), i18nPrefix: 'tapir', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'tapir',
    ]),
    GCWTool(
        tool: TelegraphSelection(),
        i18nPrefix: 'telegraph_selection',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: []),
    GCWTool(
        tool: TeletypewriterSelection(),
        i18nPrefix: 'teletypewriter_selection',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: []),
    GCWTool(tool: TeletypewriterPunchTape(), i18nPrefix: 'punchtape', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'ccitt',
      'ccitt_1',
      'ccitt_2',
      'ccitt_3',
      'ccitt_4',
      'ccitt_5',
      'punchtape',
      'teletypewriter',
      'symbol_siemens',
      'symbol_westernunion',
      'symbol_murraybaudot',
      'symbol_baudot'
    ]),
    GCWTool(
        tool: TextAnalysis(),
        i18nPrefix: 'textanalysis',
        categories: [ToolCategory.CRYPTOGRAPHY],
        searchKeys: ['alphabetvalues', 'asciivalues', 'textanalysis']),
    GCWTool(tool: Trifid(), i18nPrefix: 'trifid', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'trifid',
    ]),
    GCWTool(
        tool: TomTomSelection(),
        i18nPrefix: 'tomtom_selection',
        categories: [ToolCategory.CRYPTOGRAPHY],
        searchKeys: []),
    GCWTool(tool: TTS(), i18nPrefix: 'tts', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'tts',
    ]),
    GCWTool(tool: UnitConverter(), i18nPrefix: 'unitconverter', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'unitconverter',
    ]),
    GCWTool(
        tool: VanitySelection(),
        i18nPrefix: 'vanity_selection',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: []),
    GCWTool(
        tool: VigenereSelection(),
        i18nPrefix: 'vigenere_selection',
        categories: [ToolCategory.CRYPTOGRAPHY],
        searchKeys: []),
    GCWTool(
        tool: VisualCryptography(),
        i18nPrefix: 'visual_cryptography',
        isBeta: true,
        categories: [ToolCategory.IMAGES_AND_FILES, ToolCategory.CRYPTOGRAPHY],
        searchKeys: ['visualcryptography', 'images']),
    GCWTool(tool: WASD(), i18nPrefix: 'wasd', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'wasd',
    ]),
    GCWTool(
        tool: WherigoSelection(),
        i18nPrefix: 'wherigourwigo_selection',
        categories: [ToolCategory.CRYPTOGRAPHY],
        searchKeys: []),
    GCWTool(
        tool: WeatherSymbols(),
        i18nPrefix: 'weathersymbols',
        categories: [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: ['weather', 'weather_clouds', 'weather_a']),
    GCWTool(tool: Z22(), i18nPrefix: 'z22', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'z22',
    ]),
    GCWTool(tool: ZamonianNumbers(), autoScroll: false, i18nPrefix: 'zamoniannumbers', categories: [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: [
      'symbol_zamonian',
    ]),
    GCWTool(tool: ZC1(), i18nPrefix: 'zc1', categories: [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: [
      'zc1',
    ]),

    //ApparentTemperatureSelection  ********************************************************************************************
    GCWTool(tool: HeatIndex(), i18nPrefix: 'heatindex', searchKeys: [
      'apparenttemperature',
      'apparenttemperature_heatindex',
    ]),
    GCWTool(tool: Humidex(), i18nPrefix: 'humidex', searchKeys: [
      'apparenttemperature',
      'apparenttemperature_humidex',
    ]),
    GCWTool(tool: SummerSimmerIndex(), i18nPrefix: 'summersimmerindex', searchKeys: [
      'apparenttemperature',
      'apparenttemperature_summersimmerindex',
    ]),
    GCWTool(tool: Windchill(), i18nPrefix: 'windchill', searchKeys: [
      'apparenttemperature',
      'apparenttemperature_windchill',
    ]),
    GCWTool(tool: WetBulbTemperature(), i18nPrefix: 'wet_bulb_temperature', searchKeys: [
      'apparenttemperature',
      'apparenttemperature_wet_bulb_temperature',
    ]),

    GCWTool(tool: Zodiac(), i18nPrefix: 'zodiac', searchKeys: [
      'symbol_alchemy',
      'symbol_planets',
      'symbol_zodiacsigns',
      'symbol_zodiacsigns_latin',
    ]),

    //AstronomySelection  ********************************************************************************************
    GCWTool(tool: SunRiseSet(), i18nPrefix: 'astronomy_sunriseset', searchKeys: [
      'astronomy',
      'astronomy_riseset',
      'astronomy_sun',
      'astronomy_sunriseset',
    ]),
    GCWTool(tool: SunPosition(), i18nPrefix: 'astronomy_sunposition', searchKeys: [
      'astronomy',
      'astronomy_position',
      'astronomy_sun',
    ]),
    GCWTool(tool: MoonRiseSet(), i18nPrefix: 'astronomy_moonriseset', searchKeys: [
      'astronomy',
      'astronomy_riseset',
      'astronomy_moon',
    ]),
    GCWTool(tool: MoonPosition(), i18nPrefix: 'astronomy_moonposition', searchKeys: [
      'astronomy',
      'astronomy_position',
      'astronomy_moon',
      'astronomy_moonposition',
    ]),
    GCWTool(tool: EasterSelection(), i18nPrefix: 'astronomy_easter_selection', searchKeys: [
      'easter_date',
    ]),
    GCWTool(tool: Seasons(), i18nPrefix: 'astronomy_seasons', searchKeys: [
      'astronomy',
      'astronomy_seasons',
    ]),
    GCWTool(tool: ShadowLength(), i18nPrefix: 'shadowlength', searchKeys: [
      'astronomy',
      'astronomy_shadow_length',
    ]),
    GCWTool(tool: RightAscensionToDegree(), i18nPrefix: 'right_ascension_to_degree', categories: [], searchKeys: [
      'astronomy',
      'right_ascension_to_degree',
      'coordinates',
    ]),

    //Babylon Numbers Selection **************************************************************************************
    GCWTool(tool: BabylonNumbers(), i18nPrefix: 'babylonnumbers', searchKeys: [
      'babylonian_numerals',
    ]),

    //BaseSelection **************************************************************************************************
    GCWTool(tool: Base16(), i18nPrefix: 'base_base16', searchKeys: [
      'base',
      'base16',
    ]),
    GCWTool(tool: Base32(), i18nPrefix: 'base_base32', searchKeys: [
      'base',
      'base32',
    ]),
    GCWTool(tool: Base58(), i18nPrefix: 'base_base58', searchKeys: [
      'base',
      'base58',
    ]),
    GCWTool(tool: Base64(), i18nPrefix: 'base_base64', searchKeys: [
      'base',
      'base64',
    ]),
    GCWTool(tool: Base85(), i18nPrefix: 'base_base85', searchKeys: [
      'base',
      'base85',
    ]),
    GCWTool(tool: Base91(), i18nPrefix: 'base_base91', searchKeys: [
      'base',
      'base91',
    ]),
    GCWTool(tool: Base122(), i18nPrefix: 'base_base122', searchKeys: [
      'base',
      'base122',
    ]),

    //BCD selection **************************************************************************************************
    GCWTool(tool: BCDOriginal(), i18nPrefix: 'bcd_original', searchKeys: [
      'bcd',
      'bcdoriginal',
    ]),
    GCWTool(tool: BCDAiken(), i18nPrefix: 'bcd_aiken', searchKeys: [
      'bcd',
      'bcdaiken',
    ]),
    GCWTool(tool: BCDGlixon(), i18nPrefix: 'bcd_glixon', searchKeys: [
      'bcd',
      'bcdglixon',
    ]),
    GCWTool(tool: BCDGray(), i18nPrefix: 'bcd_gray', searchKeys: [
      'bcd',
      'bcdgray',
    ]),
    GCWTool(tool: BCDLibawCraig(), i18nPrefix: 'bcd_libawcraig', searchKeys: [
      'bcd',
      'bcdlibawcraig',
    ]),
    GCWTool(tool: BCDOBrien(), i18nPrefix: 'bcd_obrien', searchKeys: [
      'bcd',
      'bcdobrien',
    ]),
    GCWTool(tool: BCDPetherick(), i18nPrefix: 'bcd_petherick', searchKeys: [
      'bcd',
      'bcdpetherick',
    ]),
    GCWTool(tool: BCDStibitz(), i18nPrefix: 'bcd_stibitz', searchKeys: [
      'bcd',
      'bcdstibitz',
    ]),
    GCWTool(tool: BCDTompkins(), i18nPrefix: 'bcd_tompkins', searchKeys: [
      'bcd',
      'bcdtompkins',
    ]),
    GCWTool(tool: BCDHamming(), i18nPrefix: 'bcd_hamming', searchKeys: [
      'bcd',
      'bcdhamming',
    ]),
    GCWTool(tool: BCDBiquinary(), i18nPrefix: 'bcd_biquinary', searchKeys: [
      'bcd',
      'bcd2of5',
      'bcdbiquinary',
    ]),
    GCWTool(tool: BCD2of5Planet(), i18nPrefix: 'bcd_2of5planet', searchKeys: [
      'bcd',
      'bcd2of5',
      'bcd2of5planet',
    ]),
    GCWTool(tool: BCD2of5Postnet(), i18nPrefix: 'bcd_2of5postnet', searchKeys: [
      'bcd',
      'bcd2of5',
      'bcd2of5postnet',
    ]),
    GCWTool(tool: BCD2of5(), i18nPrefix: 'bcd_2of5', searchKeys: [
      'bcd',
      'bcd2of5',
    ]),
    GCWTool(tool: BCD1of10(), i18nPrefix: 'bcd_1of10', searchKeys: [
      'bcd',
      'bcd1of10',
    ]),
    GCWTool(tool: BCDGrayExcess(), i18nPrefix: 'bcd_grayexcess', searchKeys: [
      'bcd',
      'bcdgrayexcess',
    ]),

    // Beaufort Selection *******************************************************************************************
    GCWTool(tool: Beaufort(), i18nPrefix: 'beaufort', searchKeys: [
      'beaufort',
    ]),

    // BundeswehrTalkingBoard Selection *******************************************************************************************
    GCWTool(
        tool: BundeswehrTalkingBoardAuthentification(),
        i18nPrefix: 'bundeswehr_talkingboard_auth',
        categories: [],
        searchKeys: [
          'bundeswehr_talkingboard_auth',
          'bundeswehr_talkingboard',
        ]),
    GCWTool(
        tool: BundeswehrTalkingBoardObfuscation(),
        i18nPrefix: 'bundeswehr_talkingboard_code',
        categories: [],
        searchKeys: [
          'bundeswehr_talkingboard',
          'bundeswehr_talkingboard_code',
        ]),

    //Braille Selection ****************************************************************
    GCWTool(tool: Braille(), i18nPrefix: 'braille', searchKeys: [
      'braille',
    ]),
    GCWTool(tool: BrailleDotNumbers(), i18nPrefix: 'brailledotnumbers', searchKeys: [
      'braille',
    ]),

    //CCITT Selection **********************************************************************************************
    GCWTool(tool: CCITT1(), i18nPrefix: 'ccitt_1', searchKeys: ['ccitt', 'ccitt_1', 'symbol_baudot']),
    GCWTool(tool: CCITT2(), i18nPrefix: 'ccitt_2', searchKeys: [
      'ccitt',
      'ccitt_2',
      'teletypewriter',
      'symbol_murraybaudot',
    ]),
    GCWTool(tool: CCITT3(), i18nPrefix: 'ccitt_3', searchKeys: [
      'ccitt',
      'ccitt_3',
      'teletypewriter',
    ]),
    GCWTool(tool: CCITT4(), i18nPrefix: 'ccitt_4', searchKeys: [
      'ccitt',
      'ccitt_4',
      'teletypewriter',
    ]),
    GCWTool(tool: CCITT5(), i18nPrefix: 'ccitt_5', searchKeys: [
      'ccitt',
      'ccitt_5',
      'teletypewriter',
    ]),
    GCWTool(tool: CCIR476(), i18nPrefix: 'ccitt_ccir476', searchKeys: [
      'ccitt',
      'ccitt_ccir_476',
      'teletypewriter',
    ]),

    //Cistercian Selection *****************************************************************************************
    GCWTool(tool: CistercianNumbers(), i18nPrefix: 'cistercian', searchKeys: [
      'cistercian',
    ]),

    //ColorsSelection **********************************************************************************************
    GCWTool(tool: ColorTool(), i18nPrefix: 'colors', searchKeys: [
      'color',
      'colorpicker',
    ]),
    GCWTool(tool: RALColorCodes(), i18nPrefix: 'ralcolorcodes', searchKeys: [
      'color',
      'ralcolorcodes',
    ]),
    GCWTool(tool: PantoneColorCodes(), i18nPrefix: 'pantonecolorcodes', searchKeys: [
      'color',
      'pantonecolorcodes',
    ]),

    //CombinatoricsSelection ***************************************************************************************
    GCWTool(tool: Combination(), i18nPrefix: 'combinatorics_combination', searchKeys: [
      'combinatorics',
      'combinatorics_combination',
    ]),
    GCWTool(tool: Permutation(), i18nPrefix: 'combinatorics_permutation', searchKeys: [
      'combinatorics',
      'combinatorics_permutation',
    ]),
    GCWTool(tool: CombinationPermutation(), i18nPrefix: 'combinatorics_combinationpermutation', searchKeys: [
      'combinatorics',
      'combinatorics_combination',
      'combinatorics_permutation',
    ]),

    //CoordsSelection **********************************************************************************************
    GCWTool(
        tool: WaypointProjection(),
        i18nPrefix: 'coords_waypointprojection',
        iconPath: 'assets/icons/coords/icon_waypoint_projection.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_compassrose',
          'coordinates_waypointprojection',
        ]),
    GCWTool(
        tool: DistanceBearing(),
        i18nPrefix: 'coords_distancebearing',
        iconPath: 'assets/icons/coords/icon_distance_and_bearing.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_distancebearing',
        ]),
    GCWTool(
        tool: FormatConverter(),
        i18nPrefix: 'coords_formatconverter',
        iconPath: 'assets/icons/coords/icon_format_converter.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_formatconverter',
        ]),
    GCWTool(
        tool: MapView(),
        autoScroll: false,
        suppressToolMargin: true,
        i18nPrefix: 'coords_openmap',
        iconPath: 'assets/icons/coords/icon_free_map.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_mapview',
        ]),
    GCWTool(
        tool: VariableCoordinateFormulas(),
        i18nPrefix: 'coords_variablecoordinate',
        iconPath: 'assets/icons/coords/icon_variable_coordinate.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'formulasolver',
          'coordinates_variablecoordinateformulas',
        ]),
    GCWTool(
        tool: DMMOffset(),
        i18nPrefix: 'coords_dmmoffset',
        iconPath: 'assets/icons/coords/icon_dmm_offset.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_mapview',
        ]),
    GCWTool(
        tool: CoordinateAveraging(),
        i18nPrefix: 'coords_averaging',
        iconPath: 'assets/icons/coords/icon_coordinate_measurement.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_coordinateaveraging',
        ]),
    GCWTool(
        tool: CenterTwoPoints(),
        i18nPrefix: 'coords_centertwopoints',
        iconPath: 'assets/icons/coords/icon_center_two_points.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_centertwopoints',
        ]),
    GCWTool(
        tool: CentroidArithmeticMean(),
        i18nPrefix: 'coords_centroid',
        iconPath: 'assets/icons/coords/icon_centroid.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_centroid',
          'coordinates_arithmeticmean',
        ]),
    GCWTool(
        tool: CentroidCenterOfGravity(),
        i18nPrefix: 'coords_centroid_centerofgravity',
        iconPath: 'assets/icons/coords/icon_centroid.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_centroid',
          'coordinates_centerofgravity',
        ]),
    GCWTool(
        tool: CenterThreePoints(),
        i18nPrefix: 'coords_centerthreepoints',
        iconPath: 'assets/icons/coords/icon_center_three_points.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_centerthreepoints',
        ]),
    GCWTool(
        tool: SegmentLine(),
        i18nPrefix: 'coords_segmentline',
        iconPath: 'assets/icons/coords/icon_segment_line.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_segmentline',
        ]),
    GCWTool(
        tool: SegmentBearings(),
        i18nPrefix: 'coords_segmentbearings',
        iconPath: 'assets/icons/coords/icon_segment_bearings.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_segmentbearing',
        ]),
    GCWTool(
        tool: CrossBearing(),
        i18nPrefix: 'coords_crossbearing',
        iconPath: 'assets/icons/coords/icon_cross_bearing.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_crossbearing',
        ]),
    GCWTool(
        tool: IntersectBearings(),
        i18nPrefix: 'coords_intersectbearings',
        iconPath: 'assets/icons/coords/icon_intersect_bearings.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_compassrose',
          'coordinates_intersectbearing',
        ]),
    GCWTool(
        tool: IntersectFourPoints(),
        i18nPrefix: 'coords_intersectfourpoints',
        iconPath: 'assets/icons/coords/icon_intersect_four_points.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_intersectfourpoints',
        ]),
    GCWTool(
        tool: IntersectGeodeticAndCircle(),
        i18nPrefix: 'coords_intersectbearingcircle',
        iconPath: 'assets/icons/coords/icon_intersect_bearing_and_circle.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_compassrose',
          'coordinates_intersectgeodeticandcircle',
        ]),
    GCWTool(
        tool: IntersectTwoCircles(),
        i18nPrefix: 'coords_intersecttwocircles',
        iconPath: 'assets/icons/coords/icon_intersect_two_circles.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_intersecttwocircles',
        ]),
    GCWTool(
        tool: IntersectThreeCircles(),
        i18nPrefix: 'coords_intersectthreecircles',
        iconPath: 'assets/icons/coords/icon_intersect_three_circles.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_intersectthreecircles',
        ]),
    GCWTool(
        tool: Antipodes(),
        i18nPrefix: 'coords_antipodes',
        iconPath: 'assets/icons/coords/icon_antipodes.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_antipodes',
        ]),
    GCWTool(
        tool: Intersection(),
        i18nPrefix: 'coords_intersection',
        iconPath: 'assets/icons/coords/icon_intersection.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_intersection',
        ]),
    GCWTool(
        tool: Resection(),
        i18nPrefix: 'coords_resection',
        iconPath: 'assets/icons/coords/icon_resection.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_resection',
        ]),
    GCWTool(
        tool: EquilateralTriangle(),
        i18nPrefix: 'coords_equilateraltriangle',
        iconPath: 'assets/icons/coords/icon_equilateral_triangle.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_equilateraltriangle',
        ]),
    GCWTool(
        tool: EllipsoidTransform(),
        i18nPrefix: 'coords_ellipsoidtransform',
        iconPath: 'assets/icons/coords/icon_ellipsoid_transform.png',
        categories: [
          ToolCategory.COORDINATES
        ],
        searchKeys: [
          'coordinates',
          'coordinates_ellipsoidtransform',
        ]),

    //Countries Selection ******************************************************************************************

    GCWTool(tool: CountriesCallingCodes(), i18nPrefix: 'countries_callingcode', searchKeys: [
      'countries',
      'countries_callingcodes',
    ]),
    GCWTool(tool: CountriesIOCCodes(), i18nPrefix: 'countries_ioccode', searchKeys: [
      'countries',
      'countries_ioccodes',
    ]),
    GCWTool(tool: CountriesISOCodes(), i18nPrefix: 'countries_isocode', searchKeys: [
      'countries',
      'countries_isocodes',
    ]),
    GCWTool(tool: CountriesVehicleCodes(), i18nPrefix: 'countries_vehiclecode', searchKeys: [
      'countries',
      'countries_vehiclecodes',
    ]),
    GCWTool(tool: CountriesFlags(), i18nPrefix: 'countries_flags', searchKeys: [
      'countries',
      'symbol_flags',
      'countries_flags',
    ]),

    //CrossSumSelection *******************************************************************************************

    GCWTool(tool: CrossSum(), i18nPrefix: 'crosssum_crosssum', searchKeys: [
      'crosssums',
    ]),
    GCWTool(tool: CrossSumRange(), i18nPrefix: 'crosssum_range', searchKeys: [
      'crosssums',
      'crossumrange',
    ]),
    GCWTool(tool: IteratedCrossSumRange(), i18nPrefix: 'crosssum_range_iterated', searchKeys: [
      'crosssums',
      'iteratedcrosssumrange',
    ]),
    GCWTool(tool: CrossSumRangeFrequency(), i18nPrefix: 'crosssum_range_frequency', searchKeys: [
      'crosssums',
      'crossumrange',
      'iteratedcrossumrangefrequency',
    ]),
    GCWTool(tool: IteratedCrossSumRangeFrequency(), i18nPrefix: 'crosssum_range_iterated_frequency', searchKeys: [
      'crosssums',
      'crossumrange',
      'crosssumrangefrequency',
    ]),

    //DatesSelection **********************************************************************************************
    GCWTool(tool: DayCalculator(), i18nPrefix: 'dates_daycalculator', searchKeys: [
      'dates',
      'dates_daycalculator',
    ]),
    GCWTool(tool: TimeCalculator(), i18nPrefix: 'dates_timecalculator', searchKeys: [
      'dates',
      'dates_timecalculator',
    ]),
    GCWTool(tool: Weekday(), i18nPrefix: 'dates_weekday', searchKeys: [
      'dates',
      'dates_weekday',
    ]),
    GCWTool(tool: DayOfTheYear(), i18nPrefix: 'dates_day_of_the_year', searchKeys: [
      'dates',
      'dates_day_of_the_year',
    ]),
    GCWTool(tool: Calendar(), i18nPrefix: 'dates_calendar', searchKeys: [
      'dates',
      'dates_calendar',
    ]),

    //DNASelection ************************************************************************************************
    GCWTool(tool: DNANucleicAcidSequence(), i18nPrefix: 'dna_nucleicacidsequence', searchKeys: [
      'dna',
      'dnanucleicacidsequence',
    ]),
    GCWTool(tool: DNAAminoAcids(), i18nPrefix: 'dna_aminoacids', searchKeys: [
      'dna',
      'dnaaminoacids',
    ]),
    GCWTool(tool: DNAAminoAcidsTable(), i18nPrefix: 'dna_aminoacids_table', searchKeys: [
      'dna',
      'dnaamonoacidstable',
    ]),

    //E Selection *************************************************************************************************
    GCWTool(tool: ENthDecimal(), i18nPrefix: 'irrationalnumbers_nthdecimal', searchKeys: [
      'enthdecimal',
    ]),
    GCWTool(tool: EDecimalRange(), i18nPrefix: 'irrationalnumbers_decimalrange', searchKeys: [
      'edecimalrange',
    ]),
    GCWTool(tool: ESearch(), i18nPrefix: 'irrationalnumbers_search', searchKeys: [
      'esearch',
    ]),

    //Easter Selection ***************************************************************************************
    GCWTool(tool: EasterDate(), i18nPrefix: 'astronomy_easter_easterdate', searchKeys: [
      'easter_date',
    ]),
    GCWTool(tool: EasterYears(), i18nPrefix: 'astronomy_easter_easteryears', searchKeys: [
      'easter_date',
      'easter_years',
    ]),

    //Esoteric Programming Language Selection ****************************************************************
    GCWTool(tool: Beatnik(), i18nPrefix: 'beatnik', searchKeys: [
      'esotericprogramminglanguage',
      'esoteric_beatnik',
    ]),
    GCWTool(tool: Befunge(), i18nPrefix: 'befunge', isBeta: true, searchKeys: [
      'esotericprogramminglanguage',
      'befunge',
    ]),
    GCWTool(tool: Brainfk(), i18nPrefix: 'brainfk', searchKeys: [
      'esotericprogramminglanguage',
      'esoteric_brainfk',
    ]),
    GCWTool(tool: Cow(), i18nPrefix: 'cow', searchKeys: [
      'esotericprogramminglanguage',
      'esoteric_cow',
    ]),
    GCWTool(tool: Chef(), i18nPrefix: 'chef', searchKeys: [
      'esotericprogramminglanguage',
      'esoteric_chef',
    ]),
    GCWTool(tool: Deadfish(), i18nPrefix: 'deadfish', searchKeys: [
      'esotericprogramminglanguage',
      'esoteric_deadfish',
    ]),
    GCWTool(
        tool: Hohoho(),
        i18nPrefix: 'hohoho',
        searchKeys: ['esotericprogramminglanguage', 'esoteric_hohoho', 'christmas']),
    GCWTool(tool: KarolRobot(), i18nPrefix: 'karol_robot', searchKeys: [
      'esoteric_karol_robot',
    ]),
    GCWTool(tool: Malbolge(), i18nPrefix: 'malbolge', searchKeys: [
      'esotericprogramminglanguage',
      'esoteric_malbolge',
    ]),
    GCWTool(tool: Ook(), i18nPrefix: 'ook', searchKeys: [
      'esotericprogramminglanguage',
      'esoteric_brainfk',
      'esoteric_ook',
    ]),
    GCWTool(
        tool: Piet(),
        i18nPrefix: 'piet',
        isBeta: true,
        searchKeys: ['esotericprogramminglanguage', 'esoteric_piet', 'color', 'images']),
    GCWTool(tool: WhitespaceLanguage(), i18nPrefix: 'whitespace_language', searchKeys: [
      'esotericprogramminglanguage',
      'esoteric_whitespacelanguage',
    ]),

    //Hash Selection *****************************************************************************************
    GCWTool(tool: HashBreaker(), i18nPrefix: 'hashes_hashbreaker', categories: [
      ToolCategory.GENERAL_CODEBREAKERS
    ], searchKeys: [
      'codebreaker',
      'hashes',
      'hashbreaker',
    ]),
    GCWTool(tool: UrwigoHashBreaker(), i18nPrefix: 'urwigo_hashbreaker', searchKeys: [
      'wherigo',
      'urwigo',
      'hashes',
      'hashbreaker',
    ]),
    GCWTool(tool: HashOverview(), i18nPrefix: 'hashes_overview', searchKeys: ['hashes', 'hashes_overview']),
    GCWTool(
        tool: HashIdentification(),
        i18nPrefix: 'hashes_identification',
        searchKeys: ['hashes', 'hashes_identification']),
    GCWTool(tool: SHA1(), i18nPrefix: 'hashes_sha1', searchKeys: [
      'hashes',
      'hashes_sha1',
    ]),
    GCWTool(tool: SHA1HMac(), i18nPrefix: 'hashes_sha1hmac', searchKeys: [
      'hashes',
      'hashes_sha1',
      'hashes_hmac',
    ]),
    GCWTool(tool: SHA224(), i18nPrefix: 'hashes_sha224', searchKeys: [
      'hashes',
      'hashes_sha2',
      'hashes_sha224',
    ]),
    GCWTool(tool: SHA224HMac(), i18nPrefix: 'hashes_sha224hmac', searchKeys: [
      'hashes',
      'hashes_sha2',
      'hashes_sha224',
      'hashes_hmac',
    ]),
    GCWTool(tool: SHA256(), i18nPrefix: 'hashes_sha256', searchKeys: [
      'hashes',
      'hashes_sha2',
      'hashes_sha256',
    ]),
    GCWTool(tool: SHA256HMac(), i18nPrefix: 'hashes_sha256hmac', searchKeys: [
      'hashes',
      'hashes_sha2',
      'hashes_sha256',
      'hashes_hmac',
    ]),
    GCWTool(tool: SHA384(), i18nPrefix: 'hashes_sha384', searchKeys: [
      'hashes',
      'hashes_sha2',
      'hashes_sha384',
    ]),
    GCWTool(tool: SHA384HMac(), i18nPrefix: 'hashes_sha384hmac', searchKeys: [
      'hashes',
      'hashes_sha2',
      'hashes_sha384',
      'hashes_hmac',
    ]),
    GCWTool(tool: SHA512(), i18nPrefix: 'hashes_sha512', searchKeys: [
      'hashes',
      'hashes_sha2',
      'hashes_sha512',
    ]),
    GCWTool(tool: SHA512HMac(), i18nPrefix: 'hashes_sha512hmac', searchKeys: [
      'hashes',
      'hashes_sha2',
      'hashes_sha512',
      'hashes_hmac',
    ]),
    GCWTool(tool: SHA512_224(), i18nPrefix: 'hashes_sha512.224', searchKeys: [
      'hashes',
      'hashes_sha2',
      'hashes_sha512_224',
    ]),
    GCWTool(tool: SHA512_224HMac(), i18nPrefix: 'hashes_sha512.224hmac', searchKeys: [
      'hashes',
      'hashes_sha2',
      'hashes_sha512_224',
      'hashes_hmac',
    ]),
    GCWTool(tool: SHA512_256(), i18nPrefix: 'hashes_sha512.256', searchKeys: [
      'hashes',
      'hashes_sha2',
      'hashes_sha512_256',
    ]),
    GCWTool(tool: SHA512_256HMac(), i18nPrefix: 'hashes_sha512.256hmac', searchKeys: [
      'hashes',
      'hashes_sha2',
      'hashes_sha512_256',
      'hashes_hmac',
    ]),
    GCWTool(tool: SHA3_224(), i18nPrefix: 'hashes_sha3.224', searchKeys: [
      'hashes',
      'hashes_sha3',
      'hashes_sha3_224',
    ]),
    GCWTool(tool: SHA3_224HMac(), i18nPrefix: 'hashes_sha3.224hmac', searchKeys: [
      'hashes',
      'hashes_sha3',
      'hashes_sha3_224',
      'hashes_hmac',
    ]),
    GCWTool(tool: SHA3_256(), i18nPrefix: 'hashes_sha3.256', searchKeys: [
      'hashes',
      'hashes_sha3',
      'hashes_sha3_256',
    ]),
    GCWTool(tool: SHA3_256HMac(), i18nPrefix: 'hashes_sha3.256hmac', searchKeys: [
      'hashes',
      'hashes_sha3',
      'hashes_sha3_256',
      'hashes_hmac',
    ]),
    GCWTool(tool: SHA3_384(), i18nPrefix: 'hashes_sha3.384', searchKeys: [
      'hashes',
      'hashes_sha3',
      'hashes_sha3_384',
    ]),
    GCWTool(tool: SHA3_384HMac(), i18nPrefix: 'hashes_sha3.384hmac', searchKeys: [
      'hashes',
      'hashes_sha3',
      'hashes_sha3_384',
      'hashes_hmac',
    ]),
    GCWTool(tool: SHA3_512(), i18nPrefix: 'hashes_sha3.512', searchKeys: [
      'hashes',
      'hashes_sha3',
      'hashes_sha3_512',
    ]),
    GCWTool(tool: SHA3_512HMac(), i18nPrefix: 'hashes_sha3.512hmac', searchKeys: [
      'hashes',
      'hashes_sha3',
      'hashes_sha3_512',
      'hashes_hmac',
    ]),
    GCWTool(tool: Keccak_128(), i18nPrefix: 'hashes_keccak128', searchKeys: [
      'hashes',
      'hashes_sha3',
      'hashes_keccak',
      'hashes_keccak_128',
    ]),
    GCWTool(tool: Keccak_224(), i18nPrefix: 'hashes_keccak224', searchKeys: [
      'hashes',
      'hashes_sha3',
      'hashes_keccak',
      'hashes_keccak_224',
    ]),
    GCWTool(tool: Keccak_256(), i18nPrefix: 'hashes_keccak256', searchKeys: [
      'hashes',
      'hashes_sha3',
      'hashes_keccak',
      'hashes_keccak_256',
    ]),
    GCWTool(tool: Keccak_288(), i18nPrefix: 'hashes_keccak288', searchKeys: [
      'hashes',
      'hashes_sha3',
      'hashes_keccak',
      'hashes_keccak_288',
    ]),
    GCWTool(tool: Keccak_384(), i18nPrefix: 'hashes_keccak384', searchKeys: [
      'hashes',
      'hashes_sha3',
      'hashes_keccak',
      'hashes_keccak_384',
    ]),
    GCWTool(tool: Keccak_512(), i18nPrefix: 'hashes_keccak512', searchKeys: [
      'hashes',
      'hashes_sha3',
      'hashes_keccak',
      'hashes_keccak_512',
    ]),
    GCWTool(tool: RIPEMD_128(), i18nPrefix: 'hashes_ripemd128', searchKeys: [
      'hashes',
      'hashes_ripemd',
      'hashes_ripemd_128',
    ]),
    GCWTool(tool: RIPEMD_128HMac(), i18nPrefix: 'hashes_ripemd128hmac', searchKeys: [
      'hashes',
      'hashes_ripemd',
      'hashes_ripemd_128',
      'hashes_hmac',
    ]),
    GCWTool(tool: RIPEMD_160(), i18nPrefix: 'hashes_ripemd160', searchKeys: [
      'hashes',
      'hashes_ripemd',
      'hashes_ripemd_160',
    ]),
    GCWTool(tool: RIPEMD_160HMac(), i18nPrefix: 'hashes_ripemd160hmac', searchKeys: [
      'hashes',
      'hashes_ripemd',
      'hashes_ripemd_160',
      'hashes_hmac',
    ]),
    GCWTool(tool: RIPEMD_256(), i18nPrefix: 'hashes_ripemd256', searchKeys: [
      'hashes',
      'hashes_ripemd',
      'hashes_ripemd_256',
    ]),
    GCWTool(tool: RIPEMD_256HMac(), i18nPrefix: 'hashes_ripemd256hmac', searchKeys: [
      'hashes',
      'hashes_ripemd',
      'hashes_ripemd_256',
      'hashes_hmac',
    ]),
    GCWTool(tool: RIPEMD_320(), i18nPrefix: 'hashes_ripemd320', searchKeys: [
      'hashes',
      'hashes_ripemd',
      'hashes_ripemd_320',
    ]),
    GCWTool(tool: RIPEMD_320HMac(), i18nPrefix: 'hashes_ripemd320hmac', searchKeys: [
      'hashes',
      'hashes_ripemd',
      'hashes_ripemd_320',
      'hashes_hmac',
    ]),
    GCWTool(tool: MD2(), i18nPrefix: 'hashes_md2', searchKeys: [
      'hashes',
      'hashes_md2',
    ]),
    GCWTool(tool: MD2HMac(), i18nPrefix: 'hashes_md2hmac', searchKeys: [
      'hashes',
      'hashes_md2',
      'hashes_hmac',
    ]),
    GCWTool(tool: MD4(), i18nPrefix: 'hashes_md4', searchKeys: [
      'hashes',
      'hashes_md4',
    ]),
    GCWTool(tool: MD4HMac(), i18nPrefix: 'hashes_md4hmac', searchKeys: [
      'hashes',
      'hashes_md4',
      'hashes_hmac',
    ]),
    GCWTool(tool: MD5(), i18nPrefix: 'hashes_md5', searchKeys: [
      'hashes',
      'hashes_md5',
    ]),
    GCWTool(tool: MD5HMac(), i18nPrefix: 'hashes_md5hmac', searchKeys: [
      'hashes',
      'hashes_md5',
      'hashes_hmac',
    ]),
    GCWTool(tool: Tiger_192(), i18nPrefix: 'hashes_tiger192', searchKeys: [
      'hashes',
      'hashes_tiger_192',
    ]),
    GCWTool(tool: Tiger_192HMac(), i18nPrefix: 'hashes_tiger192hmac', searchKeys: [
      'hashes',
      'hashes_tiger_192',
      'hashes_hmac',
    ]),
    GCWTool(tool: Whirlpool_512(), i18nPrefix: 'hashes_whirlpool512', searchKeys: [
      'hashes',
      'hashes_whirlpool_512',
    ]),
    GCWTool(tool: Whirlpool_512HMac(), i18nPrefix: 'hashes_whirlpool512hmac', searchKeys: [
      'hashes',
      'hashes_whirlpool_512',
      'hashes_hmac',
    ]),
    GCWTool(tool: BLAKE2b_160(), i18nPrefix: 'hashes_blake2b160', searchKeys: [
      'hashes',
      'hashes_blake2b',
      'hashes_blake2b_160',
    ]),
    GCWTool(tool: BLAKE2b_224(), i18nPrefix: 'hashes_blake2b224', searchKeys: [
      'hashes',
      'hashes_blake2b',
      'hashes_blake2b_224',
    ]),
    GCWTool(tool: BLAKE2b_256(), i18nPrefix: 'hashes_blake2b256', searchKeys: [
      'hashes',
      'hashes_blake2b',
      'hashes_blake2b_256',
    ]),
    GCWTool(tool: BLAKE2b_384(), i18nPrefix: 'hashes_blake2b384', searchKeys: [
      'hashes',
      'hashes_blake2b',
      'hashes_blake2b_384',
    ]),
    GCWTool(tool: BLAKE2b_512(), i18nPrefix: 'hashes_blake2b512', searchKeys: [
      'hashes',
      'hashes_blake2b',
      'hashes_blake2b_512',
    ]),

    // IceCodeSelection *********************************************************************************************
    GCWTool(tool: IceCodes(), i18nPrefix: 'icecodes', searchKeys: [
      'icecodes',
    ]),

    //Language Games Selection *******************************************************************************
    GCWTool(tool: ChickenLanguage(), i18nPrefix: 'chickenlanguage', searchKeys: [
      'languagegames',
      'languagegames_chickenlanguage',
    ]),
    GCWTool(tool: DuckSpeak(), i18nPrefix: 'duckspeak', searchKeys: [
      'languagegames',
      'duckspeak',
    ]),
    GCWTool(tool: PigLatin(), i18nPrefix: 'piglatin', searchKeys: [
      'languagegames',
      'languagegames_piglatin',
    ]),
    GCWTool(tool: RobberLanguage(), i18nPrefix: 'robberlanguage', searchKeys: [
      'languagegames',
      'languagegames_robberlanguage',
    ]),
    GCWTool(tool: SpoonLanguage(), i18nPrefix: 'spoonlanguage', searchKeys: [
      'languagegames',
      'languagegames_spoonlanguage',
    ]),

    //Main Menu **********************************************************************************************
    GCWTool(tool: GeneralSettings(), i18nPrefix: 'settings_general', searchKeys: []),
    GCWTool(tool: CoordinatesSettings(), i18nPrefix: 'settings_coordinates', searchKeys: []),
    GCWTool(tool: ToolSettings(), i18nPrefix: 'settings_tools', searchKeys: []),
    GCWTool(tool: SaveRestoreSettings(), i18nPrefix: 'settings_saverestore', searchKeys: []),
    GCWTool(tool: Changelog(), i18nPrefix: 'mainmenu_changelog', suppressHelpButton: true, searchKeys: [
      'changelog',
    ]),
    GCWTool(tool: About(), i18nPrefix: 'mainmenu_about', suppressHelpButton: true, searchKeys: [
      'about',
    ]),
    GCWTool(
        tool: CallForContribution(),
        i18nPrefix: 'mainmenu_callforcontribution',
        suppressHelpButton: true,
        searchKeys: [
          'callforcontribution',
        ]),
    GCWTool(tool: Licenses(), i18nPrefix: 'licenses', suppressHelpButton: true, searchKeys: [
      'licenses',
    ]),

    //MayaCalendar Selection **************************************************************************************
    GCWTool(tool: MayaCalendar(), i18nPrefix: 'mayacalendar', searchKeys: [
      'calendar',
      'maya_calendar',
    ]),

    //MayaNumbers Selection **************************************************************************************
    GCWTool(tool: MayaNumbers(), i18nPrefix: 'mayanumbers', searchKeys: [
      'mayanumbers',
    ]),

    //Morse Selection ****************************************************************
    GCWTool(tool: Morse(), i18nPrefix: 'morse', searchKeys: [
      'morse',
    ]),

    //NumeralWordsSelection ****************************************************************************************
    GCWTool(tool: NumeralWordsTextSearch(), i18nPrefix: 'numeralwords_textsearch', searchKeys: [
      'numeralwords',
      'numeralwords_lang',
      'numeralwordstextsearch',
    ]),
    GCWTool(tool: NumeralWordsLists(), i18nPrefix: 'numeralwords_lists', searchKeys: [
      'numeralwords',
      'numeralwords_lang',
      'numeralwordslists',
    ]),
    GCWTool(tool: NumeralWordsConverter(), i18nPrefix: 'numeralwords_converter', searchKeys: [
      'numeralwords',
      'numeralwordsconverter',
    ]),
    GCWTool(tool: NumeralWordsIdentifyLanguages(), i18nPrefix: 'numeralwords_identify_languages', searchKeys: [
      'numeralwords',
      'numeralwords_identifylanguages',
    ]),

    //NumberSequenceSelection ****************************************************************************************
    GCWTool(tool: NumberSequenceFactorialSelection(), i18nPrefix: 'numbersequence_factorial', searchKeys: [
      'numbersequence',
      'numbersequence_factorialselection',
    ]),
    GCWTool(tool: NumberSequenceFibonacciSelection(), i18nPrefix: 'numbersequence_fibonacci', searchKeys: [
      'numbersequence',
      'numbersequence_fibonacciselection',
    ]),
    GCWTool(tool: NumberSequenceMersenneSelection(), i18nPrefix: 'numbersequence_mersenne', searchKeys: [
      'numbersequence',
      'numbersequence_mersenneselection',
    ]),
    GCWTool(tool: NumberSequenceMersennePrimesSelection(), i18nPrefix: 'numbersequence_mersenneprimes', searchKeys: [
      'numbersequence',
      'primes',
      'numbersequence_mersenneprimesselection',
    ]),
    GCWTool(
        tool: NumberSequenceMersenneExponentsSelection(),
        i18nPrefix: 'numbersequence_mersenneexponents',
        searchKeys: [
          'numbersequence',
          'numbersequence_mersenneexponentsselection',
        ]),
    GCWTool(tool: NumberSequenceMersenneFermatSelection(), i18nPrefix: 'numbersequence_mersennefermat', searchKeys: [
      'numbersequence',
      'numbersequence_mersennefermatselection',
    ]),
    GCWTool(tool: NumberSequenceFermatSelection(), i18nPrefix: 'numbersequence_fermat', searchKeys: [
      'numbersequence',
      'numbersequence_fermatselection',
    ]),
    GCWTool(tool: NumberSequencePerfectNumbersSelection(), i18nPrefix: 'numbersequence_perfectnumbers', searchKeys: [
      'numbersequence',
      'numbersequence_perfectnumbersselection',
    ]),
    GCWTool(
        tool: NumberSequenceSuperPerfectNumbersSelection(),
        i18nPrefix: 'numbersequence_superperfectnumbers',
        searchKeys: [
          'numbersequence',
          'numbersequence_superperfectnumbersselection',
        ]),
    GCWTool(
        tool: NumberSequencePrimaryPseudoPerfectNumbersSelection(),
        i18nPrefix: 'numbersequence_primarypseudoperfectnumbers',
        searchKeys: [
          'numbersequence',
          'numbersequence_primarypseudoperfectnumbersselection',
        ]),
    GCWTool(tool: NumberSequenceWeirdNumbersSelection(), i18nPrefix: 'numbersequence_weirdnumbers', searchKeys: [
      'numbersequence',
      'numbersequence_weirdnumbersselection',
    ]),
    GCWTool(tool: NumberSequenceSublimeNumbersSelection(), i18nPrefix: 'numbersequence_sublimenumbers', searchKeys: [
      'numbersequence',
      'numbersequence_sublimenumbersselection',
    ]),
    GCWTool(
        tool: NumberSequencePermutablePrimesSelection(),
        i18nPrefix: 'numbersequence_permutableprimes',
        searchKeys: [
          'numbersequence',
          'primes',
          'numbersequence_permutableprimesselection',
        ]),
    GCWTool(tool: NumberSequenceLuckyNumbersSelection(), i18nPrefix: 'numbersequence_luckynumbers', searchKeys: [
      'numbersequence',
      'numbersequence_luckynumbersselection',
    ]),
    GCWTool(tool: NumberSequenceHappyNumbersSelection(), i18nPrefix: 'numbersequence_happynumbers', searchKeys: [
      'numbersequence',
      'numbersequence_happynumbersselection',
    ]),
    GCWTool(tool: NumberSequenceBellSelection(), i18nPrefix: 'numbersequence_bell', searchKeys: [
      'numbersequence',
      'numbersequence_bellselection',
    ]),
    GCWTool(tool: NumberSequencePellSelection(), i18nPrefix: 'numbersequence_pell', searchKeys: [
      'numbersequence',
      'numbersequence_pellselection',
    ]),
    GCWTool(tool: NumberSequenceLucasSelection(), i18nPrefix: 'numbersequence_lucas', searchKeys: [
      'numbersequence',
      'numbersequence_lucasselection',
    ]),
    GCWTool(tool: NumberSequencePellLucasSelection(), i18nPrefix: 'numbersequence_pelllucas', searchKeys: [
      'numbersequence',
      'numbersequence_pelllucasselection',
    ]),
    GCWTool(tool: NumberSequenceJacobsthalSelection(), i18nPrefix: 'numbersequence_jacobsthal', searchKeys: [
      'numbersequence',
      'numbersequence_jacobsthalselection',
    ]),
    GCWTool(tool: NumberSequenceJacobsthalLucasSelection(), i18nPrefix: 'numbersequence_jacobsthallucas', searchKeys: [
      'numbersequence',
      'numbersequence_jacobsthallucasselection',
    ]),
    GCWTool(
        tool: NumberSequenceJacobsthalOblongSelection(),
        i18nPrefix: 'numbersequence_jacobsthaloblong',
        searchKeys: [
          'numbersequence',
          'numbersequence_jacobsthaloblongselection',
        ]),
    GCWTool(tool: NumberSequenceCatalanSelection(), i18nPrefix: 'numbersequence_catalan', searchKeys: [
      'numbersequence',
      'numbersequence_catalanselection',
    ]),
    GCWTool(tool: NumberSequenceRecamanSelection(), i18nPrefix: 'numbersequence_recaman', searchKeys: [
      'numbersequence',
      'numbersequence_recamanselection',
    ]),
    GCWTool(tool: NumberSequenceLychrelSelection(), i18nPrefix: 'numbersequence_lychrel', searchKeys: [
      'numbersequence',
      'numbersequence_lychrelselection',
    ]),

    //NumberSequenceSelection Factorial ****************************************************************************************
    GCWTool(tool: NumberSequenceFactorialNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_factorialselection',
    ]),
    GCWTool(tool: NumberSequenceFactorialRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_factorialselection',
    ]),
    GCWTool(tool: NumberSequenceFactorialCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_factorialselection',
    ]),
    GCWTool(tool: NumberSequenceFactorialDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_factorialselection',
    ]),
    GCWTool(tool: NumberSequenceFactorialContainsDigits(), i18nPrefix: 'numbersequence_containsdigits', searchKeys: [
      'numbersequence_factorialselection',
    ]),

    //NumberSequenceSelection Mersenne-Fermat ****************************************************************************************
    GCWTool(tool: NumberSequenceMersenneFermatNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_mersennefermatselection',
    ]),
    GCWTool(tool: NumberSequenceMersenneFermatRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_mersennefermatselection',
    ]),
    GCWTool(tool: NumberSequenceMersenneFermatCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_mersennefermatselection',
    ]),
    GCWTool(tool: NumberSequenceMersenneFermatDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_mersennefermatselection',
    ]),
    GCWTool(
        tool: NumberSequenceMersenneFermatContainsDigits(),
        i18nPrefix: 'numbersequence_containsdigits',
        searchKeys: [
          'numbersequence_mersennefermatselection',
        ]),

    //NumberSequenceSelection Fermat ****************************************************************************************
    GCWTool(tool: NumberSequenceFermatNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_fermatselection',
    ]),
    GCWTool(tool: NumberSequenceFermatRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_fermatselection',
    ]),
    GCWTool(tool: NumberSequenceFermatCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_fermatselection',
    ]),
    GCWTool(tool: NumberSequenceFermatDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_fermatselection',
    ]),
    GCWTool(tool: NumberSequenceFermatContainsDigits(), i18nPrefix: 'numbersequence_containsdigits', searchKeys: [
      'numbersequence_fermatselection',
    ]),

    //NumberSequenceSelection Lucas ****************************************************************************************
    GCWTool(tool: NumberSequenceLucasNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_lucasselection',
    ]),
    GCWTool(tool: NumberSequenceLucasRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_lucasselection',
    ]),
    GCWTool(tool: NumberSequenceLucasCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_lucasselection',
    ]),
    GCWTool(tool: NumberSequenceLucasDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_lucasselection',
    ]),
    GCWTool(tool: NumberSequenceLucasContainsDigits(), i18nPrefix: 'numbersequence_containsdigits', searchKeys: [
      'numbersequence_lucasselection',
    ]),

    //NumberSequenceSelection Fibonacci ****************************************************************************************
    GCWTool(tool: NumberSequenceFibonacciNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_fibonacciselection',
    ]),
    GCWTool(tool: NumberSequenceFibonacciRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_fibonacciselection',
    ]),
    GCWTool(tool: NumberSequenceFibonacciCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_fibonacciselection',
    ]),
    GCWTool(tool: NumberSequenceFibonacciDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_fibonacciselection',
    ]),
    GCWTool(tool: NumberSequenceFibonacciContainsDigits(), i18nPrefix: 'numbersequence_containsdigits', searchKeys: [
      'numbersequence_fibonacciselection',
    ]),

    //NumberSequenceSelection Mersenne ****************************************************************************************
    GCWTool(tool: NumberSequenceMersenneNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_mersenneselection',
    ]),
    GCWTool(tool: NumberSequenceMersenneRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_mersenneselection',
    ]),
    GCWTool(tool: NumberSequenceMersenneCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_mersenneselection',
    ]),
    GCWTool(tool: NumberSequenceMersenneDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_mersenneselection',
    ]),
    GCWTool(tool: NumberSequenceMersenneContainsDigits(), i18nPrefix: 'numbersequence_containsdigits', searchKeys: [
      'numbersequence_mersenneselection',
    ]),

    //NumberSequenceSelection Bell ****************************************************************************************
    GCWTool(tool: NumberSequenceBellNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_bellselection',
    ]),
    GCWTool(tool: NumberSequenceBellRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_bellselection',
    ]),
    GCWTool(tool: NumberSequenceBellCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_bellselection',
    ]),
    GCWTool(tool: NumberSequenceBellDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_bellselection',
    ]),
    GCWTool(tool: NumberSequenceBellContainsDigits(), i18nPrefix: 'numbersequence_containsdigits', searchKeys: [
      'numbersequence_bellselection',
    ]),

    //NumberSequenceSelection Pell ****************************************************************************************
    GCWTool(tool: NumberSequencePellNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_pellselection',
    ]),
    GCWTool(tool: NumberSequencePellRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_pellselection',
    ]),
    GCWTool(tool: NumberSequencePellCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_pellselection',
    ]),
    GCWTool(tool: NumberSequencePellDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_pellselection',
    ]),
    GCWTool(tool: NumberSequencePellContainsDigits(), i18nPrefix: 'numbersequence_containsdigits', searchKeys: [
      'numbersequence_pellselection',
    ]),

    //NumberSequenceSelection Pell-Lucas ****************************************************************************************
    GCWTool(tool: NumberSequencePellLucasNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_pelllucasselection',
    ]),
    GCWTool(tool: NumberSequencePellLucasRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_pelllucasselection',
    ]),
    GCWTool(tool: NumberSequencePellLucasCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_pelllucasselection',
    ]),
    GCWTool(tool: NumberSequencePellLucasDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_pelllucasselection',
    ]),
    GCWTool(tool: NumberSequencePellLucasContainsDigits(), i18nPrefix: 'numbersequence_containsdigits', searchKeys: [
      'numbersequence_pelllucasselection',
    ]),

    //NumberSequenceSelection Jacobsthal ****************************************************************************************
    GCWTool(tool: NumberSequenceJacobsthalNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_jacobsthalselection',
    ]),
    GCWTool(tool: NumberSequenceJacobsthalRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_jacobsthalselection',
    ]),
    GCWTool(tool: NumberSequenceJacobsthalCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_jacobsthalselection',
    ]),
    GCWTool(tool: NumberSequenceJacobsthalDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_jacobsthalselection',
    ]),
    GCWTool(tool: NumberSequenceJacobsthalContainsDigits(), i18nPrefix: 'numbersequence_containsdigits', searchKeys: [
      'numbersequence_jacobsthalselection',
    ]),

    //NumberSequenceSelection Jacobsthal-Lucas ****************************************************************************************
    GCWTool(tool: NumberSequenceJacobsthalLucasNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_jacobsthallucasselection',
    ]),
    GCWTool(tool: NumberSequenceJacobsthalLucasRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_jacobsthallucasselection',
    ]),
    GCWTool(tool: NumberSequenceJacobsthalLucasCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_jacobsthallucasselection',
    ]),
    GCWTool(tool: NumberSequenceJacobsthalLucasDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_jacobsthallucasselection',
    ]),
    GCWTool(
        tool: NumberSequenceJacobsthalLucasContainsDigits(),
        i18nPrefix: 'numbersequence_containsdigits',
        searchKeys: [
          'numbersequence_jacobsthallucasselection',
        ]),

    //NumberSequenceSelection Jacobsthal Oblong ****************************************************************************************
    GCWTool(tool: NumberSequenceJacobsthalOblongNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_jacobsthaloblongselection',
    ]),
    GCWTool(tool: NumberSequenceJacobsthalOblongRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_jacobsthaloblongselection',
    ]),
    GCWTool(tool: NumberSequenceJacobsthalOblongCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_jacobsthaloblongselection',
    ]),
    GCWTool(tool: NumberSequenceJacobsthalOblongDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_jacobsthaloblongselection',
    ]),
    GCWTool(
        tool: NumberSequenceJacobsthalOblongContainsDigits(),
        i18nPrefix: 'numbersequence_containsdigits',
        searchKeys: [
          'numbersequence_jacobsthaloblongselection',
        ]),

    //NumberSequenceSelection Catalan ****************************************************************************************
    GCWTool(tool: NumberSequenceCatalanNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_catalanselection',
    ]),
    GCWTool(tool: NumberSequenceCatalanRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_catalanselection',
    ]),
    GCWTool(tool: NumberSequenceCatalanCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_catalanselection',
    ]),
    GCWTool(tool: NumberSequenceCatalanDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_catalanselection',
    ]),
    GCWTool(tool: NumberSequenceCatalanContainsDigits(), i18nPrefix: 'numbersequence_containsdigits', searchKeys: [
      'numbersequence_catalanselection',
    ]),

    //NumberSequenceSelection Recaman ****************************************************************************************
    GCWTool(tool: NumberSequenceRecamanNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_recamanselection',
    ]),
    GCWTool(tool: NumberSequenceRecamanRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_recamanselection',
    ]),
    GCWTool(tool: NumberSequenceRecamanCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_recamanselection',
    ]),
    GCWTool(tool: NumberSequenceRecamanDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_recamanselection',
    ]),
    GCWTool(tool: NumberSequenceRecamanContainsDigits(), i18nPrefix: 'numbersequence_containsdigits', searchKeys: [
      'numbersequence_recamanselection',
    ]),

    //NumberSequenceSelection Mersenne Primes ****************************************************************************************
    GCWTool(tool: NumberSequenceMersennePrimesNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_mersenneprimesselection',
    ]),
    GCWTool(tool: NumberSequenceMersennePrimesRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_mersenneprimesselection',
    ]),
    GCWTool(tool: NumberSequenceMersennePrimesCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_mersenneprimesselection',
    ]),
    GCWTool(tool: NumberSequenceMersennePrimesDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_mersenneprimesselection',
    ]),
    GCWTool(
        tool: NumberSequenceMersennePrimesContainsDigits(),
        i18nPrefix: 'numbersequence_containsdigits',
        searchKeys: [
          'numbersequence_mersenneprimesselection',
        ]),

    //NumberSequenceSelection Mersenne Exponents ****************************************************************************************
    GCWTool(tool: NumberSequenceMersenneExponentsNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_mersenneexponentsselection',
    ]),
    GCWTool(tool: NumberSequenceMersenneExponentsRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_mersenneexponentsselection',
    ]),
    GCWTool(tool: NumberSequenceMersenneExponentsCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_mersenneexponentsselection',
    ]),
    GCWTool(tool: NumberSequenceMersenneExponentsDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_mersenneexponentsselection',
    ]),
    GCWTool(
        tool: NumberSequenceMersenneExponentsContainsDigits(),
        i18nPrefix: 'numbersequence_containsdigits',
        searchKeys: [
          'numbersequence_mersenneexponentsselection',
        ]),

    //NumberSequenceSelection Perfect numbers ****************************************************************************************
    GCWTool(tool: NumberSequencePerfectNumbersNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_perfectnumbersselection',
    ]),
    GCWTool(tool: NumberSequencePerfectNumbersRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_perfectnumbersselection',
    ]),
    GCWTool(tool: NumberSequencePerfectNumbersCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_perfectnumbersselection',
    ]),
    GCWTool(tool: NumberSequencePerfectNumbersDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_perfectnumbersselection',
    ]),
    GCWTool(
        tool: NumberSequencePerfectNumbersContainsDigits(),
        i18nPrefix: 'numbersequence_containsdigits',
        searchKeys: [
          'numbersequence_perfectnumbersselection',
        ]),

    //NumberSequenceSelection SuperPerfect numbers ****************************************************************************************
    GCWTool(tool: NumberSequenceSuperPerfectNumbersNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_superperfectnumbersselection',
    ]),
    GCWTool(tool: NumberSequenceSuperPerfectNumbersRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_superperfectnumbersselection',
    ]),
    GCWTool(tool: NumberSequenceSuperPerfectNumbersCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_superperfectnumbersselection',
    ]),
    GCWTool(tool: NumberSequenceSuperPerfectNumbersDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_superperfectnumbersselection',
    ]),
    GCWTool(
        tool: NumberSequenceSuperPerfectNumbersContainsDigits(),
        i18nPrefix: 'numbersequence_containsdigits',
        searchKeys: [
          'numbersequence_superperfectnumbersselection',
        ]),

    //NumberSequenceSelection Weird numbers ****************************************************************************************
    GCWTool(tool: NumberSequenceWeirdNumbersNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_weirdnumbersselection',
    ]),
    GCWTool(tool: NumberSequenceWeirdNumbersRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_weirdnumbersselection',
    ]),
    GCWTool(tool: NumberSequenceWeirdNumbersCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_weirdnumbersselection',
    ]),
    GCWTool(tool: NumberSequenceWeirdNumbersDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_weirdnumbersselection',
    ]),
    GCWTool(tool: NumberSequenceWeirdNumbersContainsDigits(), i18nPrefix: 'numbersequence_containsdigits', searchKeys: [
      'numbersequence_weirdnumbersselection',
    ]),

    //NumberSequenceSelection Sublime numbers ****************************************************************************************
    GCWTool(tool: NumberSequenceSublimeNumbersNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_sublimenumbersselection',
    ]),
    GCWTool(tool: NumberSequenceSublimeNumbersRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_sublimenumbersselection',
    ]),
    GCWTool(tool: NumberSequenceSublimeNumbersCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_sublimenumbersselection',
    ]),
    GCWTool(tool: NumberSequenceSublimeNumbersDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_sublimenumbersselection',
    ]),
    GCWTool(
        tool: NumberSequenceSublimeNumbersContainsDigits(),
        i18nPrefix: 'numbersequence_containsdigits',
        searchKeys: [
          'numbersequence_sublimenumbersselection',
        ]),

    //NumberSequenceSelection Lucky numbers ****************************************************************************************
    GCWTool(tool: NumberSequenceLuckyNumbersNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_luckynumbersselection',
    ]),
    GCWTool(tool: NumberSequenceLuckyNumbersRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_luckynumbersselection',
    ]),
    GCWTool(tool: NumberSequenceLuckyNumbersCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_luckynumbersselection',
    ]),
    GCWTool(tool: NumberSequenceLuckyNumbersDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_luckynumbersselection',
    ]),
    GCWTool(tool: NumberSequenceLuckyNumbersContainsDigits(), i18nPrefix: 'numbersequence_containsdigits', searchKeys: [
      'numbersequence_luckynumbersselection',
    ]),

    //NumberSequenceSelection Happy numbers ****************************************************************************************
    GCWTool(tool: NumberSequenceHappyNumbersNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_happynumbersselection',
    ]),
    GCWTool(tool: NumberSequenceHappyNumbersRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_happynumbersselection',
    ]),
    GCWTool(tool: NumberSequenceHappyNumbersCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_happynumbersselection',
    ]),
    GCWTool(tool: NumberSequenceHappyNumbersDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_happynumbersselection',
    ]),
    GCWTool(tool: NumberSequenceHappyNumbersContainsDigits(), i18nPrefix: 'numbersequence_containsdigits', searchKeys: [
      'numbersequence_happynumbersselection',
    ]),

    //NumberSequenceSelection PseudoPerfect numbers ****************************************************************************************
    GCWTool(tool: NumberSequencePrimaryPseudoPerfectNumbersNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_primarypseudoperfectnumbersselection',
    ]),
    GCWTool(tool: NumberSequencePrimaryPseudoPerfectNumbersRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_primarypseudoperfectnumbersselection',
    ]),
    GCWTool(
        tool: NumberSequencePrimaryPseudoPerfectNumbersCheckNumber(),
        i18nPrefix: 'numbersequence_check',
        searchKeys: [
          'numbersequence_primarypseudoperfectnumbersselection',
        ]),
    GCWTool(tool: NumberSequencePrimaryPseudoPerfectNumbersDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_primarypseudoperfectnumbersselection',
    ]),
    GCWTool(
        tool: NumberSequencePrimaryPseudoPerfectNumbersContainsDigits(),
        i18nPrefix: 'numbersequence_containsdigits',
        searchKeys: [
          'numbersequence_primarypseudoperfectnumbersselection',
        ]),

    //NumberSequenceSelection Lychrel numbers ****************************************************************************************
    GCWTool(tool: NumberSequenceLychrelNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_lychrelselection',
    ]),
    GCWTool(tool: NumberSequenceLychrelRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_lychrelselection',
    ]),
    GCWTool(tool: NumberSequenceLychrelCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_lychrelselection',
    ]),
    GCWTool(tool: NumberSequenceLychrelDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_lychrelselection',
    ]),
    GCWTool(tool: NumberSequenceLychrelContainsDigits(), i18nPrefix: 'numbersequence_containsdigits', searchKeys: [
      'numbersequence_lychrelselection',
    ]),

    //NumberSequenceSelection Mersenne Primes ****************************************************************************************
    GCWTool(tool: NumberSequencePermutablePrimesNthNumber(), i18nPrefix: 'numbersequence_nth', searchKeys: [
      'numbersequence_permutableprimesselection',
    ]),
    GCWTool(tool: NumberSequencePermutablePrimesRange(), i18nPrefix: 'numbersequence_range', searchKeys: [
      'numbersequence_permutableprimesselection',
    ]),
    GCWTool(tool: NumberSequencePermutablePrimesCheckNumber(), i18nPrefix: 'numbersequence_check', searchKeys: [
      'numbersequence_permutableprimesselection',
    ]),
    GCWTool(tool: NumberSequencePermutablePrimesDigits(), i18nPrefix: 'numbersequence_digits', searchKeys: [
      'numbersequence_permutableprimesselection',
    ]),
    GCWTool(
        tool: NumberSequencePermutablePrimesContainsDigits(),
        i18nPrefix: 'numbersequence_containsdigits',
        searchKeys: [
          'numbersequence_permutableprimesselection',
        ]),

    //PeriodicTableSelection ***************************************************************************************
    GCWTool(tool: PeriodicTable(), i18nPrefix: 'periodictable', searchKeys: []),
    GCWTool(tool: PeriodicTableDataView(), i18nPrefix: 'periodictable_dataview', searchKeys: [
      'periodictabledataview',
    ]),
    GCWTool(tool: AtomicNumbersToText(), i18nPrefix: 'atomicnumberstotext', searchKeys: [
      'periodictable_atomicnumbers',
    ]),

    //Phi Selection **********************************************************************************************
    GCWTool(tool: PhiNthDecimal(), i18nPrefix: 'irrationalnumbers_nthdecimal', searchKeys: [
      'irrationalnumbers',
      'phidecimalrange',
    ]),
    GCWTool(tool: PhiDecimalRange(), i18nPrefix: 'irrationalnumbers_decimalrange', searchKeys: [
      'irrationalnumbers',
      'phidecimalrange',
    ]),
    GCWTool(tool: PhiSearch(), i18nPrefix: 'irrationalnumbers_search', searchKeys: [
      'irrationalnumbers',
      'phisearch',
    ]),

    //Pi Selection **********************************************************************************************
    GCWTool(tool: PiNthDecimal(), i18nPrefix: 'irrationalnumbers_nthdecimal', searchKeys: [
      'irrationalnumbers',
      'pinthdecimal',
    ]),
    GCWTool(tool: PiDecimalRange(), i18nPrefix: 'irrationalnumbers_decimalrange', searchKeys: [
      'irrationalnumbers',
      'pidecimalrange',
    ]),
    GCWTool(tool: PiSearch(), i18nPrefix: 'irrationalnumbers_search', searchKeys: [
      'irrationalnumbers',
      'pisearch',
    ]),

    //Predator Selection **************************************************************************************
    GCWTool(tool: Predator(), i18nPrefix: 'predator', searchKeys: [
      'predator',
    ]),

    //PrimesSelection **********************************************************************************************
    GCWTool(tool: NthPrime(), i18nPrefix: 'primes_nthprime', searchKeys: [
      'primes',
      'primes_nthprime',
    ]),
    GCWTool(tool: IsPrime(), i18nPrefix: 'primes_isprime', searchKeys: [
      'primes',
      'primes_isprime',
    ]),
    GCWTool(tool: NearestPrime(), i18nPrefix: 'primes_nearestprime', searchKeys: [
      'primes',
      'primes_nearestprime',
    ]),
    GCWTool(tool: PrimeIndex(), i18nPrefix: 'primes_primeindex', searchKeys: [
      'primes',
      'primes_primeindex',
    ]),
    GCWTool(tool: IntegerFactorization(), i18nPrefix: 'primes_integerfactorization', searchKeys: [
      'primes',
      'primes_integerfactorization',
    ]),

    //ResistorSelection **********************************************************************************************
    GCWTool(tool: ResistorColorCodeCalculator(), i18nPrefix: 'resistor_colorcodecalculator', searchKeys: [
      'resistor',
      'color',
      'resistor_colorcode',
    ]),
    GCWTool(tool: ResistorEIA96(), i18nPrefix: 'resistor_eia96', searchKeys: [
      'resistor',
      'resistoreia96',
    ]),

    //RomanNumbersSelection **********************************************************************************************
    GCWTool(tool: RomanNumbers(), i18nPrefix: 'romannumbers', searchKeys: [
      'roman_numbers',
    ]),
    GCWTool(tool: Chronogram(), i18nPrefix: 'chronogram', searchKeys: [
      'roman_numbers',
      'chronogram',
    ]),

    //RotationSelection **********************************************************************************************
    GCWTool(tool: Rot13(), i18nPrefix: 'rotation_rot13', searchKeys: [
      'rotation',
      'rotation_rot13',
    ]),
    GCWTool(tool: Rot5(), i18nPrefix: 'rotation_rot5', searchKeys: [
      'rotation',
      'rotation_rot5',
    ]),
    GCWTool(tool: Rot18(), i18nPrefix: 'rotation_rot18', searchKeys: [
      'rotation',
      'rotation_rot18',
    ]),
    GCWTool(tool: Rot47(), i18nPrefix: 'rotation_rot47', searchKeys: [
      'rotation',
      'rotation_rot47',
    ]),
    GCWTool(tool: Rot123(), i18nPrefix: 'rotation_rot123', searchKeys: [
      'rotation',
      'rotation_rot123',
    ]),
    GCWTool(tool: RotationGeneral(), i18nPrefix: 'rotation_general', searchKeys: [
      'rotation',
    ]),

    // RSA *******************************************************************************************************
    GCWTool(tool: RSA(), i18nPrefix: 'rsa_rsa', searchKeys: [
      'rsa',
    ]),
    GCWTool(tool: RSAEChecker(), i18nPrefix: 'rsa_e.checker', searchKeys: [
      'rsa',
      'rsa_echecker',
    ]),
    GCWTool(tool: RSADChecker(), i18nPrefix: 'rsa_d.checker', searchKeys: [
      'rsa',
      'rsa_dchecker',
    ]),
    GCWTool(tool: RSADCalculator(), i18nPrefix: 'rsa_d.calculator', searchKeys: [
      'rsa',
      'rsa_dcalculator',
    ]),
    GCWTool(tool: RSANCalculator(), i18nPrefix: 'rsa_n.calculator', searchKeys: [
      'rsa',
      'rsa_ncalculator',
    ]),
    GCWTool(tool: RSAPhiCalculator(), i18nPrefix: 'rsa_phi.calculator', searchKeys: ['rsa']),
    GCWTool(tool: RSAPrimesCalculator(), i18nPrefix: 'rsa_primes.calculator', searchKeys: ['rsa', 'primes']),

    //Scrabble Selection *****************************************************************************************

    GCWTool(tool: Scrabble(), i18nPrefix: 'scrabble', searchKeys: [
      'games_scrabble',
    ]),
    GCWTool(tool: ScrabbleOverview(), i18nPrefix: 'scrabbleoverview', searchKeys: [
      'games_scrabble',
    ]),

    //Segments Display *******************************************************************************************
    GCWTool(
        tool: SevenSegments(),
        i18nPrefix: 'segmentdisplay_7segments',
        iconPath: 'assets/icons/science_and_technology/icon_7segment_display.png',
        searchKeys: [
          'segments',
          'segments_seven',
        ]),
    GCWTool(
        tool: FourteenSegments(),
        i18nPrefix: 'segmentdisplay_14segments',
        iconPath: 'assets/icons/science_and_technology/icon_14segment_display.png',
        searchKeys: [
          'segments',
          'segments_fourteen',
        ]),
    GCWTool(
        tool: SixteenSegments(),
        i18nPrefix: 'segmentdisplay_16segments',
        iconPath: 'assets/icons/science_and_technology/icon_16segment_display.png',
        searchKeys: [
          'segments',
          'segments_sixteen',
        ]),

    //Shadoks Selection ******************************************************************************************
    GCWTool(tool: ShadoksNumbers(), i18nPrefix: 'shadoksnumbers', searchKeys: [
      'shadoksnumbers',
    ]),

    //Silver Ratio Selection **********************************************************************************************
    GCWTool(tool: SilverRatioNthDecimal(), i18nPrefix: 'irrationalnumbers_nthdecimal', searchKeys: [
      'silverratiodecimalrange',
    ]),
    GCWTool(tool: SilverRatioDecimalRange(), i18nPrefix: 'irrationalnumbers_decimalrange', searchKeys: [
      'silverratiodecimalrange',
    ]),
    GCWTool(tool: SilverRatioSearch(), i18nPrefix: 'irrationalnumbers_search', searchKeys: [
      'silverratiosearch',
    ]),

    //SQRT 2 Selection **********************************************************************************************
    GCWTool(tool: SQRT2NthDecimal(), i18nPrefix: 'irrationalnumbers_nthdecimal', searchKeys: [
      '',
    ]),
    GCWTool(tool: SQRT2DecimalRange(), i18nPrefix: 'irrationalnumbers_decimalrange', searchKeys: [
      '',
    ]),
    GCWTool(tool: SQRT2Search(), i18nPrefix: 'irrationalnumbers_search', searchKeys: [
      '',
    ]),

    //SQRT 3 Selection **********************************************************************************************
    GCWTool(tool: SQRT3NthDecimal(), i18nPrefix: 'irrationalnumbers_nthdecimal', searchKeys: [
      '',
    ]),
    GCWTool(tool: SQRT3DecimalRange(), i18nPrefix: 'irrationalnumbers_decimalrange', searchKeys: [
      '',
    ]),
    GCWTool(tool: SQRT3Search(), i18nPrefix: 'irrationalnumbers_search', searchKeys: [
      '',
    ]),

    //SQRT 5 Selection **********************************************************************************************
    GCWTool(tool: SQRT5NthDecimal(), i18nPrefix: 'irrationalnumbers_nthdecimal', searchKeys: [
      '',
    ]),
    GCWTool(tool: SQRT5DecimalRange(), i18nPrefix: 'irrationalnumbers_decimalrange', searchKeys: [
      '',
    ]),
    GCWTool(tool: SQRT5Search(), i18nPrefix: 'irrationalnumbers_search', searchKeys: [
      '',
    ]),

    //Symbol Tables **********************************************************************************************
    GCWTool(tool: SymbolTableExamplesSelect(), autoScroll: false, i18nPrefix: 'symboltablesexamples', searchKeys: [
      'symbol',
      'symboltablesexamples',
    ]),
    GCWTool(
      tool: SymbolReplacer(),
      i18nPrefix: 'symbol_replacer',
      isBeta: true,
      searchKeys: [
        'symbol_replacer',
      ],
      categories: [ToolCategory.GENERAL_CODEBREAKERS],
    ),

    GCWSymbolTableTool(symbolKey: 'adlam', symbolSearchStrings: [
      'symbol_adlam',
    ]),
    GCWSymbolTableTool(symbolKey: 'albhed', symbolSearchStrings: [
      'symbol_albhed',
    ]),
    GCWSymbolTableTool(symbolKey: 'alchemy', symbolSearchStrings: [
      'symbol_alchemy',
    ]),
    GCWSymbolTableTool(symbolKey: 'alchemy_alphabet', symbolSearchStrings: [
      'symbol_alchemy_alphabet',
    ]),
    GCWSymbolTableTool(symbolKey: 'alien_mushrooms', symbolSearchStrings: [
      'symbol_alien_mushrooms',
    ]),
    GCWSymbolTableTool(symbolKey: 'angerthas_cirth', symbolSearchStrings: [
      'symbol_lordoftherings',
      'symbol_runes',
      'symbol_angerthas_cirth',
    ]),
    GCWSymbolTableTool(symbolKey: 'alphabetum_arabum', symbolSearchStrings: [
      'symbol_alphabetum_arabum',
    ]),
    GCWSymbolTableTool(symbolKey: 'alphabetum_egiptiorum', symbolSearchStrings: [
      'symbol_alphabetum_egiptiorum',
    ]),
    GCWSymbolTableTool(symbolKey: 'alphabetum_gothicum', symbolSearchStrings: [
      'symbol_alphabetum_gothicum',
    ]),
    GCWSymbolTableTool(symbolKey: 'antiker', symbolSearchStrings: [
      'symbol_antiker',
    ]),
    GCWSymbolTableTool(symbolKey: 'arabic_indian_numerals', symbolSearchStrings: [
      'symbol_arabic_indian_numerals',
    ]),
    GCWSymbolTableTool(symbolKey: 'arcadian', symbolSearchStrings: [
      'symbol_arcadian',
    ]),
    GCWSymbolTableTool(symbolKey: 'ath', symbolSearchStrings: [
      'symbol_ath',
    ]),
    GCWSymbolTableTool(symbolKey: 'atlantean', symbolSearchStrings: [
      'symbol_atlantean',
    ]),
    GCWSymbolTableTool(symbolKey: 'aurebesh', symbolSearchStrings: [
      'symbol_aurebesh',
    ]),
    GCWSymbolTableTool(symbolKey: 'australian_sign_language', symbolSearchStrings: [
      'symbol_signlanguage',
      'symbol_australian_sign_language',
    ]),
    GCWSymbolTableTool(symbolKey: 'babylonian_numerals', symbolSearchStrings: [
      'babylonian_numerals',
    ]),
    GCWSymbolTableTool(symbolKey: 'ballet', symbolSearchStrings: [
      'symbol_ballet',
    ]),
    GCWSymbolTableTool(symbolKey: 'barbier', symbolSearchStrings: [
      'braille',
      'symbol_barbier',
    ]),
    GCWSymbolTableTool(symbolKey: 'barcode39', symbolSearchStrings: [
      'barcodes',
      'barcode39',
    ]),
    GCWSymbolTableTool(symbolKey: 'baudot_1888', symbolSearchStrings: ['ccitt', 'symbol_baudot', 'teletypewriter']),
    GCWSymbolTableTool(symbolKey: 'baudot_54123', symbolSearchStrings: ['ccitt', 'symbol_baudot', 'teletypewriter']),
    GCWSymbolTableTool(symbolKey: 'birds_on_a_wire', symbolSearchStrings: [
      'symbol_birds_on_a_wire',
    ]),
    GCWSymbolTableTool(symbolKey: 'blox', symbolSearchStrings: [
      'symbol_blox',
    ]),
    GCWSymbolTableTool(symbolKey: 'brahmi_numerals', symbolSearchStrings: [
      'symbol_brahmi_numerals',
    ]),
    GCWSymbolTableTool(symbolKey: 'braille_de', symbolSearchStrings: [
      'braille',
    ]),
    GCWSymbolTableTool(symbolKey: 'braille_en', symbolSearchStrings: [
      'braille',
    ]),
    GCWSymbolTableTool(symbolKey: 'braille_eu', symbolSearchStrings: [
      'braille',
      'braille_euro',
    ]),
    GCWSymbolTableTool(symbolKey: 'braille_fr', symbolSearchStrings: [
      'braille',
    ]),
    GCWSymbolTableTool(symbolKey: 'british_sign_language', symbolSearchStrings: [
      'symbol_signlanguage',
      'symbol_british_sign_language',
    ]),
    GCWSymbolTableTool(symbolKey: 'chain_of_death_direction', symbolSearchStrings: [
      'symbol_chain_of_death_direction',
    ]),
    GCWSymbolTableTool(symbolKey: 'chain_of_death_pairs', symbolSearchStrings: [
      'symbol_chain_of_death_pairs',
    ]),
    GCWSymbolTableTool(symbolKey: 'chappe_1794', symbolSearchStrings: [
      'telegraph',
      'symbol_chappe',
      'symbol_chappe_1794',
    ]),
    GCWSymbolTableTool(symbolKey: 'chappe_1809', symbolSearchStrings: [
      'telegraph',
      'symbol_chappe',
      'symbol_chappe_1809',
    ]),
    GCWSymbolTableTool(symbolKey: 'chappe_v1', symbolSearchStrings: [
      'telegraph',
      'symbol_chappe',
      'symbol_chappe_v1',
    ]),
    GCWSymbolTableTool(symbolKey: 'cherokee', symbolSearchStrings: [
      'symbol_cherokee',
    ]),
    GCWSymbolTableTool(symbolKey: 'chinese_numerals', symbolSearchStrings: [
      'symbol_chinese_numerals',
    ]),
    GCWSymbolTableTool(symbolKey: 'christmas', symbolSearchStrings: [
      'christmas',
    ]),
    GCWSymbolTableTool(symbolKey: 'cirth_erebor', symbolSearchStrings: [
      'symbol_runes',
      'symbol_lordoftherings',
      'symbol_cirtherebor',
    ]),
    GCWSymbolTableTool(symbolKey: 'cistercian', symbolSearchStrings: [
      'cistercian',
    ]),
    GCWSymbolTableTool(symbolKey: 'color_add', symbolSearchStrings: [
      'color',
      'symbol_color_add',
    ]),
    GCWSymbolTableTool(symbolKey: 'color_code', symbolSearchStrings: [
      'color',
      'symbol_color_code',
    ]),
    GCWSymbolTableTool(symbolKey: 'color_honey', symbolSearchStrings: [
      'color',
      'symbol_color_honey',
    ]),
    GCWSymbolTableTool(symbolKey: 'color_tokki', symbolSearchStrings: [
      'color',
      'symbol_color_tokki',
    ]),
    GCWSymbolTableTool(symbolKey: 'cookewheatstone_1', symbolSearchStrings: [
      'telegraph',
      'symbol_cookewheatstone',
      'symbol_cookewheatstone_1',
    ]),
    GCWSymbolTableTool(symbolKey: 'cookewheatstone_2', symbolSearchStrings: [
      'telegraph',
      'symbol_cookewheatstone',
      'symbol_cookewheatstone_2',
    ]),
    GCWSymbolTableTool(symbolKey: 'cookewheatstone_5', symbolSearchStrings: [
      'telegraph',
      'symbol_cookewheatstone',
      'symbol_cookewheatstone_5',
    ]),
    GCWSymbolTableTool(symbolKey: 'country_flags', symbolSearchStrings: [
      'countries',
      'symbol_flags',
      'countries_flags',
    ]),
    GCWSymbolTableTool(symbolKey: 'covenant', symbolSearchStrings: [
      'symbol_covenant',
    ]),
    GCWSymbolTableTool(symbolKey: 'crystal', symbolSearchStrings: [
      'symbol_crystal',
    ]),
    GCWSymbolTableTool(symbolKey: 'cyrillic', symbolSearchStrings: [
      'symbol_cyrillic',
    ]),
    GCWSymbolTableTool(symbolKey: 'cyrillic_numbers', symbolSearchStrings: [
      'symbol_cyrillic_numbers',
    ]),
    GCWSymbolTableTool(symbolKey: 'daedric', symbolSearchStrings: [
      'symbol_daedric',
    ]),
    GCWSymbolTableTool(symbolKey: 'dagger', symbolSearchStrings: [
      'symbol_dagger',
    ]),
    GCWSymbolTableTool(symbolKey: 'dancing_men', symbolSearchStrings: [
      'symbol_dancing_men',
    ]),
    GCWSymbolTableTool(symbolKey: 'deafblind', symbolSearchStrings: [
      'symbol_signlanguage',
      'symbol_deafblind',
    ]),
    GCWSymbolTableTool(symbolKey: 'devanagari_numerals', symbolSearchStrings: [
      'symbol_devanagari_numerals',
    ]),
    GCWSymbolTableTool(symbolKey: 'dni', symbolSearchStrings: [
      'symbol_dni',
    ]),
    GCWSymbolTableTool(symbolKey: 'dni_colors', symbolSearchStrings: [
      'color',
      'symbol_dni_colors',
    ]),
    GCWSymbolTableTool(symbolKey: 'dni_numbers', symbolSearchStrings: [
      'symbol_dni_numbers',
    ]),
    GCWSymbolTableTool(symbolKey: 'doop_speak', symbolSearchStrings: [
      'symbol_doop',
    ]),
    GCWSymbolTableTool(symbolKey: 'dorabella', symbolSearchStrings: [
      'symbol_dorabella',
    ]),
    GCWSymbolTableTool(symbolKey: 'doremi', symbolSearchStrings: [
      'symbol_doremi',
    ]),
    GCWSymbolTableTool(symbolKey: 'dragon_language', symbolSearchStrings: [
      'symbol_dragon_language',
    ]),
    GCWSymbolTableTool(symbolKey: 'dragon_runes', symbolSearchStrings: [
      'symbol_dragon_runes',
    ]),
    GCWSymbolTableTool(symbolKey: 'eastern_arabic_indian_numerals', symbolSearchStrings: [
      'symbol_eastern_arabic_indian_numerals',
    ]),
    GCWSymbolTableTool(symbolKey: 'egyptian_numerals', symbolSearchStrings: [
      'symbol_egyptian_numerals',
    ]),
    GCWSymbolTableTool(symbolKey: 'elia', symbolSearchStrings: [
      'elia',
    ]),
    GCWSymbolTableTool(symbolKey: 'enochian', symbolSearchStrings: [
      'symbol_enochian',
    ]),
    GCWSymbolTableTool(symbolKey: 'eurythmy', symbolSearchStrings: [
      'symbol_eurythmy',
    ]),
    GCWSymbolTableTool(symbolKey: 'face_it', symbolSearchStrings: [
      'symbol_face_it',
    ]),
    GCWSymbolTableTool(symbolKey: 'fakoo', symbolSearchStrings: [
      'symbol_fakoo',
    ]),
    GCWSymbolTableTool(symbolKey: 'fez', symbolSearchStrings: [
      'symbol_fez',
    ]),
    GCWSymbolTableTool(symbolKey: 'finger', symbolSearchStrings: [
      'symbol_signlanguage',
      'symbol_finger',
    ]),
    GCWSymbolTableTool(symbolKey: 'finger_numbers', symbolSearchStrings: [
      'symbol_signlanguage',
      'symbol_finger_numbers',
    ]),
    GCWSymbolTableTool(symbolKey: 'flags', symbolSearchStrings: [
      'symbol_flags',
    ]),
    GCWSymbolTableTool(symbolKey: 'flags_german_kriegsmarine', symbolSearchStrings: [
      'symbol_flags',
      'symbol_flags_german_kriegsmarine',
    ]),
    GCWSymbolTableTool(symbolKey: 'flags_nato', symbolSearchStrings: [
      'symbol_flags',
      'symbol_flags_nato',
    ]),
    GCWSymbolTableTool(symbolKey: 'flags_rn_howe', symbolSearchStrings: [
      'symbol_flags',
      'symbol_flags_rn_howe',
    ]),
    GCWSymbolTableTool(symbolKey: 'flags_rn_marryat', symbolSearchStrings: [
      'symbol_flags',
      'symbol_flags_rn_marryat',
    ]),
    GCWSymbolTableTool(symbolKey: 'flags_rn_popham', symbolSearchStrings: [
      'symbol_flags',
      'symbol_flags_rn_popham',
    ]),
    GCWSymbolTableTool(symbolKey: 'fonic', symbolSearchStrings: [
      'symbol_fonic',
    ]),
    GCWSymbolTableTool(symbolKey: 'four_triangles', symbolSearchStrings: [
      'symbol_four_triangles',
    ]),
    GCWSymbolTableTool(symbolKey: 'freemason', symbolSearchStrings: [
      'symbol_freemason',
    ]),
    GCWSymbolTableTool(symbolKey: 'freemason_v2', symbolSearchStrings: ['symbol_freemason']),
    GCWSymbolTableTool(symbolKey: 'futurama', symbolSearchStrings: [
      'symbol_futurama',
    ]),
    GCWSymbolTableTool(symbolKey: 'futurama_2', symbolSearchStrings: [
      'symbol_futurama_2',
    ]),
    GCWSymbolTableTool(symbolKey: 'gallifreyan', symbolSearchStrings: [
      'symbol_gallifreyan',
    ]),
    GCWSymbolTableTool(symbolKey: 'gargish', symbolSearchStrings: [
      'symbol_gargish',
    ]),
    GCWSymbolTableTool(symbolKey: 'gc_attributes_ids', symbolSearchStrings: [
      'symbol_gc_attributes',
    ]),
    GCWSymbolTableTool(symbolKey: 'gc_attributes_meaning', symbolSearchStrings: [
      'symbol_gc_attributes',
    ]),
    GCWSymbolTableTool(symbolKey: 'gernreich', symbolSearchStrings: [
      'symbol_gernreich',
    ]),
    GCWSymbolTableTool(symbolKey: 'gerudo', symbolSearchStrings: [
      'zelda',
      'symbol_gerudo',
    ]),
    GCWSymbolTableTool(symbolKey: 'glagolitic', symbolSearchStrings: [
      'symbol_gnommish',
    ]),
    GCWSymbolTableTool(symbolKey: 'gnommish', symbolSearchStrings: []),
    GCWSymbolTableTool(symbolKey: 'greek_numerals', symbolSearchStrings: [
      'symbol_greek_numerals',
    ]),
    GCWSymbolTableTool(symbolKey: 'hanja', symbolSearchStrings: [
      'symbol_hanja',
      'symbol_sino_korean',
    ]),
    GCWSymbolTableTool(symbolKey: 'hangul_korean', symbolSearchStrings: [
      'symbol_hangul',
    ]),
    GCWSymbolTableTool(symbolKey: 'hangul_sino_korean', symbolSearchStrings: [
      'symbol_hangul',
      'symbol_sino_korean',
    ]),
    GCWSymbolTableTool(symbolKey: 'hazard', symbolSearchStrings: [
      'symbol_hazard',
    ]),
    GCWSymbolTableTool(symbolKey: 'hebrew', symbolSearchStrings: [
      'symbol_hebrew',
    ]),
    GCWSymbolTableTool(symbolKey: 'hebrew_v2', symbolSearchStrings: [
      'symbol_hebrew_v2',
    ]),
    GCWSymbolTableTool(symbolKey: 'hexahue', symbolSearchStrings: [
      'color',
      'symbol_hexahue',
    ]),
    GCWSymbolTableTool(symbolKey: 'hieratic_numerals', symbolSearchStrings: [
      'symbol_hieratic_numerals',
    ]),
    GCWSymbolTableTool(symbolKey: 'hieroglyphs', symbolSearchStrings: [
      'symbol_hieroglyphs',
    ]),
    GCWSymbolTableTool(symbolKey: 'hieroglyphs_v2', symbolSearchStrings: [
      'symbol_hieroglyphs',
    ]),
    GCWSymbolTableTool(symbolKey: 'hobbit_runes', symbolSearchStrings: [
      'symbol_lordoftherings',
      'symbol_runes',
      'symbol_hobbit_runes',
    ]),
    GCWSymbolTableTool(symbolKey: 'hvd', symbolSearchStrings: [
      'symbol_hvd',
    ]),
    GCWSymbolTableTool(symbolKey: 'hylian_64', symbolSearchStrings: [
      'zelda',
      'symbol_hylian_64',
    ]),
    GCWSymbolTableTool(symbolKey: 'hylian_albw_botw', symbolSearchStrings: [
      'zelda',
      'symbol_hylian_albw_botw',
    ]),
    GCWSymbolTableTool(symbolKey: 'hylian_skyward_sword', symbolSearchStrings: [
      'zelda',
      'symbol_hylian_skywardsword',
    ]),
    GCWSymbolTableTool(symbolKey: 'hylian_symbols', symbolSearchStrings: [
      'zelda',
      'symbol_hylian_symbols',
    ]),
    GCWSymbolTableTool(symbolKey: 'hylian_twilight_princess_gcn', symbolSearchStrings: [
      'zelda',
      'symbol_hylian_twilightprincess_gcn',
    ]),
    GCWSymbolTableTool(symbolKey: 'hylian_twilight_princess_wii', symbolSearchStrings: [
      'zelda',
      'symbol_hylian_twilightprincess_wii',
    ]),
    GCWSymbolTableTool(symbolKey: 'hylian_wind_waker', symbolSearchStrings: [
      'zelda',
      'symbol_hylian_windwaker',
    ]),
    GCWSymbolTableTool(symbolKey: 'hymmnos', symbolSearchStrings: [
      'symbol_hymmnos',
    ]),
    GCWSymbolTableTool(symbolKey: 'icecodes', symbolSearchStrings: [
      'icecodes',
    ]),
    GCWSymbolTableTool(symbolKey: 'iching', symbolSearchStrings: [
      'symbol_iching',
    ]),
    GCWSymbolTableTool(symbolKey: 'illuminati_v1', symbolSearchStrings: [
      'symbol_illuminati',
      'symbol_illuminati_v1',
    ]),
    GCWSymbolTableTool(symbolKey: 'illuminati_v2', symbolSearchStrings: [
      'symbol_illuminati',
      'symbol_illuminati_v2',
    ]),
    GCWSymbolTableTool(symbolKey: 'intergalactic', symbolSearchStrings: [
      'symbol_intergalactic',
    ]),
    GCWSymbolTableTool(symbolKey: 'iokharic', symbolSearchStrings: [
      'symbol_iokharic',
    ]),
    GCWSymbolTableTool(symbolKey: 'ita1_1926', symbolSearchStrings: ['ccitt', 'symbol_baudot', 'teletypewriter']),
    GCWSymbolTableTool(symbolKey: 'ita1_1929', symbolSearchStrings: ['ccitt', 'symbol_baudot', 'teletypewriter']),
    GCWSymbolTableTool(symbolKey: 'ita2_1929', symbolSearchStrings: ['ccitt', 'symbol_murray', 'teletypewriter']),
    GCWSymbolTableTool(symbolKey: 'ita2_1931', symbolSearchStrings: ['ccitt', 'symbol_murray', 'teletypewriter']),
    GCWSymbolTableTool(symbolKey: 'japanese_numerals', symbolSearchStrings: [
      'japanese_numerals',
    ]),
    GCWSymbolTableTool(symbolKey: 'kabouter_abc', symbolSearchStrings: [
      'symbol_kabouter_abc',
    ]),
    GCWSymbolTableTool(symbolKey: 'kabouter_abc_1947', symbolSearchStrings: [
      'symbol_kabouter_abc_1947',
    ]),
    GCWSymbolTableTool(symbolKey: 'kartrak', symbolSearchStrings: [
      'color',
      'barcodes',
      'symbol_kartrak',
    ]),
    GCWSymbolTableTool(symbolKey: 'kharoshthi', symbolSearchStrings: [
      'symbol_kharoshthi',
    ]),
    GCWSymbolTableTool(symbolKey: 'klingon', symbolSearchStrings: [
      'symbol_klingon',
    ]),
    GCWSymbolTableTool(symbolKey: 'klingon_klinzhai', symbolSearchStrings: [
      'symbol_klingon',
      'symbol_klingon_klinzhai',
    ]),
    GCWSymbolTableTool(symbolKey: 'krempel', symbolSearchStrings: [
      'color',
      'symbol_krempel',
    ]),
    GCWSymbolTableTool(symbolKey: 'krypton', symbolSearchStrings: [
      'symbol_krypton',
    ]),
    GCWSymbolTableTool(symbolKey: 'la_buse', symbolSearchStrings: [
      'symbol_freemason',
      'symbol_la_buse',
    ]),
    GCWSymbolTableTool(symbolKey: 'lorm', symbolSearchStrings: [
      'symbol_signlanguage',
      'symbol_lorm',
    ]),
    GCWSymbolTableTool(symbolKey: 'magicode', symbolSearchStrings: [
      'symbol_magicode',
    ]),
    GCWSymbolTableTool(symbolKey: 'mandalorian', symbolSearchStrings: [
      'symbol_mandalorian',
    ]),
    GCWSymbolTableTool(symbolKey: 'marain', symbolSearchStrings: [
      'symbol_marain',
    ]),
    GCWSymbolTableTool(symbolKey: 'marain_v2', symbolSearchStrings: [
      'symbol_marain_v2',
    ]),
    GCWSymbolTableTool(symbolKey: 'matoran', symbolSearchStrings: [
      'symbol_matoran',
    ]),
    GCWSymbolTableTool(symbolKey: 'maya_calendar_longcount', symbolSearchStrings: [
      'calendar',
      'symbol_maya_calendar_longcount',
    ]),
    GCWSymbolTableTool(symbolKey: 'maya_calendar_haab_codices', symbolSearchStrings: [
      'calendar',
      'symbol_maya_calendar_haab',
    ]),
    GCWSymbolTableTool(symbolKey: 'maya_calendar_haab_inscripts', symbolSearchStrings: [
      'calendar',
      'symbol_maya_calendar_haab',
    ]),
    GCWSymbolTableTool(symbolKey: 'maya_calendar_tzolkin_codices', symbolSearchStrings: [
      'calendar',
      'symbol_maya_calendar_tzolkin',
    ]),
    GCWSymbolTableTool(symbolKey: 'maya_calendar_tzolkin_inscripts', symbolSearchStrings: [
      'calendar',
      'symbol_maya_calendar_tzolkin',
    ]),
    GCWSymbolTableTool(symbolKey: 'maya_numerals', symbolSearchStrings: [
      'mayanumbers',
    ]),
    GCWSymbolTableTool(symbolKey: 'maze', symbolSearchStrings: [
      'symbol_maze',
    ]),
    GCWSymbolTableTool(symbolKey: 'minimoys', symbolSearchStrings: [
      'symbol_minimoys',
    ]),
    GCWSymbolTableTool(symbolKey: 'moon', symbolSearchStrings: [
      'symbol_moon',
    ]),
    GCWSymbolTableTool(symbolKey: 'moon_phases', symbolSearchStrings: [
      'symbol_moon_phases',
    ]),
    GCWSymbolTableTool(symbolKey: 'morse', symbolSearchStrings: [
      'morse',
    ]),
    GCWSymbolTableTool(symbolKey: 'murray', symbolSearchStrings: [
      'symbol_murray',
    ]),
    GCWSymbolTableTool(
        symbolKey: 'murraybaudot', symbolSearchStrings: ['ccitt', 'symbol_murraybaudot', 'teletypewriter']),
    GCWSymbolTableTool(symbolKey: 'musica', symbolSearchStrings: [
      'music_notes',
      'symbol_musica',
    ]),
    GCWSymbolTableTool(symbolKey: 'nazcaan', symbolSearchStrings: [
      'symbol_nazcaan',
    ]),
    GCWSymbolTableTool(symbolKey: 'new_zealand_sign_language', symbolSearchStrings: [
      'symbol_signlanguage',
      'symbol_new_zealand_sign_language',
    ]),
    GCWSymbolTableTool(symbolKey: 'niessen', symbolSearchStrings: [
      'symbol_signlanguage',
      'symbol_niessen',
    ]),
    GCWSymbolTableTool(symbolKey: 'ninjargon', symbolSearchStrings: [
      'symbol_ninjargon',
    ]),
    GCWSymbolTableTool(symbolKey: 'notes_doremi', symbolSearchStrings: [
      'music',
      'music_notes',
      'symbol_notes_doremi',
    ]),
    GCWSymbolTableTool(symbolKey: 'notes_names_altoclef', symbolSearchStrings: [
      'music',
      'music_notes',
      'symbol_notes_names_altoclef',
    ]),
    GCWSymbolTableTool(symbolKey: 'notes_names_bassclef', symbolSearchStrings: [
      'music',
      'music_notes',
      'symbol_notes_names_bassclef',
    ]),
    GCWSymbolTableTool(symbolKey: 'notes_names_trebleclef', symbolSearchStrings: [
      'music',
      'music_notes',
      'symbol_notes_names_trebleclef',
    ]),
    GCWSymbolTableTool(symbolKey: 'notes_notevalues', symbolSearchStrings: [
      'music',
      'music_notes',
      'symbol_notes_notevalues',
    ]),
    GCWSymbolTableTool(symbolKey: 'notes_restvalues', symbolSearchStrings: [
      'music',
      'music_notes',
      'symbol_notes_restvalues',
    ]),
    GCWSymbolTableTool(symbolKey: 'nyctography', symbolSearchStrings: [
      'symbol_nyctography',
    ]),
    GCWSymbolTableTool(symbolKey: 'ogham', symbolSearchStrings: [
      'symbol_ogham',
    ]),
    GCWSymbolTableTool(symbolKey: 'optical_fiber_fotag', symbolSearchStrings: [
      'color',
      'symbol_opticalfiber',
      'symbol_optical_fiber_fotag',
    ]),
    GCWSymbolTableTool(symbolKey: 'optical_fiber_iec60304', symbolSearchStrings: [
      'color',
      'symbol_opticalfiber',
      'symbol_optical_fiber_iec60304',
    ]),
    GCWSymbolTableTool(symbolKey: 'optical_fiber_swisscom', symbolSearchStrings: [
      'color',
      'symbol_opticalfiber',
      'optical_fiber_swisscom',
    ]),
    GCWSymbolTableTool(symbolKey: 'phoenician', symbolSearchStrings: [
      'symbol_phoenician',
    ]),
    GCWSymbolTableTool(symbolKey: 'pipeline', symbolSearchStrings: [
      'symbol_pipeline',
    ]),
    GCWSymbolTableTool(symbolKey: 'pipeline_din2403', symbolSearchStrings: [
      'color',
      'symbol_pipeline_din2403',
    ]),
    GCWSymbolTableTool(symbolKey: 'pixel', symbolSearchStrings: [
      'symbol_pixel',
    ]),
    GCWSymbolTableTool(symbolKey: 'planet', symbolSearchStrings: [
      'barcodes',
      'symbol_planet',
    ]),
    GCWSymbolTableTool(symbolKey: 'planets', symbolSearchStrings: [
      'symbol_planets',
    ]),
    GCWSymbolTableTool(symbolKey: 'pokemon_unown', symbolSearchStrings: [
      'pokemon',
      'symbol_pokemon_unown',
    ]),
    GCWSymbolTableTool(symbolKey: 'postcode_01247', symbolSearchStrings: [
      'barcodes',
      'symbol_postcode01247',
    ]),
    GCWSymbolTableTool(symbolKey: 'postcode_8421', symbolSearchStrings: [
      'barcodes',
      'symbol_postcode8421',
    ]),
    GCWSymbolTableTool(symbolKey: 'postnet', symbolSearchStrings: [
      'barcodes',
      'symbol_postnet',
    ]),
    GCWSymbolTableTool(symbolKey: 'predator', symbolSearchStrings: [
      'predator',
    ]),
    GCWSymbolTableTool(symbolKey: 'prosyl', symbolSearchStrings: [
      'symbol_prosyl',
    ]),
    GCWSymbolTableTool(symbolKey: 'puzzle', symbolSearchStrings: [
      'symbol_puzzle',
    ]),
    GCWSymbolTableTool(symbolKey: 'puzzle_2', symbolSearchStrings: [
      'symbol_puzzle',
    ]),
    GCWSymbolTableTool(symbolKey: 'prussian_colors_artillery', symbolSearchStrings: [
      'symbol_prussian_colors_artillery',
    ]),
    GCWSymbolTableTool(symbolKey: 'prussian_colors_infantery', symbolSearchStrings: [
      'symbol_prussian_colors_infantery',
    ]),
    GCWSymbolTableTool(symbolKey: 'quadoo', symbolSearchStrings: [
      'symbol_quadoo',
    ]),
    GCWSymbolTableTool(symbolKey: 'reality', symbolSearchStrings: [
      'symbol_reality',
    ]),
    GCWSymbolTableTool(symbolKey: 'red_herring', symbolSearchStrings: [
      'symbol_red_herring',
    ]),
    GCWSymbolTableTool(symbolKey: 'resistor', symbolSearchStrings: [
      'color',
      'resistor_colorcode',
    ]),
    GCWSymbolTableTool(symbolKey: 'rhesus_a', symbolSearchStrings: [
      'symbol_rhesus',
    ]),
    GCWSymbolTableTool(symbolKey: 'rhesus_b', symbolSearchStrings: [
      'symbol_rhesus',
    ]),
    GCWSymbolTableTool(symbolKey: 'rhesus_c1', symbolSearchStrings: [
      'symbol_rhesus',
    ]),
    GCWSymbolTableTool(symbolKey: 'rhesus_c2', symbolSearchStrings: [
      'symbol_rhesus',
    ]),
    GCWSymbolTableTool(symbolKey: 'rm4scc', symbolSearchStrings: [
      'barcodes',
      'symbol_rm4scc',
    ]),
    GCWSymbolTableTool(symbolKey: 'robots', symbolSearchStrings: [
      'symbol_robots',
    ]),
    GCWSymbolTableTool(symbolKey: 'romulan', symbolSearchStrings: [
      'symbol_romulan',
    ]),
    GCWSymbolTableTool(symbolKey: 'runes', symbolSearchStrings: [
      'symbol_futhark',
      'symbol_runes',
    ]),
    GCWSymbolTableTool(symbolKey: 'sanluca', symbolSearchStrings: [
      'symbol_sanluca',
    ]),
    GCWSymbolTableTool(symbolKey: 'sarati', symbolSearchStrings: [
      'symbol_sarati',
    ]),
    GCWSymbolTableTool(symbolKey: 'semaphore', symbolSearchStrings: [
      'symbol_semaphore',
    ]),
    GCWSymbolTableTool(symbolKey: 'shadoks', symbolSearchStrings: [
      'shadoksnumbers',
    ]),
    GCWSymbolTableTool(symbolKey: 'sheikah', symbolSearchStrings: [
      'zelda',
      'symbol_sheikah',
    ]),
    GCWSymbolTableTool(symbolKey: 'shoes', symbolSearchStrings: [
      'symbol_shoes',
    ]),
    GCWSymbolTableTool(symbolKey: 'siemens', symbolSearchStrings: ['symbol_siemens', 'teletypewriter']),
    GCWSymbolTableTool(symbolKey: 'sign', symbolSearchStrings: ['symbol_signlanguage']),
    GCWSymbolTableTool(symbolKey: 'skullz', symbolSearchStrings: [
      'symbol_skullz',
    ]),
    GCWSymbolTableTool(symbolKey: 'slash_and_pipe', symbolSearchStrings: [
      'symbol_slash_and_pipe',
    ]),
    GCWSymbolTableTool(symbolKey: 'solmisation', symbolSearchStrings: [
      'symbol_solmisation',
    ]),
    GCWSymbolTableTool(symbolKey: 'space_invaders', symbolSearchStrings: [
      'symbol_space_invaders',
    ]),
    GCWSymbolTableTool(symbolKey: 'spintype', symbolSearchStrings: [
      'symbol_spintype',
    ]),
    GCWSymbolTableTool(symbolKey: 'stippelcode', symbolSearchStrings: [
      'symbol_stippelcode',
    ]),
    GCWSymbolTableTool(symbolKey: 'suetterlin', symbolSearchStrings: [
      'symbol_suetterlin',
    ]),
    GCWSymbolTableTool(symbolKey: 'sunuz', symbolSearchStrings: [
      'symbol_sunuz',
    ]),
    GCWSymbolTableTool(symbolKey: 'surf', symbolSearchStrings: [
      'symbol_surf',
    ]),
    GCWSymbolTableTool(symbolKey: 'tae', symbolSearchStrings: [
      'symbol_tae',
    ]),
    GCWSymbolTableTool(symbolKey: 'tamil_numerals', symbolSearchStrings: [
      'symbol_tamil_numerals',
    ]),
    GCWSymbolTableTool(symbolKey: 'telegraph_pasley', symbolSearchStrings: [
      'telegraph',
      'symbol_pasley_telegraph',
    ]),
    GCWSymbolTableTool(symbolKey: 'telegraph_popham', symbolSearchStrings: [
      'telegraph',
      'symbol_popham_telegraph',
    ]),
    GCWSymbolTableTool(symbolKey: 'telegraph_prussia', symbolSearchStrings: [
      'telegraph',
      'telegraph_prussia',
    ]),
    GCWSymbolTableTool(symbolKey: 'templers', symbolSearchStrings: [
      'symbol_templers',
    ]),
    GCWSymbolTableTool(symbolKey: 'tenctonese_cursive', symbolSearchStrings: [
      'symbol_tenctonese',
    ]),
    GCWSymbolTableTool(symbolKey: 'tenctonese_printed', symbolSearchStrings: [
      'symbol_tenctonese',
    ]),
    GCWSymbolTableTool(symbolKey: 'tengwar_beleriand', symbolSearchStrings: [
      'symbol_lordoftherings',
      'symbol_tengwar_beleriand',
    ]),
    GCWSymbolTableTool(symbolKey: 'tengwar_classic', symbolSearchStrings: [
      'symbol_lordoftherings',
      'symbol_tengwar_classic',
    ]),
    GCWSymbolTableTool(symbolKey: 'tengwar_general', symbolSearchStrings: [
      'symbol_lordoftherings',
      'symbol_tengwar_general',
    ]),
    GCWSymbolTableTool(symbolKey: 'terzi', symbolSearchStrings: [
      'symbol_terzi',
    ]),
    GCWSymbolTableTool(symbolKey: 'thai_numerals', symbolSearchStrings: [
      'symbol_thai_numerals',
    ]),
    GCWSymbolTableTool(symbolKey: 'theban', symbolSearchStrings: [
      'symbol_theban',
    ]),
    GCWSymbolTableTool(symbolKey: 'three_squares', symbolSearchStrings: [
      'symbol_three_squares',
    ]),
    GCWSymbolTableTool(symbolKey: 'tines', symbolSearchStrings: [
      'symbol_tines',
    ]),
    GCWSymbolTableTool(symbolKey: 'tomtom', symbolSearchStrings: [
      'tomtom',
    ]),
    GCWSymbolTableTool(symbolKey: 'trafficsigns_germany', symbolSearchStrings: [
      'symbol_trafficsigns_germany',
    ]),
    GCWSymbolTableTool(symbolKey: 'ulog', symbolSearchStrings: [
      'symbol_ulog',
    ]),
    GCWSymbolTableTool(symbolKey: 'unitology', symbolSearchStrings: [
      'symbol_unitology',
    ]),
    GCWSymbolTableTool(symbolKey: 'utopian', symbolSearchStrings: [
      'symbol_utopian',
    ]),
    GCWSymbolTableTool(symbolKey: 'visitor_1984', symbolSearchStrings: [
      'symbol_visitor_1984',
    ]),
    GCWSymbolTableTool(symbolKey: 'visitor_2009', symbolSearchStrings: [
      'symbol_visitor_2009',
    ]),
    GCWSymbolTableTool(symbolKey: 'vulcanian', symbolSearchStrings: [
      'symbol_vulcanian',
    ]),
    GCWSymbolTableTool(symbolKey: 'wakandan', symbolSearchStrings: [
      'symbol_wakandan',
    ]),
    GCWSymbolTableTool(symbolKey: 'weather_a', symbolSearchStrings: ['weather', 'weather_a']),
    GCWSymbolTableTool(symbolKey: 'weather_c', symbolSearchStrings: ['weather', 'weather_c', 'weather_clouds']),
    GCWSymbolTableTool(symbolKey: 'weather_cl', symbolSearchStrings: ['weather', 'weather_cl', 'weather_clouds']),
    GCWSymbolTableTool(symbolKey: 'weather_cm', symbolSearchStrings: ['weather', 'weather_cm', 'weather_clouds']),
    GCWSymbolTableTool(symbolKey: 'weather_ch', symbolSearchStrings: ['weather', 'weather_ch', 'weather_clouds']),
    GCWSymbolTableTool(symbolKey: 'weather_n', symbolSearchStrings: ['weather', 'weather_n', 'weather_clouds']),
    GCWSymbolTableTool(symbolKey: 'weather_w', symbolSearchStrings: ['weather', 'weather_w']),
    GCWSymbolTableTool(symbolKey: 'weather_ww', symbolSearchStrings: ['weather', 'weather_ww']),
    GCWSymbolTableTool(symbolKey: 'webdings', symbolSearchStrings: [
      'symbol_webdings',
    ]),
    GCWSymbolTableTool(symbolKey: 'westernunion', symbolSearchStrings: ['symbol_westernunion', 'teletypewriter']),
    GCWSymbolTableTool(symbolKey: 'windforce_beaufort', symbolSearchStrings: [
      'beaufort',
      'symbol_windforce_beaufort',
    ]),
    GCWSymbolTableTool(symbolKey: 'windforce_knots', symbolSearchStrings: [
      'beaufort',
      'symbol_windforce_knots',
    ]),
    GCWSymbolTableTool(symbolKey: 'window', symbolSearchStrings: [
      'window',
    ]),
    GCWSymbolTableTool(symbolKey: 'wingdings', symbolSearchStrings: [
      'symbol_wingdings',
    ]),
    GCWSymbolTableTool(symbolKey: 'wingdings2', symbolSearchStrings: [
      'symbol_wingdings2',
    ]),
    GCWSymbolTableTool(symbolKey: 'wingdings3', symbolSearchStrings: [
      'symbol_wingdings3',
    ]),
    GCWSymbolTableTool(symbolKey: 'yan_koryani', symbolSearchStrings: [
      'symbol_yan_koryani',
    ]),
    GCWSymbolTableTool(symbolKey: 'yinyang', symbolSearchStrings: [
      'symbol_yinyang',
    ]),
    GCWSymbolTableTool(symbolKey: 'zamonian', symbolSearchStrings: [
      'symbol_zamonian',
    ]),
    GCWSymbolTableTool(symbolKey: 'zentradi', symbolSearchStrings: [
      'symbol_zentradi',
    ]),
    GCWSymbolTableTool(symbolKey: 'zodiac_signs', symbolSearchStrings: [
      'symbol_zodiacsigns',
    ]),
    GCWSymbolTableTool(symbolKey: 'zodiac_signs_latin', symbolSearchStrings: [
      'symbol_zodiacsigns',
      'symbol_zodiacsigns_latin',
    ]),
    GCWSymbolTableTool(symbolKey: 'zodiac_z340', symbolSearchStrings: [
      'symbol_zodiac_z340',
    ]),
    GCWSymbolTableTool(symbolKey: 'zodiac_z408', symbolSearchStrings: [
      'symbol_zodiac_z408',
    ]),

    // TelegraphSelection *********************************************************************************************
    GCWTool(tool: ChappeTelegraph(), i18nPrefix: 'telegraph_chappe', searchKeys: [
      'telegraph',
      'telegraph_chappe',
    ]),
    GCWTool(tool: EdelcrantzTelegraph(), i18nPrefix: 'telegraph_edelcrantz', searchKeys: [
      'telegraph',
      'telegraph_edelcrantz',
    ]),
    GCWTool(tool: MurrayTelegraph(), i18nPrefix: 'telegraph_murray', searchKeys: [
      'telegraph',
      'telegraph_murray',
    ]),
    GCWTool(tool: OhlsenTelegraph(), i18nPrefix: 'telegraph_ohlsen', searchKeys: [
      'telegraph',
      'telegraph_ohlsen',
    ]),
    GCWTool(tool: PasleyTelegraph(), i18nPrefix: 'telegraph_pasley', searchKeys: [
      'telegraph',
      'telegraph_pasley',
    ]),
    GCWTool(tool: PophamTelegraph(), i18nPrefix: 'telegraph_popham', searchKeys: [
      'telegraph',
      'telegraph_popham',
    ]),
    GCWTool(tool: PrussiaTelegraph(), i18nPrefix: 'telegraph_prussia', searchKeys: [
      'telegraph',
      'telegraph_prussia',
    ]),
    GCWTool(tool: SemaphoreTelegraph(), i18nPrefix: 'symboltables_semaphore', searchKeys: [
      'telegraph',
      'telegraph_semaphore',
    ]),
    GCWTool(tool: WigWagSemaphoreTelegraph(), i18nPrefix: 'telegraph_wigwag', searchKeys: [
      'telegraph',
      'telegraph_wigwag',
    ]),
    GCWTool(tool: GaussWeberTelegraph(), i18nPrefix: 'telegraph_gausswebertelegraph', searchKeys: [
      'telegraph',
      'telegraph_gaussweber',
    ]),
    GCWTool(tool: SchillingCanstattTelegraph(), i18nPrefix: 'telegraph_schillingcanstatt', searchKeys: [
      'telegraph',
      'telegraph_schillingcanstatt',
    ]),
    GCWTool(tool: WheatstoneCookeNeedleTelegraph(), i18nPrefix: 'telegraph_wheatstonecooke_needle', searchKeys: [
      'telegraph',
      'telegraph_wheatstonecooke_needle',
    ]),

    //Teletypewriter Selection **********************************************************************************************
    GCWTool(tool: AncientTeletypewriter(), i18nPrefix: 'ccitt_ancient', searchKeys: [
      'ccitt',
      'ccitt_ancient',
      'teletypewriter',
      'symbol_siemens',
      'symbol_westernunion',
      'symbol_murraybaudot',
      'symbol_baudot'
    ]),
    GCWTool(tool: CCITTTeletypewriter(), i18nPrefix: 'ccitt', searchKeys: [
      'ccitt',
      'ccitt_1',
      'ccitt_2',
      'ccitt_3',
      'ccitt_4',
      'ccitt_5',
      'ccitt_ccir_476',
      'teletypewriter',
      'symbol_baudot'
          'symbol_murraybaudot',
    ]),
    GCWTool(
        tool: OtherTeletypewriter(),
        i18nPrefix: 'ccitt_other',
        searchKeys: ['teletypewriter', 'z22', 'zc1', 'illiac', 'algol', 'tts']),

    // TomTomSelection *********************************************************************************************
    GCWTool(tool: TomTom(), i18nPrefix: 'tomtom', searchKeys: [
      'tomtom',
    ]),

    //VanitySelection **********************************************************************************************
    GCWTool(tool: VanitySingletap(), i18nPrefix: 'vanity_singletap', searchKeys: [
      'vanity',
      'vanitysingletap',
    ]),
    GCWTool(tool: VanityMultitap(), i18nPrefix: 'vanity_multitap', searchKeys: [
      'vanity',
      'vanitymultitap',
    ]),
    GCWTool(tool: VanityWordsList(), i18nPrefix: 'vanity_words_list', searchKeys: [
      'vanity',
      'vanitywordslist',
    ]),
    GCWTool(tool: VanityWordsTextSearch(), i18nPrefix: 'vanity_words_search', searchKeys: [
      'vanity',
      'vanitytextsearch',
    ]),

    //VigenereSelection *******************************************************************************************
    GCWTool(tool: VigenereBreaker(), i18nPrefix: 'vigenerebreaker', categories: [
      ToolCategory.GENERAL_CODEBREAKERS
    ], searchKeys: [
      'codebreaker',
      'vigenerebreaker',
      'vigenere',
      'rotation',
    ]),
    GCWTool(tool: Vigenere(), i18nPrefix: 'vigenere', searchKeys: [
      'vigenere',
      'rotation',
    ]),
    GCWTool(tool: Gronsfeld(), i18nPrefix: 'gronsfeld', searchKeys: [
      'vigenere',
      'rotation',
      'gronsfeld',
    ]),
    GCWTool(tool: Trithemius(), i18nPrefix: 'trithemius', searchKeys: [
      'vigenere',
      'rotation',
      'trithemius',
    ]),

    //WherigoUrwigoSelection **************************************************************************************
    GCWTool(tool: WherigoAnalyze(), i18nPrefix: 'wherigo', isBeta: true, categories: [
      ToolCategory.IMAGES_AND_FILES,
      ToolCategory.GENERAL_CODEBREAKERS
    ], searchKeys: [
      'wherigo',
      'wherigourwigo',
    ]),
    //UrwigoHashBreaker already inserted in section "Hashes"
    GCWTool(
        tool: UrwigoTextDeobfuscation(),
        i18nPrefix: 'urwigo_textdeobfuscation',
        searchKeys: ['wherigo', 'urwigo', 'urwigo_textdeobfuscation']),
    GCWTool(
        tool: EarwigoTextDeobfuscation(),
        i18nPrefix: 'earwigo_textdeobfuscation',
        searchKeys: ['wherigo', 'earwigo', 'urwigo_textdeobfuscation']),
  ].map((toolWidget) {
    toolWidget.toolName = i18n(context, toolWidget.i18nPrefix + '_title');
    toolWidget.defaultLanguageToolName = i18n(context, toolWidget.i18nPrefix + '_title', useDefaultLanguage: true);

    try {
      toolWidget.description = i18n(context, toolWidget.i18nPrefix + '_description');
    } catch (e) {}

    try {
      toolWidget.example = i18n(context, toolWidget.i18nPrefix + '_example');
    } catch (e) {}

    return toolWidget;
  }).toList();

  createIndexedSearchStrings();
}

refreshRegistry() {
  registeredTools = null;
}
