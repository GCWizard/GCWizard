import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/main_menu/gcw_mainmenuentry_stub.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';

class Licenses extends StatefulWidget {
  @override
  LicensesState createState() => LicensesState();
}

class LicensesState extends State<Licenses> {
  @override
  Widget build(BuildContext context) {
    var content = Column(children: [
      GCWTextDivider(text: i18n(context, 'licenses_usedflutterlibraries')),
      Column(
        children: columnedMultiLineOutput(null, [
          ['archive', 'Apache 2.0 License'],
          ['auto_size_text', 'MIT License'],
          ['base32', 'MIT License'],
          ['cached_network_image', 'MIT License'],
          ['diacritic', 'BSD-3-Clause License'],
          ['file_picker', 'MIT License'],
          ['file_picker_writable', 'MIT License'],
          ['encrypt', 'BSD-3-Clause License'],
          ['exif', 'MIT License'],
          ['flutter_map', 'BSD-3-Clause License'],
          ['flutter_map_marker_popup', 'BSD-3-Clause License'],
          ['flutter_map_tappable_polyline', 'MIT License'],
          ['fluttertoast', 'MIT License'],
          ['http', 'BSD-3-Clause License'],
          ['image', 'Apache 2.0 License'],
          ['intl', 'BSD-3-Clause License'],
          ['location', 'MIT License'],
          ['mask_text_input_formatter', 'MIT License'],
          ['math_expressions', 'MIT License'],
          ['package_info', 'BSD-3-Clause License'],
          ['path', 'BSD-3-Clause License'],
          ['path_provider', 'BSD-3-Clause License'],
          ['permission_handler', 'MIT License'],
          ['pointycastle', 'MIT License'],
          ['prefs', 'Apache 3.0 License'],
          ['provider', 'MIT License'],
          ['qr', 'BSD-3-Clause License'],
          ['r_scan', 'BSD-3-Clause License'],
          ['scrollable_positioned_list', 'BSD-3-Clause License'],
          ['touchable', 'GPL 3.0 License'],
          ['universal_html', 'Apache 2.0 License'],
          ['uuid', 'MIT License'],
          ['url_launcher', 'BSD-3-Clause License'],
        ]),
      ),
      GCWTextDivider(text: i18n(context, 'licenses_additionalcode')),
      Column(
        children: columnedMultiLineOutput(null, [
          ['Astronomy Functions', 'astronomie.info, jgiesen.de', null],
          ['Beatnik Interpreter', 'Hendrik Van Belleghem', 'Gnu Public License, Artistic License'],
          ['Calendar conversions', 'Johannes Thomann, University of Zurich Asia-Orient-Institute', null],
          ['Centroid Code', 'Andy Eschbacher (carto.com)', null],
          [
            'Chef Interpreter',
            'Wesley Janssen, Joost Rijneveld, Mathijs Vos',
            'CC0 1.0 Universal Public Domain Dedication'
          ],
          ['Color Picker', 'flutter_hsvcolor_picker (minimized)', 'Color Picker', null],
          ['Coordinate Measurement', 'David Vávra', 'Apache 2.0 License'],
          ['Cow Interpreter', 'Marco "Atomk" F.', 'MIT License'],
          ['Cow Generator', 'Frank Buss', null],
          ['Gauss-Krüger Code', 'moenk', null],
          ['Geo3x3 Code', '@taisukef', 'CC0-1.0 License'],
          ['Geodetics Code', 'Charles Karney (GeographicLib)', 'MIT/X11 License'],
          ['GeoHex Code', '@chsii (geohex4j), @sa2da (geohex.org)', 'MIT License'],
          ['Malbolge Code', 'lscheffer.com, Matthias Ernst', 'CC0, Public Domain'],
          ['Substitution Breaker', 'Jens Guballa (guballa.de)', 'MIT License'],
          ['Sudoku Solver', 'Peter Norvig (norvig.com), \'dartist\'', 'MIT License'],
          ['Vigenère Breaker', 'Jens Guballa (guballa.de)', null],
          ['Whitespace Interpreter', 'Adam Papenhausen', 'MIT License'],
        ]),
      ),
      GCWTextDivider(text: i18n(context, 'licenses_symboltablesources')),
      Column(
        children: columnedMultiLineOutput(null, [
          ['myGeoTools', 'several'],
          ['Wikipedia', 'several'],
          ['www.steinerverlag.de', 'Eurythmy'],
          ['www.breitkopf.de', 'Solmisation'],
          ['game-icons.net (CC BY 3.0)\npixabay.com\nwww.clker.com (CC-0)', 'Geocache Attributes'],
          ['Schilling Canstatt Telegraph', 'Volker Aschoff,\nPaul Schilling von Canstatt und die Geschichte des elektromagnetischen Telegraphen\nISBN 3-486-20691-5'],
        ]),
      ),
      GCWTextDivider(text: i18n(context, 'licenses_bibliography')),
      Column(
        children: columnedMultiLineOutput(null, [
          ['Aschoff, Volker', 'Paul Schilling von Canstatt und die Geschichte des elektromagnetischen Telegraphen\nISBN 3-486-20691-5'],
          ['Holzmann, Gerard J.', 'The early history of data networks\nISBN 978-0-8186678-2-4'],
          ['Long, Cully', 'How to puzzle caches\nISBN 978-0-9973488-9-7'],
          ['Wrixon, Fred B.', 'Geheimsprachen\nISBN 978-3-8331-2562-1'],
          ["Navajo Code Talkers' Dictionary", 'https://www.history.navy.mil/research/library/online-reading-room/title-list-alphabetically/n/navajo-code-talker-dictionary.html'],
          ['World Braille usage', 'https://www.perkins.org/wp-content/uploads/2021/07/world-braille-usage-third-edition.pdf'],
          ['Das System der deutschen Blindenschrift', 'https://www.pharmabraille.com/wp-content/uploads/2015/01/system_d_blindenschrift_7620.pdf'],
          ['Code Braille Français Uniformisé (CBFU) 2nd edition, September 2008', 'https://www.pharmabraille.com/wp-content/uploads/2015/01/CBFU_edition_internationale.pdf'],
          ['Rules of Unified English Braille 2013', 'https://www.pharmabraille.com/wp-content/uploads/2015/11/Rules-of-Unified-English-Braille-2013.pdf'],
          ['Königlich Preussische Telegraphendirection', 'Wörterbuch für die Telegraphisten-Coorespondenz\nhttp://www.optischertelegraph23.de/mobile/'],
          ['', ''],
        ]),
      ),
    ]);

    return GCWMainMenuEntryStub(content: content);
  }
}
