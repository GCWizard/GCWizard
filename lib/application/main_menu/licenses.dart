import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/main_menu/mainmenuentry_stub.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';

class Licenses extends StatefulWidget {
  const Licenses({Key? key}) : super(key: key);

  @override
  _LicensesState createState() => _LicensesState();
}

class _LicensesState extends State<Licenses> {
  @override
  Widget build(BuildContext context) {
    var content = Column(children: [
      GCWExpandableTextDivider(
          text: i18n(context, 'licenses_additionalcode'),
          child: const GCWColumnedMultilineOutput(data: [
            ['Astronomy Functions', 'astronomie.info, jgiesen.de', 'Personal Permission'],
            ['Base58', 'Dark Launch', null],
            ['Base91', 'Joachim Henke', 'BSD-3-Clause License'],
            ['Base122', 'Kevin Alberston\nPatrick Favre-Bulle', 'MIT License\nApache License, Version 2.0'],
            ['Beatnik Interpreter', 'Hendrik Van Belleghem', 'Gnu Public License, Artistic License'],
            [
              'Calendar conversions',
              'Johannes Thomann, University of Zurich Asia-Orient-Institute',
              'Personal Permission'
            ],
            ['Centroid Code', 'Andy Eschbacher (carto.com)', 'Personal Permission'],
            [
              'Chef Interpreter',
              'Wesley Janssen, Joost Rijneveld, Mathijs Vos',
              'CC0 1.0 Universal Public Domain Dedication'
            ],
            ['Color Picker', 'flutter_hsvcolor_picker (minimized)', null],
            ['Coordinate Measurement', 'David Vávra', 'Apache 2.0 License'],
            ['Cow Interpreter', 'Marco "Atomk" F.', 'MIT License'],
            ['Cow Generator', 'Frank Buss', 'Personal Permission'],
            ['DutchGrid Code', '@djvanderlaan', 'MIT License'],
            ['Gauss-Krüger Code', 'moenk', 'Personal Permission'],
            ['GC Wizard Script Code', 'Herbert Schildt/James Holmes\nMcGrawHill', 'Personal Permission'],
            ['Geo3x3 Code', '@taisukef', 'CC0-1.0 License'],
            ['Geodetics Code', 'Charles Karney (GeographicLib)', 'MIT/X11 License'],
            ['GeoHex Code', '@chsii (geohex4j), @sa2da (geohex.org)', 'MIT License'],
            ['Lambert Code', 'Charles Karney (GeographicLib)', 'MIT/X11 License'],
            ['Magic Eye Solver', 'piellardj.github.io\ngithub.com/machinewrapped', 'MIT License'],
            ['Malbolge Code', 'lscheffer.com, Matthias Ernst', 'CC0, Public Domain'],
            ['Substitution Breaker', 'Jens Guballa (guballa.de)', 'MIT License'],
            ['Sudoku Solver', 'Peter Norvig (norvig.com), \'dartist\'', 'MIT License'],
            ['Urwigo Tools', '@Krevo (WherigoTools)', 'MIT License'],
            ['Vigenère Breaker', 'Jens Guballa (guballa.de)', 'Personal Permission'],
            ['Whitespace Interpreter', 'Adam Papenhausen', 'MIT License'],
            ['Wherigo Analyzer', 'WFoundation\ngithub.com/WFoundation', ''],
          ])),
      GCWExpandableTextDivider(
          text: i18n(context, 'licenses_used_apis'),
          suppressTopSpace: false,
          child: const GCWColumnedMultilineOutput(data: [
            ['Geohashing', 'http://geo.crox.net/djia/{yyyy-MM-dd}'],
          ])),
      GCWExpandableTextDivider(
          text: i18n(context, 'licenses_telegraphs'),
          suppressTopSpace: false,
          child: GCWColumnedMultilineOutput(data: [
            [
              i18n(context, 'telegraph_edelcrantz_title'),
              'Gerard Holzmann,\nSilvia Rubio Hernández\nAnders Lindeberg-Lindvet, Curator Tekniskamuseet Stockholm\nErika Tanhua-Piiroinen, Tampere University Finland'
            ],
            [
              i18n(context, 'telegraph_murray_title'),
              'Helmar Fischer,\nJohn Buckledee, Chairman, Dunstable and District Local History Society on behalf of Mrs Omer Roucoux'
            ],
            [i18n(context, 'telegraph_ohlsen_title'), 'Anne Solberg\nNorsk Teknisk Museum, Oslo'],
            [
              i18n(context, 'telegraph_pasley_title'),
              'Wrixon, Fred B.: Geheimsprachen. Könemann, 2006. ISBN 978-3-8331-2562-1. Seite 450'
            ],
            [
              i18n(context, 'telegraph_popham_title'),
              'Wrixon, Fred B.: Geheimsprachen. Könemann, 2006. ISBN 978-3-8331-2562-1. Seite 446'
            ],
            [
              i18n(context, 'telegraph_prussia_title'),
              'Bilddatenbank der Museumsstiftung Post und Telekommunikation (CC BY-SA)'
            ],
            [i18n(context, 'telegraph_schillingcanstatt_title'), 'Volker Aschoff'],
          ])),
      GCWExpandableTextDivider(
          text: i18n(context, 'licenses_images'),
          suppressTopSpace: false,
          child: GCWColumnedMultilineOutput(
            data: [
              [i18n(context, 'iau_constellation_title'), 'Torsten Bronger', 'GNU FDL, Version 1.2/CC BY-SA 3.0']
            ],
          )),
      GCWExpandableTextDivider(
          text: i18n(context, 'licenses_usedflutterlibraries'),
          expanded: false,
          suppressTopSpace: false,
          child: const GCWColumnedMultilineOutput(data: [
            ['archive', 'Apache 2.0 License'],
            ['audioplayers', 'MIT License'],
            ['auto_size_text', 'MIT License'],
            ['base32', 'MIT License'],
            ['cached_network_image', 'MIT License'],
            ['code_text_field', 'MIT License'],
            ['device_info_plus', 'BSD-3-Clause License'],
            ['diacritic', 'BSD-3-Clause License'],
            ['encrypt', 'BSD-3-Clause License'],
            ['exif', 'MIT License'],
            ['file_picker', 'MIT License'],
            ['file_picker_writable', 'MIT License'],
            ['flutter_highlight', 'MIT License'],
            ['flutter_localizations', 'BSD-3-Clause License'],
            ['flutter_map', 'BSD-3-Clause License'],
            ['flutter_map_marker_popup', 'BSD-3-Clause License'],
            ['flutter_map_tappable_polyline', 'MIT License'],
            ['highlight', 'MIT License'],
            ['http', 'BSD-3-Clause License'],
            ['http_parser', 'BSD-3-Clause License'],
            ['image', 'Apache 2.0 License'],
            ['intl', 'BSD-3-Clause License'],
            ['latlong2', 'Apache 2.0 License'],
            ['location', 'MIT License'],
            ['mask_text_input_formatter', 'MIT License'],
            ['math_expressions', 'MIT License'],
            ['package_info_plus', 'BSD-3-Clause License'],
            ['path', 'BSD-3-Clause License'],
            ['path_provider', 'BSD-3-Clause License'],
            ['permission_handler', 'MIT License'],
            ['photo_view', 'MIT License'],
            ['pointycastle', 'MIT License'],
            ['prefs', 'Apache 3.0 License'],
            ['provider', 'MIT License'],
            ['qr', 'BSD-3-Clause License'],
            ['r_scan', 'BSD-3-Clause License'],
            ['scrollable_positioned_list', 'BSD-3-Clause License'],
            ['stack', 'MIT License'],
            ['touchable', 'GPL 3.0 License'],
            ['tuple', 'BSD-2-Clause License'],
            ['universal_html', 'Apache 2.0 License'],
            ['unrar_file', 'Apache 2.0 License'],
            ['uuid', 'MIT License'],
            ['url_launcher', 'BSD-3-Clause License'],
            ['utility', 'MIT License'],
            ['week_of_year', 'BSD-3-Clause License'],
            ['xml', 'MIT License'],
            [
              'xmp',
              'MIT License'
            ], // it used not in pubspec but directly embedded because of conflicts of internal dependencies
          ])),
      GCWExpandableTextDivider(
          text: i18n(context, 'licenses_fonts'),
          expanded: false,
          suppressTopSpace: false,
          child: const GCWColumnedMultilineOutput(data: [
            ['Courier Prime', 'Google Fonts', 'SIL OPEN FONT LICENSE Version 1.1'],
            ['Roboto', 'Google Fonts', 'Apache License, Version 2.0']
          ])),
      GCWExpandableTextDivider(
          text: i18n(context, 'licenses_symboltablesources'),
          expanded: false,
          suppressTopSpace: false,
          child: GCWColumnedMultilineOutput(data: [
            const ['several', 'myGeoTools'],
            const ['several', 'Wikipedia'],
            [i18n(context, 'symboltables_alien_mushrooms_title'), '(Personal Use)'],
            [
              i18n(context, 'symboltables_base16_title'),
              'https://web.archive.org/web/20221224135846/https://patentimages.storage.googleapis.com/88/54/da/d88ca78fe93623/US3974444.pdf'
            ],
            [i18n(context, 'symboltables_base16_02_title'), 'https://dl.acm.org/doi/pdf/10.1145/364096.364107'],
            [i18n(context, 'symboltables_berber_title'), 'https://en.wikipedia.org/wiki/Tifinagh (Wiki Commons)'],
            [
              i18n(context, 'symboltables_bibibinary_title'),
              'https://en.wikipedia.org/wiki/Bibi-binary#/media/File:Table_de_correspondance_entre_le_Bibinaire_et_les_autres_notations.svg (CC BY-SA 4.0)'
            ],
            [
              i18n(context, 'symboltables_blue_monday_title'),
              'adopted from https://geocachen.be/geocaching/geocache-puzzels-oplossen/blue-monday-kleurencode/; (Personal Use)'
            ],
            [i18n(context, 'symboltables_cirth_erebor_title'), '(Personal Use)'],
            [i18n(context, 'symboltables_christmas_title'), 'StudioMIES (Personal Use)'],
            [i18n(context, 'symboltables_dragon_language_title'), '(Personal Use)'],
            [i18n(context, 'symboltables_eurythmy_title'), 'www.steinerverlag.de (Non-Commercial Use)'],
            [i18n(context, 'symboltables_face_it_title'), '(Personal Use)'],
            [i18n(context, 'symboltables_fantastic_title'),
              'https://nederlandse-fantasia.fandom.com/wiki/Fantastisch (CC BY-SA 3.0)'],
            [i18n(context, 'symboltables_futurama_2_title'), 'Leandor Pardini (onlinewebfonts.com) (CC BY-SA 3.0)'],
            [
              i18n(context, 'symboltables_gc_attributes_ids_title'),
              'game-icons.net (CC BY 3.0)\npixabay.com\nclker.com (CC-0)'
            ],
            [i18n(context, 'symboltables_iokharic_title'), '(Personal Use)'],
            [
              i18n(context, 'symboltables_kabouter_abc_title'),
              'Pascalvanboxel, Egel (scoutpedia.nl) (CC BY-NC-SA 4.0)'
            ],
            [
              i18n(context, 'symboltables_kurrent_title'),
              'https://commons.wikimedia.org/wiki/File:Deutsche_Kurrentschrift.jpg (Public Domain)'
            ],
            [
              i18n(context, 'symboltables_matoran_title'),
              'Matoran is part of the Bionicle™ world. Bionicle™ is a trademark of the LEGO Group of companies which does not sponsor, authorize or endorse this tool. (Personal Use)'
            ],
            [
              i18n(context, 'symboltables_maya_numbers_glyphs_title'),
              'https://www.mayan-calendar.org/images/reference/mayan-numbers_mayan-number-system_720x570.gif (Reporductions of this educational item are allowed. www.unitycorps.org)'
            ],
            [i18n(context, 'symboltables_murray_title'), 'Japiejo (geocachingtoolbox.com)'],
            [
              i18n(context, 'symboltables_ninjargon_title'),
              'Ninjago™ is a trademark of the LEGO Group of companies which does not sponsor, authorize or endorse this tool. (Personal Use)'
            ],
            [i18n(context, 'symboltables_oak_island_money_pit_extended_title'), 'oakislandmystery.com (Personal Use)'],
            [i18n(context, 'symboltables_prosyl_title'), '(Personal Use)'],
            [i18n(context, 'symboltables_puzzle_2_title'), 'Roci (fontspace.com) (Personal Use)'],
            [i18n(context, 'telegraph_prussia_title'), 'Museumsstiftung Post und Telekommunikation (CC BY-SA)'],
            [i18n(context, 'symboltables_sanluca_title'), 'Leadermassimo (wikimafia.it) (CC BY-SA 4.0)'],
            [i18n(context, 'symboltables_solmisation_title'), 'www.breitkopf.de (Personal Use)'],
            [i18n(context, 'symboltables_sprykski_title'), '(Personal Use)'],
            [i18n(context, 'symboltables_tifinagh_title'), 'https://en.wikipedia.org/wiki/Tifinagh (Wiki Commons)'],
            [i18n(context, 'symboltables_voynich_title'), 'VonHaarberg, (WikiCommons, CC BY-SA 4.0)'],
            [
              i18n(context, 'symboltables_steinheil_title'),
              'https://de.wikipedia.org/wiki/Steinheilschrift (Wiki Commons)'
            ],
            [i18n(context, 'symboltables_vulcanian_title'), '(Personal Use)'],
          ], flexValues: const [
            1,
            2
          ])),
    ]);

    return MainMenuEntryStub(content: content);
  }
}
