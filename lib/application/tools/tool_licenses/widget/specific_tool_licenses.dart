part of 'package:gc_wizard/application/registry.dart';

class _SpecificToolLicenses {
  final BuildContext context;
  _SpecificToolLicenses(this.context);

  BuildContext get _context {
    return context;
  }

  ToolLicenseEntry get _toolLicenseJanMeeus {
    return ToolLicenseOfflineBook(
      context: _context,
      author: 'Jean Meeus',
      title: 'Astronomical Algorithms',
      isbn: '978-0943396613',
      publisher: 'Atlantic Books',
      year: 1998,
      month: 12,
      day: 1
    );
  }

  ToolLicenseEntry get _toolLicenseGeographicLib {
    return ToolLicensePortedCode(
      context: _context,
      author: 'Charles Karney',
      title: 'GeographicLib',
      licenseType: ToolLicenseType.MIT,
      licenseUrl: 'https://github.com/S-Man42/geographiclib/blob/23bd797bf2b1fa894ca30b69a9cf998e00f4a663/LICENSE.txt',
      sourceUrl: 'https://github.com/S-Man42/geographiclib/tree/23bd797bf2b1fa894ca30b69a9cf998e00f4a663'
    );
  }

  ToolLicenseEntry get _toolLicensePointyCastle {
    return ToolLicenseCodeLibrary(
      context: _context,
      author: 'Legion of the Bouncy Castle Inc',
      title: 'Flutter Library: Pointy Castle',
      licenseType: ToolLicenseType.MIT,
      licenseUrl: 'https://github.com/S-Man42/pc-dart/blob/c7009dbf7785f4ff865ddb4eefdaed8c18ef3baa/LICENSE',
      sourceUrl: 'https://github.com/S-Man42/pc-dart/tree/c7009dbf7785f4ff865ddb4eefdaed8c18ef3baa'
    );
  }

  ToolLicenseEntry get _toolLicenseFAA8260 {
    return ToolLicenseOnlineArticle(
      context: _context,
      author: 'U.S. Department of Transportation (FAA)',
      title: 'Article: FAA Order 8260.58A CHG 2, Appendix E: Geospatial Standard',
      year: 2018, month: 11, day: 9,
      sourceUrl: 'https://web.archive.org/web/20240118214508/https://www.faa.gov/documentLibrary/media/Order/FAA_Order_8260.58A_Including_Change_1_and_2.pdf'
    );
  }

  ToolLicenseEntry get _toolLicenseMitre {
    return ToolLicensePortedCode(
      context: _context,
      author: 'The MITRE Corporation',
      title: 'Geodetic Library',
      licenseType: ToolLicenseType.APACHE2,
      licenseUrl: 'https://github.com/S-Man42/geodetic_library/blob/e2fd776eec8f7591d98022682137de0f74a4a0d7/LICENSE',
      sourceUrl: 'https://github.com/S-Man42/geodetic_library/tree/e2fd776eec8f7591d98022682137de0f74a4a0d7'
    );
  }

  ToolLicenseEntry get _toolLicenseGeoMidpoint {
    return ToolLicenseOnlineArticle(
      context: _context,
      author: 'Geo Midpoint (geomidpoint.com)',
      title: 'Calculation Methods: A. Geographic midpoint',
      sourceUrl: 'https://web.archive.org/web/20240606083622/http://www.geomidpoint.com/calculation.html'
    );
  }

  ToolLicenseEntry get _toolLicenseNASADeltaT {
    return ToolLicenseOnlineArticle(
      context: _context,
      author: 'NASA',
      title: 'Polynomial Expressions for Delta T (ΔT)',
      sourceUrl: 'https://web.archive.org/web/20240601113536/http://eclipse.gsfc.nasa.gov/SEcat5/deltatpoly.html'
    );
  }


  ToolLicenseEntry get _toolLicenseAstronomieInfo {
    return ToolLicensePortedCode(
      context: _context,
      author: 'Helmut Lehmeyer, Arnold Barmettler\n(astronomie.info)',
      title: 'Astronomical Calculations',
      licenseType: ToolLicenseType.GPL3,
      licenseUrl: 'http://web.archive.org/web/20180502230101/http://lexikon.astronomie.info/java/sunmoon/progs/Astronomy.java',
      sourceUrl: 'http://web.archive.org/web/20180502230101/http://lexikon.astronomie.info/java/sunmoon/progs/Astronomy.java'
    );
  }

  ToolLicenseEntry get _toolLicensePracticalAstronomy {
    return ToolLicenseOfflineBook(
      context: _context,
      author: 'Peter Duffett-Smith',
      title: 'Practical Astronomy with your Calculator',
      isbn: '978-0521356992',
      year: 1989, month: 3, day: 1,
      publisher: 'Cambridge University Press'
    );
  }

  ToolLicenseEntry get _toolLicenseWrixonGeheimsprachen {
    return ToolLicenseOfflineBook(
        context: context,
        author: 'Fred B. Wrixon',
        title: 'Geheimsprachen',
        publisher: 'Könemann Tandem Verlag GmbH',
        isbn: '978-3-8331-2562-1',
        year: 2006,
        );
  }

