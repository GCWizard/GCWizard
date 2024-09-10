import 'package:flutter/material.dart';
import 'package:gc_wizard/application/category_views/selector_lists/apparent_temperature_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/astronomy_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/babylon_numbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/bacon_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/base_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/bcd_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/beaufort_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/braille_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/bundeswehr_talkingboard.dart';
import 'package:gc_wizard/application/category_views/selector_lists/ccitt_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_creditcard_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_de_taxid_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_ean_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_euro_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_iban_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_imei_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_isbn_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_uic_selection.dart';
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
import 'package:gc_wizard/application/category_views/selector_lists/miscellaneous_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/morse_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_bell_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_busybeaver_selection.dart';
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
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_primes_selection.dart';
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
import 'package:gc_wizard/application/category_views/selector_lists/slash_and_pipe_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/spelling_alphabets_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/sqrt2_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/sqrt3_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/sqrt5_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/symbol_table_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/telegraph_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/teletypewriter_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/tomtom_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/uic_wagoncode_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/vanity_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/vigenere_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/wherigo_urwigo_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/zodiac_selection.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/main_menu/about.dart';
import 'package:gc_wizard/application/main_menu/call_for_contribution.dart';
import 'package:gc_wizard/application/main_menu/changelog.dart';
import 'package:gc_wizard/application/main_menu/licenses.dart';
import 'package:gc_wizard/application/searchstrings/logic/search_strings.dart';
import 'package:gc_wizard/application/settings/widget/settings_coordinates.dart';
import 'package:gc_wizard/application/settings/widget/settings_general.dart';
import 'package:gc_wizard/application/settings/widget/settings_saverestore.dart';
import 'package:gc_wizard/application/settings/widget/settings_tools.dart';
import 'package:gc_wizard/application/tools/tool_licenses/widget/tool_license_types.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/tools/coords/antipodes/widget/antipodes.dart';
import 'package:gc_wizard/tools/coords/centerpoint/center_three_points/widget/center_three_points.dart';
import 'package:gc_wizard/tools/coords/centerpoint/center_two_points/widget/center_two_points.dart';
import 'package:gc_wizard/tools/coords/centroid/centroid_arithmetic_mean/widget/centroid_arithmetic_mean.dart';
import 'package:gc_wizard/tools/coords/centroid/centroid_center_of_gravity/widget/centroid_center_of_gravity.dart';
import 'package:gc_wizard/tools/coords/coordinate_averaging/widget/coordinate_averaging.dart';
import 'package:gc_wizard/tools/coords/cross_bearing/widget/cross_bearing.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/widget/distancebearing_geodetic.dart';
import 'package:gc_wizard/tools/coords/dmm_offset/widget/dmm_offset.dart';
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
import 'package:gc_wizard/tools/coords/segment_bearings/widget/segment_bearings.dart';
import 'package:gc_wizard/tools/coords/segment_line/widget/segment_line.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/widget/variable_coordinate_formulas.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/widget/waypoint_projection_geodetic.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/abaddon/widget/abaddon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/adfgvx/widget/adfgvx.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/affine/widget/affine.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/widget/alphabet_values.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/amsco/widget/amsco.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/atbash/widget/atbash.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/avemaria/widget/avemaria.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/babylon_numbers/widget/babylon_numbers.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bacon/widget/bacon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bacon/widget/bacon_analyze.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/base122/widget/base122.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/base16/widget/base16.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/base32/widget/base32.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/base58/widget/base58.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/base64/widget/base64.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/base85/widget/base85.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/base91/widget/base91.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/battleship/widget/battleship.dart';
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
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/judoon/widget/judoon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/kamasutra/widget/kamasutra.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/kenny/widget/kenny.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/chicken_language/widget/chicken_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/duck_speak/widget/duck_speak.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/pig_latin/widget/pig_latin.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/robber_language/widget/robber_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/spoon_language/widget/spoon_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/maya_numbers/widget/maya_numbers.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/mexican_army_cipher_wheel/widget/mexican_army_cipher_wheel.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/morbit/widget/morbit.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/morse/widget/morse.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/navajo/widget/navajo.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/numeral_words_converter/widget/numeral_words_converter.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/numeral_words_identify_languages/widget/numeral_words_identify_languages.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/numeral_words_lists/widget/numeral_words_lists.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/numeral_words_text_search/widget/numeral_words_text_search.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/one_time_pad/widget/one_time_pad.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/playfair/widget/playfair.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/pokemon/widget/pokemon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/pollux/widget/pollux.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/widget/polybios.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/porta/widget/porta.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/predator/widget/predator.dart';
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
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa/widget/rsa.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_d_calculator/widget/rsa_d_calculator.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_d_checker/widget/rsa_d_checker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_e_checker/widget/rsa_e_checker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_n_calculator/widget/rsa_n_calculator.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_phi_calculator/widget/rsa_phi_calculator.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_primes_calculator/widget/rsa_primes_calculator.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/shadoks_numbers/widget/shadoks_numbers.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/skytale/widget/skytale.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/slash_and_pipe/widget/slash_and_pipe.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/solitaire/widget/solitaire.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/straddling_checkerboard/widget/straddling_checkerboard.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/widget/substitution.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/tap_code/widget/tap_code.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/tapir/widget/tapir.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/text_analysis/widget/text_analysis.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/tomtom/widget/tomtom.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/trifid/widget/trifid.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/trithemius/widget/trithemius.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/universal_product_code/widget/universal_product_code.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/widget/vigenere.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/wasd/widget/wasd.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/zamonian_numbers/widget/zamonian_numbers.dart';
import 'package:gc_wizard/tools/formula_solver/widget/formula_solver_formulagroups.dart';
import 'package:gc_wizard/tools/games/alphametics/widget/alphametics.dart';
import 'package:gc_wizard/tools/games/bowling/widget/bowling.dart';
import 'package:gc_wizard/tools/games/catan/widget/catan.dart';
import 'package:gc_wizard/tools/games/game_of_life/widget/game_of_life.dart';
import 'package:gc_wizard/tools/games/logical_supporter/widget/logical_supporter.dart';
import 'package:gc_wizard/tools/games/nonogram/widget/nonogram_solver.dart';
import 'package:gc_wizard/tools/games/number_pyramid/widget/number_pyramid_solver.dart';
import 'package:gc_wizard/tools/games/scrabble/scrabble/widget/scrabble.dart';
import 'package:gc_wizard/tools/games/scrabble/scrabble_overview/widget/scrabble_overview.dart';
import 'package:gc_wizard/tools/games/sudoku/sudoku_solver/widget/sudoku_solver.dart';
import 'package:gc_wizard/tools/games/word_search/widget/word_search.dart';
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
import 'package:gc_wizard/tools/images_and_files/image_stretch_shrink/widget/image_stretch_shrink.dart';
import 'package:gc_wizard/tools/images_and_files/magic_eye_solver/widget/magic_eye_solver.dart';
import 'package:gc_wizard/tools/images_and_files/qr_code/widget/qr_code.dart';
import 'package:gc_wizard/tools/images_and_files/stegano/widget/stegano.dart';
import 'package:gc_wizard/tools/images_and_files/visual_cryptography/widget/visual_cryptography.dart';
import 'package:gc_wizard/tools/miscellaneous/gcwizardscript/widget/gcwizard_script.dart';
import 'package:gc_wizard/tools/science_and_technology/alcohol_mass/widget/alcohol_mass.dart';
import 'package:gc_wizard/tools/science_and_technology/alphabet_number_systems/hebrew/widget/hebrew_number_system.dart';
import 'package:gc_wizard/tools/science_and_technology/alphabet_number_systems/milesian/widget/milesian_number_system.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/heat_index/widget/heat_index.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/humidex/widget/humidex.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/summer_simmer/widget/summer_simmer.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/wet_bulb_temperature/widget/wet_bulb_temperature.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/windchill/widget/windchill.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/easter/easter_date/widget/easter_date.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/easter/easter_years/widget/easter_years.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/iau_constellation/widget/iau_all_constellations.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/iau_constellation/widget/iau_single_constellations.dart';
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
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/checkdigits_creditcard.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/checkdigits_de_taxid.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/checkdigits_ean.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/checkdigits_euro.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/checkdigits_iban.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/checkdigits_imei.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/checkdigits_isbn.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/checkdigits_uic.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/color_tool/widget/color_tool.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/pantone_color_codes/widget/pantone_color_codes.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/ral_color_codes/widget/ral_color_codes.dart';
import 'package:gc_wizard/tools/science_and_technology/combinatorics/combination/widget/combination.dart';
import 'package:gc_wizard/tools/science_and_technology/combinatorics/combination_permutation/widget/combination_permutation.dart';
import 'package:gc_wizard/tools/science_and_technology/combinatorics/permutation/widget/permutation.dart';
import 'package:gc_wizard/tools/science_and_technology/complex_numbers/widget/complex_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/compound_interest/widget/compound_interest.dart';
import 'package:gc_wizard/tools/science_and_technology/countries/countries_calling_codes/widget/countries_calling_codes.dart';
import 'package:gc_wizard/tools/science_and_technology/countries/countries_embassycodes_ger/widget/countries_embassycodes_ger.dart';
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
import 'package:gc_wizard/tools/science_and_technology/date_and_time/excel_time/widget/excel_time.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/time_calculator/widget/time_calculator.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/unix_time/widget/unix_time.dart';
import 'package:gc_wizard/tools/science_and_technology/date_and_time/weekday/widget/weekday.dart';
import 'package:gc_wizard/tools/science_and_technology/decabit/widget/decabit.dart';
import 'package:gc_wizard/tools/science_and_technology/divisor/widget/divisor.dart';
import 'package:gc_wizard/tools/science_and_technology/dna/dna_aminoacids/widget/dna_aminoacids.dart';
import 'package:gc_wizard/tools/science_and_technology/dna/dna_aminoacids_table/widget/dna_aminoacids_table.dart';
import 'package:gc_wizard/tools/science_and_technology/dna/dna_nucleicacidsequence/widget/dna_nucleicacidsequence.dart';
import 'package:gc_wizard/tools/science_and_technology/dtmf/widget/dtmf.dart';
import 'package:gc_wizard/tools/science_and_technology/gcd/widget/gcd.dart';
import 'package:gc_wizard/tools/science_and_technology/guitar_strings/widget/guitar_strings.dart';
import 'package:gc_wizard/tools/science_and_technology/hexadecimal/widget/hexadecimal.dart';
import 'package:gc_wizard/tools/science_and_technology/iata_icao_search/widget/iata_icao_search.dart';
import 'package:gc_wizard/tools/science_and_technology/icecodes/widget/icecodes.dart';
import 'package:gc_wizard/tools/science_and_technology/ieee754/widget/ieee754.dart';
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
import 'package:gc_wizard/tools/science_and_technology/lcm/widget/lcm.dart';
import 'package:gc_wizard/tools/science_and_technology/mathematical_constants/widget/mathematical_constants.dart';
import 'package:gc_wizard/tools/science_and_technology/maya_calendar/widget/maya_calendar.dart';
import 'package:gc_wizard/tools/science_and_technology/music_notes/music_notes/widget/music_notes.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/bell/widget/bell.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/busybeaver/widget/busybeaver.dart';
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
import 'package:gc_wizard/tools/science_and_technology/number_sequences/primes/widget/primes.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/recaman/widget/recaman.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/sublime_numbers/widget/sublime_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/superperfect_numbers/widget/superperfect_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/weird_numbers/widget/weird_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/widget/numeral_bases.dart';
import 'package:gc_wizard/tools/science_and_technology/paperformat/widget/paperformat.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/atomic_numbers_to_text/widget/atomic_numbers_to_text.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/periodic_table/widget/periodic_table.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/periodic_table_data_view/widget/periodic_table_data_view.dart';
import 'package:gc_wizard/tools/science_and_technology/physical_constants/widget/physical_constants.dart';
import 'package:gc_wizard/tools/science_and_technology/piano/widget/piano.dart';
import 'package:gc_wizard/tools/science_and_technology/postcode/widget/postcode.dart';
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
import 'package:gc_wizard/tools/science_and_technology/sort/widget/sort.dart';
import 'package:gc_wizard/tools/science_and_technology/spelling_alphabets/spelling_alphabets_crypt/widget/spelling_alphabets_crypt.dart';
import 'package:gc_wizard/tools/science_and_technology/spelling_alphabets/spelling_alphabets_list/widget/spelling_alphabets_list.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/chappe/widget/chappe.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/edelcrantz/widget/edelcrantz.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/foy_breguet/widget/foy_breguet.dart';
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
import 'package:gc_wizard/tools/science_and_technology/ufi/widget/ufi.dart';
import 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/widget/uic_wagoncode.dart';
import 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/widget/uic_wagoncode_countrycodes.dart';
import 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/widget/uic_wagoncode_freight_classifications.dart';
import 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/widget/uic_wagoncode_passenger_lettercodes.dart';
import 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/widget/uic_wagoncode_vkm.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/widget/unit_converter.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/vanity_multitap/widget/vanity_multitap.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/vanity_singletap/widget/vanity_singletap.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/vanity_words_list/widget/vanity_words_list.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/vanity_words_search/widget/vanity_words_search.dart';
import 'package:gc_wizard/tools/science_and_technology/velocity_acceleration/widget/velocity_acceleration.dart';
import 'package:gc_wizard/tools/science_and_technology/weather_symbols/widget/weather_symbols.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_table_tool.dart';
import 'package:gc_wizard/tools/symbol_tables/symbol_replacer/widget/symbol_replacer.dart';
import 'package:gc_wizard/tools/symbol_tables/symbol_tables_examples_select/widget/symbol_tables_examples_select.dart';
import 'package:gc_wizard/tools/uncategorized/wedding_anniversaries/widget/wedding_anniversaries.dart';
import 'package:gc_wizard/tools/uncategorized/zodiac/widget/zodiac.dart';
import 'package:gc_wizard/tools/wherigo/earwigo_text_deobfuscation/widget/earwigo_text_deobfuscation.dart';
import 'package:gc_wizard/tools/wherigo/urwigo_hashbreaker/widget/urwigo_hashbreaker.dart';
import 'package:gc_wizard/tools/wherigo/urwigo_text_deobfuscation/widget/urwigo_text_deobfuscation.dart';
import 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_analyze.dart';

part 'package:gc_wizard/application/tools/tool_licenses/widget/specific_tool_licenses.dart';

List<GCWTool> registeredTools = [];

void initializeRegistry(BuildContext context) {
  var stl = _SpecificToolLicenses(context);

  registeredTools = [
    //MainSelection
    GCWTool(tool: const Abaddon(), id: 'abaddon', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'abaddon',
    ]),
    GCWTool(tool: const ADFGVX(), id: 'adfgvx', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'adfgvx',
    ]),
    GCWTool(tool: const Affine(), id: 'affine', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'affine',
    ]),
    GCWTool(tool: const AlcoholMass(), id: 'alcoholmass', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'alcoholmass',
    ], licenses: const []),
    GCWTool(tool: const ALGOL(), id: 'algol', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'algol',
    ]),
    GCWTool(tool: AlphabetValues(), id: 'alphabetvalues', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'alphabetvalues',
    ], deeplinkAlias: const [
      'alphabet_values',
      'av',
      'buchstabenwerte',
      'bww'
    ], licenses: const []),
    ]),
    GCWTool(tool: const Alphametics(), id: 'symbol_arithmetic', categories: const [
      ToolCategory.GAMES
    ], searchKeys: [
      'symbol_arithmetic',
    ]),
    GCWTool(tool: const Amsco(), id: 'amsco', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'amsco',
    ]),
    GCWTool(tool: const AnimatedImage(), id: 'animated_image', isBeta: true, categories: const [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: const [
      'animated_images',
    ], licenses: const []),
    GCWTool(tool: const AnimatedImageMorseCode(), id: 'animated_image_morse_code', isBeta: true, categories: const [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: const [
      'animated_images_morse_code',
      'animated_images',
    ], licenses: const []),
    GCWTool(
        tool: const ApparentTemperatureSelection(),
        id: 'apparenttemperature_selection',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const []),
    GCWTool(tool: const ASCIIValues(), id: 'asciivalues', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'asciivalues',
      'binary',
    ]),
    GCWTool(tool: const AstronomySelection(), id: 'astronomy_selection', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'astronomy',
    ]),
    GCWTool(
      tool: Atbash(),
      id: 'atbash',
      categories: const [ToolCategory.CRYPTOGRAPHY],
      searchKeys: const [
        'atbash',
      ],
      deeplinkAlias: const ['atbasch'],
    ),
    GCWTool(tool: const AveMaria(), id: 'avemaria', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'avemaria',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Johannes Trithemius',
          licenseType: ToolLicenseType.CCBYSA4,
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Johannes_Trithemius&oldid=1228861699'),
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Polygraphia (book)',
          licenseType: ToolLicenseType.CCBYSA4,
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Polygraphia_(book)&oldid=1217884545'),
      ToolLicenseOnlineBook(
          context: context,
          author: 'Johannes Trithemius',
          title:
          'Polygraphiae libri sex, Ioannis Trithemii abbatis Peapolitani, quondam Spanheimensis, ad Maximilianum Caesarem',
          sourceUrl: 'https://www.loc.gov/resource/rbc0001.2009fabyan12345/?r=-0.956,-0.016,2.912,1.143,0')
    ]),
    GCWTool(
        tool: const BabylonNumbersSelection(),
        id: 'babylonnumbers_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(
        tool: const BaconSelection(),
        id: 'bacon_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(
        tool: const BaseSelection(),
        id: 'base_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(tool: const BCDSelection(), id: 'bcd_selection', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'binary',
    ]),
    GCWTool(tool: const Battleship(), id: 'battleship', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'battleship',
    ], licenses: const []),
    GCWTool(tool: const BloodAlcoholContent(), id: 'bloodalcoholcontent', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'alcoholmass',
      'bloodalcoholcontent',
    ], licenses: const []),
    GCWTool(
        tool: const BrailleSelection(),
        id: 'braille_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(
        tool: const BeaufortSelection(),
        id: 'beaufort_selection',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const []),
    GCWTool(tool: const Beghilos(), id: 'beghilos', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'beghilos',
      'segments',
      'segements_seven',
    ]),
    GCWTool(tool: const Bifid(), id: 'bifid', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'bifid',
    ]),
    GCWTool(tool: const Binary(), id: 'binary', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'binary',
    ]),
    GCWTool(tool: const Binary2Image(), id: 'binary2image', categories: const [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: const [
      'binary',
      'barcodes',
      'images',
    ]),
    GCWTool(tool: const BookCipher(), id: 'book_cipher', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'bookcipher',
    ], licenses: const []),
    GCWTool(tool: const Bowling(), id: 'bowling', categories: const [
      ToolCategory.GAMES
    ], searchKeys: const [
      'bowling',
    ], licenses: const []),
    GCWTool(
        tool: const BundeswehrTalkingBoardSelection(),
        id: 'bundeswehr_talkingboard_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(tool: const BurrowsWheeler(), id: 'burrowswheeler', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'burroeswheeler',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Burrows–Wheeler transform',
          licenseType: ToolLicenseType.CCBYSA4,
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Burrows%E2%80%93Wheeler_transform&oldid=1220898169')
    ]),
    GCWTool(tool: Caesar(), id: 'caesar', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'rotation',
      'caesar',
    ]),
    GCWTool(tool: const Catan(), id: 'catan', categories: const [
      ToolCategory.GAMES
    ], searchKeys: const [
      'catan',
    ]),
    GCWTool(
        tool: const CCITTSelection(),
        id: 'ccitt_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(tool: const Chao(), id: 'chao', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'chao',
    ]),
    GCWTool(tool: const CipherWheel(), id: 'cipherwheel', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'cipherwheel',
    ]),
    GCWTool(
        tool: const CheckDigitsSelection(),
        id: 'checkdigits_selection',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const []),
    GCWTool(
        tool: const CistercianNumbersSelection(),
        id: 'cistercian_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(
        tool: const ColorsSelection(),
        id: 'colors_selection',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const []),
    GCWTool(
        tool: const CombinatoricsSelection(),
        id: 'combinatorics_selection',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const []),
    GCWTool(tool: const ComplexNumbers(), id: 'complex_numbers', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'complexnumbers',
    ], licenses: const []),
    GCWTool(tool: const CompoundInterest(), id: 'compoundinterest', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'compoundinterest',
    ], licenses: const []),
    GCWTool(tool: const CoordsSelection(), id: 'coords_selection', searchKeys: const [
      'coordinates',
    ]),
    GCWTool(
        tool: const CountriesSelection(),
        id: 'countries_selection',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const []),
    GCWTool(
        tool: const CrossSumSelection(),
        id: 'crosssum_selection',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const []),
    GCWTool(tool: const CryptographySelection(), id: 'cryptography_selection', searchKeys: const [
      'cryptographyselection',
    ]),
    GCWTool(tool: const DatesSelection(), id: 'dates_selection', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'dates',
    ]),
    GCWTool(tool: const Decabit(), id: 'decabit', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'decabit',
    ]),
    GCWTool(tool: const Divisor(), id: 'divisor', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'divisor',
    ]),
    GCWTool(
        tool: const DNASelection(),
        id: 'dna_selection',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const []),
    GCWTool(tool: const DTMF(), id: 'dtmf', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'dtmf',
    ]),
    GCWTool(tool: const EnclosedAreas(), id: 'enclosedareas', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'enclosedareas',
    ]),
    GCWTool(tool: const ESelection(), id: 'e_selection', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'e',
      'irrationalnumbers',
    ]),
    GCWTool(tool: const Enigma(), id: 'enigma', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'enigma',
    ], licenses: [
      ToolLicenseOnlineArticle(
        context: context,
        author: 'en.wikipedia.org and contributors',
        title: 'Enigma machine',
        licenseType: ToolLicenseType.CCBYSA4,
        licenseUrl:
        'https://en.wikipedia.org/w/index.php?title=Wikipedia:Text_of_the_Creative_Commons_Attribution-ShareAlike_4.0_International_License&oldid=1162946924',
        sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Enigma_machine&oldid=1226502398',
      ),
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Enigma (Maschine)',
          licenseType: ToolLicenseType.CCBYSA4,
          licenseUrl:
          'https://web.archive.org/web/20240718115628/https://creativecommons.org/licenses/by-sa/4.0/deed.de',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Enigma_(Maschine)&oldid=245365474'),
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Dominik Oepen, Sebastian Höfer\n(Humboldt Universität zu Berlin)',
          title: 'Die Enigma',
          year: 2007,
          month: 4,
          day: 20,
          sourceUrl:
          'https://web.archive.org/web/20240613212151/https://www2.informatik.hu-berlin.de/~oependox/files/Ausarbeitung-Enigma.pdf'),
    ]),
    GCWTool(
        tool: const EsotericProgrammingLanguageSelection(),
        id: 'esotericprogramminglanguages_selection',
        categories: const [
          ToolCategory.CRYPTOGRAPHY
        ],
        searchKeys: const [
          'esotericprogramminglanguage',
        ]),
    GCWTool(
      tool: const ExifReader(),
      id: 'exif',
      categories: const [ToolCategory.IMAGES_AND_FILES],
      searchKeys: const [
        'exif',
      ],
      licenses: const [],
    ),
    GCWTool(tool: const FormulaSolverFormulaGroups(), id: 'formulasolver', searchKeys: const [
      'formulasolver',
    ], licenses: const []),
    GCWTool(
      tool: const Fox(),
      id: 'fox',
      categories: const [ToolCategory.CRYPTOGRAPHY],
      searchKeys: const [
        'fox',
      ],
      licenses: [
        ToolLicenseOfflineBook(
            context: context,
            author: 'Markus Gründel',
            title: 'Geocaching I: Alles rund um die moderne Schatzsuche (Basiswissen für draußen, Band 203',
            publisher: 'Stein, Conrad',
            isbn: '978-3866867444',
            year: 2021,
            customComment: '8. Edition'),
        ToolLicenseOfflineBook(
          context: context,
          author: 'Ray Nolan',
          title: 'Das Nostradamus Testament',
          publisher: 'Langen Müller',
          isbn: '3-7844-2532-1',
          year: 1996,
          customComment: 'Page 200',
        ),
      ],
    ),
    GCWTool(tool: const Gade(), id: 'gade', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'gade',
    ]),
    GCWTool(
      tool: const GamesSelection(),
      id: 'games_selection',
      searchKeys: const [
        'games',
      ],
    ),
    GCWTool(tool: const GameOfLife(), id: 'gameoflife', categories: const [
      ToolCategory.GAMES
    ], searchKeys: const [
      'gameoflife',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Conways_Spiel_des_Lebens',
          licenseType: ToolLicenseType.CCBYSA4,
          licenseUrl:
          'https://web.archive.org/web/20240718115628/https://creativecommons.org/licenses/by-sa/4.0/deed.de',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Conways_Spiel_des_Lebens&oldid=246560171'),
    ]),
    GCWTool(tool: const GCCode(), id: 'gccode', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'gccode',
    ]),
    GCWTool(tool: const GCD(), id: 'gcd', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'gcd',
    ]),
    GCWTool(tool: const GeneralCodebreakersSelection(), id: 'generalcodebreakers_selection', searchKeys: const [
      'codebreaker',
    ]),
    GCWTool(tool: const Geohashing(), id: 'geohashing', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'geohashing',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Randall Munroe (xkcd.com)',
          title: 'XKCD 426: Geohashing',
          licenseType: ToolLicenseType.CCNC25,
          licenseUrl: 'https://web.archive.org/web/20240715221350/https://creativecommons.org/licenses/by-nc/2.5/',
          sourceUrl: 'https://web.archive.org/web/20240715180948/https://xkcd.com/426/'),
      ToolLicenseAPI(
        context: context,
        author: '@Crox (geohashing.site)',
        title: 'Dow Jones API',
        licenseType: ToolLicenseType.FREE_TO_USE,
        licenseUrl:
        'https://web.archive.org/web/20240725231749/https://geohashing.site/index.php?title=Dow_Jones_Industrial_Average&type=revision&diff=21062&oldid=21061',
        sourceUrl: 'http://geo.crox.net/djia',
      ),
    ]),
    GCWTool(tool: const Gray(), id: 'gray', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'binary',
      'gray',
    ]),
    GCWTool(tool: const Grid(), id: 'grid', categories: const [
      ToolCategory.GAMES
    ], searchKeys: const [
      'grid',
    ]),
    GCWTool(tool: const GuitarStrings(), id: 'guitarstrings', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'music',
      'guitar',
    ], licenses: const []),
    GCWTool(
        tool: const HashSelection(),
        id: 'hashes_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(tool: const HebrewNumberSystem(), id: 'hebrew_numbers', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'hebrew_numbers',
    ]),
    GCWTool(tool: const Hexadecimal(), id: 'hexadecimal', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'hexadecimal',
    ]),
    GCWTool(tool: const HexString2File(), id: 'hexstring2file', categories: const [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: const [
      'hexadecimal',
      'hexstring2file',
    ], licenses: const []),
    GCWTool(tool: const HexViewer(), id: 'hexviewer', categories: const [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: const [
      'hexadecimal',
      'hexviewer',
    ]),
    GCWTool(tool: const HiddenData(), id: 'hiddendata', isBeta: true, categories: const [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: const [
      'hiddendata',
    ], licenses: const []),
    GCWTool(tool: const Homophone(), id: 'homophone', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'homophone',
    ]),
    GCWTool(tool: const Houdini(), id: 'houdini', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'houdini',
    ]),
    GCWTool(
      tool: const IATAICAOSearch(),
      id: 'iataicao',
      categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
      searchKeys: const [
        'iataicao',
      ],
    ),
    GCWTool(
      tool: const IceCodesSelection(),
      id: 'icecodes_selection',
      categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
      searchKeys: const [],
    ),
    GCWTool(tool: const IEEE754(), id: 'ieee754', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'binary',
      'ieee754',
    ]),
    GCWTool(tool: const ILLIAC(), id: 'illiac', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'illiac',
    ]),
    GCWTool(tool: const ImagesAndFilesSelection(), id: 'imagesandfiles_selection', isBeta: true, searchKeys: const [
      'images',
      'imagesandfilesselection',
    ]),
    GCWTool(
        tool: const ImageColorCorrections(),
        autoScroll: false,
        categories: const [ToolCategory.IMAGES_AND_FILES],
        id: 'image_colorcorrections',
        searchKeys: const [
          'images',
          'color',
          'image_colorcorrections',
        ],
        licenses: const []),
    GCWTool(
        tool: const ImageFlipRotate(),
        categories: const [ToolCategory.IMAGES_AND_FILES],
        id: 'image_fliprotate',
        searchKeys: const [
          'images',
          'image_fliprotate',
        ],
        licenses: const []),
    GCWTool(
        tool: const ImageStretchShrink(),
        categories: const [ToolCategory.IMAGES_AND_FILES],
        id: 'image_stretchshrink',
        searchKeys: const [
          'images',
          'image_stretchshrink',
        ],
        licenses: const []),
    GCWTool(
        tool: const IPCodes(),
        id: 'ipcodes',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const ['ipcodes']),

    GCWTool(tool: const Kamasutra(), id: 'kamasutra', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'rotation',
      'kamasutra',
    ]),
    GCWTool(tool: const Kenny(), id: 'kenny', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'kenny',
    ]),
    GCWTool(tool: const KeyboardLayout(), id: 'keyboard_layout', searchKeys: const [
      'keyboard',
    ]),
    GCWTool(tool: const KeyboardNumbers(), id: 'keyboard_numbers', searchKeys: const ['keyboard', 'keyboard_numbers']),
    GCWTool(
        tool: const KeyboardSelection(),
        id: 'keyboard_selection',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const []),
    GCWTool(tool: const LCM(), id: 'lcm', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'lcm',
    ]),
    GCWTool(
        tool: const LanguageGamesSelection(),
        id: 'languagegames_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(tool: const LogicalSupporter(), id: 'logicalsupporter', categories: const [
      ToolCategory.GAMES
    ], searchKeys: const [
      'games',
      'games_logicalsupporter',
    ]),
    GCWTool(tool: const MagicEyeSolver(), id: 'magic_eye', isBeta: true, categories: const [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: const [
      'magic_eye',
      'images'
    ], licenses: [
      ToolLicensePortedCode(
          context: context,
          author: 'Jérémie "piellardj" Piellard',
          title: 'stereogram-solver',
          sourceUrl:
          'https://web.archive.org/web/20240722204912/https://github.com/piellardj/stereogram-solver?tab=readme-ov-file',
          licenseType: ToolLicenseType.MIT),
    ]),
    GCWTool(tool: const MathematicalConstants(), id: 'mathematical_constants', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'mathematical_constants',
    ]),
    GCWTool(
        tool: const MayaCalendarSelection(),
        categories: const [ToolCategory.CRYPTOGRAPHY],
        id: 'mayacalendar_selection',
        searchKeys: const []),
    GCWTool(
        tool: const MayaNumbersSelection(),
        id: 'mayanumbers_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(tool: const MexicanArmyCipherWheel(), id: 'mexicanarmycipherwheel', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'cipherwheel',
      'mexicanarmycipherwheel',
    ]),
    GCWTool(tool: const MilesianNumberSystem(), id: 'milesian_numbers', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'milesian_numbers',
    ]),
    GCWTool(
        tool: const Morbit(),
        id: 'morbit',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const ['morbit', 'numbers']),
    GCWTool(
        tool: const MorseSelection(),
        id: 'morse_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(tool: MultiDecoder(), id: 'multidecoder', categories: const [
      ToolCategory.GENERAL_CODEBREAKERS
    ], searchKeys: const [
      'multidecoder',
    ], deeplinkAlias: const [
      'multitool'
    ], licenses: const []),
    GCWTool(
        tool: const MusicNotes(),
        id: 'music_notes',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const ['music', 'music_notes'],
        licenses: const []),
    GCWTool(tool: const Navajo(), id: 'navajo', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'navajo',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Department of Defense',
          title: 'Navajo Code Talkers\' Dictionary REVISED 15 JUNE 1945',
          sourceUrl:
          'https://web.archive.org/web/20240722205845/https://www.history.navy.mil/research/library/online-reading-room/title-list-alphabetically/n/navajo-code-talker-dictionary.html')
    ]),
    GCWTool(tool: const NonogramSolver(), id: 'nonogramsolver', categories: const [
      ToolCategory.GAMES
    ], searchKeys: const [
      'games',
      'nonogramsolver',
      'grid',
      'images'
    ], licenses: [
      ToolLicensePortedCode(
          context: context,
          author: 'Thomas Rosenau',
          title: 'Nonogram Solver',
          sourceUrl: 'https://web.archivechive.org/web/20240819161712/https://github.com/ThomasR/nonogram-solver',
          licenseType: ToolLicenseType.APACHE2,
          licenseUrl: 'https://web.archivechive.org/web/20240819161901/https://github.com/ThomasR/nonogram-solver?tab=Apache-2.0-1-ov-file'),
    ]),
    GCWTool(tool: const NumberPyramidSolver(), id: 'numberpyramidsolver', categories: const [
      ToolCategory.GAMES,
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'games',
      'games_numberpyramidsolver',
    ], licenses: [
      ToolLicensePortedCode(
          context: context,
          author: 'Dennis \'dennistreysa\' P.',
          title: 'Py-Ramid',
          sourceUrl: 'https://web.archivechive.org/web/20240819161342/https://github.com/dennistreysa/Py-Ramid',
          licenseType: ToolLicenseType.GPL3,
          licenseUrl: 'https://web.archivechive.org/web/20240819161613/https://github.com/dennistreysa/Py-Ramid?tab=GPL-3.0-1-ov-file'),
    ]),
    GCWTool(
        tool: const NumberSequenceSelection(),
        id: 'numbersequence',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const []),
    GCWTool(tool: const NumeralBases(), id: 'numeralbases', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'binary',
      'numeralbases',
    ]),
    GCWTool(
        tool: const NumeralWordsSelection(),
        id: 'numeralwords_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(
        tool: OneTimePad(),
        id: 'onetimepad',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const ['onetimepad', 'numbers'],
        deeplinkAlias: const ['otp', 'one_time_pad']),
    GCWTool(tool: const PaperFormats(), id: 'paperformat', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'paperformat',
    ]),
    GCWTool(tool: const PeriodicTableSelection(), id: 'periodictable_selection', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'periodictable',
    ]),
    GCWTool(tool: const PhiSelection(), id: 'phi_selection', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'phi',
      'irrationalnumbers',
    ]),
    GCWTool(tool: const Piano(), id: 'piano', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'music',
      'music_notes',
      'piano',
    ]),
    GCWTool(tool: const Postcode(), id: 'postcode', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'postcode',
      'symbol_postcode01247',
      'symbol_postcode8421',
      'binary'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Zielcode',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Zielcode&oldid=246247471')
    ]),
    GCWTool(tool: const PiSelection(), id: 'pi_selection', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'pi',
      'irrationalnumbers',
    ]),
    GCWTool(tool: const PhysicalConstants(), id: 'physical_constants', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'physical_constants',
    ]),
    GCWTool(tool: Playfair(), id: 'playfair', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'playfair',
    ]),
    GCWTool(tool: const Pokemon(), id: 'pokemon_code', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'pokemon',
    ]),
    GCWTool(
        tool: const Pollux(),
        id: 'pollux',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const ['pollux', 'numbers']),
    GCWTool(tool: const Polybios(), id: 'polybios', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'polybios',
    ]),
    GCWTool(tool: const Porta(), id: 'porta', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'porta',
    ], licenses: [
      ToolLicenseOnlineArticle(
        context: context,
        author: 'Didier Müller',
        title: 'Le chiffre da Porta',
        sourceUrl: 'https://web.archive.org/web/20240726132205/https://www.apprendre-en-ligne.net/crypto/porta/index.html',
        year: 2021,
        month: 01,
        day: 24,
      )
    ]),
    GCWTool(
        tool: const PredatorSelection(),
        id: 'predator_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(tool: const PrimeAlphabet(), id: 'primealphabet', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'primes',
      'primealphabet',
    ]),
    GCWTool(
        tool: const PrimesSelection(),
        id: 'primes_selection',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const []),
    GCWTool(tool: const Projectiles(), id: 'projectiles', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'projectiles',
    ], licenses: const []),
    GCWTool(tool: const QrCode(), id: 'qr_code', isBeta: true, categories: const [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: const [
      'qrcode',
    ], licenses: const []),
    GCWTool(tool: const QuadraticEquation(), id: 'quadratic_equation', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'quadraticequation',
    ], licenses: const []),
    GCWTool(tool: const Rabbit(), id: 'rabbit', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'rabbit',
    ]),
    GCWTool(tool: const Ragbaby(), id: 'ragbaby', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'ragbaby',
    ], licenses: [
      ToolLicenseOnlineArticle(context: context,
          author: 'Lionel',
          title: 'Ragbaby Cipher Young Tyros',
          year: 2023, month: 02, day: 24,
          sourceUrl: 'https://web.archive.org/web/20240415085406/https://youngtyros.com/2023/02/19/ragbaby-cipher/'
      )
    ]),
    GCWTool(tool: const RailFence(), id: 'railfence', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'railfence',
    ]),
    GCWTool(tool: const RC4(), id: 'rc4', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'rc4',
    ]),
    GCWTool(tool: const Recycling(), id: 'recycling', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'recycling',
    ]),
    GCWTool(
        tool: const ResistorSelection(),
        id: 'resistor_selection',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const []),
    GCWTool(tool: const Reverse(), id: 'reverse', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'reverse',
    ]),
    GCWTool(
        tool: const RomanNumbersSelection(),
        id: 'romannumbers_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(
        tool: const RotationSelection(),
        id: 'rotation_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(tool: const RSASelection(), id: 'rsa_selection', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'primes',
    ]),
    GCWTool(tool: const ScienceAndTechnologySelection(), id: 'scienceandtechnology_selection', searchKeys: const [
      'scienceandtechnologyselection',
    ]),
    GCWTool(
        tool: const ScrabbleSelection(),
        id: 'scrabble_selection',
        categories: const [ToolCategory.GAMES],
        searchKeys: const ['games']),
    GCWTool(tool: const MiscellaneousSelection(), id: 'miscellaneous_selection', searchKeys: const []),
    GCWTool(
        tool: const SegmentDisplaySelection(),
        id: 'segmentdisplay_selection',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const []),
    GCWTool(
        tool: const ShadoksSelection(),
        id: 'shadoks_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(tool: const SilverRatioSelection(), id: 'silverratio_selection', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'silverratio',
      'irrationalnumbers',
    ]),
    GCWTool(tool: const Skytale(), id: 'skytale', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'skytale',
    ]),
    GCWTool(
        tool: const SlashAndPipeSelection(),
        id: 'slash_and_pipe_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(tool: const Solitaire(), id: 'solitaire', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'solitaire',
    ], licenses: const []),
    GCWTool(
        tool: const Sort(),
        id: 'sort',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const ['sort']),
    GCWTool(
        tool: const SpellingAlphabetsSelection(),
        id: 'spelling_alphabets_selection',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const []),
    GCWTool(tool: const SQRT2Selection(), id: 'sqrt2_selection', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'sqrt',
      'irrationalnumbers',
    ]),
    GCWTool(tool: const SQRT3Selection(), id: 'sqrt3_selection', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'sqrt',
      'irrationalnumbers',
    ]),
    GCWTool(tool: const SQRT5Selection(), id: 'sqrt5_selection', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'sqrt',
      'irrationalnumbers',
    ]),
    GCWTool(tool: const Stegano(), id: 'stegano', categories: const [
      ToolCategory.IMAGES_AND_FILES
    ], searchKeys: const [
      'stegano',
    ], licenses: const []),
    GCWTool(tool: const StraddlingCheckerboard(), id: 'straddlingcheckerboard', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'straddlingcheckerboard',
    ]),
    GCWTool(tool: const Substitution(), id: 'substitution', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'substitution',
    ]),
    GCWTool(tool: SubstitutionBreaker(), id: 'substitutionbreaker', categories: const [
      ToolCategory.GENERAL_CODEBREAKERS
    ], searchKeys: const [
      'codebreaker',
      'substitutionbreaker',
    ], deeplinkAlias: const [
      'substitution_breaker',
      'substbreaker',
      'substbreak',
      'subst_breaker',
      'subst_break'
    ], licenses: [
      ToolLicensePortedCode(
          context: context,
          author: 'Jens Guballa (guballa.de)',
          title: 'SubstitutionBreaker',
          sourceUrl: 'https://gitlab.com/guballa/SubstitutionBreaker/-/tree/93dcc269efbfe6c62c3a93a6ce66077d6ff335fb',
          licenseType: ToolLicenseType.MIT,
          licenseUrl:
          'https://gitlab.com/guballa/SubstitutionBreaker/-/blob/93dcc269efbfe6c62c3a93a6ce66077d6ff335fb/LICENSE'),
    ]),
    GCWTool(tool: const SudokuSolver(), id: 'sudokusolver', categories: const [
      ToolCategory.GAMES
    ], searchKeys: const [
      'games',
      'games_sudokusolver',
    ], licenses: [
      ToolLicensePortedCode(
          context: context,
          author: 'Demis Bellot, Adam Singer, Matias Meno',
          title: 'Sudoku Solver',
          sourceUrl: 'https://web.archivechive.org/web/20240819162156/https://github.com/dartist/sudoku_solver',
          licenseType: ToolLicenseType.FREE_TO_USE,
          licenseUrl: 'https://web.archivechive.org/web/20240819162341/https://github.com/dartist/sudoku_solver/blob/master/LICENSE'),
    ]),
    GCWTool(
      tool: const SymbolTableSelection(),
      toolBarItemList: [symbolTableToolbarMenuItem(context)],
      id: 'symboltables_selection',
      searchKeys: const [],
    ),
    GCWTool(tool: const TapCode(), id: 'tapcode', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'tapcode',
    ]),
    GCWTool(
        tool: Tapir(),
        id: 'tapir',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const ['tapir', 'numbers']),
    GCWTool(
        tool: const TelegraphSelection(),
        id: 'telegraph_selection',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const []),
    GCWTool(
        tool: const TeletypewriterSelection(),
        id: 'teletypewriter_selection',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const []),
    GCWTool(tool: const TeletypewriterPunchTape(), id: 'punchtape', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
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
    ], licenses: const []),
    GCWTool(
        tool: const TextAnalysis(),
        id: 'textanalysis',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const ['alphabetvalues', 'asciivalues', 'textanalysis'],
        licenses: const []),
    GCWTool(tool: const Trifid(), id: 'trifid', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'trifid',
    ]),
    GCWTool(
        tool: const TomTomSelection(),
        id: 'tomtom_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(tool: const TTS(), id: 'tts', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'tts',
    ]),
    GCWTool(tool: const UFI(), id: 'ufi', categories: const [
      ToolCategory.CRYPTOGRAPHY,
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'ufi',
    ]),
    GCWTool(
        tool: const UICWagonCodeSelection(),
        id: 'uic_wagoncode_selection',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY]),
    GCWTool(tool: const UnitConverter(), id: 'unitconverter', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'unitconverter',
    ], licenses: const []),
    GCWTool(tool: const UniversalProductCode(), id: 'universalproductcode', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'barcodes',
      'binary',
      'universalproductcode',
    ]),
    GCWTool(
        tool: const VelocityAcceleration(),
        id: 'velocity_acceleration',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const ['velocity_acceleration'],
        licenses: const []),
    GCWTool(
        tool: const VanitySelection(),
        id: 'vanity_selection',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const []),
    GCWTool(
        tool: const VigenereSelection(),
        id: 'vigenere_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(
        tool: const VisualCryptography(),
        id: 'visual_cryptography',
        categories: const [ToolCategory.IMAGES_AND_FILES, ToolCategory.CRYPTOGRAPHY],
        searchKeys: const ['visualcryptography', 'images'],
        licenses: const []),
    GCWTool(tool: const WASD(), id: 'wasd', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'wasd',
    ]),
    GCWTool(
        tool: const WherigoSelection(),
        id: 'wherigourwigo_selection',
        categories: const [ToolCategory.CRYPTOGRAPHY],
        searchKeys: const []),
    GCWTool(
        tool: const WeatherSymbols(),
        id: 'weathersymbols',
        categories: const [ToolCategory.SCIENCE_AND_TECHNOLOGY],
        searchKeys: const ['weather', 'weather_clouds', 'weather_a']),
    GCWTool(tool: const Z22(), id: 'z22', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'z22',
    ]),
    GCWTool(
        tool: const WordSearch(),
        id: 'word_search',
        categories: const [ToolCategory.GAMES],
        searchKeys: const ['word_search', 'grid']),
    GCWTool(tool: ZamonianNumbers(), autoScroll: false, id: 'zamoniannumbers', categories: const [
      ToolCategory.CRYPTOGRAPHY
    ], searchKeys: const [
      'symbol_zamonian',
    ]),
    GCWTool(tool: const ZC1(), id: 'zc1', categories: const [
      ToolCategory.SCIENCE_AND_TECHNOLOGY
    ], searchKeys: const [
      'zc1',
    ]),
    GCWTool(tool: const ZodiacSelection(), id: 'zodiac_selection', categories: const [ToolCategory.MISCELLANEOUS]),

    //ApparentTemperatureSelection  ********************************************************************************************
    GCWTool(tool: const HeatIndex(), id: 'heatindex', searchKeys: const [
      'apparenttemperature',
      'apparenttemperature_heatindex',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Hitzeindex',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Hitzeindex&oldid=243515966',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWTool(tool: const Humidex(), id: 'humidex', searchKeys: const [
      'apparenttemperature',
      'apparenttemperature_humidex',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Humidex',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Humidex&oldid=1235632685',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWTool(tool: const SummerSimmerIndex(), id: 'summersimmerindex', searchKeys: const [
      'apparenttemperature',
      'apparenttemperature_summersimmerindex',
    ], licenses: [
      ToolLicenseOnlineArticle(
        context: context,
        author: 'vCalc',
        title: 'Summer Simmer Index',
        sourceUrl:
        'https://web.archive.org/web/20240724192214/https://ncalculators.com/meteorology/summer-simmer-index-calculator.htm',
      )
    ]),
    GCWTool(tool: const Windchill(), id: 'windchill', searchKeys: const [
      'apparenttemperature',
      'apparenttemperature_windchill',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Windchill',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Windchill&oldid=243515968',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWTool(tool: const WetBulbTemperature(), id: 'wet_bulb_temperature', searchKeys: const [
      'apparenttemperature',
      'apparenttemperature_wet_bulb_temperature',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Kühlgrenztemperatur',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=K%C3%BChlgrenztemperatur&oldid=246986523',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),

    //AstronomySelection  ********************************************************************************************
    GCWTool(tool: const IAUAllConstellations(), id: 'iau_constellation', searchKeys: const [
      'astronomy',
      'iau_constellation',
    ], licenses: [
      ToolLicenseImage(
        context: context,
        author: 'The International Astronomical Union',
        title: 'The Constellations',
        sourceUrl: 'https://www.iau.org/public/themes/constellations/',
        licenseType: ToolLicenseType.CCBY4,
        licenseUseType: ToolLicenseUseType.COPY,
      ),
    ]),
    GCWTool(
        tool: const IAUSingleConstellation(ConstellationName: 'Andromeda'),
        id: 'iau_constellation',
        searchKeys: const [],
        licenses: [
          ToolLicenseImage(
            context: context,
            author: 'The International Astronomical Union',
            title: 'The Constellations',
            sourceUrl: 'https://www.iau.org/public/themes/constellations/',
            licenseType: ToolLicenseType.CCBY4,
            licenseUseType: ToolLicenseUseType.COPY,
          ),
        ]),
    GCWTool(tool: const SunRiseSet(), id: 'astronomy_sunriseset', searchKeys: const [
      'astronomy',
      'astronomy_riseset',
      'astronomy_sun',
      'astronomy_sunriseset',
    ], licenses: [
      stl._toolLicensePracticalAstronomy,
      stl._toolLicenseAstronomieInfo,
      stl._toolLicenseNASADeltaT,
    ]),
    GCWTool(tool: const SunPosition(), id: 'astronomy_sunposition', searchKeys: const [
      'astronomy',
      'astronomy_position',
      'astronomy_sun',
    ], licenses: [
      stl._toolLicensePracticalAstronomy,
      stl._toolLicenseAstronomieInfo,
      stl._toolLicenseNASADeltaT,
    ]),
    GCWTool(tool: const MoonRiseSet(), id: 'astronomy_moonriseset', searchKeys: const [
      'astronomy',
      'astronomy_riseset',
      'astronomy_moon',
    ], licenses: [
      stl._toolLicensePracticalAstronomy,
      stl._toolLicenseAstronomieInfo,
      stl._toolLicenseNASADeltaT,
    ]),
    GCWTool(tool: const MoonPosition(), id: 'astronomy_moonposition', searchKeys: const [
      'astronomy',
      'astronomy_position',
      'astronomy_moon',
      'astronomy_moonposition',
    ], licenses: [
      stl._toolLicensePracticalAstronomy,
      stl._toolLicenseAstronomieInfo,
      stl._toolLicenseNASADeltaT,
    ]),
    GCWTool(tool: const EasterSelection(), id: 'astronomy_easter_selection', searchKeys: const [
      'easter_date',
    ]),
    GCWTool(tool: const Seasons(), id: 'astronomy_seasons', searchKeys: const [
      'astronomy',
      'astronomy_seasons',
    ], licenses: [
      stl._toolLicenseJanMeeus,
      ToolLicensePortedCode(
        context: context,
        author: 'Jürgen Giesen (jgiesen.de)',
        title: 'Equinoxes and Solstices',
        privatePermission: ToolLicensePrivatePermission(
          context: context,
          medium: 'e-mail',
          permissionYear: 2020,
          permissionMonth: 6,
          permissionDay: 29,
        ),
        sourceUrl: 'https://web.archive.org/web/20140805014345/http://www.jgiesen.de/astro/astroJS/seasons2/seasons.js',
        licenseType: ToolLicenseType.PRIVATE_PERMISSION,
      )
    ]),
    GCWTool(tool: const ShadowLength(), id: 'shadowlength', searchKeys: const [
      'astronomy',
      'astronomy_shadow_length',
    ], licenses: [
      stl._toolLicenseNASADeltaT,
    ]),
    GCWTool(
        tool: const RightAscensionToDegree(),
        id: 'right_ascension_to_degree',
        categories: const [],
        searchKeys: const [
          'astronomy',
          'right_ascension_to_degree',
          'coordinates',
        ],
        licenses: [
          ToolLicenseOnlineArticle(
            context: context,
            author: 'en.wikipedia.org and contributors',
            title: 'Equatorial coordinate system',
            licenseType: ToolLicenseType.CCBYSA4,
            licenseUrl:
            'https://en.wikipedia.org/w/index.php?title=Wikipedia:Text_of_the_Creative_Commons_Attribution-ShareAlike_4.0_International_License&oldid=1162946924',
            sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Equatorial_coordinate_system&oldid=1228085432',
          ),
          ToolLicensePortedCode(
              context: context,
              author: '@max-mapper',
              title: 'equatorial',
              licenseType: ToolLicenseType.GITHUB_DEFAULT,
              sourceUrl: 'https://github.com/S-Man42/equatorial/tree/f11b2a91be12721d87b108cc495953bc96565fec'),
        ]),

    //Babylon Numbers Selection **************************************************************************************
    GCWTool(tool: const BabylonNumbers(), id: 'babylonnumbers', searchKeys: const [
      'babylonian_numerals',
    ], licenses: const []),

    //BaconSelection **************************************************************************************************
    GCWTool(tool: const Bacon(), id: 'bacon', categories: const [
    ], searchKeys: const [
      'bacon',
      'binary',
    ]),
    GCWTool(tool: const BaconAnalyze(), id: 'bacon_analyze', categories: const [
    ], searchKeys: const [
      'bacon',
      'binary',
    ]),

    //BaseSelection **************************************************************************************************
    GCWTool(tool: Base16(), id: 'base_base16', searchKeys: const [
      'base',
      'base16',
    ], deeplinkAlias: const [
      'base16'
    ]),
    GCWTool(tool: Base32(), id: 'base_base32', searchKeys: const [
      'base',
      'base32',
    ], deeplinkAlias: const [
      'base32'
    ], licenses: const []),
    GCWTool(
      tool: Base58(),
      id: 'base_base58',
      searchKeys: const [
        'base',
        'base58',
      ],
      deeplinkAlias: const ['base58'],
      licenses: [
        ToolLicenseOnlineArticle(
            context: context,
            author: 'en.wikipedia.org and contributors',
            title: 'Binary-to-text encoding',
            licenseType: ToolLicenseType.CCBYSA4,
            sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Binary-to-text_encoding&oldid=1228363691'),
        ToolLicenseCodeLibrary(
            context: context,
            author: 'NovaCrypto',
            title: 'Base58',
            sourceUrl: 'https://web.archive.org/web/20240722085432/https://github.com/NovaCrypto/Base58',
            licenseType: ToolLicenseType.GPL3),
        ToolLicenseCodeLibrary(
            context: context,
            author: 'David Keijser',
            title: 'Base58',
            sourceUrl: 'https://web.archive.org/web/20240721175430/https://pypi.org/project/base58/',
            licenseType: ToolLicenseType.MIT),
        ToolLicenseCodeLibrary(
            context: context,
            author: 'darklaunch',
            title: 'Base58 Decoder and Encoder',
            sourceUrl:
            'https://web.archive.org/web/20240721175752/https://www.darklaunch.com/base58-encode-and-decode-using-php-with-example-base58-encode-base58-decode.html',
            licenseType: ToolLicenseType.PUBLIC_DOMAIN),
      ],
    ),
    GCWTool(tool: Base64(), id: 'base_base64', searchKeys: const [
      'base',
      'base64',
    ], deeplinkAlias: const [
      'base64'
    ]),
    GCWTool(tool: Base85(), id: 'base_base85', searchKeys: const [
      'base',
      'base85',
    ], deeplinkAlias: const [
      'base85'
    ]),
    GCWTool(
      tool: Base91(),
      id: 'base_base91',
      searchKeys: const [
        'base',
        'base91',
      ],
      deeplinkAlias: const ['base91'],
      licenses: [
        ToolLicenseOnlineArticle(
            context: context,
            author: 'en.wikipedia.org and contributors',
            title: 'Binary-to-text encoding',
            licenseType: ToolLicenseType.CCBYSA4,
            sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Binary-to-text_encoding&oldid=1228363691'),
        ToolLicenseCodeLibrary(
            context: context,
            author: 'Joachim Henke',
            title: 'Base91',
            sourceUrl: 'https://web.archive.org/web/20240721180207/https://sourceforge.net/projects/base91/',
            licenseType: ToolLicenseType.BSD),
      ],
    ),
    GCWTool(
      tool: Base122(),
      id: 'base_base122',
      searchKeys: const [
        'base',
        'base122',
      ],
      deeplinkAlias: const ['base122'],
      licenses: [
        ToolLicenseOnlineArticle(
            context: context,
            author: 'en.wikipedia.org and contributors',
            title: 'Binary-to-text encoding',
            licenseType: ToolLicenseType.CCBYSA4,
            sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Binary-to-text_encoding&oldid=1228363691'),
        ToolLicenseCodeLibrary(
            context: context,
            author: 'Kevin Alberston',
            title: 'Base122',
            sourceUrl:
            'https://web.archive.org/web/20240721180712/https://github.com/kevinAlbs/Base122/blob/master/base122.js',
            licenseType: ToolLicenseType.MIT),
        ToolLicenseCodeLibrary(
            context: context,
            author: 'Patrick Favre-Bulle',
            title: 'Base122',
            sourceUrl:
            'https://web.archive.org/web/20240723104905/https://github.com/patrickfav/base122-java/blob/master/src/main/java/at/favre/lib/encoding/Base122.java',
            licenseType: ToolLicenseType.APACHE2),
      ],
    ),

    //BCD selection **************************************************************************************************
    GCWTool(tool: const BCDOriginal(), id: 'bcd_original', searchKeys: const [
      'bcd',
      'bcdoriginal',
    ]),
    GCWTool(tool: const BCDAiken(), id: 'bcd_aiken', searchKeys: const [
      'bcd',
      'bcdaiken',
    ]),
    GCWTool(tool: const BCDGlixon(), id: 'bcd_glixon', searchKeys: const [
      'bcd',
      'bcdglixon',
    ]),
    GCWTool(tool: const BCDGray(), id: 'bcd_gray', searchKeys: const [
      'bcd',
      'bcdgray',
    ]),
    GCWTool(tool: const BCDLibawCraig(), id: 'bcd_libawcraig', searchKeys: const [
      'bcd',
      'bcdlibawcraig',
    ]),
    GCWTool(tool: const BCDOBrien(), id: 'bcd_obrien', searchKeys: const [
      'bcd',
      'bcdobrien',
    ]),
    GCWTool(tool: const BCDPetherick(), id: 'bcd_petherick', searchKeys: const [
      'bcd',
      'bcdpetherick',
    ]),
    GCWTool(tool: const BCDStibitz(), id: 'bcd_stibitz', searchKeys: const [
      'bcd',
      'bcdstibitz',
    ]),
    GCWTool(tool: const BCDTompkins(), id: 'bcd_tompkins', searchKeys: const [
      'bcd',
      'bcdtompkins',
    ]),
    GCWTool(tool: const BCDHamming(), id: 'bcd_hamming', searchKeys: const [
      'bcd',
      'bcdhamming',
    ]),
    GCWTool(tool: const BCDBiquinary(), id: 'bcd_biquinary', searchKeys: const [
      'bcd',
      'bcd2of5',
      'bcdbiquinary',
    ]),
    GCWTool(tool: const BCD2of5Planet(), id: 'bcd_2of5planet', searchKeys: const [
      'bcd',
      'bcd2of5',
      'bcd2of5planet',
    ]),
    GCWTool(tool: const BCD2of5Postnet(), id: 'bcd_2of5postnet', searchKeys: const [
      'bcd',
      'bcd2of5',
      'bcd2of5postnet',
    ]),
    GCWTool(tool: const BCD2of5(), id: 'bcd_2of5', searchKeys: const [
      'bcd',
      'bcd2of5',
    ]),
    GCWTool(tool: const BCD1of10(), id: 'bcd_1of10', searchKeys: const [
      'bcd',
      'bcd1of10',
    ]),
    GCWTool(tool: const BCDGrayExcess(), id: 'bcd_grayexcess', searchKeys: const [
      'bcd',
      'bcdgrayexcess',
    ]),

    // Beaufort Selection *******************************************************************************************
    GCWTool(tool: const Beaufort(), id: 'beaufort', searchKeys: const [
      'beaufort',
    ], licenses: const []),

    // BundeswehrTalkingBoard Selection *******************************************************************************************
    GCWTool(
        tool: const BundeswehrTalkingBoardAuthentification(),
        id: 'bundeswehr_talkingboard_auth',
        categories: const [],
        searchKeys: const [
          'bundeswehr_talkingboard_auth',
          'bundeswehr_talkingboard',
        ]),
    GCWTool(
        tool: const BundeswehrTalkingBoardObfuscation(),
        id: 'bundeswehr_talkingboard_code',
        categories: const [],
        searchKeys: const [
          'bundeswehr_talkingboard',
          'bundeswehr_talkingboard_code',
        ]),

    //Braille Selection ****************************************************************
    GCWTool(tool: const Braille(), id: 'braille', searchKeys: const [
      'braille',
    ], licenses: const []),
    GCWTool(tool: const BrailleDotNumbers(), id: 'brailledotnumbers', searchKeys: const [
      'braille',
    ], licenses: const []),

    //CCITT Selection **********************************************************************************************
    GCWTool(tool: const CCITT1(), id: 'ccitt_1', searchKeys: const ['ccitt', 'ccitt_1', 'symbol_baudot']),
    GCWTool(tool: const CCITT2(), id: 'ccitt_2', searchKeys: const [
      'ccitt',
      'ccitt_2',
      'teletypewriter',
      'symbol_murraybaudot',
    ]),
    GCWTool(tool: const CCITT3(), id: 'ccitt_3', searchKeys: const [
      'ccitt',
      'ccitt_3',
      'teletypewriter',
    ]),
    GCWTool(tool: const CCITT4(), id: 'ccitt_4', searchKeys: const [
      'ccitt',
      'ccitt_4',
      'teletypewriter',
    ]),
    GCWTool(tool: const CCITT5(), id: 'ccitt_5', searchKeys: const [
      'ccitt',
      'ccitt_5',
      'teletypewriter',
    ]),
    GCWTool(tool: const CCIR476(), id: 'ccitt_ccir476', searchKeys: const [
      'ccitt',
      'ccitt_ccir_476',
      'teletypewriter',
    ]),

    //CheckDigitsSelection  ********************************************************************************************
    GCWTool(
        tool: const CheckDigitsCreditCardSelection(),
        id: 'checkdigits_creditcard_selection',
        searchKeys: const ['checkdigits']),
    GCWTool(
        tool: const CheckDigitsDETaxIDSelection(),
        id: 'checkdigits_de_taxid_selection',
        searchKeys: const ['checkdigits', 'checkdigits_de_taxid']),
    GCWTool(
      tool: const CheckDigitsEANSelection(),
      id: 'checkdigits_ean_selection',
      searchKeys: const ['checkdigits', 'checkdigits_ean'],
    ),
    GCWTool(
        tool: const CheckDigitsIBANSelection(),
        id: 'checkdigits_iban_selection',
        searchKeys: const ['checkdigits', 'checkdigits_iban']),
    GCWTool(
        tool: const CheckDigitsIMEISelection(),
        id: 'checkdigits_imei_selection',
        searchKeys: const ['checkdigits', 'checkdigits_imei']),
    GCWTool(
        tool: const CheckDigitsISBNSelection(),
        id: 'checkdigits_isbn_selection',
        searchKeys: const ['checkdigits', 'checkdigits_isbn']),
    GCWTool(
        tool: const CheckDigitsEUROSelection(),
        id: 'checkdigits_euro_selection',
        searchKeys: const ['checkdigits', 'checkdigits_euro']),
    GCWTool(
        tool: const CheckDigitsUICSelection(),
        id: 'checkdigits_uic_selection',
        searchKeys: const ['checkdigits', 'checkdigits_uic'], licenses: [stl._toolLicenseUICWiki]),

    //CheckDigitsCreditCardSelection  ********************************************************************************************
    GCWTool(
        tool: const CheckDigitsCreditCardCheckNumber(),
        id: 'checkdigits_creditcard_checknumber',
        searchKeys: const [],
        licenses: [
          ToolLicenseAPI(
              context: context,
              author: 'BINLIST.NET',
              title: 'BIN Lookup Service API',
              sourceUrl: 'https://web.archive.org/web/20240723180911/https://binlist.net/',
              licenseType: ToolLicenseType.FREE_TO_USE),
        ]),
    GCWTool(
        tool: const CheckDigitsCreditCardCalculateCheckDigit(),
        id: 'checkdigits_creditcard_calculate_digit',
        searchKeys: const []),
    GCWTool(
        tool: const CheckDigitsCreditCardCalculateMissingDigit(),
        id: 'checkdigits_creditcard_calculate_number',
        searchKeys: const []),

    //CheckDigitsDETINSelection  ********************************************************************************************
    GCWTool(tool: const CheckDigitsDETaxIDCheckNumber(), id: 'checkdigits_de_taxid_checknumber', searchKeys: const []),
    GCWTool(
        tool: const CheckDigitsDETaxIDCalculateCheckDigit(),
        id: 'checkdigits_de_taxid_calculate_digit',
        searchKeys: const []),
    GCWTool(
        tool: const CheckDigitsDETaxIDCalculateMissingDigit(),
        id: 'checkdigits_de_taxid_calculate_number',
        searchKeys: const []),

    //CheckDigitsEANSelection  ********************************************************************************************
    GCWTool(
        tool: const CheckDigitsEANCheckNumber(),
        id: 'checkdigits_ean_checknumber',
        searchKeys: const [],
        licenses: [
          ToolLicenseAPI(
            context: context,
            author: 'https://opengtindb.org/',
            title: 'Open EAN/GTIN Database API',
            licenseType: ToolLicenseType.GFDL,
            sourceUrl: 'https://opengtindb.org/api.php',
          )
        ]),
    GCWTool(
        tool: const CheckDigitsEANCalculateCheckDigit(), id: 'checkdigits_ean_calculate_digit', searchKeys: const []),
    GCWTool(
      tool: const CheckDigitsEANCalculateMissingDigit(),
      id: 'checkdigits_ean_calculate_number',
      searchKeys: const [],
    ),

    //CheckDigitsEUROSelection  ********************************************************************************************
    GCWTool(tool: const CheckDigitsEUROCheckNumber(), id: 'checkdigits_euro_checknumber', searchKeys: const []),
    GCWTool(
        tool: const CheckDigitsEUROCalculateCheckDigit(), id: 'checkdigits_euro_calculate_digit', searchKeys: const []),
    GCWTool(
        tool: const CheckDigitsEUROCalculateMissingDigit(),
        id: 'checkdigits_euro_calculate_number',
        searchKeys: const []),

    //CheckDigitsIBANSelection  ********************************************************************************************
    GCWTool(
      tool: const CheckDigitsIBANCheckNumber(),
      id: 'checkdigits_iban_checknumber',
      searchKeys: const [],
    ),
    GCWTool(
        tool: const CheckDigitsIBANCalculateCheckDigit(), id: 'checkdigits_iban_calculate_digit', searchKeys: const []),
    GCWTool(
        tool: const CheckDigitsIBANCalculateMissingDigit(),
        id: 'checkdigits_iban_calculate_number',
        searchKeys: const []),

    //CheckDigitsIMEISelection  ********************************************************************************************
    GCWTool(tool: const CheckDigitsIMEICheckNumber(), id: 'checkdigits_imei_checknumber', searchKeys: const []),
    GCWTool(
        tool: const CheckDigitsIMEICalculateCheckDigit(), id: 'checkdigits_imei_calculate_digit', searchKeys: const []),
    GCWTool(
        tool: const CheckDigitsIMEICalculateMissingDigit(),
        id: 'checkdigits_imei_calculate_number',
        searchKeys: const []),

    //CheckDigitsISBNSelection  ********************************************************************************************
    GCWTool(tool: const CheckDigitsISBNCheckNumber(), id: 'checkdigits_isbn_checknumber', searchKeys: const []),
    GCWTool(
        tool: const CheckDigitsISBNCalculateCheckDigit(), id: 'checkdigits_isbn_calculate_digit', searchKeys: const []),
    GCWTool(
        tool: const CheckDigitsISBNCalculateMissingDigit(),
        id: 'checkdigits_isbn_calculate_number',
        searchKeys: const []),

    //CheckDigitsUICSelection  ********************************************************************************************
    GCWTool(tool: const CheckDigitsUICCheckNumber(), id: 'checkdigits_uic_checknumber', searchKeys: const []),
    GCWTool(
        tool: const CheckDigitsUICCalculateCheckDigit(), id: 'checkdigits_uic_calculate_digit', searchKeys: const []),
    GCWTool(
        tool: const CheckDigitsUICCalculateMissingDigit(),
        id: 'checkdigits_uic_calculate_number',
        searchKeys: const []),

    //Cistercian Selection *****************************************************************************************
    GCWTool(tool: const CistercianNumbers(), id: 'cistercian', searchKeys: const [
      'cistercian',
    ], licenses: const []),

    //ColorsSelection **********************************************************************************************
    GCWTool(tool: const ColorTool(), id: 'colors', searchKeys: const [
      'color',
      'colorpicker',
    ], licenses: const []),
    GCWTool(tool: const RALColorCodes(), id: 'ralcolorcodes', searchKeys: const [
      'color',
      'ralcolorcodes',
    ]),
    GCWTool(tool: const PantoneColorCodes(), id: 'pantonecolorcodes', searchKeys: const [
      'color',
      'pantonecolorcodes',
    ]),

    //CombinatoricsSelection ***************************************************************************************
    GCWTool(tool: const Combination(), id: 'combinatorics_combination', searchKeys: const [
      'combinatorics',
      'combinatorics_combination',
    ]),
    GCWTool(tool: const Permutation(), id: 'combinatorics_permutation', searchKeys: const [
      'combinatorics',
      'combinatorics_permutation',
    ]),
    GCWTool(tool: const CombinationPermutation(), id: 'combinatorics_combinationpermutation', searchKeys: const [
      'combinatorics',
      'combinatorics_combination',
      'combinatorics_permutation',
    ]),

    //CoordsSelection **********************************************************************************************
    GCWTool(
        tool: const WaypointProjectionGeodetic(),
        id: 'coords_waypointprojection',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_waypoint_projection.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_compassrose',
          'coordinates_waypointprojection',
          'coordinates_geodetic',
        ],
        licenses: [
          stl._toolLicenseGeographicLib,
        ]),
    GCWTool(
        tool: const DistanceBearingGeodetic(),
        id: 'coords_distancebearing',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_distance_and_bearing.png',
        categories: const [
          ToolCategory.COORDINATES,
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_distancebearing',
          'coordinates_geodetic',
        ],
        licenses: [
          stl._toolLicenseGeographicLib,
        ]),
    GCWTool(
      tool: const FormatConverter(),
      id: 'coords_formatconverter',
      iconPath: 'lib/tools/coords/_common/assets/icons/icon_format_converter.png',
      categories: const [ToolCategory.COORDINATES],
      searchKeys: const [
        'coordinates',
        'coordinates_formatconverter',
      ],
      licenses: [
        stl._toolLicenseGeographicLib,
        ToolLicenseOnlineArticle(
            context: context,
            author: 'Hartwig Koch, Frank Naberfeld\n(Robert Bosch GmbH)',
            title:
            'Verfahren zur Festlegung einer Ortsposition und Vorrichtung zur elektronischen Verarbeitung von Ortspositionen\nPatent DE 102 39 432.6',
            year: 2002,
            month: 8,
            day: 28,
            licenseType: ToolLicenseType.FREE_TO_USE,
            sourceUrl:
            'https://web.archive.org/web/20240720180713/https://patentimages.storage.googleapis.com/8c/d1/46/c983120d1aea7b/DE10239432A1.pdf'),
        ToolLicensePortedCode(
          context: context,
          author: 'Jan van der Laan',
          title: 'rijksdriehoek',
          licenseType: ToolLicenseType.MIT,
          licenseUrl: 'https://github.com/S-Man42/rijksdriehoek/blob/dfea5221b8e3f9f44b6f0102114ab92f36eca5b2/LICENSE',
          sourceUrl: 'hhttps://github.com/S-Man42/rijksdriehoek/tree/dfea5221b8e3f9f44b6f0102114ab92f36eca5b2',
        ),
        ToolLicenseOnlineArticle(
            context: context,
            author: 'F.H. Schreutelkamp, Strang van Hees\n(De Koepel)',
            title: 'Benaderingsformules voor de transformatie tussen RD- en WGS84-kaartcoördinaten',
            sourceUrl:
            'https://web.archive.org/web/20041206052853/http://www.dekoepel.nl/pdf/Transformatieformules.pdf'),
        ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Global Area Reference System',
          licenseType: ToolLicenseType.CCBYSA4,
          licenseUrl:
          'https://en.wikipedia.org/w/index.php?title=Wikipedia:Text_of_the_Creative_Commons_Attribution-ShareAlike_4.0_International_License&oldid=1162946924',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Global_Area_Reference_System&oldid=1127203453',
        ),
        ToolLicenseOnlineArticle(
            context: context,
            author: 'National Geospatial-Intelligence Agency',
            title: 'Article: Global Area Reference System (GARS)',
            year: 2006,
            month: 10,
            day: 6,
            sourceUrl:
            'https://web.archive.org/web/20061020155156/http://earth-info.nga.mil/GandG/coordsys/grids/gars.html'),
        ToolLicensePortedCode(
            context: context,
            author: 'Taisuke Fukuno',
            title: 'Geo3x3',
            licenseType: ToolLicenseType.CC0_1,
            licenseUrl:
            'https://github.com/S-Man42/Geo3x3/tree/ca45f4a2c5fcebd806d1dbf615c7a26a8cad1150?tab=License-1-ov-file',
            sourceUrl: 'https://github.com/S-Man42/Geo3x3/tree/ca45f4a2c5fcebd806d1dbf615c7a26a8cad1150'),
        ToolLicenseOnlineArticle(
            context: context,
            author: '@sa2da',
            title: 'GeoHex',
            licenseType: ToolLicenseType.MIT,
            licenseUrl: 'https://web.archive.org/web/20240301005527/http://www.geohex.org/',
            sourceUrl: 'https://web.archive.org/web/20240301005527/http://www.geohex.org/'),
        ToolLicensePortedCode(
            context: context,
            author: 'Chikura Shinsaku',
            title: 'geohex4j',
            licenseType: ToolLicenseType.MIT,
            licenseUrl:
            'https://github.com/S-Man42/geohex4j/tree/464acda075666e0c2cb868935b334371c7f2eb97?tab=readme-ov-file#license',
            sourceUrl: 'https://github.com/S-Man42/geohex4j/tree/464acda075666e0c2cb868935b334371c7f2eb97'),
        ToolLicenseOnlineArticle(
          context: context,
          author: 'Ziyad S. Al-Salloum (makaney.net)',
          title: 'Makaney Code FAQ',
          year: 2011,
          licenseType: ToolLicenseType.FREE_TO_USE,
          licenseUrl: 'https://web.archive.org/web/20230719211854/http://www.makaney.net/mkc_standard.html',
          sourceUrl: 'https://web.archive.org/web/20230719211854/http://www.makaney.net/mkc_standard.html',
        ),
        ToolLicensePortedCode(
            context: context,
            author: 'Stichting Mapcode Foundation (mapcode.com)',
            title: 'mapcode-js',
            licenseType: ToolLicenseType.APACHE2,
            licenseUrl: 'https://github.com/S-Man42/mapcode-js/blob/25abcc53f4a15b996810a9d0fd00ff2efd0f2eeb/LICENSE',
            sourceUrl: 'https://github.com/S-Man42/mapcode-js/tree/25abcc53f4a15b996810a9d0fd00ff2efd0f2eeb'),
        ToolLicensePortedCode(
            context: context,
            author: '@Google',
            title: 'Open Location Code',
            licenseType: ToolLicenseType.APACHE2,
            licenseUrl:
            'https://github.com/S-Man42/open-location-code/blob/dfcebc905b81c3d9c987f7b3ac6e992f1e8710c6/LICENSE',
            sourceUrl: 'https://github.com/S-Man42/open-location-code/tree/dfcebc905b81c3d9c987f7b3ac6e992f1e8710c6'),
        ToolLicenseOnlineArticle(
            context: context,
            author: 'OpenStreetMap.org and contributors',
            title: 'Slippy map tilenames',
            licenseType: ToolLicenseType.CCBYSA2,
            licenseUrl: 'https://wiki.openstreetmap.org/w/index.php?title=Wiki_content_license&oldid=2661763',
            sourceUrl: 'https://wiki.openstreetmap.org/w/index.php?title=Slippy_map_tilenames&oldid=2689774'),
        ToolLicenseOnlineArticle(
            context: context,
            author: 'Bundesamt für Landestopografie Schweiz swisstopo',
            title:
            'Formeln und Konstanten für die Berechnung der Schweizerischen schiefachsigen Zylinderprojektion und der Transformation zwischen Koordinatensystemen',
            year: 2016,
            month: 12,
            sourceUrl:
            'https://web.archive.org/web/20210511074533/https://www.swisstopo.admin.ch/content/swisstopo-internet/de/topics/survey/reference-systems/switzerland/_jcr_content/contentPar/tabs/items/dokumente_publikatio/tabPar/downloadlist/downloadItems/517_1459343190376.download/refsys_d.pdf'),
        ToolLicensePortedCode(
            context: context,
            author: 'Thomas \'moenk\' Mönkemeier\n(moenk.de)',
            title: 'GK nach GPS/GPS nach GK',
            privatePermission: ToolLicensePrivatePermission(
              context: context,
              medium: 'PN in geoclub.de forum',
              permissionYear: 2013,
            ),
            sourceUrl:
            'https://web.archive.org/web/20121102023141/http://www.moenk.de/index.php?serendipity[subpage]=downloadmanager&level=1&thiscat=4',
            licenseType: ToolLicenseType.PRIVATE_PERMISSION),
        ToolLicensePortedCode(
            context: context,
            author: 'Google Inc.',
            title: 's2-geometry-library-java',
            sourceUrl:
            'https://web.archive.org/web/20240903110359/https://github.com/google/s2-geometry-library-java/tree/master',
            licenseType: ToolLicenseType.APACHE2,
            licenseUrl: 'https://web.archive.org/web/20240903110701/https://github.com/google/s2-geometry-library-java/tree/master?tab=Apache-2.0-1-ov-file'),
      ],
    ),
    GCWTool(
        tool: const MapView(),
        autoScroll: false,
        suppressToolMargin: true,
        id: 'coords_openmap',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_free_map.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_mapview',
        ],
        licenses: [
          stl._toolLicenseFAA8260,
          ToolLicensePortedCode(
              context: context,
              author: 'Paul Kohut',
              title: 'GeoFormula and TerpsTest',
              licenseType: ToolLicenseType.APACHE2,
              licenseUrl:
              'https://github.com/S-Man42/GeoFormulas/tree/ac40eb5589883999f830908cd1db45c73e1e1267?tab=readme-ov-file#legal-stuff',
              sourceUrl: 'http://web.archive.org/web/20240812021538/https://github.com/pkohut/GeoFormulas'),
          ToolLicensePortedCode(
              context: context,
              author: '@josxha (Github)',
              title: 'Flutter Map: Scalebar',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl:
              'https://web.archive.org/web/20240606210131/https://pub.dev/packages/flutter_map/license',
              sourceUrl: 'http://web.archive.org/web/20240831132524/https://github.com/josxha/flutter_map/blob/477bbdf41e5e99b74b8f2f6b7054f38e1e8d64c7/lib/src/layer/scalebar/scalebar.dart')
        ]),
    GCWTool(
      tool: const VariableCoordinateFormulas(),
      id: 'coords_variablecoordinate',
      iconPath: 'lib/tools/coords/_common/assets/icons/icon_variable_coordinate.png',
      categories: const [ToolCategory.COORDINATES],
      searchKeys: const [
        'coordinates',
        'formulasolver',
        'coordinates_variablecoordinateformulas',
      ],
      licenses: const [],
    ),
    GCWTool(
        tool: const DMMOffset(),
        id: 'coords_dmmoffset',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_dmm_offset.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_mapview',
        ]),
    GCWTool(
        tool: const CoordinateAveraging(),
        id: 'coords_averaging',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_coordinate_measurement.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_coordinateaveraging',
        ],
        licenses: [
          ToolLicensePortedCode(
              context: context,
              author: 'David Vávra',
              title: 'GPS Averaging',
              licenseType: ToolLicenseType.APACHE2,
              licenseUrl:
              'https://github.com/S-Man42/GPS-Averaging/blob/260eb5464d6d1b969c3f30bce42c5cf7848aab93/LICENSE.md',
              sourceUrl: 'https://github.com/S-Man42/GPS-Averaging/tree/260eb5464d6d1b969c3f30bce42c5cf7848aab93')
        ]),
    GCWTool(
        tool: const CenterTwoPoints(),
        id: 'coords_centertwopoints',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_center_two_points.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_centertwopoints',
        ],
        licenses: const []),
    GCWTool(
        tool: const CentroidArithmeticMean(),
        id: 'coords_centroid',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_centroid.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_centroid',
          'coordinates_arithmeticmean',
        ],
        licenses: [
          stl._toolLicenseGeoMidpoint,
        ]),
    GCWTool(
        tool: const CentroidCenterOfGravity(),
        id: 'coords_centroid_centerofgravity',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_centroid.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_centroid',
          'coordinates_centerofgravity',
        ],
        licenses: [
          stl._toolLicenseGeoMidpoint,
        ]),
    GCWTool(
        tool: const CenterThreePoints(),
        id: 'coords_centerthreepoints',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_center_three_points.png',
        categories: const [
          ToolCategory.COORDINATES,
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_centerthreepoints',
        ],
        licenses: [
          ToolLicensePortedCode(
            context: context,
            author: 'Kirk Kuykendall, Charles \'@cffk\' Karney (gis.stackexchange.com)',
            title: 'Answer: How can I use ArcGIS 10.1 to find a geodesic equidistant point defined by three points?',
            sourceUrl: 'http://web.archive.org/web/20240909104633/https://gis.stackexchange.com/revisions/63083/4',
            licenseType: ToolLicenseType.CCBYSA3,
            licenseUrl: 'http://web.archive.org/web/20240909124039/https://gis.stackexchange.com/posts/63083/timeline'
          ),
          ToolLicenseOnlineArticle(
            context: context,
            author: 'Rod Stephens',
            year: 2001, month: 11, day: 8,
            title: 'Draw a circle through three points in C#',
            sourceUrl: 'http://web.archive.org/web/20140428104056/http://blog.csharphelper.com/2011/11/08/draw-a-circle-through-three-points-in-c.aspx'
          )
        ]),
    GCWTool(
        tool: const SegmentLine(),
        id: 'coords_segmentline',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_segment_line.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_segmentline',
        ],
        licenses: const []),
    GCWTool(
        tool: const SegmentBearings(),
        id: 'coords_segmentbearings',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_segment_bearings.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_segmentbearing',
        ],
        licenses: const []),
    GCWTool(
        tool: const CrossBearing(),
        id: 'coords_crossbearing',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_cross_bearing.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_crossbearing',
        ],
        licenses: const []),
    GCWTool(
        tool: const IntersectBearings(),
        id: 'coords_intersectbearings',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_intersect_bearings.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_compassrose',
          'coordinates_intersectbearing',
        ],
        licenses: [
          stl._toolLicenseGeographicLib,
        ]),
    GCWTool(
        tool: const IntersectFourPoints(),
        id: 'coords_intersectfourpoints',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_intersect_four_points.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_intersectfourpoints',
        ],
        licenses: [
          stl._toolLicenseGeographicLib,
        ]),
    GCWTool(
        tool: const IntersectGeodeticAndCircle(),
        id: 'coords_intersectbearingcircle',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_intersect_bearing_and_circle.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_compassrose',
          'coordinates_intersectgeodeticandcircle',
        ],
        licenses: [
          stl._toolLicenseFAA8260,
          stl._toolLicenseMitre,
        ]),
    GCWTool(
        tool: const IntersectTwoCircles(),
        id: 'coords_intersecttwocircles',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_intersect_two_circles.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_intersecttwocircles',
        ],
        licenses: [
          stl._toolLicenseFAA8260,
          stl._toolLicenseMitre,
        ]),
    GCWTool(
        tool: const IntersectThreeCircles(),
        id: 'coords_intersectthreecircles',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_intersect_three_circles.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_intersectthreecircles',
        ],
        licenses: [
          stl._toolLicenseFAA8260,
          stl._toolLicenseMitre,
        ]),
    GCWTool(
        tool: const Antipodes(),
        id: 'coords_antipodes',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_antipodes.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_antipodes',
        ],
        licenses: const []),
    GCWTool(
        tool: const Intersection(),
        id: 'coords_intersection',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_intersection.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_intersection',
        ],
        licenses: const []),
    GCWTool(
        tool: const Resection(),
        id: 'coords_resection',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_resection.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_resection',
        ],
        licenses: const []),
    GCWTool(
        tool: const EquilateralTriangle(),
        id: 'coords_equilateraltriangle',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_equilateral_triangle.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_equilateraltriangle',
        ],
        licenses: const []),
    GCWTool(
        tool: const WaypointProjectionRhumbline(),
        id: 'coords_rhumbline_projection',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_waypoint_projection.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_waypointprojection',
          'coordinates_rhumbline',
        ],
        licenses: [
          stl._toolLicenseGeographicLib
        ]),
    GCWTool(
        tool: const DistanceBearingRhumbline(),
        id: 'coords_rhumbline_distancebearing',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_distance_and_bearing.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_distancebearing',
          'coordinates_rhumbline',
        ],
        licenses: [
          stl._toolLicenseGeographicLib
        ]),
    GCWTool(
        tool: const EllipsoidTransform(),
        id: 'coords_ellipsoidtransform',
        iconPath: 'lib/tools/coords/_common/assets/icons/icon_ellipsoid_transform.png',
        categories: const [
          ToolCategory.COORDINATES
        ],
        searchKeys: const [
          'coordinates',
          'coordinates_ellipsoidtransform',
        ],
        licenses: const []),

    //Countries Selection ******************************************************************************************

    GCWTool(tool: CountriesCallingCodes(), id: 'countries_callingcode', searchKeys: const [
      'countries',
      'countries_callingcodes',
    ]),
    GCWTool(tool: CountriesIOCCodes(), id: 'countries_ioccode', searchKeys: const [
      'countries',
      'countries_ioccodes',
    ]),
    GCWTool(tool: CountriesISOCodes(), id: 'countries_isocode', searchKeys: const [
      'countries',
      'countries_isocodes',
    ]),
    GCWTool(tool: CountriesVehicleCodes(), id: 'countries_vehiclecode', searchKeys: const [
      'countries',
      'countries_vehiclecodes',
    ]),
    GCWTool(tool: CountriesEmbassyCodesGER(), id: 'countries_embassycodes_ger', searchKeys: const [
      'countries',
      'countries_embassycodes_ger',
    ]),
    GCWTool(tool: const CountriesFlags(), id: 'countries_flags', searchKeys: const [
      'countries',
      'symbol_flags',
      'countries_flags',
    ], licenses: const []),

    //CrossSumSelection *******************************************************************************************

    GCWTool(tool: const CrossSum(), id: 'crosssum_crosssum', searchKeys: const [
      'crosssums',
    ]),
    GCWTool(tool: const CrossSumRange(), id: 'crosssum_range', searchKeys: const [
      'crosssums',
      'crossumrange',
    ], licenses: const []),
    GCWTool(tool: const IteratedCrossSumRange(), id: 'crosssum_range_iterated', searchKeys: const [
      'crosssums',
      'iteratedcrosssumrange',
    ]),
    GCWTool(tool: const CrossSumRangeFrequency(), id: 'crosssum_range_frequency', searchKeys: const [
      'crosssums',
      'crossumrange',
      'iteratedcrossumrangefrequency',
    ]),
    GCWTool(tool: const IteratedCrossSumRangeFrequency(), id: 'crosssum_range_iterated_frequency', searchKeys: const [
      'crosssums',
      'crossumrange',
      'crosssumrangefrequency',
    ]),

    //DatesSelection **********************************************************************************************
    GCWTool(tool: const DayCalculator(), id: 'dates_daycalculator', searchKeys: const [
      'dates',
      'dates_daycalculator',
    ]),
    GCWTool(tool: const TimeCalculator(), id: 'dates_timecalculator', searchKeys: const [
      'dates',
      'dates_timecalculator',
    ]),
    GCWTool(tool: const Weekday(), id: 'dates_weekday', searchKeys: const [
      'dates',
      'dates_weekday',
    ]),
    GCWTool(tool: const CalendarWeek(), id: 'dates_calendarweek', searchKeys: const [
      'dates',
      'dates_calendarweek',
    ], licenses: const []),

    GCWTool(tool: const DayOfTheYear(), id: 'dates_day_of_the_year', searchKeys: const [
      'dates',
      'dates_day_of_the_year',
    ], licenses: const []),
    GCWTool(
      tool: const Calendar(),
      id: 'dates_calendar',
      searchKeys: const [
        'dates',
        'dates_calendar',
      ],
      licenses: [
        ToolLicensePortedCode(
          context: context,
          author: 'Johannes Thomann',
          title: 'Kalenderumrechnung - Islamisch, Jüdisch, Koptisch, Persisch',
          privatePermission: ToolLicensePrivatePermission(
            context: context,
            medium: 'e-Mail',
            permissionYear: 2021,
            permissionMonth: 5,
            permissionDay: 21,
          ),
          sourceUrl:
          'https://web.archive.org/web/20240721214347/https://www.aoi.uzh.ch/de/islamwissenschaft/studium/tools/kalenderumrechnung.html',
          licenseType: ToolLicenseType.PRIVATE_PERMISSION,
        ),
      ],
    ),
    GCWTool(tool: const ExcelTime(), id: 'excel_time', searchKeys: const [
      'dates',
      'excel_time',
    ], licenses: const []),
    GCWTool(tool: const UnixTime(), id: 'unix_time', searchKeys: const [
      'dates',
      'unix_time',
    ], licenses: const []),

    //DNASelection ************************************************************************************************
    GCWTool(tool: const DNANucleicAcidSequence(), id: 'dna_nucleicacidsequence', searchKeys: const [
      'dna',
      'dnanucleicacidsequence',
    ]),
    GCWTool(tool: const DNAAminoAcids(), id: 'dna_aminoacids', searchKeys: const [
      'dna',
      'dnaaminoacids',
    ]),
    GCWTool(tool: const DNAAminoAcidsTable(), id: 'dna_aminoacids_table', searchKeys: const [
      'dna',
      'dnaamonoacidstable',
    ]),

    //E Selection *************************************************************************************************
    GCWTool(tool: const ENthDecimal(), id: 'irrationalnumbers_nthdecimal', id_prefix: 'e_', searchKeys: const [
      'enthdecimal',
    ]),
    GCWTool(tool: const EDecimalRange(), id: 'irrationalnumbers_decimalrange', id_prefix: 'e_', searchKeys: const [
      'edecimalrange',
    ]),
    GCWTool(tool: const ESearch(), id: 'irrationalnumbers_search', id_prefix: 'e_', searchKeys: const [
      'esearch',
    ]),

    //Easter Selection ***************************************************************************************
    GCWTool(tool: const EasterDate(), id: 'astronomy_easter_easterdate', searchKeys: const [
      'easter_date',
    ], licenses: [
      stl._toolLicenseJanMeeus,
    ]),
    GCWTool(tool: const EasterYears(), id: 'astronomy_easter_easteryears', searchKeys: const [
      'easter_date',
      'easter_years',
    ], licenses: [
      stl._toolLicenseJanMeeus,
    ]),

    //Esoteric Programming Language Selection ****************************************************************
    GCWTool(tool: const Beatnik(), id: 'beatnik', searchKeys: const [
      'esotericprogramminglanguage',
      'esoteric_beatnik',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Cliff L. Biffle',
          title: 'Beatnik',
          sourceUrl: 'https://web.archive.org/web/20240616184504/https://cliffle.com/esoterica/beatnik/'),
      ToolLicensePortedCode(
          context: context,
          author: 'Hendrik Van Belleghem',
          title: 'Acme-Beatnik-0.02',
          sourceUrl:
          'https://web.archive.org/web/20240722064615/https://metacpan.org/release/BEATNIK/Acme-Beatnik-0.02/source',
          licenseType: ToolLicenseType.AL),
    ]),
    GCWTool(tool: const Befunge(), id: 'befunge', isBeta: true, searchKeys: const [
      'esotericprogramminglanguage',
      'befunge',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Befunge',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Befunge&oldid=1187697788',
          licenseType: ToolLicenseType.CCBYSA4),
      ToolLicensePortedCode(
          context: context,
          author: 'catseye',
          title: 'Befunge-93',
          sourceUrl: 'https://web.archive.org/web/20240722072403/https://github.com/catseye/Befunge-93',
          licenseType: ToolLicenseType.BSD),
    ]),
    GCWTool(tool: const Brainfk(), id: 'brainfk', searchKeys: const [
      'esotericprogramminglanguage',
      'esoteric_brainfk',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Brainfuck',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Brainfuck&oldid=1235460695',
          licenseType: ToolLicenseType.CCBYSA4),
      ToolLicensePortedCode(
          context: context,
          author: 'Fabian Mastenbroek',
          title: 'brainfuck',
          sourceUrl: 'https://github.com/fabianishere/brainfuck',
          licenseType: ToolLicenseType.APACHE2),
      ToolLicensePortedCode(
          context: context,
          author: 'Anar Software',
          title: 'BrainJuck Generator',
          sourceUrl: 'https://github.com/anars/BrainJuck/blob/master/source/com/anars/brainjuck/Generator.java',
          licenseType: ToolLicenseType.GPL3),
    ]),
    GCWTool(tool: const Cow(), id: 'cow', searchKeys: const [
      'esotericprogramminglanguage',
      'esoteric_cow',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Sean "BigZaphod" Heber',
          title: 'Cow',
          sourceUrl: 'https://web.archive.org/web/20240722070525/https://bigzaphod.github.io/COW/'),
      ToolLicensePortedCode(
          context: context,
          author: 'Mark "AtomK F.',
          title: 'C-Cow-Interpreter',
          sourceUrl:
          'https://web.archive.org/web/20240722070830/https://github.com/Atomk/C-COW-Interpreter/blob/master/cow-interpreter.c',
          licenseType: ToolLicenseType.MIT),
      // TODO: @Thomas: PortedCode richtig oder OnlineArticle?
      ToolLicensePortedCode(
          context: context,
          author: 'Frank Buß',
          title: 'Cow',
          licenseType: ToolLicenseType.PRIVATE_PERMISSION,
          sourceUrl: 'https://web.archive.org/web/20240722071149/https://frank-buss.de/cow.html',
          privatePermission: ToolLicensePrivatePermission(
              context: context, medium: 'e-Mail', permissionYear: 2021, permissionMonth: 7, permissionDay: 22))
    ]),
    GCWTool(tool: const Chef(), id: 'chef', searchKeys: const [
      'esotericprogramminglanguage',
      'esoteric_chef',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'David Morgan-Mar',
          title: 'Chef',
          sourceUrl: 'https://web.archive.org/web/20240722065211/https://www.dangermouse.net/esoteric/chef.html'),
      ToolLicensePortedCode(
          context: context,
          author: 'Wesley Janssen, Joost Rijneveld and Mathijs Vos',
          title: 'Chef-Interpreter',
          sourceUrl: 'https://web.archive.org/web/20240722064914/https://github.com/joostrijneveld/Chef-Interpreter',
          licenseType: ToolLicenseType.CC0_1),
    ]),
    GCWTool(tool: const Deadfish(), id: 'deadfish', searchKeys: const [
      'esotericprogramminglanguage',
      'esoteric_deadfish',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Jonathan Todd Skinner',
          title: 'the Deadfish Programming Language',
          sourceUrl:
          'https://web.archive.org/web/20100425075447/http://www.jonathantoddskinner.com/projects/deadfish.html'),
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Esolang, the esoteric programming languages wiki',
          title: 'Deadfish',
          sourceUrl: 'https://esolangs.org/w/index.php?title=Deadfish&oldid=133382'),
      ToolLicensePortedCode(
          context: context,
          author: 'Jonathan Todd Skinner',
          title: 'the Deadfish Programming Language',
          sourceUrl:
          'https://web.archive.org/web/20100425075447/http://www.jonathantoddskinner.com/projects/deadfish.html',
          licenseType: ToolLicenseType.FREE_TO_USE),
    ]),
    GCWTool(tool: const Hohoho(), id: 'hohoho', searchKeys: const [
      'esotericprogramminglanguage',
      'esoteric_hohoho',
      'christmas'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'P. Reichl, S. Claus',
          title: '”Oh Tanenbaum, oh Tanenbaum...”: Technical Foundations of Xmas 4.0 Research',
          sourceUrl: 'https://web.archive.org/web/20240722074714/https://arxiv.org/pdf/1712.06259'),
    ]),
    GCWTool(tool: const KarolRobot(), id: 'karol_robot', searchKeys: const [
      'esoteric_karol_robot',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Karel (programming language)',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Karel_(programming_language)&oldid=1220885127',
          licenseType: ToolLicenseType.CCBYSA4),
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Robert H. Untch',
          title: 'Karel the Robot',
          sourceUrl: 'https://web.archive.org/web/20240722080406/https://www.cs.mtsu.edu/~untch/karel/index.html'),
      ToolLicenseOnlineBook(
        context: context,
        author: 'Richard E. Pattis',
        title: 'Karel the robot : a gentle introduction to the art of programming',
        sourceUrl: 'https://archive.org/details/karelrobotgentle0000patt/page/n7/mode/2up',
      ),
    ]),
    GCWTool(tool: const Malbolge(), id: 'malbolge', searchKeys: const [
      'esotericprogramminglanguage',
      'esoteric_malbolge',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Malbolge',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Malbolge&oldid=1230857335',
          licenseType: ToolLicenseType.CCBYSA4),
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Ben Olmstead',
          title: 'Malbolge',
          sourceUrl: 'https://web.archive.org/web/20240722081619/http://www.lscheffer.com/malbolge_spec.html'),
      ToolLicensePortedCode(
          context: context,
          author: 'Ben Olmstead',
          title: 'Interpreter for Malbolge',
          sourceUrl: 'https://web.archive.org/web/20240722081935/http://www.lscheffer.com/malbolge_interp.html',
          licenseType: ToolLicenseType.FREE_TO_USE),
      ToolLicensePortedCode(
          context: context,
          author: 'Matthias Ernst',
          title: 'Generator for text printing Malbolge programs',
          customComment: 'stringout.c, attached to e-Mail',
          privatePermission: ToolLicensePrivatePermission(
              context: context, medium: 'e-Mail', permissionYear: 2021, permissionMonth: 1, permissionDay: 12),
          licenseType: ToolLicenseType.PRIVATE_PERMISSION,
          sourceUrl: ''),
    ]),
    GCWTool(tool: Ook(), id: 'ook', searchKeys: const [
      'esotericprogramminglanguage',
      'esoteric_brainfk',
      'esoteric_ook',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Ook!',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Ook!&oldid=223308865',
          licenseType: ToolLicenseType.CCBYSA4),
      ToolLicensePortedCode(
          context: context,
          author: 'David Morgan-Mar',
          title: 'Ook!',
          sourceUrl: 'https://www.dangermouse.net/esoteric/ook.html',
          licenseType: ToolLicenseType.FREE_TO_USE),
    ]),
    GCWTool(tool: const Piet(), id: 'piet', isBeta: true, searchKeys: const [
      'esotericprogramminglanguage',
      'esoteric_piet',
      'color',
      'images'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Piet (Programmiersprache)',
          licenseType: ToolLicenseType.CCBYSA4,
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Piet_(Programmiersprache)&oldid=240673094'),
      ToolLicenseOnlineArticle(
          context: context,
          author: 'David Morgan-Mar',
          title: 'Piet',
          sourceUrl: 'https://web.archive.org/web/20240722200934/https://www.dangermouse.net/esoteric/piet.html'),
      ToolLicenseCodeLibrary(
          context: context,
          author: 'Matthew "MatthewMooreZA" Moore',
          title: 'PietSharp',
          sourceUrl: 'https://web.archive.org/web/20240722201424/https://github.com/MatthewMooreZA/PietSharp',
          licenseType: ToolLicenseType.GITHUB_DEFAULT),
      ToolLicenseCodeLibrary(
          context: context,
          author: 'sebbeobe',
          title: 'piet_message_generator',
          sourceUrl: 'https://web.archive.org/web/20240722201719/https://github.com/sebbeobe/piet_message_generator',
          licenseType: ToolLicenseType.GPL3),
    ]),
    GCWTool(tool: const WhitespaceLanguage(), id: 'whitespace_language', searchKeys: const [
      'esotericprogramminglanguage',
      'esoteric_whitespacelanguage',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Whitespace (programming language)',
          licenseType: ToolLicenseType.CCBYSA4,
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Whitespace_(programming_language)&oldid=1212567115'),
      ToolLicenseCodeLibrary(
          context: context,
          author: 'Adam "adapap" Papenhausen',
          title: 'whitespace-interpreter',
          sourceUrl:
          'https://web.archive.org/web/20240722195953/https://github.com/adapap/whitespace-interpreter/blob/master/whitespace_interpreter.py#L1',
          licenseType: ToolLicenseType.MIT),
      ToolLicenseCodeLibrary(
          context: context,
          author: 'naoki "naokikp" kageyama',
          title: 'Whitespace Interpreter',
          sourceUrl: 'https://web.archive.org/web/20240722200540/https://github.com/naokikp/naokikp.github.io',
          licenseType: ToolLicenseType.GITHUB_DEFAULT),
    ]),

    //Hash Selection *****************************************************************************************
    GCWTool(tool: const HashBreaker(), id: 'hashes_hashbreaker', categories: const [
      ToolCategory.GENERAL_CODEBREAKERS
    ], searchKeys: const [
      'codebreaker',
      'hashes',
      'hashbreaker',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const UrwigoHashBreaker(), id: 'urwigo_hashbreaker', searchKeys: const [
      'wherigo',
      'urwigo',
      'hashes',
      'hashbreaker',
    ]),
    GCWTool(
        tool: const HashOverview(),
        id: 'hashes_overview',
        searchKeys: const ['hashes', 'hashes_overview'],
        licenses: [stl._toolLicensePointyCastle]),
    GCWTool(
        tool: const HashIdentification(),
        id: 'hashes_identification',
        searchKeys: const ['hashes', 'hashes_identification'],
        licenses: [stl._toolLicensePointyCastle]),
    GCWTool(tool: const SHA1(), id: 'hashes_sha1', searchKeys: const [
      'hashes',
      'hashes_sha1',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA1HMac(), id: 'hashes_sha1hmac', searchKeys: const [
      'hashes',
      'hashes_sha1',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA224(), id: 'hashes_sha224', searchKeys: const [
      'hashes',
      'hashes_sha2',
      'hashes_sha224',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA224HMac(), id: 'hashes_sha224hmac', searchKeys: const [
      'hashes',
      'hashes_sha2',
      'hashes_sha224',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA256(), id: 'hashes_sha256', searchKeys: const [
      'hashes',
      'hashes_sha2',
      'hashes_sha256',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA256HMac(), id: 'hashes_sha256hmac', searchKeys: const [
      'hashes',
      'hashes_sha2',
      'hashes_sha256',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA384(), id: 'hashes_sha384', searchKeys: const [
      'hashes',
      'hashes_sha2',
      'hashes_sha384',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA384HMac(), id: 'hashes_sha384hmac', searchKeys: const [
      'hashes',
      'hashes_sha2',
      'hashes_sha384',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA512(), id: 'hashes_sha512', searchKeys: const [
      'hashes',
      'hashes_sha2',
      'hashes_sha512',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA512HMac(), id: 'hashes_sha512hmac', searchKeys: const [
      'hashes',
      'hashes_sha2',
      'hashes_sha512',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA512_224(), id: 'hashes_sha512.224', searchKeys: const [
      'hashes',
      'hashes_sha2',
      'hashes_sha512_224',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA512_224HMac(), id: 'hashes_sha512.224hmac', searchKeys: const [
      'hashes',
      'hashes_sha2',
      'hashes_sha512_224',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA512_256(), id: 'hashes_sha512.256', searchKeys: const [
      'hashes',
      'hashes_sha2',
      'hashes_sha512_256',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA512_256HMac(), id: 'hashes_sha512.256hmac', searchKeys: const [
      'hashes',
      'hashes_sha2',
      'hashes_sha512_256',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA3_224(), id: 'hashes_sha3.224', searchKeys: const [
      'hashes',
      'hashes_sha3',
      'hashes_sha3_224',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA3_224HMac(), id: 'hashes_sha3.224hmac', searchKeys: const [
      'hashes',
      'hashes_sha3',
      'hashes_sha3_224',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA3_256(), id: 'hashes_sha3.256', searchKeys: const [
      'hashes',
      'hashes_sha3',
      'hashes_sha3_256',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA3_256HMac(), id: 'hashes_sha3.256hmac', searchKeys: const [
      'hashes',
      'hashes_sha3',
      'hashes_sha3_256',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA3_384(), id: 'hashes_sha3.384', searchKeys: const [
      'hashes',
      'hashes_sha3',
      'hashes_sha3_384',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA3_384HMac(), id: 'hashes_sha3.384hmac', searchKeys: const [
      'hashes',
      'hashes_sha3',
      'hashes_sha3_384',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA3_512(), id: 'hashes_sha3.512', searchKeys: const [
      'hashes',
      'hashes_sha3',
      'hashes_sha3_512',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const SHA3_512HMac(), id: 'hashes_sha3.512hmac', searchKeys: const [
      'hashes',
      'hashes_sha3',
      'hashes_sha3_512',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const Keccak_128(), id: 'hashes_keccak128', searchKeys: const [
      'hashes',
      'hashes_sha3',
      'hashes_keccak',
      'hashes_keccak_128',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const Keccak_224(), id: 'hashes_keccak224', searchKeys: const [
      'hashes',
      'hashes_sha3',
      'hashes_keccak',
      'hashes_keccak_224',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const Keccak_256(), id: 'hashes_keccak256', searchKeys: const [
      'hashes',
      'hashes_sha3',
      'hashes_keccak',
      'hashes_keccak_256',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const Keccak_288(), id: 'hashes_keccak288', searchKeys: const [
      'hashes',
      'hashes_sha3',
      'hashes_keccak',
      'hashes_keccak_288',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const Keccak_384(), id: 'hashes_keccak384', searchKeys: const [
      'hashes',
      'hashes_sha3',
      'hashes_keccak',
      'hashes_keccak_384',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const Keccak_512(), id: 'hashes_keccak512', searchKeys: const [
      'hashes',
      'hashes_sha3',
      'hashes_keccak',
      'hashes_keccak_512',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const RIPEMD_128(), id: 'hashes_ripemd128', searchKeys: const [
      'hashes',
      'hashes_ripemd',
      'hashes_ripemd_128',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const RIPEMD_128HMac(), id: 'hashes_ripemd128hmac', searchKeys: const [
      'hashes',
      'hashes_ripemd',
      'hashes_ripemd_128',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const RIPEMD_160(), id: 'hashes_ripemd160', searchKeys: const [
      'hashes',
      'hashes_ripemd',
      'hashes_ripemd_160',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const RIPEMD_160HMac(), id: 'hashes_ripemd160hmac', searchKeys: const [
      'hashes',
      'hashes_ripemd',
      'hashes_ripemd_160',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const RIPEMD_256(), id: 'hashes_ripemd256', searchKeys: const [
      'hashes',
      'hashes_ripemd',
      'hashes_ripemd_256',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const RIPEMD_256HMac(), id: 'hashes_ripemd256hmac', searchKeys: const [
      'hashes',
      'hashes_ripemd',
      'hashes_ripemd_256',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const RIPEMD_320(), id: 'hashes_ripemd320', searchKeys: const [
      'hashes',
      'hashes_ripemd',
      'hashes_ripemd_320',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const RIPEMD_320HMac(), id: 'hashes_ripemd320hmac', searchKeys: const [
      'hashes',
      'hashes_ripemd',
      'hashes_ripemd_320',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const MD2(), id: 'hashes_md2', searchKeys: const [
      'hashes',
      'hashes_md2',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const MD2HMac(), id: 'hashes_md2hmac', searchKeys: const [
      'hashes',
      'hashes_md2',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const MD4(), id: 'hashes_md4', searchKeys: const [
      'hashes',
      'hashes_md4',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const MD4HMac(), id: 'hashes_md4hmac', searchKeys: const [
      'hashes',
      'hashes_md4',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const MD5(), id: 'hashes_md5', searchKeys: const [
      'hashes',
      'hashes_md5',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const MD5HMac(), id: 'hashes_md5hmac', searchKeys: const [
      'hashes',
      'hashes_md5',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const Tiger_192(), id: 'hashes_tiger192', searchKeys: const [
      'hashes',
      'hashes_tiger_192',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const Tiger_192HMac(), id: 'hashes_tiger192hmac', searchKeys: const [
      'hashes',
      'hashes_tiger_192',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const Whirlpool_512(), id: 'hashes_whirlpool512', searchKeys: const [
      'hashes',
      'hashes_whirlpool_512',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const Whirlpool_512HMac(), id: 'hashes_whirlpool512hmac', searchKeys: const [
      'hashes',
      'hashes_whirlpool_512',
      'hashes_hmac',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const BLAKE2b_160(), id: 'hashes_blake2b160', searchKeys: const [
      'hashes',
      'hashes_blake2b',
      'hashes_blake2b_160',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const BLAKE2b_224(), id: 'hashes_blake2b224', searchKeys: const [
      'hashes',
      'hashes_blake2b',
      'hashes_blake2b_224',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const BLAKE2b_256(), id: 'hashes_blake2b256', searchKeys: const [
      'hashes',
      'hashes_blake2b',
      'hashes_blake2b_256',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const BLAKE2b_384(), id: 'hashes_blake2b384', searchKeys: const [
      'hashes',
      'hashes_blake2b',
      'hashes_blake2b_384',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),
    GCWTool(tool: const BLAKE2b_512(), id: 'hashes_blake2b512', searchKeys: const [
      'hashes',
      'hashes_blake2b',
      'hashes_blake2b_512',
    ], licenses: [
      stl._toolLicensePointyCastle
    ]),

    // IceCodeSelection *********************************************************************************************
    GCWTool(tool: const IceCodes(), id: 'icecodes', searchKeys: const [
      'icecodes',
    ]),

    //Language Games Selection *******************************************************************************
    GCWTool(tool: const ChickenLanguage(), id: 'chickenlanguage', searchKeys: const [
      'languagegames',
      'languagegames_chickenlanguage',
    ]),
    GCWTool(tool: const DuckSpeak(), id: 'duckspeak', searchKeys: const [
      'languagegames',
      'duckspeak',
    ]),
    GCWTool(tool: const Judoon(), id: 'judoon', searchKeys: const [
      'judoon'
    ], licenses: [
      ToolLicenseOnlineArticle(context: context,
        author: 'Whooligan',
        title: 'Whooligan\'s Judoon Language Translator',
        sourceUrl: 'https://web.archive.org/web/20230311235731/http://www.judoon.com/judoon-translator.php',
      ),
      ToolLicenseOnlineArticle(context: context,
        author: 'Whooligan',
        title: 'Doctor Who Fan Forum',
        sourceUrl: 'http://www.judoon.com/judoon-translator.php',
      )]),
    GCWTool(tool: const PigLatin(), id: 'piglatin', searchKeys: const [
      'languagegames',
      'languagegames_piglatin',
    ]),
    GCWTool(tool: const RobberLanguage(), id: 'robberlanguage', searchKeys: const [
      'languagegames',
      'languagegames_robberlanguage',
    ]),
    GCWTool(tool: const SpoonLanguage(), id: 'spoonlanguage', searchKeys: const [
      'languagegames',
      'languagegames_spoonlanguage',
    ]),

    //Main Menu **********************************************************************************************
    GCWTool(tool: const GeneralSettings(), id: 'settings_general', searchKeys: const []),
    GCWTool(tool: const CoordinatesSettings(), id: 'settings_coordinates', searchKeys: const []),
    GCWTool(tool: const ToolSettings(), id: 'settings_tools', searchKeys: const []),
    GCWTool(tool: const SaveRestoreSettings(), id: 'settings_saverestore', searchKeys: const []),
    GCWTool(tool: const Changelog(), id: 'mainmenu_changelog', suppressHelpButton: true, searchKeys: const [
      'changelog',
    ]),
    GCWTool(tool: const About(), id: 'mainmenu_about', suppressHelpButton: true, searchKeys: const [
      'about',
    ]),
    GCWTool(
        tool: const CallForContribution(),
        id: 'mainmenu_callforcontribution',
        suppressHelpButton: true,
        searchKeys: const [
          'callforcontribution',
        ]),
    GCWTool(tool: const Licenses(), id: 'licenses', suppressHelpButton: true, searchKeys: const [
      'licenses',
    ]),

    //MayaCalendar Selection **************************************************************************************
    GCWTool(tool: const MayaCalendar(), id: 'mayacalendar', searchKeys: const [
      'calendar',
      'maya_calendar',
    ], licenses: const []),

    //MayaNumbers Selection **************************************************************************************
    GCWTool(tool: const MayaNumbers(), id: 'mayanumbers', searchKeys: const [
      'mayanumbers',
    ], licenses: const []),

    //Morse Selection ****************************************************************
    GCWTool(tool: Morse(), id: 'morse', searchKeys: const [
      'morse',
    ]),

    //NumeralWordsSelection ****************************************************************************************
    GCWTool(tool: const NumeralWordsTextSearch(), id: 'numeralwords_textsearch', searchKeys: const [
      'numeralwords',
      'numeralwords_lang',
      'numeralwordstextsearch',
    ]),
    GCWTool(tool: const NumeralWordsLists(), id: 'numeralwords_lists', searchKeys: const [
      'numeralwords',
      'numeralwords_lang',
      'numeralwordslists',
    ]),
    GCWTool(tool: const NumeralWordsConverter(), id: 'numeralwords_converter', searchKeys: const [
      'numeralwords',
      'numeralwordsconverter',
    ]),
    GCWTool(tool: const NumeralWordsIdentifyLanguages(), id: 'numeralwords_identify_languages', searchKeys: const [
      'numeralwords',
      'numeralwords_identifylanguages',
    ]),

    //NumberSequenceSelection ****************************************************************************************
    GCWTool(tool: const NumberSequenceFactorialSelection(), id: 'numbersequence_factorial', searchKeys: const [
      'numbersequence',
      'numbersequence_factorialselection',
    ]),
    GCWTool(tool: const NumberSequenceFibonacciSelection(), id: 'numbersequence_fibonacci', searchKeys: const [
      'numbersequence',
      'numbersequence_fibonacciselection',
    ]),
    GCWTool(tool: const NumberSequenceMersenneSelection(), id: 'numbersequence_mersenne', searchKeys: const [
      'numbersequence',
      'numbersequence_mersenneselection',
    ]),
    GCWTool(
        tool: const NumberSequenceMersennePrimesSelection(),
        id: 'numbersequence_mersenneprimes',
        searchKeys: const [
          'numbersequence',
          'primes',
          'numbersequence_mersenneprimesselection',
        ]),
    GCWTool(tool: const NumberSequencePrimesSelection(), id: 'numbersequence_primes', searchKeys: const [
      'numbersequence',
      'primes',
    ]),
    GCWTool(
        tool: const NumberSequenceMersenneExponentsSelection(),
        id: 'numbersequence_mersenneexponents',
        searchKeys: const [
          'numbersequence',
          'numbersequence_mersenneexponentsselection',
        ]),
    GCWTool(
        tool: const NumberSequenceMersenneFermatSelection(),
        id: 'numbersequence_mersennefermat',
        searchKeys: const [
          'numbersequence',
          'numbersequence_mersennefermatselection',
        ]),
    GCWTool(tool: const NumberSequenceFermatSelection(), id: 'numbersequence_fermat', searchKeys: const [
      'numbersequence',
      'numbersequence_fermatselection',
    ]),
    GCWTool(
        tool: const NumberSequencePerfectNumbersSelection(),
        id: 'numbersequence_perfectnumbers',
        searchKeys: const [
          'numbersequence',
          'numbersequence_perfectnumbersselection',
        ]),
    GCWTool(
        tool: const NumberSequenceSuperPerfectNumbersSelection(),
        id: 'numbersequence_superperfectnumbers',
        searchKeys: const [
          'numbersequence',
          'numbersequence_superperfectnumbersselection',
        ]),
    GCWTool(
        tool: const NumberSequencePrimaryPseudoPerfectNumbersSelection(),
        id: 'numbersequence_primarypseudoperfectnumbers',
        searchKeys: const [
          'numbersequence',
          'numbersequence_primarypseudoperfectnumbersselection',
        ]),
    GCWTool(tool: const NumberSequenceWeirdNumbersSelection(), id: 'numbersequence_weirdnumbers', searchKeys: const [
      'numbersequence',
      'numbersequence_weirdnumbersselection',
    ]),
    GCWTool(
        tool: const NumberSequenceSublimeNumbersSelection(),
        id: 'numbersequence_sublimenumbers',
        searchKeys: const [
          'numbersequence',
          'numbersequence_sublimenumbersselection',
        ]),
    GCWTool(
        tool: const NumberSequencePermutablePrimesSelection(),
        id: 'numbersequence_permutableprimes',
        searchKeys: const [
          'numbersequence',
          'primes',
          'numbersequence_permutableprimesselection',
        ]),
    GCWTool(tool: const NumberSequenceLuckyNumbersSelection(), id: 'numbersequence_luckynumbers', searchKeys: const [
      'numbersequence',
      'numbersequence_luckynumbersselection',
    ]),
    GCWTool(tool: const NumberSequenceHappyNumbersSelection(), id: 'numbersequence_happynumbers', searchKeys: const [
      'numbersequence',
      'numbersequence_happynumbersselection',
    ]),
    GCWTool(tool: const NumberSequenceBellSelection(), id: 'numbersequence_bell', searchKeys: const [
      'numbersequence',
      'numbersequence_bellselection',
    ]),
    GCWTool(tool: const NumberSequencePellSelection(), id: 'numbersequence_pell', searchKeys: const [
      'numbersequence',
      'numbersequence_pellselection',
    ]),
    GCWTool(tool: const NumberSequenceLucasSelection(), id: 'numbersequence_lucas', searchKeys: const [
      'numbersequence',
      'numbersequence_lucasselection',
    ]),
    GCWTool(tool: const NumberSequencePellLucasSelection(), id: 'numbersequence_pelllucas', searchKeys: const [
      'numbersequence',
      'numbersequence_pelllucasselection',
    ]),
    GCWTool(tool: const NumberSequenceJacobsthalSelection(), id: 'numbersequence_jacobsthal', searchKeys: const [
      'numbersequence',
      'numbersequence_jacobsthalselection',
    ]),
    GCWTool(
        tool: const NumberSequenceJacobsthalLucasSelection(),
        id: 'numbersequence_jacobsthallucas',
        searchKeys: const [
          'numbersequence',
          'numbersequence_jacobsthallucasselection',
        ]),
    GCWTool(
        tool: const NumberSequenceJacobsthalOblongSelection(),
        id: 'numbersequence_jacobsthaloblong',
        searchKeys: const [
          'numbersequence',
          'numbersequence_jacobsthaloblongselection',
        ]),
    GCWTool(tool: const NumberSequenceCatalanSelection(), id: 'numbersequence_catalan', searchKeys: const [
      'numbersequence',
      'numbersequence_catalanselection',
    ]),
    GCWTool(tool: const NumberSequenceRecamanSelection(), id: 'numbersequence_recaman', searchKeys: const [
      'numbersequence',
      'numbersequence_recamanselection',
    ]),
    GCWTool(tool: const NumberSequenceLychrelSelection(), id: 'numbersequence_lychrel', searchKeys: const [
      'numbersequence',
      'numbersequence_lychrelselection',
    ]),
    GCWTool(tool: const NumberSequenceBusyBeaverSelection(), id: 'numbersequence_busy_beaver', searchKeys: const [
      'numbersequence',
      'numbersequence_busy_beavernumbersselection',
    ]),

    //NumberSequenceSelection BusyBeaver ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceBusyBeaverNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'busy_beaver_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceBusyBeaverRange(),
        id: 'numbersequence_range',
        id_prefix: 'busy_beaver_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceBusyBeaverCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'busy_beaver_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceBusyBeaverDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'busy_beaver_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceBusyBeaverContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'busy_beaver_',
        searchKeys: const []),

    //NumberSequenceSelection Factorial ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceFactorialNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'factorial_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceFactorialRange(),
        id: 'numbersequence_range',
        id_prefix: 'factorial_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceFactorialCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'factorial_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceFactorialDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'factorial_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceFactorialContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'factorial_',
        searchKeys: const []),

    //NumberSequenceSelection Mersenne-Fermat ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceMersenneFermatNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'mersenne-fermat_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceMersenneFermatRange(),
        id: 'numbersequence_range',
        id_prefix: 'mersenne-fermat_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceMersenneFermatCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'mersenne-fermat_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceMersenneFermatDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'mersenne-fermat_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceMersenneFermatContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'mersenne-fermat_',
        searchKeys: const []),

    //NumberSequenceSelection Fermat ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceFermatNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'fermat_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceFermatRange(),
        id: 'numbersequence_range',
        id_prefix: 'fermat_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceFermatCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'fermat_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceFermatDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'fermat_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceFermatContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'fermat_',
        searchKeys: const []),

    //NumberSequenceSelection Lucas ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceLucasNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'lucas_',
        searchKeys: const []),
    GCWTool(tool: const NumberSequenceLucasRange(), id: 'numbersequence_range', id_prefix: 'lucas_', searchKeys: const [
      'numbersequence_lucasselection',
    ]),
    GCWTool(
        tool: const NumberSequenceLucasCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'lucas_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceLucasDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'lucas_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceLucasContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'lucas_',
        searchKeys: const []),

    //NumberSequenceSelection Fibonacci ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceFibonacciNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'fibonacci_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceFibonacciRange(),
        id: 'numbersequence_range',
        id_prefix: 'fibonacci_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceFibonacciCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'fibonacci_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceFibonacciDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'fibonacci_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceFibonacciContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'fibonacci_',
        searchKeys: const []),

    //NumberSequenceSelection Mersenne ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceMersenneNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'mersenne_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceMersenneRange(),
        id: 'numbersequence_range',
        id_prefix: 'mersenne_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceMersenneCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'mersenne_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceMersenneDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'mersenne_',
        searchKeys: const [
          'numbersequence_mersenneselection',
        ]),
    GCWTool(
        tool: const NumberSequenceMersenneContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'mersenne_',
        searchKeys: const []),

    //NumberSequenceSelection Bell ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceBellNthNumber(), id: 'numbersequence_nth', id_prefix: 'bell_', searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceBellRange(), id: 'numbersequence_range', id_prefix: 'bell_', searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceBellCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'bell_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceBellDigits(), id: 'numbersequence_digits', id_prefix: 'bell_', searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceBellContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'bell_',
        searchKeys: const []),

    //NumberSequenceSelection Pell ****************************************************************************************
    GCWTool(
        tool: const NumberSequencePellNthNumber(), id: 'numbersequence_nth', id_prefix: 'pell_', searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePellRange(), id: 'numbersequence_range', id_prefix: 'pell_', searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePellCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'pell_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePellDigits(), id: 'numbersequence_digits', id_prefix: 'pell_', searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePellContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'pell_',
        searchKeys: const []),

    //NumberSequenceSelection Pell-Lucas ****************************************************************************************
    GCWTool(
        tool: const NumberSequencePellLucasNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'pell_lucas_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePellLucasRange(),
        id: 'numbersequence_range',
        id_prefix: 'pell_lucas_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePellLucasCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'pell_lucas_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePellLucasDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'pell_lucas_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePellLucasContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'pell_lucas_',
        searchKeys: const []),

    //NumberSequenceSelection Jacobsthal ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceJacobsthalNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'jacobsthal_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceJacobsthalRange(),
        id: 'numbersequence_range',
        id_prefix: 'jacobsthal_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceJacobsthalCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'jacobsthal_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceJacobsthalDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'jacobsthal_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceJacobsthalContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'jacobsthal_',
        searchKeys: const []),

    //NumberSequenceSelection Jacobsthal-Lucas ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceJacobsthalLucasNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'jacobsthal_lucas_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceJacobsthalLucasRange(),
        id: 'numbersequence_range',
        id_prefix: 'jacobsthal_lucas_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceJacobsthalLucasCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'jacobsthal_lucas_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceJacobsthalLucasDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'jacobsthal_lucas_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceJacobsthalLucasContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'jacobsthal_lucas_',
        searchKeys: const []),

    //NumberSequenceSelection Jacobsthal Oblong ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceJacobsthalOblongNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'jacobsthal_oblong_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceJacobsthalOblongRange(),
        id: 'numbersequence_range',
        id_prefix: 'jacobsthal_oblong_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceJacobsthalOblongCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'jacobsthal_oblong_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceJacobsthalOblongDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'jacobsthal_oblong_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceJacobsthalOblongContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'jacobsthal_oblong_',
        searchKeys: const []),

    //NumberSequenceSelection Catalan ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceCatalanNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'catalan_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceCatalanRange(),
        id: 'numbersequence_range',
        id_prefix: 'catalan_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceCatalanCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'catalan_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceCatalanDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'catalan_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceCatalanContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'catalan_',
        searchKeys: const []),

    //NumberSequenceSelection Recaman ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceRecamanNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'recaman_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceRecamanRange(),
        id: 'numbersequence_range',
        id_prefix: 'recaman_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceRecamanCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'recaman_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceRecamanDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'recaman_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceRecamanContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'recaman_',
        searchKeys: const []),

    //NumberSequenceSelection Mersenne Primes ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceMersennePrimesNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'mersenne_primes_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceMersennePrimesRange(),
        id: 'numbersequence_range',
        id_prefix: 'mersenne_primes_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceMersennePrimesCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'mersenne_primes_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceMersennePrimesDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'mersenne_primes_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceMersennePrimesContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'mersenne_primes_',
        searchKeys: const []),

    //NumberSequenceSelection Mersenne Exponents ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceMersenneExponentsNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'mersenne_exponents_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceMersenneExponentsRange(),
        id: 'numbersequence_range',
        id_prefix: 'mersenne_exponents_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceMersenneExponentsCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'mersenne_exponents_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceMersenneExponentsDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'mersenne_exponents_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceMersenneExponentsContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'mersenne_exponents_',
        searchKeys: const []),

    //NumberSequenceSelection Perfect numbers ****************************************************************************************
    GCWTool(
        tool: const NumberSequencePerfectNumbersNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'perfect_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePerfectNumbersRange(),
        id: 'numbersequence_range',
        id_prefix: 'perfect_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePerfectNumbersCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'perfect_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePerfectNumbersDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'perfect_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePerfectNumbersContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'perfect_numbers_',
        searchKeys: const []),

    //NumberSequenceSelection SuperPerfect numbers ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceSuperPerfectNumbersNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'superperfect_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceSuperPerfectNumbersRange(),
        id: 'numbersequence_range',
        id_prefix: 'superperfect_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceSuperPerfectNumbersCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'superperfect_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceSuperPerfectNumbersDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'superperfect_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceSuperPerfectNumbersContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'superperfect_numbers_',
        searchKeys: const []),

    //NumberSequenceSelection Weird numbers ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceWeirdNumbersNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'weird_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceWeirdNumbersRange(),
        id: 'numbersequence_range',
        id_prefix: 'weird_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceWeirdNumbersCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'weird_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceWeirdNumbersDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'weird_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceWeirdNumbersContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'weird_numbers_',
        searchKeys: const []),

    //NumberSequenceSelection Sublime numbers ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceSublimeNumbersNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'sublime_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceSublimeNumbersRange(),
        id: 'numbersequence_range',
        id_prefix: 'sublime_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceSublimeNumbersCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'sublime_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceSublimeNumbersDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'sublime_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceSublimeNumbersContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'sublime_numbers_',
        searchKeys: const []),

    //NumberSequenceSelection Lucky numbers ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceLuckyNumbersNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'lucky_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceLuckyNumbersRange(),
        id: 'numbersequence_range',
        id_prefix: 'lucky_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceLuckyNumbersCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'lucky_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceLuckyNumbersDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'lucky_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceLuckyNumbersContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'lucky_numbers_',
        searchKeys: const []),

    //NumberSequenceSelection Happy numbers ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceHappyNumbersNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'happy_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceHappyNumbersRange(),
        id: 'numbersequence_range',
        id_prefix: 'happy_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceHappyNumbersCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'happy_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceHappyNumbersDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'happy_numbers_',
        searchKeys: const []),

    GCWTool(
        tool: const NumberSequenceHappyNumbersContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'happy_numbers_',
        searchKeys: const []),

    //NumberSequenceSelection PseudoPerfect numbers ****************************************************************************************
    GCWTool(
        tool: const NumberSequencePrimaryPseudoPerfectNumbersNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'pseudoperfect_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePrimaryPseudoPerfectNumbersRange(),
        id: 'numbersequence_range',
        id_prefix: 'pseudoperfect_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePrimaryPseudoPerfectNumbersCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'pseudoperfect_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePrimaryPseudoPerfectNumbersDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'pseudoperfect_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePrimaryPseudoPerfectNumbersContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'pseudoperfect_numbers_',
        searchKeys: const []),

    //NumberSequenceSelection Lychrel numbers ****************************************************************************************
    GCWTool(
        tool: const NumberSequenceLychrelNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'lychrel_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceLychrelRange(),
        id: 'numbersequence_range',
        id_prefix: 'lychrel_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceLychrelCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'lychrel_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceLychrelDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'lychrel_numbers_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequenceLychrelContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'lychrel_numbers_',
        searchKeys: const []),

    //NumberSequenceSelection Mersenne Primes ****************************************************************************************
    GCWTool(
        tool: const NumberSequencePermutablePrimesNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'mersenne_primes_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePermutablePrimesRange(),
        id: 'numbersequence_range',
        id_prefix: 'mersenne_primes_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePermutablePrimesCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'mersenne_primes_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePermutablePrimesDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'mersenne_primes_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePermutablePrimesContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'mersenne_primes_',
        searchKeys: const []),

    //NumberSequenceSelection  Primes ****************************************************************************************
    GCWTool(
        tool: const NumberSequencePrimesNthNumber(),
        id: 'numbersequence_nth',
        id_prefix: 'primes_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePrimesRange(),
        id: 'numbersequence_range',
        id_prefix: 'primes_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePrimesCheckNumber(),
        id: 'numbersequence_check',
        id_prefix: 'primes_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePrimesDigits(),
        id: 'numbersequence_digits',
        id_prefix: 'primes_',
        searchKeys: const []),
    GCWTool(
        tool: const NumberSequencePrimesContainsDigits(),
        id: 'numbersequence_containsdigits',
        id_prefix: 'primes_',
        searchKeys: const []),

    //PeriodicTableSelection ***************************************************************************************
    GCWTool(tool: const PeriodicTable(), id: 'periodictable', searchKeys: const [], licenses: const []),
    GCWTool(
        tool: const PeriodicTableDataView(
          atomicNumber: 1,
        ),
        id: 'periodictable_dataview',
        searchKeys: const [
          'periodictabledataview',
        ]),
    GCWTool(tool: const AtomicNumbersToText(), id: 'atomicnumberstotext', searchKeys: const [
      'periodictable_atomicnumbers',
    ]),

    //Phi Selection **********************************************************************************************
    GCWTool(tool: const PhiNthDecimal(), id: 'irrationalnumbers_nthdecimal', id_prefix: 'phi_', searchKeys: const [
      'irrationalnumbers',
      'phidecimalrange',
    ]),
    GCWTool(tool: const PhiDecimalRange(), id: 'irrationalnumbers_decimalrange', id_prefix: 'phi_', searchKeys: const [
      'irrationalnumbers',
      'phidecimalrange',
    ]),
    GCWTool(tool: const PhiSearch(), id: 'irrationalnumbers_search', id_prefix: 'phi_', searchKeys: const [
      'irrationalnumbers',
      'phisearch',
    ]),

    //Pi Selection **********************************************************************************************
    GCWTool(tool: const PiNthDecimal(), id: 'irrationalnumbers_nthdecimal', id_prefix: 'pi_', searchKeys: const [
      'irrationalnumbers',
      'pinthdecimal',
    ]),
    GCWTool(tool: const PiDecimalRange(), id: 'irrationalnumbers_decimalrange', id_prefix: 'pi_', searchKeys: const [
      'irrationalnumbers',
      'pidecimalrange',
    ]),
    GCWTool(tool: const PiSearch(), id: 'irrationalnumbers_search', id_prefix: 'pi_', searchKeys: const [
      'irrationalnumbers',
      'pisearch',
    ]),

    //Predator Selection **************************************************************************************
    GCWTool(tool: const Predator(), id: 'predator', searchKeys: const [
      'predator',
    ], licenses: const []),

    //PrimesSelection **********************************************************************************************
    GCWTool(tool: const NthPrime(), id: 'primes_nthprime', searchKeys: const [
      'primes',
      'primes_nthprime',
    ]),
    GCWTool(tool: const IsPrime(), id: 'primes_isprime', searchKeys: const [
      'primes',
      'primes_isprime',
    ]),
    GCWTool(tool: const NearestPrime(), id: 'primes_nearestprime', searchKeys: const [
      'primes',
      'primes_nearestprime',
    ]),
    GCWTool(tool: const PrimeIndex(), id: 'primes_primeindex', searchKeys: const [
      'primes',
      'primes_primeindex',
    ]),
    GCWTool(tool: const IntegerFactorization(), id: 'primes_integerfactorization', searchKeys: const [
      'primes',
      'primes_integerfactorization',
    ]),

    //ResistorSelection **********************************************************************************************
    GCWTool(tool: const ResistorColorCodeCalculator(), id: 'resistor_colorcodecalculator', searchKeys: const [
      'resistor',
      'color',
      'resistor_colorcode',
    ], licenses: const []),
    GCWTool(tool: const ResistorEIA96(), id: 'resistor_eia96', searchKeys: const [
      'resistor',
      'resistoreia96',
    ], licenses: const []),

    //RomanNumbersSelection **********************************************************************************************
    GCWTool(
      tool: RomanNumbers(),
      id: 'romannumbers',
      searchKeys: const [
        'roman_numbers',
      ],
      deeplinkAlias: const ['roman'],
    ),
    GCWTool(tool: const Chronogram(), id: 'chronogram', searchKeys: const [
      'roman_numbers',
      'chronogram',
    ]),

    //RotationSelection **********************************************************************************************
    GCWTool(tool: Rot13(), id: 'rotation_rot13', searchKeys: const [
      'rotation',
      'rotation_rot13',
    ], deeplinkAlias: const [
      'rot13'
    ]),
    GCWTool(tool: Rot5(), id: 'rotation_rot5', searchKeys: const [
      'rotation',
      'rotation_rot5',
    ], deeplinkAlias: const [
      'rot5'
    ]),
    GCWTool(tool: Rot18(), id: 'rotation_rot18', searchKeys: const [
      'rotation',
      'rotation_rot18',
    ], deeplinkAlias: const [
      'rot18'
    ]),
    GCWTool(tool: Rot47(), id: 'rotation_rot47', searchKeys: const [
      'rotation',
      'rotation_rot47',
    ], deeplinkAlias: const [
      'rot47'
    ]),
    GCWTool(tool: const Rot123(), id: 'rotation_rot123', searchKeys: const [
      'rotation',
      'rotation_rot123',
    ]),
    GCWTool(tool: RotationGeneral(), id: 'rotation_general', searchKeys: const [
      'rotation',
    ], deeplinkAlias: const [
      'rotation',
      'rot',
      'rotx'
    ]),

    // RSA *******************************************************************************************************
    GCWTool(tool: const RSA(), id: 'rsa_rsa', searchKeys: const [
      'rsa',
    ]),
    GCWTool(tool: const RSAEChecker(), id: 'rsa_e.checker', searchKeys: const [
      'rsa',
      'rsa_echecker',
    ]),
    GCWTool(tool: const RSADChecker(), id: 'rsa_d.checker', searchKeys: const [
      'rsa',
      'rsa_dchecker',
    ]),
    GCWTool(tool: const RSADCalculator(), id: 'rsa_d.calculator', searchKeys: const [
      'rsa',
      'rsa_dcalculator',
    ]),
    GCWTool(tool: const RSANCalculator(), id: 'rsa_n.calculator', searchKeys: const [
      'rsa',
      'rsa_ncalculator',
    ]),
    GCWTool(tool: const RSAPhiCalculator(), id: 'rsa_phi.calculator', searchKeys: const ['rsa']),
    GCWTool(tool: const RSAPrimesCalculator(), id: 'rsa_primes.calculator', searchKeys: const ['rsa', 'primes']),

    //Scrabble Selection *****************************************************************************************

    GCWTool(tool: const Scrabble(), id: 'scrabble', searchKeys: const [
      'games_scrabble',
    ], licenses: [
      ToolLicenseOnlineArticle(
        context: context,
        author: 'en.wikipedia.org and contributors',
        title: 'Scrabble letter distributions',
        licenseType: ToolLicenseType.CCBYSA4,
        licenseUrl:
        'https://en.wikipedia.org/w/index.php?title=Wikipedia:Text_of_the_Creative_Commons_Attribution-ShareAlike_4.0_International_License&oldid=1162946924',
        sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Scrabble_letter_distributions&oldid=1231431837',
      ),
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Scrabble',
          licenseType: ToolLicenseType.CCBYSA4,
          licenseUrl:
          'https://web.archive.org/web/20240718115628/https://creativecommons.org/licenses/by-sa/4.0/deed.de',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Scrabble&oldid=245686434'),
    ]),
    GCWTool(tool: const ScrabbleOverview(), id: 'scrabbleoverview', searchKeys: const [
      'games_scrabble',
    ], licenses: [
      ToolLicenseOnlineArticle(
        context: context,
        author: 'en.wikipedia.org and contributors',
        title: 'Scrabble letter distributions',
        licenseType: ToolLicenseType.CCBYSA4,
        licenseUrl:
        'https://en.wikipedia.org/w/index.php?title=Wikipedia:Text_of_the_Creative_Commons_Attribution-ShareAlike_4.0_International_License&oldid=1162946924',
        sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Scrabble_letter_distributions&oldid=1231431837',
      ),
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Scrabble',
          licenseType: ToolLicenseType.CCBYSA4,
          licenseUrl:
          'https://web.archive.org/web/20240718115628/https://creativecommons.org/licenses/by-sa/4.0/deed.de',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Scrabble&oldid=245686434'),
    ]),

    //Miscellaneous Selection *****************************************************************************************

    GCWTool(tool: const GCWizardScript(), id: 'gcwizard_script', isBeta: true, categories: const [
      ToolCategory.MISCELLANEOUS
    ], searchKeys: const [
      'gcwizard_script',
    ], licenses: [
      ToolLicenseOfflineBook(
          context: context,
          author: 'Herbert SChildt',
          title: 'The art of C : elegant programming solutions',
          year: 1991,
          isbn: '978-0078816918',
          publisher: 'McGrawHill',
          customComment: 'No objective letter dated from 2023-01-18'),
      ToolLicenseOnlineBook(
          context: context,
          author: 'Herbert Schildt',
          title: 'The art of C : elegant programming solutions',
          isbn: '978-0078816918',
          publisher: 'McGrawHill',
          year: 1991,
          customComment: 'Page 296ff',
          sourceUrl: 'https://archive.org/details/artofcelegantpro0000schi/mode/2up'),
    ]),

    //Segments Display *******************************************************************************************
    GCWTool(
        tool: const SevenSegments(),
        id: 'segmentdisplay_7segments',
        iconPath: 'lib/tools/science_and_technology/segment_display/7_segment_display/assets/icon_7segment_display.png',
        searchKeys: const [
          'segments',
          'segments_seven',
        ],
        licenses: const []),
    GCWTool(
        tool: const FourteenSegments(),
        id: 'segmentdisplay_14segments',
        iconPath:
        'lib/tools/science_and_technology/segment_display/14_segment_display/assets/icon_14segment_display.png',
        searchKeys: const [
          'segments',
          'segments_fourteen',
        ],
        licenses: const []),
    GCWTool(
        tool: const SixteenSegments(),
        id: 'segmentdisplay_16segments',
        iconPath:
        'lib/tools/science_and_technology/segment_display/16_segment_display/assets/icon_16segment_display.png',
        searchKeys: const [
          'segments',
          'segments_sixteen',
        ],
        licenses: const []),

    //Shadoks Selection ******************************************************************************************
    GCWTool(tool: const ShadoksNumbers(), id: 'shadoksnumbers', searchKeys: const [
      'shadoksnumbers',
    ], licenses: const []),

    //Silver Ratio Selection **********************************************************************************************
    GCWTool(
        tool: const SilverRatioNthDecimal(),
        id: 'irrationalnumbers_nthdecimal',
        id_prefix: 'silver_ration_',
        searchKeys: const [
          'silverratiodecimalrange',
        ]),
    GCWTool(
        tool: const SilverRatioDecimalRange(),
        id: 'irrationalnumbers_decimalrange',
        id_prefix: 'silver_ration_',
        searchKeys: const [
          'silverratiodecimalrange',
        ]),
    GCWTool(
        tool: const SilverRatioSearch(),
        id: 'irrationalnumbers_search',
        id_prefix: 'silver_ration_',
        searchKeys: const [
          'silverratiosearch',
        ]),

    // SlashAndPipeSelection *********************************************************************************************
    GCWTool(tool: const SlashAndPipe(), id: 'slash_and_pipe', searchKeys: const [
      'slash_and_pipe',
    ]),

    //SQRT 2 Selection **********************************************************************************************
    GCWTool(tool: const SQRT2NthDecimal(), id: 'irrationalnumbers_nthdecimal', id_prefix: 'sqrt_2_', searchKeys: const [
      '',
    ]),
    GCWTool(
        tool: const SQRT2DecimalRange(),
        id: 'irrationalnumbers_decimalrange',
        id_prefix: 'sqrt_2_',
        searchKeys: const [
          '',
        ]),
    GCWTool(tool: const SQRT2Search(), id: 'irrationalnumbers_search', id_prefix: 'sqrt_2_', searchKeys: const [
      '',
    ]),

    //SQRT 3 Selection **********************************************************************************************
    GCWTool(tool: const SQRT3NthDecimal(), id: 'irrationalnumbers_nthdecimal', id_prefix: 'sqrt_3_', searchKeys: const [
      '',
    ]),
    GCWTool(
        tool: const SQRT3DecimalRange(),
        id: 'irrationalnumbers_decimalrange',
        id_prefix: 'sqrt_3_',
        searchKeys: const [
          '',
        ]),
    GCWTool(tool: const SQRT3Search(), id: 'irrationalnumbers_search', id_prefix: 'sqrt_3_', searchKeys: const [
      '',
    ]),

    //SQRT 5 Selection **********************************************************************************************
    GCWTool(tool: const SQRT5NthDecimal(), id: 'irrationalnumbers_nthdecimal', id_prefix: 'sqrt_5_', searchKeys: const [
      '',
    ]),
    GCWTool(
        tool: const SQRT5DecimalRange(),
        id: 'irrationalnumbers_decimalrange',
        id_prefix: 'sqrt_5_',
        searchKeys: const [
          '',
        ]),
    GCWTool(tool: const SQRT5Search(), id: 'irrationalnumbers_search', id_prefix: 'sqrt_5_', searchKeys: const [
      '',
    ]),

    //Spelling Alphabets Selection **********************************************************************************************
    GCWTool(tool: const SpellingAlphabetsCrypt(), id: 'spelling_alphabets_crypt', searchKeys: const [
      'spelling_alphabets',
    ]),
    GCWTool(tool: const SpellingAlphabetsList(), id: 'spelling_alphabets_list', searchKeys: const [
      'spelling_alphabets',
    ]),

    //Symbol Tables **********************************************************************************************
    // https://docs.google.com/spreadsheets/d/1yPCPTHXHWqRxkAQFCAktz9E1-dGCiQRHmwwh06h9kWs/edit?gid=0#gid=0
    // TODO get/search/request license and add license information
    // TODO keep google sheet up to date

    GCWTool(tool: const SymbolTableExamplesSelect(), autoScroll: false, id: 'symboltablesexamples', searchKeys: const [
      'symbol',
      'symboltablesexamples',
    ], licenses: const []),
    GCWTool(tool: const SymbolReplacer(), id: 'symbol_replacer', isBeta: true, searchKeys: const [
      'symbol_replacer',
    ], categories: const [
      ToolCategory.GENERAL_CODEBREAKERS
    ], licenses: [
      ToolLicensePortedCode(
          context: context,
          author: 'Zac Forshee',
          title: 'ImageHashing ',
          licenseUrl:
          'https://web.archive.org/web/20240724150805/https://github.com/jforshee/ImageHashing/blob/master/README.md',
          sourceUrl:
          'https://web.archive.org/web/20240000000000*/https://github.com/jforshee/ImageHashing/blob/master/ImageHashing/ImageHashing.cs',
          licenseType: ToolLicenseType.FREE_TO_USE),
    ]),

    GCWSymbolTableTool(symbolKey: 'adlam', symbolSearchStrings: const [
      'symbol_adlam',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Adlam (Schrift)',
          licenseType: ToolLicenseType.CCBYSA4,
          licenseUrl:
          'https://web.archive.org/web/20240718115628/https://creativecommons.org/licenses/by-sa/4.0/deed.de',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Adlam_(Schrift)&oldid=223204639'),
    ]),
    GCWSymbolTableTool(symbolKey: 'albhed', symbolSearchStrings: const [
      'symbol_albhed'
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Al-bhed-fans (deviantart.com)',
          title: 'Al-bhed TTF',
          sourceUrl:
          'https://web.archive.org/web/20231121201318/https://www.deviantart.com/al-bhed-fans/art/Al-bhed-TTF-20702586',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),

    GCWSymbolTableTool(symbolKey: 'alchemy', symbolSearchStrings: const [
      'symbol_alchemy',
    ], licenses: [
      ToolLicenseOnlineArticle(
        context: context,
        author: 'en.wikipedia.org and contributors',
        title: 'Alchemical symbol',
        sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Alchemical_symbol&oldid=1228852947',
        licenseType: ToolLicenseType.CCBYSA4,
      ),
    ]),
    GCWSymbolTableTool(symbolKey: 'alchemy_alphabet', symbolSearchStrings: const [
      'symbol_alchemy_alphabet',
    ], licenses: [
      stl._toolLicenseOnlineBookPolygraphieTrithemius
    ]),
    GCWSymbolTableTool(symbolKey: 'alien_mushrooms', symbolSearchStrings: const [
      'symbol_alien_mushrooms',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Marcel Zellweger (chank.com)',
          title: 'Alien Mushrooms',
          privatePermission: ToolLicensePrivatePermission(
            context: context,
            medium: 'e-mail',
            permissionYear: 2024,
            permissionMonth: 7,
            permissionDay: 25,
          ),
          sourceUrl: 'https://web.archive.org/web/20230610084302/https://chank.com/font-AlienMushrooms',
          licenseType: ToolLicenseType.PRIVATE_PERMISSION)
    ]),
    GCWSymbolTableTool(symbolKey: 'angerthas_cirth', symbolSearchStrings: const [
      'symbol_lordoftherings',
      'symbol_runes',
      'symbol_angerthas_cirth',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
    ]),
    GCWSymbolTableTool(symbolKey: 'alphabetum_arabum', symbolSearchStrings: const [
      'symbol_alphabetum_arabum',
    ], licenses: [
      stl._toolLicenseOnlineBookAlphabetumAlphabetaCharacteres,
    ]),
    GCWSymbolTableTool(symbolKey: 'alphabetum_egiptiorum', symbolSearchStrings: const [
      'symbol_alphabetum_egiptiorum',
    ], licenses: [
      stl._toolLicenseOnlineBookAlphabetumAlphabetaCharacteres,
    ]),
    GCWSymbolTableTool(symbolKey: 'alphabetum_gothicum', symbolSearchStrings: const [
      'symbol_alphabetum_gothicum',
    ], licenses: [
      ToolLicenseOnlineBook(
          context: context,
          author: 'Magnus Olaus',
          title: 'Historia de gentibus septentrionalibus',
          sourceUrl: 'https://web.archive.org/web/20240607153005/https://runeberg.org/olmagnus/0143.html',
          year: 1555,
          licenseType: ToolLicenseType.PUBLIC_DOMAIN,
          customComment: 'Lib. I, Cap. XXXVI, p. 57'),
    ]),
    GCWSymbolTableTool(symbolKey: 'antiker', symbolSearchStrings: const [
      'symbol_antiker',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: '@SFH (stargate.fandom.com)',
          title: 'Ancient alphabet',
          licenseUrl: 'https://web.archive.org/web/20230224043116/https://www.fandom.com/licensing',
          sourceUrl:
          'https://web.archive.org/web/20220609042351/https://stargate.fandom.com/wiki/Ancient_language?file=Ancient_alpahabet.png',
          licenseType: ToolLicenseType.CCBYSA3)
    ]),
    GCWSymbolTableTool(symbolKey: 'arabic_indian_numerals', symbolSearchStrings: const [
      'symbol_arabic_indian_numerals',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Arabische Zahlschrift',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Arabische_Zahlschrift&oldid=246917272',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'arcadian', symbolSearchStrings: const [
      'symbol_arcadian',
    ], licenses: [
      ToolLicenseFont(
        context: context,
        author: 'Skies of Arcadia Island (arcadia.island.free.fr)',
        title: 'La police d\'Arcadia',
        sourceUrl:
        'https://web.archive.org/web/20230628184941/http://arcadia.island.free.fr/down/police.zip',
        licenseType: ToolLicenseType.FREE_TO_USE,
      ),
    ]),
    GCWSymbolTableTool(symbolKey: 'ath', symbolSearchStrings: const [
      'symbol_ath',
    ], licenses: [
      ToolLicenseFont(
        context: context,
        author: 'WurdBentur',
        title: 'Dadh Ath',
        sourceUrl:
        'https://web.archive.org/web/20240808095142/https://www.deviantart.com/wurdbendur/art/Dadh-Ath-9821558',
        licenseType: ToolLicenseType.FREE_TO_USE,
      ),
      ToolLicenseImage(
        context: context,
        author: 'Morioka Hiroyuki',
        title: 'Ath alphabet',
        sourceUrl: 'https://web.archive.org/web/20240808095601/https://www.omniglot.com/conscripts/ath.htm',
        licenseType: ToolLicenseType.PRIVATE_PERMISSION,
        licenseUseType: ToolLicenseUseType.COPY,
        privatePermission: ToolLicensePrivatePermission(
            context: context,
            medium: 'e-mail',
            permissionYear: 2024,
            permissionMonth: 7,
            permissionDay: 31,
            permissionAuthor: 'Simon Ager (Omniglot)'
        ),
      )
    ]),
    GCWSymbolTableTool(symbolKey: 'atlantean', symbolSearchStrings: const [
      'symbol_atlantean',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Typeface',
          title: 'Atlantean',
          sourceUrl: 'https://web.archive.org/web/20240726131815/https://online-fonts.com/fonts/atlantean',
          licenseType: ToolLicenseType.NON_COMMERCIAL,
          licenseUrl: 'https://web.archive.org/web/20211208065631/https://www.high-logic.com/font-license-agreement')
    ]),
    GCWSymbolTableTool(symbolKey: 'aurebesh', symbolSearchStrings: const [
      'symbol_aurebesh',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Pixel Sagas',
          title: 'Aurebesh',
          sourceUrl: 'https://web.archive.org/web/20240221062740/https://www.pixelsagas.com/?download=aurebesh',
          licenseType: ToolLicenseType.FREE_TO_USE,
          licenseUrl: 'https://web.archive.org/web/20240728140247/https://www.pixelsagas.com/?p=55285#comment-92401')
    ]),
    GCWSymbolTableTool(symbolKey: 'australian_sign_language', symbolSearchStrings: const [
      'symbol_signlanguage',
      'symbol_australian_sign_language',
    ], licenses: [
      ToolLicenseOnlineBook(
          context: context,
          author: 'Trevor A Johnston',
          title:
          'Auslan: The Sign Language of the Australian Deaf community. Unpublished doctoral dissertation, University of Sydney, Sydney.',
          year: 1989,
          month: 1,
          day: 1,
          sourceUrl: 'https://web.archive.org/web/20240808102336/https://www.academia.edu/792102')
    ]),
    GCWSymbolTableTool(symbolKey: 'babylonian_numerals', symbolSearchStrings: const [
      'babylonian_numerals',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Babylonian cuneiform numerals',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Babylonian_cuneiform_numerals&oldid=1218528028',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'ballet', symbolSearchStrings: const [
      'symbol_ballet',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'WOODCUTTER',
          title: 'Ballet',
          sourceUrl: 'https://web.archive.org/web/20240808101306/https://www.dafont.com/ballet.font',
          licenseType: ToolLicenseType.FREE_TO_USE,
          customComment: 'dafont.com')
    ]),
    GCWSymbolTableTool(symbolKey: 'barbier', symbolSearchStrings: const [
      'braille',
      'symbol_barbier',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Charles Barbier',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Charles_Barbier&oldid=1216652066',
          licenseType: ToolLicenseType.CCBYSA4),
      ToolLicenseOnlineBook(
          context: context,
          author: 'Charles Barbier',
          title: "Essai sur divers procédés d'expéditive française",
          year: 1815,
          sourceUrl:
          "https://books.google.de/books?id=lkVzrUr1RvEC&q=essai+sur+divers+proc%C3%A9d%C3%A9s+d%27exp%C3%A9ditive+fran%C3%A7aise&pg=PA1&redir_esc=y#v=snippet&q=essai%20sur%20divers%20proc%C3%A9d%C3%A9s%20d'exp%C3%A9ditive%20fran%C3%A7aise&f=false")
    ]),
    GCWSymbolTableTool(symbolKey: 'barcode39', symbolSearchStrings: const [
      'barcodes',
      'barcode39',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'BarcodesInc',
          title: 'Free Barcode Font – Code 39',
          sourceUrl: 'https://web.archive.org/web/20200423103716/https://www.barcodesinc.com/free-barcode-font/',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'base16_02', symbolSearchStrings: const [
      'symbol_base16_02',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Bruce_Martin_hexadecimal_notation_proposal.png',
          sourceUrl:
          'https://en.wikipedia.org/w/index.php?title=Hexadecimal&oldid=1230560724#/media/File:Bruce_Martin_hexadecimal_notation_proposal.png'),
    ]),
    GCWSymbolTableTool(symbolKey: 'base16', symbolSearchStrings: const [
      'base16'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Base-16_digits.svg',
          sourceUrl:
          'https://en.wikipedia.org/w/index.php?title=Hexadecimal&oldid=1230560724#/media/File:Base-16_digits.svg'),
    ]),
    GCWSymbolTableTool(symbolKey: 'baudot_1888', symbolSearchStrings: const [
      'ccitt',
      'symbol_baudot',
      'teletypewriter'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Baudot Code, 1888, US-Patent',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Baudot_code&oldid=1227345731',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'baudot_54123', symbolSearchStrings: const [
      'ccitt',
      'symbol_baudot',
      'teletypewriter'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Baudot Code, 1926, Bit-orderb54123',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Baudot-Code&oldid=245951643',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'bibibinary', symbolSearchStrings: const [
      'bibibinary'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Table_de_correspondance_entre_le_Bibinaire_et_les_autres_notations.svg',
          sourceUrl:
          'https://en.wikipedia.org/w/index.php?title=Bibi-binary&oldid=1218138081#/media/File:Table_de_correspondance_entre_le_Bibinaire_et_les_autres_notations.svg'),
    ]),
    GCWSymbolTableTool(symbolKey: 'billiard_balls', symbolSearchStrings: const [
      'symbol_billiard_balls',
    ], licenses: [
      ToolLicenseImage(
          context: context,
          author: 'Billiard Gear Vector by Cgvector.com',
          title: 'Billiard Balls',
          sourceUrl: 'https://web.archive.org/web/20240524133920/https://www.freevector.com/billiard-balls',
          licenseType: ToolLicenseType.CCBY4,
          licenseUrl: 'https://web.archive.org/web/20240524133455/https://creativecommons.org/licenses/by/4.0/',
          licenseUseType: ToolLicenseUseType.COPY)
    ]),
    GCWSymbolTableTool(symbolKey: 'birds_on_a_wire', symbolSearchStrings: const [
      'symbol_birds_on_a_wire',
    ], licenses: [
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'blox', symbolSearchStrings: const [
      'symbol_blox',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
    ]),
    GCWSymbolTableTool(symbolKey: 'blue_monday', symbolSearchStrings: const [
      'symbol_blue_monday',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'New Order (https://www.youtube.com/watch?v=c1GxjzHm5us)',
          title: 'Song Blue Monday',
          sourceUrl: 'https://geocachen.be/geocaching/geocache-puzzels-oplossen/blue-monday-kleurencode/',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'brahmi_numerals', symbolSearchStrings: const [
      'symbol_brahmi_numerals',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Brahmi numeral signs.svg',
          sourceUrl: 'https://commons.wikimedia.org/w/index.php?title=File:Brahmi_numeral_signs.svg&oldid=831438313'),
    ]),
    GCWSymbolTableTool(symbolKey: 'braille_de', symbolSearchStrings: const [
      'braille',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Brailleschrift',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Brailleschrift&oldid=246388105',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'braille_en', symbolSearchStrings: const [
      'braille',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Braille',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Braille&oldid=1232540524',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'braille_eu', symbolSearchStrings: const [
      'braille',
      'braille_euro',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Computerbraille',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Computerbraille&oldid=236592045',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'braille_fr', symbolSearchStrings: const [
      'braille',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'fr.wikipedia.org and contributors',
          title: 'Braille',
          sourceUrl: 'https://fr.wikipedia.org/w/index.php?title=Braille&oldid=214867784',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'british_sign_language', symbolSearchStrings: const [
      'symbol_signlanguage',
      'symbol_british_sign_language',
    ], licenses: [
      stl._toolLicenseCullyLong,
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'British Sign Language chart.png',
          sourceUrl:
          'https://web.archive.org/web/20220126171505/https://commons.wikimedia.org/wiki/File:British_Sign_Language_chart.png')
    ]),
    GCWSymbolTableTool(symbolKey: 'chain_of_death_direction', symbolSearchStrings: const [
      'symbol_chain_of_death_direction',
    ], licenses: [
      stl._toolLicenseWrixonGeheimsprachen,
    ]),
    GCWSymbolTableTool(symbolKey: 'chain_of_death_pairs', symbolSearchStrings: const [
      'symbol_chain_of_death_pairs',
    ], licenses: [
      stl._toolLicenseWrixonGeheimsprachen,
    ]),
    GCWSymbolTableTool(symbolKey: 'chappe_1794', symbolSearchStrings: const [
      'telegraph',
      'symbol_chappe',
      'symbol_chappe_1794',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Chappe code - c. 1794.svg',
          sourceUrl: 'https://commons.wikimedia.org/w/index.php?title=File:Chappe_code_-_c._1794.svg&oldid=876996749')
    ]),
    GCWSymbolTableTool(symbolKey: 'chappe_1809', symbolSearchStrings: const [
      'telegraph',
      'symbol_chappe',
      'symbol_chappe_1809',
      'zigzag'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Chappe code - c. 1809.svg',
          sourceUrl: 'https://commons.wikimedia.org/w/index.php?title=File:Chappe_code_-_c._1809.svg&oldid=876996757')
    ]),
    GCWSymbolTableTool(symbolKey: 'chappe_v1', symbolSearchStrings: const [
      'telegraph',
      'symbol_chappe',
      'symbol_chappe_v1',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Chappe',
          sourceUrl: 'https://commons.wikimedia.org/w/index.php?title=File:Chappe.svg&oldid=872347070')
    ]),
    GCWSymbolTableTool(symbolKey: 'chappe_v2', symbolSearchStrings: const [
      'telegraph',
      'symbol_chappe',
      'symbol_chappe_v1',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Museum für Post und Telekommunikation',
          title: 'Kupferstich: Optischer Telegraf auf dem Louvre in Paris mit Zeichenalphabet',
          sourceUrl: '',
          customComment: 'Inventarnummer 4.2012.446')
    ]),
    GCWSymbolTableTool(symbolKey: 'foybreguet', symbolSearchStrings: const [
      'telegraph',
      'symbol_chappe',
      'symbol_foybreguet',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Foy–Breguet telegraph',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Foy%E2%80%93Breguet_telegraph&oldid=1169555630')
    ]),
    GCWSymbolTableTool(symbolKey: 'cherokee', symbolSearchStrings: const [
      'symbol_cherokee',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Cherokee language',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Cherokee_language&oldid=1238063152',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'chinese_numerals', symbolSearchStrings: const [
      'symbol_chinese_numerals',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Chinese numerals',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Chinese_numerals&oldid=1233670341',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'christmas', symbolSearchStrings: const [
      'christmas',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Studio Mies',
          title: 'Lettertype Mies Christmas Icons',
          sourceUrl:
          'https://web.archive.org/web/20220726192456/https://www.dafont.com/de/lettertype-mies-christmas-icons.font',
          licenseType: ToolLicenseType.PERSONAL_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'cirth_erebor', symbolSearchStrings: const [
      'symbol_runes',
      'symbol_lordoftherings',
      'symbol_cirtherebor',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Daniel Steven Smith',
          title: 'Cirth Erebor',
          sourceUrl: 'https://web.archive.org/web/20220501000000*/https://dl.dafont.com/dl/?f=cirth_erebor',
          licenseType: ToolLicenseType.NON_COMMERCIAL)
    ]),
    GCWSymbolTableTool(symbolKey: 'cistercian', symbolSearchStrings: const [
      'cistercian',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Cistercian numerals',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Cistercian_numerals&oldid=1213598900',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'clocks_1', symbolSearchStrings: const [
      'symbol_clocks',
    ], licenses: [
      ToolLicenseImage(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Der Clock Code/ das Uhrenalphabet',
          sourceUrl: 'https://web.archive.org/web/20221206164006/https://www.bergziege-owl.de/clock-code/',
          licenseType: ToolLicenseType.FREE_TO_USE,
          licenseUseType: ToolLicenseUseType.COPY)
    ]),
    GCWSymbolTableTool(symbolKey: 'clocks_2_1', symbolSearchStrings: const [
      'symbol_clocks',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'clocks_2_2', symbolSearchStrings: const [
      'symbol_clocks',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'clocks_3', symbolSearchStrings: const [
      'symbol_clocks',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'color_add', symbolSearchStrings: const [
      'color',
      'symbol_color_add',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'color_code', symbolSearchStrings: const [
      'color',
      'symbol_color_code',
    ], licenses: [
      ToolLicenseImage(
          context: context,
          author: 'ColorADD.net',
          title: 'ColorADD - The Color Alphabet',
          privatePermission: ToolLicensePrivatePermission(
              medium: 'e-mail',
              permissionYear: 2024,
              permissionMonth: 8,
              permissionDay: 20,
              context: context,
              permissionAuthor: 'Silvia Couto'
          ),
          sourceUrl:
          'https://web.archive.org/web/20240629170653/https://www.coloradd.net/en/coloradd-code/',
          licenseType: ToolLicenseType.NON_COMMERCIAL,
          licenseUseType: ToolLicenseUseType.COPY)
    ]),
    GCWSymbolTableTool(symbolKey: 'color_honey', symbolSearchStrings: const [
      'color',
      'symbol_color_honey',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Kim Godgul',
          title: '칼라하니(ColorHoney) 알파벳 만들기, 로마자 알파벳을 할당하는 방법',
          sourceUrl: 'https://web.archive.org/web/20090403065210/https://chogul.tistory.com/413',
          year: 2009,
          month: 3,
          day: 3,
          licenseType: ToolLicenseType.CCBYNCND20,
          licenseUrl: 'https://web.archive.org/web/20090408213051/http://creativecommons.org/licenses/by-nc-nd/2.0/kr')
    ]),
    GCWSymbolTableTool(symbolKey: 'color_tokki', symbolSearchStrings: const [
      'color',
      'symbol_color_tokki',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Kim Godgul',
          title: '칼라토끼(ColorTokki) - 칼라하니(ColorHoney)와 쌍둥이',
          sourceUrl: 'https://web.archive.org/web/20240728121027/https://chogul.tistory.com/414',
          year: 2009,
          month: 3,
          day: 3,
          licenseType: ToolLicenseType.CCBYNCND20,
          licenseUrl: 'https://web.archive.org/web/20090408213051/http://creativecommons.org/licenses/by-nc-nd/2.0/kr')
    ]),
    GCWSymbolTableTool(symbolKey: 'cookewheatstone_1', symbolSearchStrings: const [
      'telegraph',
      'symbol_cookewheatstone',
      'symbol_cookewheatstone_1',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Cooke and Wheatstone telegraph',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Cooke_and_Wheatstone_telegraph&oldid=1232265572',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'cookewheatstone_2', symbolSearchStrings: const [
      'telegraph',
      'symbol_cookewheatstone',
      'symbol_cookewheatstone_2',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Cooke and Wheatstone telegraph',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Cooke_and_Wheatstone_telegraph&oldid=1232265572',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'cookewheatstone_5', symbolSearchStrings: const [
      'telegraph',
      'symbol_cookewheatstone',
      'symbol_cookewheatstone_5',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Cooke and Wheatstone telegraph',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Cooke_and_Wheatstone_telegraph&oldid=1232265572',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'cosmic', symbolSearchStrings: const [
      'symbol_cosmic',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Pixel Sagas',
          title: 'Modern Cybertronic',
          sourceUrl:
          'https://web.archive.org/web/20240403144459/https://www.pixelsagas.com/?download=modern-cybertronic',
          licenseType: ToolLicenseType.FREE_TO_USE,
          licenseUrl: 'https://web.archive.org/web/20240728140247/https://www.pixelsagas.com/?p=55285#comment-92401')
    ]),
    GCWSymbolTableTool(symbolKey: 'country_flags', symbolSearchStrings: const [
      'countries',
      'symbol_flags',
      'countries_flags',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'wikipedia.org and contributors',
          title: 'Gallery of sovereign state flags',
          sourceUrl:
          'https://web.archive.org/web/20210109105312/https://en.wikipedia.org/wiki/Gallery_of_sovereign_state_flags',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'covenant', symbolSearchStrings: const [
      'symbol_covenant',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Alex joystikX',
          title: 'COVENANT FONT',
          sourceUrl: 'https://web.archive.org/web/20170616100744/https://www.fonts4free.net/covenant-font.html',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'crystal', symbolSearchStrings: const [
      'symbol_crystal',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'MagnusArania',
          title: 'Crystallic Alphabet',
          sourceUrl:
          'https://web.archive.org/web/20221213100809/https://www.deviantart.com/magnusarania/art/Crystallic-Alphabet-457870324',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'cyrillic', symbolSearchStrings: const [
      'symbol_cyrillic',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'wikipedia.org and contributors',
          title: 'Cyrillic script',
          sourceUrl: 'https://web.archive.org/web/20190330043501/https://en.wikipedia.org/wiki/Cyrillic_script',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'cyrillic_numbers', symbolSearchStrings: const [
      'symbol_cyrillic_numbers',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'wikipedia.org and contributors',
          title: 'Cyrillic script',
          sourceUrl: 'https://web.archive.org/web/20190330043501/https://en.wikipedia.org/wiki/Cyrillic_script',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'daedric', symbolSearchStrings: const [
      'symbol_daedric',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: '@TheRealLurlock (en.uesp.net)',
          title: 'Oblivion',
          year: 2007,
          month: 11,
          day: 29,
          licenseType: ToolLicenseType.FREE_TO_USE,
          licenseUrl:
          'https://web.archive.org/web/20240514014436/https://en.uesp.net/wiki/File:Obliviontt.zip#Licensing',
          sourceUrl: 'httpss://web.archive.org/web/20240514014436/https://en.uesp.net/wiki/File:Obliviontt.zip')
    ]),
    GCWSymbolTableTool(symbolKey: 'dagger', symbolSearchStrings: const [
      'symbol_dagger',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Stefan Baitz',
          year: 1997,
          title: 'Alphabet of Daggers',
          licenseType: ToolLicenseType.NON_COMMERCIAL,
          sourceUrl: 'https://web.archive.org/web/20110714122346/http://www.mouserfonts.com/Files/baitz/dagger.zip',
          customComment: 'License text in source file')
    ]),
    GCWSymbolTableTool(symbolKey: 'dancing_men', symbolSearchStrings: const [
      'symbol_dancing_men',
    ], licenses: [
      ToolLicenseOnlineBook(
          context: context,
          author: 'Arthur Conan Doyle',
          title: 'The Return of Sherlock Holmes - Chapter III: The Adventure of the Dancing Men',
          year: 1905,
          sourceUrl:
          'https://web.archive.org/web/20230310063322/https://en.wikisource.org/wiki/The_Return_of_Sherlock_Holmes/Chapter_3'),
      ToolLicenseOnlineBook(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'The Adventure of the Dancing Men',
          sourceUrl:
          'https://web.archive.org/web/20210108115120/https://en.wikipedia.org/wiki/The_Adventure_of_the_Dancing_Men',
          licenseType: ToolLicenseType.CCBYSA4),
      stl._toolLicenseWrixonGeheimsprachen,
    ]),
    GCWSymbolTableTool(symbolKey: 'deafblind', symbolSearchStrings: const [
      'symbol_signlanguage',
      'symbol_deafblind',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Deafblind Information Australia',
          title: 'Living with Deafblindness. Deafblind Manual Alphabet',
          sourceUrl:
          'https://web.archive.org/web/20240808104641/https://www.deafblindinformation.org.au/living-with-deafblindness/deafblind-communication/deafblind-manual-alphabet/'),
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Two-handed manual alphabets',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Two-handed_manual_alphabets&oldid=1182989428',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'devanagari_numerals', symbolSearchStrings: const [
      'symbol_devanagari_numerals',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Devanagari numerals',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Devanagari_numerals&oldid=1220470774',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'dinotopia', symbolSearchStrings: const [
      'symbol_dinotopia',
    ], licenses: [
      ToolLicenseOfflineBook(
          context: context,
          author: 'James Gurney',
          title: 'Dinotopia: The World Beneath',
          year: 1995,
          isbn: '9781570361647',
          publisher: 'Turner Publishing'),
      ToolLicenseFont(
          context: context,
          author: 'Mike H. Lee, Josh Dixon',
          title: 'Dinotopian',
          year: 1998,
          sourceUrl:
          'https://web.archive.org/web/20210923113944/https://www.oocities.org/timessquare/4965/sffont.html#dino',
          licenseType: ToolLicenseType.FREE_TO_USE,
          customComment: 'License text in first section of the website')
    ]),
    GCWSymbolTableTool(symbolKey: 'dni', symbolSearchStrings: const [
      'symbol_dni',
    ], licenses: [
      stl._toolLicenseDni
    ]),
    GCWSymbolTableTool(symbolKey: 'dni_colors', symbolSearchStrings: const [
      'color',
      'symbol_dni_colors',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: ' Robin Lionheart',
          year: 2001,
          title: 'D\'ni Color Symbols',
          sourceUrl: 'https://web.archive.org/web/20220929100934/http://www.robinlionheart.com/conlang/dnicolors'),
      stl._toolLicenseDni
    ]),
    GCWSymbolTableTool(symbolKey: 'dni_numbers', symbolSearchStrings: const [
      'symbol_dni_numbers',
    ], licenses: [
      stl._toolLicenseDni
    ]),
    GCWSymbolTableTool(symbolKey: 'doop_speak', symbolSearchStrings: const [
      'symbol_doop',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'West Wind Fonts',
          title: '"Roswell Wreckage" Font',
          sourceUrl:
          'https://web.archive.org/web/20240729163459/https://blambot.com/collections/dialogue-fonts/products/roswell-wreckage?variant=20500735164470',
          licenseType: ToolLicenseType.FREE_TO_USE,
          customComment: 'for Non-profit/ Indie Comics')
    ]),
    GCWSymbolTableTool(symbolKey: 'dorabella', symbolSearchStrings: const [
      'symbol_dorabella',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Dorabella',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Dorabella_Cipher&oldid=1227166448',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'doremi', symbolSearchStrings: const [
      'symbol_doremi',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Solresol',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Solresol&oldid=242474951',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'dragon_language', symbolSearchStrings: const [
      'symbol_dragon_language',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Matthew Luckow',
          title: 'Dragon Alphabet Font',
          sourceUrl: 'https://web.archive.org/web/20230324082609/https://www.fontget.com/font/dragon-alphabet/',
          licenseType: ToolLicenseType.PERSONAL_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'dragon_runes', symbolSearchStrings: const [
      'symbol_dragon_runes',
    ], licenses: [
      stl._toolLicenseCullyLong,
    ]),
    GCWSymbolTableTool(symbolKey: 'eastern_arabic_indian_numerals', symbolSearchStrings: const [
      'symbol_eastern_arabic_indian_numerals',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Arabische Zahlschrift',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Arabische_Zahlschrift&oldid=246917272',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'egyptian_numerals', symbolSearchStrings: const [
      'symbol_egyptian_numerals',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Egyptian numerals',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Egyptian_numerals&oldid=1222065795',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'elia', symbolSearchStrings: const [
      'elia',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'enochian', symbolSearchStrings: const [
      'symbol_enochian',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Enochian',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Enochian&oldid=1232294087',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'eternity_code', symbolSearchStrings: const [
      'symbol_eternity_code',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'eurythmy', symbolSearchStrings: const [
      'symbol_eurythmy',
    ], licenses: [
      ToolLicenseImage(
          context: context,
          author: 'Rudolf Steiner Verlag',
          title: 'Eurythmiefiguren',
          privatePermission: ToolLicensePrivatePermission(
            medium: 'e-mail',
            permissionYear: 2020,
            permissionMonth: 11,
            permissionDay: 14,
            context: context,
          ),
          sourceUrl:
          'https://web.archive.org/web/20210731034944/https://www.anthroposophie-muenchen.de/eurythmiefiguren',
          licenseType: ToolLicenseType.NON_COMMERCIAL,
          licenseUseType: ToolLicenseUseType.COPY)
    ]),
    GCWSymbolTableTool(symbolKey: 'face_it', symbolSearchStrings: const [
      'symbol_face_it',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'West Wind Fonts',
          title: 'Face it!',
          sourceUrl: 'https://web.archive.org/web/20200929020901/https://www.fontspace.com/face-it-font-f10791',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'fakoo', symbolSearchStrings: const [
      'symbol_fakoo',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Alexander Fakoó',
          title: 'FAKOO.DE',
          sourceUrl: 'https://web.archive.org/web/20240808105937/https://fakoo.de/',
          licenseType: ToolLicenseType.CCBYNCND40)
    ]),
    GCWSymbolTableTool(symbolKey: 'fantastic', symbolSearchStrings: const [
      'symbol_fantastic',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Nederlandse fantasia Wiki',
          title: 'Fantastisch',
          sourceUrl:
          'https://web.archive.org/web/20240714203824/https://nederlandse-fantasia.fandom.com/wiki/Fantastisch',
          licenseType: ToolLicenseType.CCBYSA3)
    ]),
    GCWSymbolTableTool(symbolKey: 'fez', symbolSearchStrings: const [
      'symbol_fez',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'CalTrask',
          title: 'Zuish',
          sourceUrl: 'https://web.archive.org/web/20240808110634/https://www.dafont.com/zuish.font',
          licenseType: ToolLicenseType.FREE_TO_USE,
          customComment: 'dafont.com')
    ]),
    GCWSymbolTableTool(symbolKey: 'finger', symbolSearchStrings: const [
      'symbol_signlanguage',
      'symbol_finger',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Fingeralphabet',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Fingeralphabet&oldid=247429082',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'finger_numbers', symbolSearchStrings: const [
      'symbol_signlanguage',
      'symbol_finger_numbers',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Fingeralphabet',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Fingeralphabet&oldid=247429082',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'flags', symbolSearchStrings: const [
      'symbol_flags',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'International maritime signal flags',
          sourceUrl: 'https://en.wikipedia.org/wiki/International_maritime_signal_flags',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'flags_german_kriegsmarine', symbolSearchStrings: const [
      'symbol_flags',
      'symbol_flags_german_kriegsmarine',
    ], licenses: [
      ToolLicenseOfflineBook(
          context: context,
          author: 'Andreas Herzfeld',
          title: 'Die Signalflaggen und Signalbücher deutscher Kriegs- und Handelsmarinen seit 1815',
          isbn: '978-3-935131-16-2'),
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Andreas Herzfeld',
          title: 'Die Signalflaggen und Signalbücher deutscher Kriegs- und Handelsmarinen seit 1815',
          sourceUrl: 'https://web.archive.org/web/20240808112049/https://dr-herzfeld.de/signalflaggen/index.htm')
    ]),
    GCWSymbolTableTool(symbolKey: 'flags_nato', symbolSearchStrings: const [
      'symbol_flags',
      'symbol_flags_nato',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'International maritime signal flags',
          sourceUrl: 'https://en.wikipedia.org/wiki/International_maritime_signal_flags',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'flags_rn_howe', symbolSearchStrings: const [
      'symbol_flags',
      'symbol_flags_rn_howe',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          publisher: 'Project Gutenberg',
          author: 'W. G. Perrin',
          title: 'The Project Gutenberg EBook of British Flags',
          sourceUrl:
          'https://web.archive.org/web/20240723212351/https://www.gutenberg.org/files/46370/46370-h/46370-h.htm')
    ]),
    GCWSymbolTableTool(symbolKey: 'flags_rn_marryat', symbolSearchStrings: const [
      'symbol_flags',
      'symbol_flags_rn_marryat',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Maritime flag signalling',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Maritime_flag_signalling&oldid=1176428184',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'flags_rn_popham', symbolSearchStrings: const [
      'symbol_flags',
      'symbol_flags_rn_popham',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          publisher: 'Project Gutenberg',
          author: 'W. G. Perrin',
          title: 'The Project Gutenberg EBook of British Flags',
          sourceUrl:
          'https://web.archive.org/web/20240723212351/https://www.gutenberg.org/files/46370/46370-h/46370-h.htm'),
      ToolLicenseOnlineBook(
          context: context,
          author: 'Sir Home Riggs Popham',
          title: 'Telegraphic Signals; Or Marine Vocabulary',
          publisher: 'T. Egerton, Military Library, near Whitehall',
          year: 1803,
          sourceUrl: 'https://archive.org/details/bub_gb_qxZEAAAAYAAJ/page/n5/mode/2up')
    ]),
    GCWSymbolTableTool(symbolKey: 'fonic', symbolSearchStrings: const [
      'symbol_fonic',
    ], licenses: [
      ToolLicenseImage(
        context: context,
        author: 'Unknown',
        title: 'Fonic',
        sourceUrl: 'https://web.archive.org/web/20200814001421/https://www.omniglot.com/conscripts/fonime.htm',
        licenseType: ToolLicenseType.PRIVATE_PERMISSION,
        licenseUseType: ToolLicenseUseType.COPY,
        privatePermission: ToolLicensePrivatePermission(
            context: context,
            medium: 'e-mail',
            permissionYear: 2024,
            permissionMonth: 7,
            permissionDay: 31,
            permissionAuthor: 'Simon Ager (Omniglot)'
        ),
      )
    ]),
    GCWSymbolTableTool(symbolKey: 'four_triangles', symbolSearchStrings: const [
      'symbol_four_triangles',
    ], licenses: [
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'freemason', symbolSearchStrings: const [
      'symbol_freemason',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Pigpen cipher',
          sourceUrl: 'https://commons.wikimedia.org/w/index.php?title=Category:Pigpen_cipher&oldid=334624960')
    ]),
    GCWSymbolTableTool(symbolKey: 'freemason_v2', symbolSearchStrings: const [
      'symbol_freemason'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Pigpen cipher',
          sourceUrl: 'https://commons.wikimedia.org/w/index.php?title=Category:Pigpen_cipher&oldid=334624960')
    ]),
    GCWSymbolTableTool(symbolKey: 'futhark_elder', symbolSearchStrings: const [
      'symbol_runes',
      'symbol_futhark'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Elder Futhark',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Elder_Futhark&oldid=1236807910',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'futhark_younger', symbolSearchStrings: const [
      'symbol_runes',
      'symbol_futhark'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Younger Futhark',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Younger_Futhark&oldid=1226247571',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'futhorc', symbolSearchStrings: const [
      'symbol_runes',
      'symbol_futhark',
      'symbol_futhorc'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Anglo-Saxon runes',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Anglo-Saxon_runes&oldid=1231842934',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'futurama', symbolSearchStrings: const [
      'symbol_futurama',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Darrell Johnson, Leandro Pardini',
          title: 'Futurama Alien Alphabet One',
          sourceUrl: 'https://web.archive.org/web/20190704113955/www.futurama-madhouse.net/fonts/index.shtml',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'futurama_2', symbolSearchStrings: const [
      'symbol_futurama_2',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Leandro Pardini',
          title: 'Futurama Alien Alphabet Two',
          sourceUrl: 'https://web.archive.org/web/20190704113955/www.futurama-madhouse.net/fonts/index.shtml',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'gallifreyan', symbolSearchStrings: const [
      'symbol_gallifreyan',
    ], licenses: [
      ToolLicenseImage(
          context: context,
          author: 'wikiHow Staff',
          title: 'Gallifreyisch schreiben wie Doktor Who',
          sourceUrl:
          'https://web.archive.org/web/20150725002038/https://de.wikihow.com/Gallifreyisch-schreiben-wie-Doktor-Who',
          licenseUseType: ToolLicenseUseType.REPRODUCTION,
          licenseType: ToolLicenseType.REPRODUCTION_NEEDED)
    ]),
    GCWSymbolTableTool(symbolKey: 'gargish', symbolSearchStrings: const [
      'symbol_gargish',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Pixel Sagas',
          title: 'Gargish Font',
          sourceUrl: 'https://web.archive.org/web/20200919013856/https://www.pixelsagas.com/?download=gargish',
          licenseType: ToolLicenseType.PERSONAL_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'gc_attributes_ids', symbolSearchStrings: const [
      'symbol_gc_attributes',
    ], licenses: [
      ToolLicenseImage(
        context: context,
        author: 'Geocaching HQ',
        title: 'Attributes',
        sourceUrl: 'https://web.archive.org/web/20240728194855/https://www.geocaching.com/about/icons.aspx',
        licenseUseType: ToolLicenseUseType.REPRODUCTION,
        licenseType: ToolLicenseType.REPRODUCTION_NEEDED,
      ),
      stl._toolLicenseCullyLong,
    ]),
    GCWSymbolTableTool(symbolKey: 'gc_attributes_meaning', symbolSearchStrings: const [
      'symbol_gc_attributes',
    ], licenses: [
      ToolLicenseImage(
        context: context,
        author: 'Geocaching HQ',
        title: 'Attributes',
        sourceUrl: 'https://web.archive.org/web/20240728194855/https://www.geocaching.com/about/icons.aspx',
        licenseUseType: ToolLicenseUseType.REPRODUCTION,
        licenseType: ToolLicenseType.REPRODUCTION_NEEDED,
      ),
      stl._toolLicenseCullyLong,
    ]),
    GCWSymbolTableTool(
      symbolKey: 'geovlog',
      symbolSearchStrings: const [
        'symbol_geovlog',
      ],
      licenses: [
        ToolLicenseImage(
          context: context,
          author: 'GC Rogier (GeoVlogs.nl)',
          title: 'GEOVLOGS-code',
          sourceUrl: 'https://web.archive.org/web/20240223141316/https://www.geovlogs.nl/geovlogs-code/',
          privatePermission: ToolLicensePrivatePermission(
            context: context,
            medium: 'e-mail',
            permissionYear: 2024,
            permissionMonth: 6,
            permissionDay: 14,
          ),
          licenseType: ToolLicenseType.PRIVATE_PERMISSION,
          licenseUseType: ToolLicenseUseType.COPY,
        )
      ],
    ),
    GCWSymbolTableTool(symbolKey: 'gernreich', symbolSearchStrings: const [
      'symbol_gernreich',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
    ]),
    GCWSymbolTableTool(symbolKey: 'gerudo', symbolSearchStrings: const [
      'zelda',
      'symbol_gerudo',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Sarinilli',
          title: 'Gerudo Typography - Font',
          sourceUrl:
          'https://web.archive.org/web/20200906044202/https://www.deviantart.com/sarinilli/art/Gerudo-Typography-Font-278213135',
          licenseType: ToolLicenseType.PERSONAL_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'glagolitic', symbolSearchStrings: const [
      'symbol_gnommish',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Glagolitische Schrift',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Glagolitische_Schrift&oldid=242590359',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'gnommish', symbolSearchStrings: const [], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Sylvarmyst',
          title: 'Gnommish',
          sourceUrl:
          'https://web.archive.org/web/20240730050939/https://fontstruct.com/fontstructions/show/677781/gnommish_31',
          licenseType: ToolLicenseType.CCBYSA3)
    ]),
    GCWSymbolTableTool(symbolKey: 'greek_numerals', symbolSearchStrings: const [
      'symbol_greek_numerals',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'wikipedia.org and contributors',
          title: 'Greek numerals',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Greek_numerals&oldid=1236399172',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'hangul_korean', symbolSearchStrings: const [
      'symbol_hangul',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'wikipedia.org and contributors',
          title: 'Hangul',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Hangul&oldid=1236544404',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'hangul_sino_korean', symbolSearchStrings: const [
      'symbol_hangul',
      'symbol_sino_korean',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'wikipedia.org and contributors',
          title: 'Sino Korean numbers',
          sourceUrl: 'https://www.koreanwikiproject.com/wiki/index.php?title=Sino_Korean_numbers&oldid=30107',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'hanja', symbolSearchStrings: const [
      'symbol_hanja',
      'symbol_sino_korean',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'wikipedia.org and contributors',
          title: 'Korean numerals',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Korean_numerals&oldid=1229158459',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'hazard', symbolSearchStrings: const [
      'symbol_hazard',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'hebrew', symbolSearchStrings: const [
      'symbol_hebrew',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'hebrew_v2', symbolSearchStrings: const [
      'symbol_hebrew_v2',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'hexahue', symbolSearchStrings: const [
      'color',
      'symbol_hexahue',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'hieratic_numerals', symbolSearchStrings: const [
      'symbol_hieratic_numerals',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'hieroglyphs', symbolSearchStrings: const [
      'symbol_hieroglyphs',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'hieroglyphs_v2', symbolSearchStrings: const [
      'symbol_hieroglyphs',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'hobbit_runes', symbolSearchStrings: const [
      'symbol_lordoftherings',
      'symbol_runes',
      'symbol_hobbit_runes',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Unknown author',
          title: 'Tolkien Dwarf Runes',
          sourceUrl: 'https://web.archive.org/web/20170615235150/http://www.fonts2u.com/tolkien-dwarf-runes.font',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'hvd', symbolSearchStrings: const [
      'symbol_hvd',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
    ]),
    GCWSymbolTableTool(symbolKey: 'hylian_64', symbolSearchStrings: const [
      'zelda',
      'symbol_hylian_64',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Ocarina of Time/Majora' 's Mask',
          title: 'Hylian 64',
          sourceUrl: 'https://web.archive.org/web/20200406201743/https://www.zeldaxtreme.com/fonts/',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'hylian_albw_botw', symbolSearchStrings: const [
      'zelda',
      'symbol_hylian_albw_botw',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Plaguelily',
          title: 'ABLW BOTW HYLIAN',
          sourceUrl: 'https://web.archive.org/web/20200406201743/https://www.zeldaxtreme.com/fonts/',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'hylian_skyward_sword', symbolSearchStrings: const [
      'zelda',
      'symbol_hylian_skywardsword',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Sarinilli',
          title: 'SS ANCIENT HYLIAN',
          sourceUrl: 'https://web.archive.org/web/20200406201743/https://www.zeldaxtreme.com/fonts/',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'hylian_symbols', symbolSearchStrings: const [
      'zelda',
      'symbol_hylian_symbols',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Various Zelda Games',
          title: 'Hylian Symbols',
          sourceUrl: 'https://web.archive.org/web/20200406201743/https://www.zeldaxtreme.com/fonts/',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'hylian_twilight_princess_gcn', symbolSearchStrings: const [
      'zelda',
      'symbol_hylian_twilightprincess_gcn',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Unknown',
          title: 'TP HYLIAN',
          sourceUrl: 'https://web.archive.org/web/20200406201743/https://www.zeldaxtreme.com/fonts/',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'hylian_twilight_princess_wii', symbolSearchStrings: const [
      'zelda',
      'symbol_hylian_twilightprincess_wii',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Martin Anderson - mdta Design',
          title: 'TP Hylian - Wii Regular Fonts Free Downloads',
          sourceUrl:
          'https://web.archive.org/web/20240730150257/https://www.onlinewebfonts.com/download/722c88b417177812725b0943f5470a72',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'hylian_wind_waker', symbolSearchStrings: const [
      'zelda',
      'symbol_hylian_windwaker',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Sarinilli',
          title: 'ANCIENT HYLIAN',
          sourceUrl: 'https://web.archive.org/web/20200406201743/https://www.zeldaxtreme.com/fonts/',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'hymmnos', symbolSearchStrings: const [
      'symbol_hymmnos',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'ice_lolly_ding', symbolSearchStrings: const [
      'symbol_icelolly',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Michaela Peretti',
          title: 'Ice Lolly Ding',
          sourceUrl: 'https://web.archive.org/web/20210730110407/https://www.1001freefonts.com/de/ice-lolly-ding.font',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'icecodes', symbolSearchStrings: const [
      'icecodes',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'iching', symbolSearchStrings: const [
      'symbol_iching',
    ], licenses: [
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'illuminati_v1', symbolSearchStrings: const [
      'symbol_illuminati',
      'symbol_illuminati_v1',
    ], licenses: [
      stl._toolLicenseCullyLong,
    ]),
    GCWSymbolTableTool(symbolKey: 'illuminati_v2', symbolSearchStrings: const [
      'symbol_illuminati',
      'symbol_illuminati_v2',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Berlin Version Font',
          title: 'Illuminati Dirigens Cipher',
          sourceUrl: 'https://fontmeme.com/fonts/illuminati-dirigens-cipher-berlin-version-font/',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'intergalactic', symbolSearchStrings: const [
      'symbol_intergalactic',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Aaqil A. Azhar (Foneer)',
          title: 'Robotica SGA',
          sourceUrl:
          'https://web.archive.org/web/20240730195127/https://fontstruct.com/fontstructions/show/2324755/robotica-sga',
          licenseType: ToolLicenseType.NON_COMMERCIAL)
    ]),
    GCWSymbolTableTool(symbolKey: 'interlac', symbolSearchStrings: const [
      'symbol_interlac',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'blue panther',
          title: 'Interlac Font',
          sourceUrl:
          'https://web.archive.org/web/20191026172055/https://legionfonts.com/fonts/interlac--by-blue-panther-',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'iokharic', symbolSearchStrings: const [
      'symbol_iokharic',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Pixel Sagas',
          title: 'Iokharic',
          sourceUrl: 'https://web.archive.org/web/20201001220330/https://www.fonts4free.net/iokharic-font.html',
          licenseType: ToolLicenseType.PERSONAL_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'iso7010_firesafety', symbolSearchStrings: const [
      'iso7010',
      'iso7010_firesafety'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Brandschutzzeichen',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Brandschutzzeichen&oldid=244450333',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'iso7010_mandatory', symbolSearchStrings: const [
      'iso7010',
      'iso7010_mandatory'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Gebotszeichen',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Gebotszeichen&oldid=244450314',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'iso7010_prohibition', symbolSearchStrings: const [
      'iso7010',
      'iso7010_prohibition'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Verbotszeichen',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Verbotszeichen&oldid=244450293',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'iso7010_safecondition', symbolSearchStrings: const [
      'iso7010',
      'iso7010_safecondition'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Rettungszeichen',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Rettungszeichen&oldid=244450083',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'iso7010_warning', symbolSearchStrings: const [
      'iso7010',
      'iso7010_warning'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Warnzeichen',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Warnzeichen&oldid=242647614',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'ita1_1926', symbolSearchStrings: const [
      'ccitt',
      'symbol_baudot',
      'teletypewriter'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Baudot code',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Baudot_code&oldid=1237256507',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'ita2_1929', symbolSearchStrings: const [
      'ccitt',
      'symbol_murray',
      'teletypewriter'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Geocaching Toolbox',
          title: 'Optical telegraph (Murray)',
          sourceUrl:
          'https://web.archive.org/web/20200621050813/https://www.geocachingtoolbox.com/index.php?lang=en&page=codeTables&id=shutterTelegraph',
          licenseType: ToolLicenseType.CCNC30)
    ]),
    GCWSymbolTableTool(
        symbolKey: 'ita2_1931',
        symbolSearchStrings: const ['ccitt', 'symbol_murray', 'teletypewriter'],
        licenses: const []),
    GCWSymbolTableTool(symbolKey: 'japanese_numerals', symbolSearchStrings: const [
      'japanese_numerals',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'kabouter_abc', symbolSearchStrings: const [
      'symbol_kabouter_abc',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Pascal van Boxel',
          title: 'Kabouter-ABC',
          sourceUrl: 'https://web.archive.org/web/20200808071342/https://nl.scoutwiki.org/Kabouter-ABC',
          licenseUrl:
          'https://web.archive.org/web/20200810033013/https://creativecommons.org/licenses/by-nc-sa/4.0/deed.nl',
          licenseType: ToolLicenseType.CCBYNC40),
    ]),
    GCWSymbolTableTool(symbolKey: 'kabouter_abc_1947', symbolSearchStrings: const [
      'symbol_kabouter_abc_1947',
    ], licenses: [
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'kartrak', symbolSearchStrings: const [
      'color',
      'barcodes',
      'railways',
      'symbol_kartrak',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'KarTrak',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=KarTrak&oldid=1231296757',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'kaktovik', symbolSearchStrings: const [
      'symbol_kaktovik',
      'zigzag'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Kaktovik numerals',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Kaktovik_numerals&oldid=1236877061',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'kharoshthi', symbolSearchStrings: const [
      'symbol_kharoshthi',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Kharosthi',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Kharosthi&oldid=1234511037')
    ]),
    GCWSymbolTableTool(symbolKey: 'klingon', symbolSearchStrings: const [
      'symbol_klingon',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Unknown',
          title: 'KLINGON',
          sourceUrl: 'https://web.archive.org/web/20170614203232/https://de.fonts2u.com/klingon.schriftart',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'klingon_klinzhai', symbolSearchStrings: const [
      'symbol_klingon',
      'symbol_klingon_klinzhai',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'PsychoGlyph',
          title: 'Klinzhai font',
          sourceUrl: 'https://web.archive.org/web/20210227191441/https://www.whatfontis.com/FF_Klinzhai.font',
          licenseType: ToolLicenseType.PERSONAL_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'krempel', symbolSearchStrings: const [
      'color',
      'symbol_krempel',
    ], licenses: [
      ToolLicenseImage(
          context: context,
          author: 'Ralf Krempel',
          title: 'Krempel-Code',
          sourceUrl: 'https://web.archive.org/web/20240731053812/https://de.everybodywiki.com/Krempel-Code',
          licenseUseType: ToolLicenseUseType.REPRODUCTION,
          licenseType: ToolLicenseType.REPRODUCTION_NEEDED)
    ]),
    GCWSymbolTableTool(symbolKey: 'krypton', symbolSearchStrings: const [
      'symbol_krypton',
    ], licenses: [
      stl._toolLicenseCullyLong,
    ]),
    GCWSymbolTableTool(symbolKey: 'kurrent', symbolSearchStrings: const [
      'symbol_kurrent',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Kurrent',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Kurrent&oldid=1205126071',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'la_buse', symbolSearchStrings: const [
      'symbol_freemason',
      'symbol_la_buse',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Jérémie Dupuis',
          title: 'Pigpen Cipher Font',
          sourceUrl: 'https://fontmeme.com/fonts/pigpen-cipher-font/',
          licenseType: ToolLicenseType.FREE_TO_USE),
    ]),
    GCWSymbolTableTool(symbolKey: 'linear_b', symbolSearchStrings: const [
      'symbol_linear_b',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Unknown',
          title: 'Noto Sans Linear B',
          sourceUrl: 'https://fonts.google.com/noto/specimen/Noto+Sans+Linear+B',
          licenseType: ToolLicenseType.SIL_OFL11)
    ]),
    GCWSymbolTableTool(symbolKey: 'lorm', symbolSearchStrings: const [
      'symbol_signlanguage',
      'symbol_lorm',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Alexander Fakoó',
          title: 'The Lorm Alphabet',
          sourceUrl: 'https://web.archive.org/web/20211202070642/https://fakoo.de/en/lorm.html',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'magicode', symbolSearchStrings: const [
      'symbol_magicode',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
    ]),
    GCWSymbolTableTool(symbolKey: 'malachim', symbolSearchStrings: const [
      'symbol_malachim',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Malachim',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Malachim&oldid=1217968821',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'mandalorian', symbolSearchStrings: const [
      'symbol_mandalorian',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Erikstormtrooper',
          title: 'Mandalorian Font',
          sourceUrl: 'https://web.archive.org/web/20170725020609/http://www.erikstormtrooper.com/mandalorian.htm',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'marain', symbolSearchStrings: const [
      'symbol_marain',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'TTFTCUTS',
          title: 'Marain',
          sourceUrl:
          'https://web.archive.org/web/20210823033202/https://fontstruct.com/fontstructions/show/1446008/marain-5',
          licenseType: ToolLicenseType.CCBYSA3)
    ]),
    GCWSymbolTableTool(symbolKey: 'marain_v2', symbolSearchStrings: const [
      'symbol_marain_v2',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'TTFTCUTS',
          title: 'Marain Dots',
          sourceUrl:
          'https://web.archive.org/web/20240801172315/https://fontstruct.com/fontstructions/show/1445997/marain-dots',
          licenseType: ToolLicenseType.CCBYSA3)
    ]),
    GCWSymbolTableTool(symbolKey: 'matoran', symbolSearchStrings: const [
      'symbol_matoran',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'daniel-u-thibault',
          title: 'Matoran',
          sourceUrl: 'https://web.archive.org/web/20160320142824/https://fonts2u.com/matoran.font#google_vignette',
          licenseType: ToolLicenseType.PERSONAL_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'maya_calendar_longcount', symbolSearchStrings: const [
      'calendar',
      'symbol_maya_calendar_longcount',
    ], licenses: [
      stl._toolLicenseMayaGlyphsWikisource,
    ]),
    GCWSymbolTableTool(symbolKey: 'maya_calendar_haab_codices', symbolSearchStrings: const [
      'calendar',
      'symbol_maya_calendar_haab',
    ], licenses: [
      stl._toolLicenseMayaGlyphsWikisource,
    ]),
    GCWSymbolTableTool(symbolKey: 'maya_calendar_haab_inscripts', symbolSearchStrings: const [
      'calendar',
      'symbol_maya_calendar_haab',
    ], licenses: [
      stl._toolLicenseMayaGlyphsWikisource,
    ]),
    GCWSymbolTableTool(symbolKey: 'maya_calendar_tzolkin_codices', symbolSearchStrings: const [
      'calendar',
      'symbol_maya_calendar_tzolkin',
    ], licenses: [
      stl._toolLicenseMayaGlyphsWikisource,
    ]),
    GCWSymbolTableTool(symbolKey: 'maya_calendar_tzolkin_inscripts', symbolSearchStrings: const [
      'calendar',
      'symbol_maya_calendar_tzolkin',
    ], licenses: [
      stl._toolLicenseMayaGlyphsWikisource,
    ]),
    GCWSymbolTableTool(symbolKey: 'maya_numbers_glyphs', symbolSearchStrings: const [
      'mayanumbers',
    ], licenses: [
      ToolLicenseImage(
        context: context,
        author: 'Unity Corps Research Library',
        title: 'Mayan Numbers',
        sourceUrl:
        'https://web.archive.org/web/20240722213816/https://www.mayan-calendar.org/images/reference/mayan-numbers_mayan-number-system_720x570.gif',
        licenseType: ToolLicenseType.FREE_TO_USE,
        licenseUseType: ToolLicenseUseType.COPY,
      ),
    ]),
    GCWSymbolTableTool(symbolKey: 'maya_numerals', symbolSearchStrings: const [
      'mayanumbers',
      'symbol_maya_number_glyphys',
    ], licenses: [
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'maze', symbolSearchStrings: const [
      'symbol_maze',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'medieval_runes', symbolSearchStrings: const [
      'symbol_runes',
      'symbol_futhark'
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Trackah',
          title: 'Medieval Runes',
          sourceUrl: 'https://fontstruct.com/fontstructions/show/491366/medieval_runes',
          licenseType: ToolLicenseType.CCBYSA3)
    ]),
    GCWSymbolTableTool(symbolKey: 'minimoys', symbolSearchStrings: const [
      'symbol_minimoys',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'moon', symbolSearchStrings: const [
      'symbol_moon',
    ], licenses: [
      stl._toolLicenseCullyLong,
    ]),
    GCWSymbolTableTool(symbolKey: 'moon_phases', symbolSearchStrings: const [
      'symbol_moon_phases',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Lunar phase',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Lunar_phase&oldid=1231773726',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'morse', symbolSearchStrings: const [
      'morse',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Morse',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Morse_code&oldid=1235898565',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'morse_gerke', symbolSearchStrings: const [
      'morse',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Gerke',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Friedrich_Clemens_Gerke&oldid=243194789',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'morse_1838_patent', symbolSearchStrings: const [
      'morse',
    ], licenses: [
      ToolLicenseOnlineArticle(
        context: context,
        author: 'Samuel Morse',
        title: 'Morse (1838, U.S.Patent 1647, 20.06.1840)',
        sourceUrl:
        'https://web.archive.org/web/20240724104528/https://patentimages.storage.googleapis.com/bb/4a/53/3d3b9d7e4c8619/US1647.pdf',
      )
    ]),
    GCWSymbolTableTool(symbolKey: 'morse_1844_vail', symbolSearchStrings: const [
      'morse',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Morse (1844)',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Morse_code&oldid=1235898565',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'morse_steinheil', symbolSearchStrings: const [
      'morse',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Steinheilschrift',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Steinheilschrift&oldid=225516165',
          licenseType: ToolLicenseType.CCBYSA4),
      ToolLicenseOnlineBook(
          context: context,
          author: 'Taliaferro Preston Shaffner',
          title:
          'The Telegraph Manual: A Complete History and Description of the Semaphoric, Electri and Magnetic Telegraphs of Europe, Asia, Africa, and America, Ancient and Modern',
          sourceUrl: '',
          year: 1859,
          publisher: 'Pudney & Russell',
          customComment: 'Chapter XII, Page 178')
    ]),
    GCWSymbolTableTool(symbolKey: 'murray', symbolSearchStrings: const [
      'symbol_murray',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Helmar Fischer',
          title: 'Der Klappentelegraph',
          sourceUrl:
          'https://web.archive.org/web/20240808115703/https://cms.sachsen.schule/fileadmin/_special/gruppen/592/klappentelegraph/download/klappentelegraphenalphabet_f_2007.pdf',
          licenseType: ToolLicenseType.PRIVATE_PERMISSION,
          privatePermission: ToolLicensePrivatePermission(
              context: context,
              medium: 'e-Mail',
              permissionYear: 2024,
              permissionMonth: 7,
              permissionDay: 23,
              permissionAuthor: 'Helmar Fischer')),
    ]),
    GCWSymbolTableTool(symbolKey: 'murray_v2_fischer_corrected', symbolSearchStrings: const [
      'symbol_murray',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Helmar Fischer',
          title: 'Der Klappentelegraph',
          sourceUrl:
          'https://web.archive.org/web/20240808115529/https://cms.sachsen.schule/fileadmin/_special/gruppen/592/klappentelegraph/download/klappentelegraphenalphabet_2016.pdf',
          licenseType: ToolLicenseType.PRIVATE_PERMISSION,
          privatePermission: ToolLicensePrivatePermission(
              context: context,
              medium: 'e-Mail',
              permissionYear: 2024,
              permissionMonth: 7,
              permissionDay: 23,
              permissionAuthor: 'Helmar Fischer'))
    ]),
    GCWSymbolTableTool(symbolKey: 'murray_v3_navy_1796', symbolSearchStrings: const [
      'symbol_murray',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Samuel William Fores',
          title: 'Abbildung des Telegraphen der im Februar 1796 auf der Admiralität zu London errichtet wurde',
          sourceUrl: 'https://web.archive.org/web/20240808120340/https://www.bilder.mspt.de/',
          customComment: 'Museumsstiftung Post und Telekommunikation, Inventarnummer: 4.2014.882',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'murray_v4_roucoux', symbolSearchStrings: const [
      'symbol_murray',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Omar Roucoux',
          title: 'Dunstable Signalling Station',
          sourceUrl:
          'https://web.archive.org/web/20240808120043/https://virtual-library.culturalservices.net/webingres/bedfordshire/vlib/0.digitised_resources/dunstable_article_signalling_station_enlargement.htm',
          licenseType: ToolLicenseType.PRIVATE_PERMISSION,
          privatePermission: ToolLicensePrivatePermission(
              context: context,
              medium: 'e-Mail',
              permissionYear: 2021,
              permissionMonth: 12,
              permissionDay: 21,
              permissionAuthor: 'John Buckledee'))
    ]),
    GCWSymbolTableTool(symbolKey: 'murraybaudot', symbolSearchStrings: const [
      'ccitt',
      'symbol_murraybaudot',
      'teletypewriter'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Murray Baudot Code',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Baudot_code&oldid=1227345731',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'musica', symbolSearchStrings: const [
      'music_notes',
      'symbol_musica',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'WC Fonts',
          title: 'WC Musica Bta Font',
          sourceUrl: 'https://fontmeme.com/fonts/wc-musica-bta-font/',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'nazcaan', symbolSearchStrings: const [
      'symbol_nazcaan',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Ni_no_Kuni',
          title: 'NazcaanRegular',
          sourceUrl:
          'https://web.archive.org/web/20240802171148/https://drive.google.com/file/d/0B50-IT1pATGoZDBkbU0yQXNEWlk/view?resourcekey=0-wgv-U23dbvlsc1Wbq30Oug',
          licenseType: ToolLicenseType.FREE_TO_USE,
          licenseUrl:
          'https://web.archive.org/web/20240819153145/https://www.reddit.com/r/Ni_no_Kuni/comments/zo3xji/nazcaan_font/?rdt=54051')
    ]),
    GCWSymbolTableTool(symbolKey: 'new_zealand_sign_language', symbolSearchStrings: const [
      'symbol_signlanguage',
      'symbol_new_zealand_sign_language',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'niessen', symbolSearchStrings: const [
      'symbol_signlanguage',
      'symbol_niessen',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Johannes Niessen',
          title: 'The Niessen Alphabet',
          sourceUrl: 'https://web.archive.org/web/20211202062443/https://fakoo.de/en/niessen.html',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'ninjargon', symbolSearchStrings: const [
      'symbol_ninjargon',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Mia N',
          title: 'Ninjargon Font',
          sourceUrl: 'https://web.archive.org/web/20240729052359/https://www.cufonfonts.com/font/ninjargon',
          licenseType: ToolLicenseType.NON_COMMERCIAL)
    ]),
    GCWSymbolTableTool(symbolKey: 'notes_doremi', symbolSearchStrings: const [
      'music',
      'music_notes',
      'symbol_notes_doremi',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Solresol',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Solresol&oldid=242474951',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'notes_names_altoclef', symbolSearchStrings: const [
      'music',
      'music_notes',
      'symbol_notes_names_altoclef',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Clef',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Clef&oldid=1236772573',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'notes_names_bassclef', symbolSearchStrings: const [
      'music',
      'music_notes',
      'symbol_notes_names_bassclef',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Clef',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Clef&oldid=1236772573',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'notes_names_trebleclef', symbolSearchStrings: const [
      'music',
      'music_notes',
      'symbol_notes_names_trebleclef',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Clef',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Clef&oldid=1236772573',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'notes_notevalues', symbolSearchStrings: const [
      'music',
      'music_notes',
      'symbol_notes_notevalues',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Musical note',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Musical_note&oldid=1238867492',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'notes_restvalues', symbolSearchStrings: const [
      'music',
      'music_notes',
      'symbol_notes_restvalues',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Rest (music)',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Rest_(music)&oldid=1226810233',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'nyctography', symbolSearchStrings: const [
      'symbol_nyctography',
    ], licenses: [
      stl._toolLicenseCullyLong,
      ToolLicenseFont(
          context: context,
          author: '	Pixel Sagas',
          title: 'NYCTOGRAPHIC FONT',
          sourceUrl: 'https://web.archive.org/web/20170627190841/https://www.fonts4free.net/nyctographic-font.html',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(
        symbolKey: 'oak_island_money_pit',
        symbolSearchStrings: const ['symbol_oak_island_money_pit', 'oak_island'],
        licenses: [stl._toolLicenseOakIslandMystery]),
    GCWSymbolTableTool(
        symbolKey: 'oak_island_money_pit_extended',
        symbolSearchStrings: const ['symbol_oak_island_money_extended', 'oak_island'],
        licenses: [stl._toolLicenseOakIslandMystery]),
    GCWSymbolTableTool(
        symbolKey: 'oak_island_money_pit_libyan',
        symbolSearchStrings: const ['symbol_oak_island_money_pit_libyan', 'oak_island'],
        licenses: [stl._toolLicenseOakIslandMystery]),
    GCWSymbolTableTool(symbolKey: 'ogham', symbolSearchStrings: const [
      'symbol_ogham',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Ogham',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Ogham&oldid=1234313745',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'optical_fiber_fotag', symbolSearchStrings: const [
      'color',
      'symbol_opticalfiber',
      'symbol_optical_fiber_fotag',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'TIA-598-C',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=TIA-598-C&oldid=919612867',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'optical_fiber_iec60304', symbolSearchStrings: const [
      'color',
      'symbol_opticalfiber',
      'symbol_optical_fiber_iec60304',
    ], licenses: [
      ToolLicenseOnlineArticle(
        context: context,
        author: 'Opternus',
        title: 'LWL Farbcodierungen',
        sourceUrl:
        'https://web.archive.org/web/20240808130122/https://www.opternus.de/media/pdf/79/53/b6/LWL-Farbcodes.pdf',
      )
    ]),
    GCWSymbolTableTool(symbolKey: 'optical_fiber_swisscom', symbolSearchStrings: const [
      'color',
      'symbol_opticalfiber',
      'optical_fiber_swisscom',
    ], licenses: [
      ToolLicenseOnlineArticle(
        context: context,
        author: 'Opternus',
        title: 'LWL Farbcodierungen',
        sourceUrl:
        'https://web.archive.org/web/20240808130122/https://www.opternus.de/media/pdf/79/53/b6/LWL-Farbcodes.pdf',
      )
    ]),
    GCWSymbolTableTool(symbolKey: 'phoenician', symbolSearchStrings: const [
      'symbol_phoenician',
      'zigzag'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Phoenician (Unicode block)',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Phoenician_(Unicode_block)&oldid=1236804525',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'pipeline', symbolSearchStrings: const [
      'symbol_pipeline',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
    ]),
    GCWSymbolTableTool(symbolKey: 'pipeline_din2403', symbolSearchStrings: const [
      'color',
      'symbol_pipeline_din2403',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'wikipedia.org and contributors',
          title: 'DIN 2403',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=DIN_2403&oldid=220693795',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'pixel', symbolSearchStrings: const [
      'symbol_pixel',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'planet', symbolSearchStrings: const [
      'barcodes',
      'symbol_planet',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'planets', symbolSearchStrings: const [
      'symbol_planets',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Astrological symbols',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Astrological_symbols&oldid=1227161520',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'pleiadian', symbolSearchStrings: const [
      'symbol_pleiadian',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'pokemon_unown', symbolSearchStrings: const [
      'pokemon',
      'symbol_pokemon_unown',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Unown',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Unown&oldid=1238601379',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'postcode_01247', symbolSearchStrings: const [
      'barcodes',
      'symbol_postcode01247',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'wikipedia.org and contributors',
          title: 'Zielcode',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Zielcode&oldid=246247471',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'postcode_8421', symbolSearchStrings: const [
      'barcodes',
      'symbol_postcode8421',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'wikipedia.org and contributors',
          title: 'Zielcode',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Zielcode&oldid=246247471',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'postnet', symbolSearchStrings: const [
      'barcodes',
      'symbol_postnet',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'predator', symbolSearchStrings: const [
      'predator',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: '	Giedi Prime',
          title: 'Predator Font',
          sourceUrl: 'https://web.archive.org/web/20200831204648/https://www.fontspace.com/predator-font-f5510',
          licenseType: ToolLicenseType.NON_COMMERCIAL)
    ]),
    GCWSymbolTableTool(symbolKey: 'prosyl', symbolSearchStrings: const [
      'symbol_prosyl',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Saali Peter',
          title: 'ProSyl font',
          sourceUrl: 'https://web.archive.org/web/20211205101934/https://fontineed.com/it/font/prosyl',
          licenseType: ToolLicenseType.FREE_TO_USE),
    ]),
    GCWSymbolTableTool(symbolKey: 'puzzle', symbolSearchStrings: const [
      'symbol_puzzle',
    ], licenses: [
      ToolLicenseImage(
        context: context,
        author: 'Josh Ragsdell',
        title: 'Puzzle Code',
        sourceUrl: 'https://web.archive.org/web/20210625060800/https://www.omniglot.com/conscripts/puzzlecode.htm',
        licenseType: ToolLicenseType.PRIVATE_PERMISSION,
        licenseUseType: ToolLicenseUseType.COPY,
        privatePermission: ToolLicensePrivatePermission(
            context: context,
            medium: 'e-mail',
            permissionYear: 2024,
            permissionMonth: 7,
            permissionDay: 31,
            permissionAuthor: 'Simon Ager (Omniglot)'
        ),
      ),
    ]),
    GCWSymbolTableTool(symbolKey: 'puzzle_2', symbolSearchStrings: const [
      'symbol_puzzle',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Roci',
          title: 'Puzzle Font',
          sourceUrl: 'https://web.archive.org/web/20200925235507/https://www.fontspace.com/puzzle-font-f10159',
          licenseType: ToolLicenseType.FREE_TO_USE),
    ]),
    GCWSymbolTableTool(symbolKey: 'prussian_colors_artillery', symbolSearchStrings: const [
      'symbol_prussian_colors_artillery',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Preußische Farbfolge',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Preu%C3%9Fische_Farbfolge&oldid=245158156',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'prussian_colors_infantery', symbolSearchStrings: const [
      'symbol_prussian_colors_infantery',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Preußische Farbfolge',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Preu%C3%9Fische_Farbfolge&oldid=245158156',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'quadoo', symbolSearchStrings: const [
      'symbol_quadoo',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Alexander Fakoó',
          title: 'Das Quadoo-Alphabet',
          sourceUrl: 'https://web.archive.org/web/20240808130803/https://fakoo.de/quadoo.html',
          licenseType: ToolLicenseType.CCBYNCND40)
    ]),
    GCWSymbolTableTool(symbolKey: 'ravkan', symbolSearchStrings: const [
      'symbol_ravkan',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'patrocool',
          title: 'Ravkan',
          sourceUrl:
          'https://web.archive.org/web/20240228064125/https://fontstruct.com/fontstructions/show/2220712/ravkan-27',
          licenseType: ToolLicenseType.NON_COMMERCIAL,
          licenseUrl:
          'https://web.archive.org/web/20240805121408/https://fontstruct.com/fontstructions/license/2220712/ravkan-27'),
    ]),
    GCWSymbolTableTool(symbolKey: 'ravkan_extended', symbolSearchStrings: const [
      'symbol_ravkan_extended',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'reality', symbolSearchStrings: const [
      'symbol_reality',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
    ]),
    GCWSymbolTableTool(symbolKey: 'red_herring', symbolSearchStrings: const [
      'symbol_red_herring',
    ], licenses: [
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'resistor', symbolSearchStrings: const [
      'color',
      'resistor_colorcode',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Resistor color codes',
          sourceUrl: 'https://en.wikiversity.org/w/index.php?title=Resistor_color_codes&oldid=2580031',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'rhesus_a', symbolSearchStrings: const [
      'symbol_rhesus',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Atypeek Magazine',
          title: 'WC Rhesus A Bta',
          sourceUrl: 'https://web.archive.org/web/20140831024200/https://fonts2u.com/wc-rhesus-a-bta.font',
          licenseType: ToolLicenseType.FREE_TO_USE),
    ]),
    GCWSymbolTableTool(symbolKey: 'rhesus_b', symbolSearchStrings: const [
      'symbol_rhesus',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Atypeek Magazine',
          title: 'WC Rhesus B Bta',
          sourceUrl: 'https://web.archive.org/web/20140830000224/http://www.fonts2u.com/wc-rhesus-b-bta.font',
          licenseType: ToolLicenseType.FREE_TO_USE),
    ]),
    GCWSymbolTableTool(symbolKey: 'rhesus_c1', symbolSearchStrings: const [
      'symbol_rhesus',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Atypeek Magazine',
          title: 'WC Rhesus C 1Bta font',
          sourceUrl: 'https://web.archive.org/web/20140831023848/http://www.fonts2u.com/wc-rhesus-c-1bta.font',
          licenseType: ToolLicenseType.FREE_TO_USE),
    ]),
    GCWSymbolTableTool(symbolKey: 'rhesus_c2', symbolSearchStrings: const [
      'symbol_rhesus',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Atypeek Magazine',
          title: 'WC Rhesus C 2Bta Italic',
          sourceUrl: 'https://web.archive.org/web/20150309131933/http://www.fonts2u.com/wc-rhesus-c-2bta-italic.font',
          licenseType: ToolLicenseType.FREE_TO_USE),
    ]),
    GCWSymbolTableTool(symbolKey: 'rm4scc', symbolSearchStrings: const [
      'barcodes',
      'symbol_rm4scc',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'RM4SCC',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=RM4SCC&oldid=1214051326',
          licenseType: ToolLicenseType.CCBYSA4),
    ]),
    GCWSymbolTableTool(symbolKey: 'robots', symbolSearchStrings: const [
      'symbol_robots',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Woodcutter',
          title: 'Robots Font',
          sourceUrl: 'https://web.archive.org/web/20140226111938/https://www.fontriver.com/font/robots/',
          licenseType: ToolLicenseType.FREE_TO_USE),
    ]),
    GCWSymbolTableTool(symbolKey: 'romulan', symbolSearchStrings: const [
      'symbol_romulan',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Unknown',
          title: 'Romulan',
          sourceUrl: 'https://web.archive.org/web/20170401035807/https://fonts2u.com/romulan.font',
          licenseType: ToolLicenseType.NON_COMMERCIAL),
    ]),
    GCWSymbolTableTool(symbolKey: 'sanluca', symbolSearchStrings: const [
      'symbol_sanluca',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Leadermassimo',
          title: 'San Luca code',
          sourceUrl:
          'https://web.archive.org/web/20191203174714/https://www.geocachingtoolbox.com/index.php?lang=de&page=codeTables&id=sanLucaCode',
          licenseType: ToolLicenseType.CCBYSA4,
          customComment: 'wikimafia.it'),
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'sarati', symbolSearchStrings: const [
      'symbol_sarati',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
    ]),
    GCWSymbolTableTool(symbolKey: 'semaphore', symbolSearchStrings: const [
      'symbol_semaphore',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'shadoks', symbolSearchStrings: const [
      'shadoksnumbers',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Université de Lille',
          title: 'L’alphabet shadok',
          sourceUrl:
          'https://web.archive.org/web/20240805184521/https://www.fil.univ-lille.fr/~L1S1Info/Doc/HTML/tp_numeration_shadok.html')
    ]),
    GCWSymbolTableTool(symbolKey: 'sheikah', symbolSearchStrings: const [
      'zelda',
      'symbol_sheikah',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Sarinilli',
          title: 'BOTW SHEIKAH',
          sourceUrl: 'https://web.archive.org/web/20200406201743/https://www.zeldaxtreme.com/fonts/',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'shoes', symbolSearchStrings: const [
      'symbol_shoes',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'siemens', symbolSearchStrings: const [
      'symbol_siemens',
      'teletypewriter'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: '',
          title: 'Siemens Fernschreiber',
          sourceUrl: '',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'sign', symbolSearchStrings: const [
      'symbol_signlanguage'
    ], licenses: [
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'sith', symbolSearchStrings: const [
      'symbol_sith'
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'AurekFonts',
          title: 'Sith AF',
          privatePermission: ToolLicensePrivatePermission(
            context: context,
            medium: 'e-mail',
            permissionYear: 2024,
            permissionMonth: 7,
            permissionDay: 26,
          ),
          sourceUrl: 'https://web.archive.org/web/20220729045524/https://www.dafont.com/de/sith-af.font',
          licenseType: ToolLicenseType.PRIVATE_PERMISSION)
    ]),
    GCWSymbolTableTool(symbolKey: 'skullz', symbolSearchStrings: const [
      'symbol_skullz',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Googe',
          title: 'Skullz',
          sourceUrl: 'https://fontmeme.com/schriftarten/skullz-schriftart/',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'slash_and_pipe', symbolSearchStrings: const [
      'symbol_slash_and_pipe',
    ], licenses: [
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'slash_and_pipe_codeofclaw', symbolSearchStrings: const [
      'symbol_slash_and_pipe',
      'symbol_slash_and_pipe_codeofclaw',
      'symbol_slash_and_pipe_underland',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia and contributors',
          title: 'Gregor and the Code of Claw',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Gregor_and_the_Code_of_Claw&oldid=1176094103',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'slash_and_pipe_underland', symbolSearchStrings: const [
      'symbol_slash_and_pipe',
      'symbol_slash_and_pipe_underland',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia and contributors',
          title: 'Gregor and the Code of Claw',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Gregor_and_the_Code_of_Claw&oldid=1176094103',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'solmisation', symbolSearchStrings: const [
      'symbol_solmisation',
    ], licenses: [
      ToolLicenseImage(
        context: context,
        author: 'Breitkopf & Härtel KG (addizio.de)',
        title: 'Solmisation',
        privatePermission: ToolLicensePrivatePermission(
          context: context,
          medium: 'e-mail',
          permissionYear: 2020,
          permissionMonth: 8,
          permissionDay: 9,
        ),
        sourceUrl:
        'https://web.archive.org/web/20240722095602/https://www.addizio.de/wp-content/uploads/2019/04/Solmisation.zip',
        licenseType: ToolLicenseType.PRIVATE_PERMISSION,
        licenseUseType: ToolLicenseUseType.COPY,
      ),
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Solmisation',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Solmisation&oldid=246661837',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'space_invaders', symbolSearchStrings: const [
      'symbol_space_invaders',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'spintype', symbolSearchStrings: const [
      'symbol_spintype',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
    ]),
    GCWSymbolTableTool(symbolKey: 'sprykski', symbolSearchStrings: const [
      'symbol_sprykski',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Volnaiskra',
          title: 'Sprykski Font',
          sourceUrl: 'https://web.archive.org/web/20210306061331/https://www.1001fonts.com/sprykski-font.html',
          licenseType: ToolLicenseType.PERSONAL_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'steinheil', symbolSearchStrings: const [
      'symbol_steinheil',
      'telegraph',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Steinheilschrift',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Steinheilschrift&oldid=225516165',
          licenseType: ToolLicenseType.CCBYSA4),
      ToolLicenseOnlineBook(
          context: context,
          author: 'Taliaferro Preston Shaffner',
          title:
          'The Telegraph Manual: A Complete History and Description of the Semaphoric, Electri and Magnetic Telegraphs of Europe, Asia, Africa, and America, Ancient and Modern',
          sourceUrl: '',
          year: 1859,
          publisher: 'Pudney & Russell',
          customComment: 'Chapter XII, Page 178')
    ]),
    GCWSymbolTableTool(symbolKey: 'stenography', symbolSearchStrings: const [
      'symbol_stenography',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'stippelcode', symbolSearchStrings: const [
      'symbol_stippelcode',
    ], licenses: [
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'suetterlin', symbolSearchStrings: const [
      'symbol_suetterlin',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Sütterlin',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=S%C3%BCtterlin&oldid=1231365683',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'sunuz', symbolSearchStrings: const [
      'symbol_sunuz',
    ], licenses: [
      ToolLicenseImage(
        context: context,
        author: 'Muhammad Abd-el-Rahman Barker',
        title: 'Tékumel writing systems',
        sourceUrl: 'http://web.archive.org/web/20240418033554/https://www.omniglot.com/conscripts/tekumel.php',
        licenseUseType: ToolLicenseUseType.COPY,
        licenseType: ToolLicenseType.PRIVATE_PERMISSION,
        privatePermission: ToolLicensePrivatePermission(
            context: context,
            medium: 'e-mail',
            permissionYear: 2024,
            permissionMonth: 7,
            permissionDay: 31,
            permissionAuthor: 'Simon Ager (Omniglot)'
        ),)
    ]),
    GCWSymbolTableTool(symbolKey: 'surf', symbolSearchStrings: const [
      'symbol_surf',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'WOODCUTTER',
          title: 'Surf',
          sourceUrl: 'https://web.archive.org/web/20150424085318/https://www.dafont.com/surf.font',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'tae', symbolSearchStrings: const [
      'symbol_tae',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'TAE connector',
          sourceUrl: 'https://simple.wikipedia.org/w/index.php?title=TAE_connector&oldid=8424911',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'tamil_numerals', symbolSearchStrings: const [
      'symbol_tamil_numerals',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Arabische Zahlschrift',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Arabische_Zahlschrift&oldid=246917272',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(
      symbolKey: 'telegraph_pasley',
      symbolSearchStrings: const [
        'telegraph',
        'symbol_pasley_telegraph',
      ],
      licenses: [
        stl._toolLicenseWrixonGeheimsprachen,
      ],
    ),
    GCWSymbolTableTool(
      symbolKey: 'telegraph_popham',
      symbolSearchStrings: const [
        'telegraph',
        'symbol_popham_telegraph',
      ],
      licenses: [
        stl._toolLicenseWrixonGeheimsprachen,
      ],
    ),
    GCWSymbolTableTool(symbolKey: 'telegraph_prussia', symbolSearchStrings: const [
      'telegraph',
      'telegraph_prussia',
    ], licenses: [
      ToolLicenseImage(
        context: context,
        author: 'Museumsstiftung Post und Telekommunikation',
        title: '',
        sourceUrl: '',
        licenseUrl: 'https://www.bilder.mspt.de/Nutzungsbedingungen%20fu%CC%88r%20Bildmaterial%20der%20MSPT.pdf',
        licenseType: ToolLicenseType.CCBYSA4,
        licenseUseType: ToolLicenseUseType.COPY,
      )
    ]),
    GCWSymbolTableTool(symbolKey: 'telegraph_schmidt', symbolSearchStrings: const [
      'telegraph',
      'telegraph_schmidt',
    ], licenses: [
      // https://www.cuxhaven-seiten.de/telegraph/telegraph.htm
      // https://web.archive.org/web/20240728210555/https://www.cuxhaven-seiten.de/telegraph/telegraph.htm
      // https://cuxpedia.de/index.php?title=Datei:Telegraphentabelle.jpg&oldid=31110
      ToolLicenseOnlineArticle(
          context: context,
          author: 'Museumsstiftung Post und Kommunikation',
          title:
          'Lithografie: "Deutsche Volks-Telegraphie" mit der Darstellung des Zeichensystem des optischen Telegrafen von Schmidt',
          sourceUrl: 'https://sammlungen.museumsstiftung.de/',
          licenseType: ToolLicenseType.CCBYSA4,
          customComment: 'Inventarnummer 4.2012.518')
    ]),
    GCWSymbolTableTool(symbolKey: 'templers', symbolSearchStrings: const [
      'symbol_templers',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'tenctonese_cursive', symbolSearchStrings: const [
      'symbol_tenctonese',
    ], licenses: [
      ToolLicenseFont(context: context,
          author: 'Jeff Lee',
          title: 'Tenctonese Cursive',
          sourceUrl: 'https://web.archive.org/web/20240819151530/https://www.shipbrook.net/jeff/tencton/index.html',
          licenseType: ToolLicenseType.FREE_TO_USE,
          licenseUrl: 'https://web.archive.org/web/20230603002844/https://www.shipbrook.net/jeff/typograf.html'
      )
    ]),
    GCWSymbolTableTool(symbolKey: 'tenctonese_printed', symbolSearchStrings: const [
      'symbol_tenctonese',
    ], licenses: [
      ToolLicenseFont(context: context,
          author: 'Jeff Lee',
          title: 'Tenctonese Printed',
          sourceUrl: 'https://web.archive.org/web/20240819151530/https://www.shipbrook.net/jeff/tencton/index.html',
          licenseType: ToolLicenseType.FREE_TO_USE,
          licenseUrl: 'https://web.archive.org/web/20230603002844/https://www.shipbrook.net/jeff/typograf.html'
      )
    ]),
    GCWSymbolTableTool(symbolKey: 'tengwar_beleriand', symbolSearchStrings: const [
      'symbol_lordoftherings',
      'symbol_tengwar_beleriand',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Enrique Mombello',
          title: 'Las Tengwar de Fëanor',
          sourceUrl: 'https://web.archive.org/web/20230605163745/https://www.oocities.org/enrombell/eng_dir/Index.htm',
          licenseType: ToolLicenseType.FREE_TO_USE,
          licenseUrl:
          'https://web.archive.org/web/20220210114601/https://freetengwar.sourceforge.net/links.html#unicode_tengwar_fonts')
    ]),
    GCWSymbolTableTool(symbolKey: 'tengwar_classic', symbolSearchStrings: const [
      'symbol_lordoftherings',
      'symbol_tengwar_classic',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Enrique Mombello',
          title: 'Las Tengwar de Fëanor',
          sourceUrl: 'https://web.archive.org/web/20230605163745/https://www.oocities.org/enrombell/eng_dir/Index.htm',
          licenseType: ToolLicenseType.FREE_TO_USE,
          licenseUrl:
          'https://web.archive.org/web/20220210114601/https://freetengwar.sourceforge.net/links.html#unicode_tengwar_fonts')
    ]),
    GCWSymbolTableTool(symbolKey: 'tengwar_general', symbolSearchStrings: const [
      'symbol_lordoftherings',
      'symbol_tengwar_general',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Enrique Mombello',
          title: 'Las Tengwar de Fëanor',
          sourceUrl: 'https://web.archive.org/web/20230605163745/https://www.oocities.org/enrombell/eng_dir/Index.htm',
          licenseType: ToolLicenseType.FREE_TO_USE,
          licenseUrl:
          'https://web.archive.org/web/20220210114601/https://freetengwar.sourceforge.net/links.html#unicode_tengwar_fonts')
    ]),
    GCWSymbolTableTool(symbolKey: 'terzi', symbolSearchStrings: const [
      'symbol_terzi',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'thai_numerals', symbolSearchStrings: const [
      'symbol_thai_numerals',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Enrique Mombello',
          title: 'Las Tengwar de Fëanor',
          sourceUrl: 'https://web.archive.org/web/20230605163745/https://www.oocities.org/enrombell/eng_dir/Index.htm',
          licenseType: ToolLicenseType.FREE_TO_USE,
          licenseUrl:
          'https://web.archive.org/web/20220210114601/https://freetengwar.sourceforge.net/links.html#unicode_tengwar_fonts')
    ]),
    GCWSymbolTableTool(symbolKey: 'theban', symbolSearchStrings: const [
      'symbol_theban',
    ], licenses: [
      stl._toolLicenseOnlineBookDeOccultaPhilosophia
    ]),
    GCWSymbolTableTool(symbolKey: 'three_squares', symbolSearchStrings: const [
      'symbol_three_squares',
    ], licenses: [
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'tifinagh', symbolSearchStrings: const [
      'symbol_tifinagh',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Tifinagh alphabet',
          sourceUrl: 'https://en.wikipedia.org/wiki/Tifinagh#/media/File:Tifinagh_alphabet.png',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'tines', symbolSearchStrings: const [
      'symbol_tines',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
    ]),
    GCWSymbolTableTool(symbolKey: 'tll', symbolSearchStrings: const [
      'symbol_tll',
    ], licenses: [
      ToolLicenseImage(
        context: context,
        author: 'GC Rogier (GeoVlogs.nl)',
        title: 'GEOVLOGS-code',
        sourceUrl: 'https://web.archive.org/web/20240223141316/https://www.geovlogs.nl/geovlogs-code/',
        privatePermission: ToolLicensePrivatePermission(
            context: context, medium: 'e-mail', permissionYear: 2024, permissionMonth: 6, permissionDay: 14),
        licenseType: ToolLicenseType.PRIVATE_PERMISSION,
        licenseUseType: ToolLicenseUseType.COPY,
      )
    ]),
    GCWSymbolTableTool(symbolKey: 'tomtom', symbolSearchStrings: const [
      'tomtom',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
      stl._toolLicenseGeocachingToolbox,
    ]),
    GCWSymbolTableTool(symbolKey: 'trafficsigns_germany', symbolSearchStrings: const [
      'symbol_trafficsigns_germany',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Bildtafel der Verkehrszeichen in der Bundesrepublik Deutschland seit 2017',
          sourceUrl:
          'https://de.wikipedia.org/w/index.php?title=Bildtafel_der_Verkehrszeichen_in_der_Bundesrepublik_Deutschland_seit_2017&oldid=247018625',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'ulog', symbolSearchStrings: const [
      'symbol_ulog',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
    ]),
    GCWSymbolTableTool(symbolKey: 'unitology', symbolSearchStrings: const [
      'symbol_unitology',
    ], licenses: [
      stl._toolLicenseCullyLong,
    ]),
    GCWSymbolTableTool(symbolKey: 'utopian', symbolSearchStrings: const [
      'symbol_utopian',
    ], licenses: [
      stl._toolLicenseCullyLong,
    ]),
    GCWSymbolTableTool(symbolKey: 'visitor_1984', symbolSearchStrings: const [
      'symbol_visitor_1984',
    ], licenses: [
      stl._toolLicenseCullyLong,
    ]),
    GCWSymbolTableTool(symbolKey: 'visitor_2009', symbolSearchStrings: const [
      'symbol_visitor_2009',
    ], licenses: [
      stl._toolLicenseCullyLong,
    ]),
    GCWSymbolTableTool(symbolKey: 'voynich', symbolSearchStrings: const [
      'symbol_voynich',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Voynich EVA',
          sourceUrl: 'https://commons.wikimedia.org/wiki/File:Voynich_EVA.svg?uselang=en',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'vulcanian', symbolSearchStrings: const [
      'symbol_vulcanian',
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Nick Polyarush',
          title: 'Vulcan Script',
          sourceUrl: 'https://web.archive.org/web/20201130173411/https://de.fonts2u.com/vulcan-script.schriftart',
          licenseType: ToolLicenseType.CCBYNCND30)
    ]),
    GCWSymbolTableTool(symbolKey: 'wakandan', symbolSearchStrings: const [
      'symbol_wakandan'
    ], licenses: [
      ToolLicenseFont(
          context: context,
          author: 'Adam Pypstra',
          title: 'Wakanda Forever',
          sourceUrl: 'https://web.archive.org/web/20200615000000*/https://dribbble.com/shots/4269681-Wakanda-Forever',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'weather_a', symbolSearchStrings: const [
      'weather',
      'weather_a'
    ], licenses: [
      ToolLicenseImage(
          context: context,
          author: 'Unknown',
          title: 'Pressure Tendency',
          sourceUrl:
          'https://web.archive.org/web/20231123172913/https://www.wpc.ncep.noaa.gov/dailywxmap/plottedwx.html',
          licenseType: ToolLicenseType.PUBLIC_DOMAIN,
          licenseUseType: ToolLicenseUseType.COPY)
    ]),
    GCWSymbolTableTool(symbolKey: 'weather_c', symbolSearchStrings: const [
      'weather',
      'weather_c',
      'weather_clouds'
    ], licenses: [
      ToolLicenseImage(
          context: context,
          author: 'Unknown',
          title: 'WEATHER FIGURES AND SYMBOLS',
          sourceUrl:
          'https://web.archive.org/web/20230809231644/https://cdn2.hubspot.net/hubfs/604407/weather_symbols.gif',
          licenseType: ToolLicenseType.PUBLIC_DOMAIN,
          licenseUseType: ToolLicenseUseType.COPY)
    ]),
    GCWSymbolTableTool(symbolKey: 'weather_cl', symbolSearchStrings: const [
      'weather',
      'weather_cl',
      'weather_clouds'
    ], licenses: [
      ToolLicenseImage(
          context: context,
          author: 'Unknown',
          title: 'Low Clouds',
          sourceUrl:
          'https://web.archive.org/web/20231123172913/https://www.wpc.ncep.noaa.gov/dailywxmap/plottedwx.html',
          licenseType: ToolLicenseType.PUBLIC_DOMAIN,
          licenseUseType: ToolLicenseUseType.COPY)
    ]),
    GCWSymbolTableTool(symbolKey: 'weather_cm', symbolSearchStrings: const [
      'weather',
      'weather_cm',
      'weather_clouds'
    ], licenses: [
      ToolLicenseImage(
          context: context,
          author: 'Unknown',
          title: 'Middle Clouds',
          sourceUrl:
          'https://web.archive.org/web/20231123172913/https://www.wpc.ncep.noaa.gov/dailywxmap/plottedwx.html',
          licenseType: ToolLicenseType.PUBLIC_DOMAIN,
          licenseUseType: ToolLicenseUseType.COPY)
    ]),
    GCWSymbolTableTool(symbolKey: 'weather_ch', symbolSearchStrings: const [
      'weather',
      'weather_ch',
      'weather_clouds'
    ], licenses: [
      ToolLicenseImage(
          context: context,
          author: 'Unknown',
          title: 'High Clouds',
          sourceUrl:
          'https://web.archive.org/web/20231123172913/https://www.wpc.ncep.noaa.gov/dailywxmap/plottedwx.html',
          licenseType: ToolLicenseType.PUBLIC_DOMAIN,
          licenseUseType: ToolLicenseUseType.COPY)
    ]),
    GCWSymbolTableTool(symbolKey: 'weather_n', symbolSearchStrings: const [
      'weather',
      'weather_n',
      'weather_clouds'
    ], licenses: [
      ToolLicenseImage(
          context: context,
          author: 'Unknown',
          title: 'Sky Cover',
          sourceUrl:
          'https://web.archive.org/web/20231123172913/https://www.wpc.ncep.noaa.gov/dailywxmap/plottedwx.html',
          licenseType: ToolLicenseType.PUBLIC_DOMAIN,
          licenseUseType: ToolLicenseUseType.COPY)
    ]),
    GCWSymbolTableTool(symbolKey: 'weather_w', symbolSearchStrings: const [
      'weather',
      'weather_w'
    ], licenses: [
      ToolLicenseImage(
          context: context,
          author: 'Unknown',
          title: 'Past Weather',
          sourceUrl:
          'https://web.archive.org/web/20231123172913/https://www.wpc.ncep.noaa.gov/dailywxmap/plottedwx.html',
          licenseType: ToolLicenseType.PUBLIC_DOMAIN,
          licenseUseType: ToolLicenseUseType.COPY)
    ]),
    GCWSymbolTableTool(symbolKey: 'weather_ww', symbolSearchStrings: const [
      'weather',
      'weather_ww'
    ], licenses: [
      ToolLicenseImage(
          context: context,
          author: 'Unknown',
          title: 'WEATHER FIGURES AND SYMBOLS',
          sourceUrl:
          'https://web.archive.org/web/20230809231644/https://cdn2.hubspot.net/hubfs/604407/weather_symbols.gif',
          licenseType: ToolLicenseType.PUBLIC_DOMAIN,
          licenseUseType: ToolLicenseUseType.COPY)
    ]),
    GCWSymbolTableTool(symbolKey: 'webdings', symbolSearchStrings: const [
      'symbol_webdings',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Webdings',
          sourceUrl: 'https://commons.wikimedia.org/w/index.php?title=File:Webdings-big.png&oldid=899647144',
          licenseType: ToolLicenseType.PUBLIC_DOMAIN)
    ]),
    GCWSymbolTableTool(symbolKey: 'westernunion', symbolSearchStrings: const [
      'symbol_westernunion',
      'teletypewriter'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: "RTTY.COM's CODE-CARD CORNER",
          sourceUrl: 'https://web.archive.org/web/20240808182500/https://www.rtty.com/CODECARD/codecrd1.htm',
          licenseType: ToolLicenseType.FREE_TO_USE)
    ]),
    GCWSymbolTableTool(symbolKey: 'windforce_beaufort', symbolSearchStrings: const [
      'beaufort',
      'symbol_windforce_beaufort',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Wind speed',
          sourceUrl: 'https://commons.wikimedia.org/w/index.php?title=Wind_speed&oldid=760157124',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'wingdings', symbolSearchStrings: const [
      'symbol_wingdings',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Wingdings',
          sourceUrl: 'https://commons.wikimedia.org/w/index.php?title=Wind_speed&oldid=760157124',
          licenseType: ToolLicenseType.PUBLIC_DOMAIN)
    ]),
    GCWSymbolTableTool(symbolKey: 'windforce_knots', symbolSearchStrings: const [
      'beaufort',
      'symbol_windforce_knots',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Wind speed',
          sourceUrl: 'https://commons.wikimedia.org/w/index.php?title=Wind_speed&oldid=760157124',
          licenseType: ToolLicenseType.PUBLIC_DOMAIN)
    ]),
    GCWSymbolTableTool(symbolKey: 'window', symbolSearchStrings: const [
      'window',
    ], licenses: const []),
    GCWSymbolTableTool(symbolKey: 'wingdings', symbolSearchStrings: const [
      'symbol_wingdings',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Wind speed',
          sourceUrl: 'https://commons.wikimedia.org/w/index.php?title=Wind_speed&oldid=760157124',
          licenseType: ToolLicenseType.PUBLIC_DOMAIN)
    ]),
    GCWSymbolTableTool(symbolKey: 'wingdings2', symbolSearchStrings: const [
      'symbol_wingdings2',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Wingdings',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Wingdings&oldid=1234924688',
          licenseType: ToolLicenseType.PUBLIC_DOMAIN)
    ]),
    GCWSymbolTableTool(symbolKey: 'wingdings3', symbolSearchStrings: const [
      'symbol_wingdings3',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Wingdings',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Wingdings&oldid=1234924688',
          licenseType: ToolLicenseType.PUBLIC_DOMAIN)
    ]),
    GCWSymbolTableTool(symbolKey: 'yan_koryani', symbolSearchStrings: const [
      'symbol_yan_koryani',
    ], licenses: [
      stl._toolLicenseMyGeoToolsCodeTabellen,
      ToolLicenseImage(
        context: context,
        author: 'Muhammad Abd-el-Rahman Barker',
        title: 'Tékumel writing systems',
        sourceUrl: 'http://web.archive.org/web/20240418033554/https://www.omniglot.com/conscripts/tekumel.php',
        licenseUseType: ToolLicenseUseType.COPY,
        licenseType: ToolLicenseType.PRIVATE_PERMISSION,
        privatePermission: ToolLicensePrivatePermission(
            context: context,
            medium: 'e-mail',
            permissionYear: 2024,
            permissionMonth: 7,
            permissionDay: 31,
            permissionAuthor: 'Simon Ager (Omniglot)'
        ),)
    ]),
    GCWSymbolTableTool(symbolKey: 'yinyang', symbolSearchStrings: const [
      'symbol_yinyang',
    ], licenses: [
      ToolLicenseImage(
        context: context,
        author: 'Erik Moreno',
        year: 2006, month: 2,
        title: 'Yin yang Alphalines',
        licenseUseType: ToolLicenseUseType.COPY,
        licenseType: ToolLicenseType.PRIVATE_PERMISSION,
        privatePermission: ToolLicensePrivatePermission(
            context: context,
            medium: 'e-mail',
            permissionYear: 2024,
            permissionMonth: 7,
            permissionDay: 31,
            permissionAuthor: 'Simon Ager (Omniglot)'
        ),
        sourceUrl: 'http://web.archive.org/web/20240224073021/https://www.omniglot.com/conscripts/yyal.htm',
      )
    ]),
    GCWSymbolTableTool(symbolKey: 'zamonian', symbolSearchStrings: const [
      'symbol_zamonian',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'File:Zamonische zahlen.svg',
          sourceUrl: 'https://commons.wikimedia.org/w/index.php?title=File:Zamonische_zahlen.svg&oldid=529684347',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'zentradi', symbolSearchStrings: const [
      'symbol_zentradi',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'File:Zentradi Alphabet.jpg',
          sourceUrl: 'https://commons.wikimedia.org/w/index.php?title=File:Zentradi_Alphabet.jpg&oldid=722312236',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'zodiac_signs', symbolSearchStrings: const [
      'symbol_zodiacsigns',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Zodiac',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Zodiac&oldid=1236213028',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'zodiac_signs_latin', symbolSearchStrings: const [
      'symbol_zodiacsigns',
      'symbol_zodiacsigns_latin',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikipedia.org and contributors',
          title: 'Zodiac',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Zodiac&oldid=1236213028',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'zodiac_z340', symbolSearchStrings: const [
      'symbol_zodiac_z340',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'File:Zodiac Z340 cipher key.png',
          sourceUrl: 'https://commons.wikimedia.org/w/index.php?title=File:Zodiac_Z340_cipher_key.png&oldid=759087501',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWSymbolTableTool(symbolKey: 'zodiac_z408', symbolSearchStrings: const [
      'symbol_zodiac_z408',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'en.wikisource.org and contributors; Donald and Bettye Harden',
          title: 'Zodiac Killer cipher translated',
          sourceUrl:
          'https://en.wikisource.org/w/index.php?title=Index:Zodiac_Killer_cipher_deciphered_by_Donald_and_Bettye_Harden.pdf&oldid=11214165',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),

    // TelegraphSelection *********************************************************************************************
    GCWTool(tool: const ChappeTelegraph(), id: 'telegraph_chappe', searchKeys: const [
      'telegraph',
      'telegraph_chappe',
    ], licenses: const []),
    GCWTool(
      tool: const EdelcrantzTelegraph(),
      id: 'telegraph_edelcrantz',
      searchKeys: const [
        'telegraph',
        'telegraph_edelcrantz',
      ],
      licenses: [
        ToolLicenseOnlineBook(
            context: context,
            author: 'Gerard J. Holzmann',
            title: 'The early history of data networks',
            publisher: 'John Wiley & Sons, Hoboken, New Jersey',
            isbn: '0-8186-6782-6',
            year: 2003,
            customComment: 'Page 139ff',
            sourceUrl: 'https://archive.org/details/earlyhistoryofda0000holz/mode/2up'),
        ToolLicenseOnlineBook(
            context: context,
            author: 'Silvia Rubio Hernández',
            title: 'Vapriikki Case: Design and Evaluation of an Interactive Mixed-Reality Museum Exhibit',
            sourceUrl:
            'https://web.archive.org/web/20240721203438/https://trepo.tuni.fi/bitstream/handle/10024/102557/1513599679.pdf?sequence=1&isAllowed=y',
            customComment: 'Page 23ff'),
        ToolLicenseOfflineBook(
            context: context,
            author: i18n(context, 'common_unknown'),
            title: 'Telegrafiske Chiffertabeller',
            year: 1808,
            privatePermission: ToolLicensePrivatePermission(
                context: context,
                medium: 'e-Mail',
                permissionYear: 2021,
                permissionMonth: 10,
                permissionDay: 5,
                permissionAuthor: 'Anders Lindeberg-Lindvet; Kurator Schwedisches Technikmuseum')),
      ],
    ),
    GCWTool(tool: const FoyBreguetTelegraph(), id: 'telegraph_chappe_foybreguet', searchKeys: const [
      'telegraph',
      'telegraph_chappe',
      'telegraph_foybreguet'
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'commons.wikimedia.org and contributors',
          title: 'Foy–Breguet telegraph',
          sourceUrl: 'https://en.wikipedia.org/w/index.php?title=Foy%E2%80%93Breguet_telegraph&oldid=1169555630',
          licenseType: ToolLicenseType.CCBYSA4)
    ]),
    GCWTool(tool: const MurrayTelegraph(), id: 'telegraph_murray', searchKeys: const [
      'telegraph',
      'telegraph_murray',
    ], licenses: [
      ToolLicenseOnlineArticle(
        context: context,
        author: 'Helmar Fischer',
        title:
        'Informationen übertragen - nicht mit der großen Klappe sondern mit sechs kleinen Klappen ... der Klappentelegraph',
        privatePermission: ToolLicensePrivatePermission(
            context: context, medium: 'e-Mail', permissionYear: 2021, permissionMonth: 7, permissionDay: 23),
        sourceUrl:
        'https://web.archive.org/web/20240721211725/https://cms.sachsen.schule/typoecke2/typo-experimente/informationuebertragung-mit-dem-klappentelegraph/',
      ),
      ToolLicenseOnlineArticle(
        context: context,
        author: 'John Buckledee, Chairman, Dunstable and District Local History Society on behalf of Mrs Omer Roucoux',
        title: 'Dunstable Signalling Station',
        privatePermission: ToolLicensePrivatePermission(
          context: context,
          medium: 'e-Mail',
          permissionYear: 2021,
          permissionMonth: 12,
          permissionDay: 13,
        ),
        sourceUrl:
        'https://web.archive.org/web/20240727121255/https://virtual-library.culturalservices.net/webingres/bedfordshire/vlib/0.digitised_resources/dunstable_article_signalling_station_two.htm',
      ),
      ToolLicenseImage(
        context: context,
        author: 'Unknown',
        title: 'View of the Telegraph erected on the Admiralty Office, Charing Cross in Feby 1796',
        sourceUrl:
        'https://web.archive.org/web/20240819160122/https://c7.alamy.com/comp/P036GR/english-view-of-the-telegraph-erected-on-the-admiralty-office-charing-cross-in-feby-1796-text-in-english-within-plate-the-print-dates-from-the-year-that-the-revd-lord-george-murray-designed-the-original-arrangement-although-telegraph-or-semaphore-signals-were-also-developed-in-france-as-well-as-england-in-the-last-years-of-the-18th-century-murrays-system-was-known-as-the-shutter-telegraph-and-comprised-a-vertical-board-with-six-large-holes-in-its-face-each-of-which-could-be-opened-to-display-the-sky-or-a-light-or-closed-see-mdl0020-depending-on-the-lie-of-the-land-distances-bet-P036GR.jpg',
        licenseType: ToolLicenseType.FREE_TO_USE,
        licenseUseType: ToolLicenseUseType.COPY,
      ),
    ]),
    GCWTool(tool: const OhlsenTelegraph(), id: 'telegraph_ohlsen', searchKeys: const [
      'telegraph',
      'telegraph_ohlsen',
    ], licenses: [
      ToolLicenseOfflineBook(
          context: context,
          author: 'Ole Ohlsen',
          title: 'Den Optiske Telegraf',
          year: 1808,
          privatePermission: ToolLicensePrivatePermission(
              context: context,
              permissionAuthor: 'Anne Solberg, Museumsbibliotekar, Norsk Teknisk Museum',
              medium: 'e-Mail',
              permissionYear: 2021,
              permissionMonth: 10,
              permissionDay: 28)),
    ]),
    GCWTool(tool: const PasleyTelegraph(), id: 'telegraph_pasley', searchKeys: const [
      'telegraph',
      'telegraph_pasley',
    ], licenses: [
      stl._toolLicenseWrixonGeheimsprachen,
    ]),
    GCWTool(tool: const PophamTelegraph(), id: 'telegraph_popham', searchKeys: const [
      'telegraph',
      'telegraph_popham',
    ], licenses: [
      stl._toolLicenseWrixonGeheimsprachen,
    ]),
    GCWTool(tool: const PrussiaTelegraph(), id: 'telegraph_prussia', searchKeys: const [
      'telegraph',
      'telegraph_prussia',
    ], licenses: [
      ToolLicenseOfflineBook(
          context: context,
          author: 'Königl. Pruess. Telegraphendirection',
          title:
          'Classe 5.2 Wörterbuch für die Telegraphisten-Correspondenz\nInstruction. Erster Abschnitt. Die Behandlung des Apparates.\nInstruction. Zweiter Abschnitt. Das Telegraphieren.',
          privatePermission: ToolLicensePrivatePermission(
            context: context,
            medium: 'e-Mail',
            permissionYear: 2021,
            permissionMonth: 11,
            permissionDay: 26,
            permissionAuthor: 'Sandy Lang, Bibliothek, Museum für Kommunikation Frankfurt',
          )),
    ]),
    GCWTool(tool: const SemaphoreTelegraph(), id: 'symboltables_semaphore', searchKeys: const [
      'telegraph',
      'telegraph_semaphore',
    ]),
    GCWTool(tool: const SteinheilTelegraph(), id: 'telegraph_steinheil', searchKeys: const [
      'telegraph',
      'telegraph_steinheil',
    ], licenses: [
      ToolLicenseOnlineArticle(
          context: context,
          author: 'de.wikipedia.org and contributors',
          title: 'Steinheilschrift',
          sourceUrl: 'https://de.wikipedia.org/w/index.php?title=Steinheilschrift&oldid=225516165',
          licenseType: ToolLicenseType.CCBYSA4),
      ToolLicenseOnlineBook(
          context: context,
          author: 'Taliaferro Preston Shaffner',
          title:
          'The Telegraph Manual: A Complete History and Description of the Semaphoric, Electri and Magnetic Telegraphs of Europe, Asia, Africa, and America, Ancient and Modern',
          sourceUrl: '',
          year: 1859,
          publisher: 'Pudney & Russell',
          customComment: 'Chapter XII, Page 178')
    ]),
    GCWTool(tool: const WigWagSemaphoreTelegraph(), id: 'telegraph_wigwag', searchKeys: const [
      'telegraph',
      'telegraph_wigwag',
    ]),
    GCWTool(tool: const GaussWeberTelegraph(), id: 'telegraph_gausswebertelegraph', searchKeys: const [
      'telegraph',
      'telegraph_gaussweber',
    ]),
    GCWTool(
      tool: const SchillingCanstattTelegraph(),
      id: 'telegraph_schillingcanstatt',
      searchKeys: const [
        'telegraph',
        'telegraph_schillingcanstatt',
      ],
      licenses: [
        ToolLicenseOfflineBook(
            context: context,
            author: 'Volker Aschoff',
            title: 'Paul Schilling von Canstatt und die Geschichte des elektromagnetischen Telegraphen',
            publisher: 'R. Oldenbourg Verlag, München',
            isbn: '3-486-20691-5',
            year: 1976,
            customComment: 'Deutsches Museum Abhandlungen und Berichte 44. Jahrgang 1976 • Heft 3'),
        ToolLicenseOnlineBook(
            context: context,
            author: 'Tal. P. Shaffner',
            title:
            'The telegraph manual : a complete history and description of the semaphoric, electric and magnetic telegraphs of Europe, Asia, Africa, and America, ancient and modern : with six hundred and twenty-five illustrations',
            publisher: 'D. van Nostrand, New York',
            isbn: '',
            year: 1867,
            customComment: 'Page 139',
            sourceUrl: 'https://archive.org/details/telegraphmanualc00shafrich/page/6/mode/2up'),
        ToolLicenseOnlineArticle(
            context: context,
            author: 'Eva Völker',
            title: 'Forum Wissen. Das Gauß’sche Telegraphenalphabet',
            sourceUrl: 'https://web.archive.org/web/20240820183159/https://www.forum-wissen.de/blog/das-gausssche-telegraphenalphabet/')
      ],
    ),
    GCWTool(tool: const WheatstoneCookeNeedleTelegraph(), id: 'telegraph_wheatstonecooke_needle', searchKeys: const [
      'telegraph',
      'telegraph_wheatstonecooke_needle',
    ]),

    //Teletypewriter Selection **********************************************************************************************
    GCWTool(tool: const AncientTeletypewriter(), id: 'ccitt_ancient', searchKeys: const [
      'ccitt',
      'ccitt_ancient',
      'teletypewriter',
      'symbol_siemens',
      'symbol_westernunion',
      'symbol_murraybaudot',
      'symbol_baudot'
    ]),
    GCWTool(tool: const CCITTTeletypewriter(), id: 'ccitt', searchKeys: const [
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
        tool: const OtherTeletypewriter(),
        id: 'ccitt_other',
        searchKeys: const ['teletypewriter', 'z22', 'zc1', 'illiac', 'algol', 'tts']),

    // TomTomSelection *********************************************************************************************
    GCWTool(tool: const TomTom(), id: 'tomtom', searchKeys: const [
      'tomtom',
    ]),

    // UICWagonCodeSelection ***************************************************************************************
    GCWTool(tool: const UICWagonCode(), id: 'uic_wagoncode', searchKeys: const [
      'railways',
      'uic',
      'uic_wagoncode',
    ], licenses: [
      stl._toolLicenseUICWiki,
      stl._toolLicenseUIC,
      ToolLicenseOnlineArticle(context: context,
          author: 'Svetlana Limberg (bahndienstwagen-online.de)',
          title: 'Spezialfahrzeuge nach dem UIC/OSShD-Kodex 438-4',
          sourceUrl: 'https://web.archive.org/web/20240819155713/http://www.bahndienstwagen-online.de/bahn/BDW/NVR438_4/nvr0.html'
      )
    ]),
    GCWTool(tool: const UICWagonCodeVKM(), id: 'uic_wagoncode_vkm', searchKeys: const [
      'railways',
      'uic',
      'uic_wagoncode',
      'uic_wagoncode_vkm',
    ], licenses: [
      ToolLicenseOnlineArticle(context: context,
          author: 'ERA - European Railway Agency',
          title: 'Application Guide for Vehicle Keeper Marking Code (VKM) Register',
          sourceUrl: 'http://web.archive.org/web/20240819164253/https://www.era.europa.eu/system/files/2022-11/Application%20guide%20for%20VKM%20Register.pdf?t=1724057016',
          year: 2014, month: 4, day: 1
      ),
      ToolLicenseFile(
        context: context,
        author: 'ERA - European Railway Agency',
        title: '168th list of VKMs',
        year: 2024, month: 3,
        sourceUrl: 'http://web.archive.org/save/https://www.era.europa.eu/system/files/2024-03/IU-VKM-publiclist-168.xls',
        licenseType: ToolLicenseType.PUBLIC_DOMAIN,
        licenseUseType: ToolLicenseUseType.COPY,
      )
    ]),
    GCWTool(tool: const UICWagonCodeCountryCodes(), id: 'uic_wagoncode_countrycodes', searchKeys: const [
      'railways',
      'uic',
      'uic_wagoncode',
      'countries',
    ], licenses: [
      stl._toolLicenseUICWiki,
      stl._toolLicenseUIC
    ]),
    GCWTool(
        tool: const UICWagonCodeFreightClassifications(),
        id: 'uic_wagoncode_freight_classification',
        searchKeys: const [
          'railways',
          'uic',
          'uic_wagoncode',
        ], licenses: [
      stl._toolLicenseUICWiki,
      stl._toolLicenseUIC
    ]),
    GCWTool(
        tool: const UICWagonCodePassengerLettercodes(),
        id: 'uic_wagoncode_passenger_lettercodes',
        searchKeys: const [
          'railways',
          'uic',
          'uic_wagoncode',
        ], licenses: [
      stl._toolLicenseUICWiki,
      stl._toolLicenseUIC,
      ToolLicenseOnlineArticle(context: context,
          author: 'Christian Dittmer (deutsche-reisezugwagen.de)',
          title: 'Aufbau der UIC-Wagennummer',
          sourceUrl: 'https://web.archive.org/web/20240819155722/https://www.deutsche-reisezugwagen.de/lexikon/aufbau-der-uic-wagennummer/'
      )
    ]),

    //VanitySelection **********************************************************************************************
    GCWTool(tool: const VanitySingletap(), id: 'vanity_singletap', searchKeys: const [
      'vanity',
      'vanitysingletap',
    ], licenses: const []),
    GCWTool(tool: const VanityMultitap(), id: 'vanity_multitap', searchKeys: const [
      'vanity',
      'vanitymultitap',
    ], licenses: const []),
    GCWTool(tool: const VanityWordsList(), id: 'vanity_words_list', searchKeys: const [
      'vanity',
      'vanitywordslist',
    ]),
    GCWTool(tool: const VanityWordsTextSearch(), id: 'vanity_words_search', searchKeys: const [
      'vanity',
      'vanitytextsearch',
    ]),

    //VigenereSelection *******************************************************************************************
    GCWTool(tool: const VigenereBreaker(), id: 'vigenerebreaker', categories: const [
      ToolCategory.GENERAL_CODEBREAKERS
    ], searchKeys: const [
      'codebreaker',
      'vigenerebreaker',
      'vigenere',
      'rotation',
    ], licenses: [
      ToolLicenseOnlineArticle(
        context: context,
        author: 'Jens Guballa',
        title: 'Implementierung des Vigenère Solvers',
        sourceUrl:
        'https://web.archive.org/web/20240414052702/https://guballa.de/bits-and-bytes/implementierung-des-vigenere-solvers',
      )
    ]),
    GCWTool(tool: Vigenere(), id: 'vigenere', searchKeys: const [
      'vigenere',
      'rotation',
    ]),
    GCWTool(tool: const Gronsfeld(), id: 'gronsfeld', searchKeys: const [
      'vigenere',
      'rotation',
      'gronsfeld',
    ]),
    GCWTool(tool: const Trithemius(), id: 'trithemius', searchKeys: const [
      'vigenere',
      'rotation',
      'trithemius',
    ]),
    GCWTool(
        tool: const WeddingAnniversaries(),
        id: 'wedding_anniversaries',
        categories: const [ToolCategory.MISCELLANEOUS],
        searchKeys: const ['weddinganniversaries']),

    // WherigoUrwigoSelection ************************************************************************************
    GCWTool(tool: const WherigoAnalyze(), id: 'wherigo', categories: const [
      ToolCategory.IMAGES_AND_FILES,
      ToolCategory.GENERAL_CODEBREAKERS
    ], searchKeys: const [
      'wherigo',
      'wherigourwigo',
    ], licenses: [
      ToolLicensePortedCode(
          context: context,
          author: 'WFoundation',
          title: 'WF.Compiler',
          sourceUrl: 'https://web.archive.org/web/20240722202351/https://github.com/WFoundation/WF.Compiler',
          licenseType: ToolLicenseType.GITHUB_DEFAULT),
    ]),
    //UrwigoHashBreaker already inserted in section "Hashes"
    GCWTool(tool: const UrwigoTextDeobfuscation(), id: 'urwigo_textdeobfuscation', searchKeys: const [
      'wherigo',
      'urwigo',
      'urwigo_textdeobfuscation'
    ], licenses: [
      ToolLicensePortedCode(
          context: context,
          author: 'François "Krevo" Crevola',
          title: 'Wherigo Tools',
          sourceUrl: 'https://web.archive.org/web/20240722202750/https://github.com/Krevo/WherigoTools',
          licenseType: ToolLicenseType.MIT),
    ]),
    GCWTool(
        tool: const EarwigoTextDeobfuscation(),
        id: 'earwigo_textdeobfuscation',
        searchKeys: const ['wherigo', 'earwigo', 'urwigo_textdeobfuscation']),

    // ZodiacSelection ******************************************************************************************
    GCWTool(tool: const Zodiac(), id: 'zodiac', searchKeys: const [
      'symbol_alchemy',
      'symbol_planets',
      'symbol_zodiacsigns',
      'symbol_zodiacsigns_latin',
    ], licenses: const []),
  ].map((toolWidget) {
    toolWidget.toolName = i18n(context, toolWidget.id + '_title');
    toolWidget.defaultLanguageToolName = i18n(context, toolWidget.id + '_title', useDefaultLanguage: true);

    try {
      toolWidget.description = i18n(context, toolWidget.id + '_description');
    } catch (e) {}

    try {
      toolWidget.example = i18n(context, toolWidget.id + '_example');
    } catch (e) {}

    return toolWidget;
  }).toList();

  createIndexedSearchStrings();
}

void refreshRegistry() {
  registeredTools = [];
}