  ToolLicenseEntry get _toolLicenseMayaGlyphsWikisource {
    return ToolLicenseOnlineArticle(
      context: context,
      author: 'Sylvanus Griswold Morley',
      title: 'An Introduction to the Study of the Maya Hieroglyphs, Chapter 3',
      publisher: 'Wikisource',
      sourceUrl: 'https://en.wikisource.org/w/index.php?title=An_Introduction_to_the_Study_of_the_Maya_Hieroglyphs/Chapter_3&oldid=12772621',
    );
  }

  ToolLicenseEntry get _toolLicenseOnlineBookAlphabetumAlphabetaCharacteres {
    return ToolLicenseOnlineBook(
      context: context,
      author: 'Johannes Theodor de Bry, Johannes Israel de Bry',
      title: 'Alphabeta Et Characteres',
      sourceUrl: 'https://archive.org/details/librodimgiovanba00pala',
      year: 1596,
      licenseType: ToolLicenseType.PUBLIC_DOMAIN,
    );
  }

  ToolLicenseEntry get _toolLicenseOnlineBookPolygraphieTrithemius {
    return ToolLicenseOnlineBook(
      context: context,
      author: 'Johannes Trithemius',
      title: 'Polygraphie et universelle escriture cabalistique',
      sourceUrl: 'https://archive.org/details/Historiaedegent00Olau',
      year: 1557,
      licenseType: ToolLicenseType.PUBLIC_DOMAIN,
    );
  }

  ToolLicenseEntry get _toolLicenseOnlineBookDeOccultaPhilosophia {
    return ToolLicenseOnlineBook(
      context: context,
      author: 'Heinrich Cornelius Agrippa von Nettesheim',
      title: 'De occulta philosophia',
      sourceUrl: 'https://archive.org/details/17219451458888bsb-10192450',
      year: 1531,
      licenseType: ToolLicenseType.PUBLIC_DOMAIN,
    );
  }

  ToolLicenseEntry get _toolLicenseCullyLong {
    return ToolLicenseOfflineBook(context: context,
        author: 'Cully Long',
        title: 'How to puzzle caches. Lessons, tips, tricks and hints for solving geocache puzzles',
      isbn: '978-0-9973488-9-7',
      publisher: 'single atom books',
      year: 2019,
    );
  }

  ToolLicenseEntry get _toolLicenseGeocachingToolbox {
    return ToolLicenseOnlineArticle(context: context,
      author: 'Japiejoo',
      title: 'Geocaching Toolbox Codetabellen',
      licenseType: ToolLicenseType.CCBYNCND30,
      licenseUrl: 'http://web.archive.org/web/20240728042550/https://creativecommons.org/licenses/by-nc-nd/3.0/deed.en',
      sourceUrl: 'https://web.archive.org/web/20240724071603/https://www.geocachingtoolbox.com',
    );
  }

  ToolLicenseEntry get _toolLicenseMyGeoToolsCodeTabellen {
    return ToolLicenseOnlineArticle(context: context,
      author: 'Benny',
      title: 'myGEOTools Codetabellen',
      privatePermission: ToolLicensePrivatePermission(
        context: context,
        medium: '',
        permissionYear: 0,
        permissionMonth: 0,
        permissionDay: 0,
      ),
      sourceUrl: 'https://web.archive.org/web/20240724071757/https://www.docdroid.net/fnNHMWs/alle-codetabellen-von-mygeotools-pdf',
    );
  }

  ToolLicenseEntry get _toolLicenseOakIslandMystery {
    return ToolLicenseOnlineArticle (
        context: context,
        author: 'www.OakIslandMystery.com',
        title: 'Oak Island cipher',
        sourceUrl:
        'https://web.archive.org/web/20230322224111/https://www.oakislandmystery.com/community/coded-email',
        privatePermission: ToolLicensePrivatePermission(
          context: context,
          permissionYear: 2023,
          permissionMonth: 6,
          permissionDay: 1,
          medium: 'e-mail',
        )
    );
  }

  ToolLicenseEntry get _toolLicenseDni {
    return ToolLicenseFont(context: context,
        author: 'Colin Arenz, Sebastian Ochs',
        year: 2000,
        title: 'D\'ni Script',
        sourceUrl: 'http://web.archive.org/web/20240729092553/http://linguists.riedl.org/old/sebastian/index.htm',
        licenseType: ToolLicenseType.FREE_TO_USE,
        licenseUrl: 'http://web.archive.org/web/20230604223058/http://linguists.riedl.org/old/sebastian/readme.htm'
    );
  }

  ToolLicenseEntry get _toolLicenseUICWiki {
    return ToolLicenseOnlineArticle(context: context,
        author: '*.wikipedia.org and contributors',
        title: 'UIC Wagennummer',
        sourceUrl: 'https://de.wikipedia.org/w/index.php?title=UIC-Wagennummer&oldid=247540929',
        licenseType: ToolLicenseType.CCBYSA4,
        licenseUrl: 'https://web.archive.org/web/20240718115628/https://creativecommons.org/licenses/by-sa/4.0/deed.de',
        customComment: 'incl. linked pages and different languages'
    );
  }

  ToolLicenseEntry get _toolLicenseUIC {
    return ToolLicenseOfflineArticle(context: context,
      author: 'UIC - Union Internationale des Chemins de fer',
      title: 'UIC 438-X'
    );
  }
}

