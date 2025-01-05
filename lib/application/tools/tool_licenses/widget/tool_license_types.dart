import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/text_widget_utils.dart';
import 'package:intl/intl.dart';

enum ToolLicenseType {
  PRIVATE_PERMISSION, // use as dummy; data will be taken from ToolLicensePrivatePermission object
  FREE_TO_USE,
  PERSONAL_USE,
  AL, // Artistic License
  APACHE2, // Apache 2.0
  BSD, // BSD
  BSD2, // BSD2
  BSD3, // BSD v3
  CCBY4, // Creative Commons CC BY 4.0
  CCBY3US, // Creative Commons CC BY 3.0 US
  CCBYNC40, // Creative Commons CC BY-NC-SA 4.0
  CCBYNC30, // Creative Commons CC BY-NC-SA 3.0
  CCBYSA4, // Creative Commons CC BY-SA 4.0
  CCBYSA3, // Creative Commons CC BY-SA 3.0
  CCBYSA2, // Creative Commons CC BY-SA 2.0
  CCNC30, // Creative Commons CC NC 3.0
  CCNC25, // Creative Commons CC NC 2.5
  CCBYNCND40, // Creative Commons BY-NC-ND 4.0
  CCBYNCND30, // Creative Commons BY-NC-ND 3.0
  CCBYNCND20, // Creative Commons BY-NC-ND 2.0
  CC0_1, // Creative Commons CC0 1.0
  MIT, // MIT
  MPL2, // MPL-2.0
  GPL3, //GNU GPL v3.0
  GITHUB_DEFAULT, //Github Default
  GFDL, // GNU Free Documentation License
  PUBLIC_DOMAIN,// Public Domain
  NON_COMMERCIAL,
  REPRODUCTION_NEEDED,
  OFL11,
}

/*
  if you want to describe WHAT you did with the source, e.g.
  COPY: You copied an image from a source (via screenshot, whatever), so took the original image
  REPRODUCTION: You only took an image as a template for your own work: drawed a symbol by your own, just by looking/compare it with the source without making an exact copy
 */
enum ToolLicenseUseType {COPY, REPRODUCTION}

String _licenseType(BuildContext context, ToolLicenseType licenseType) {
  switch (licenseType) {
    case ToolLicenseType.PRIVATE_PERMISSION: return ''; // data will be taken from ToolLicensePrivatePermission object instead
    case ToolLicenseType.FREE_TO_USE: return i18n(context, 'toollicenses_freetouse');
    case ToolLicenseType.PERSONAL_USE: return i18n(context, 'toollicenses_personaluse');
    case ToolLicenseType.AL: return 'Artistic License';
    case ToolLicenseType.APACHE2: return 'Apache 2.0 License';
    case ToolLicenseType.BSD: return 'BSD License';
    case ToolLicenseType.BSD2: return 'BSD-2-Clause';
    case ToolLicenseType.BSD3: return 'BSD-3-Clause';
    case ToolLicenseType.CCBY4: return 'Creative Commons CC BY 4.0';
    case ToolLicenseType.CCBY3US: return 'Creative Commons CC BY 3.0 US';
    case ToolLicenseType.CCBYNC40: return 'Creative Commons CC BY-NC-SA 4.0';
    case ToolLicenseType.CCBYNC30: return 'Creative Commons CC BY-NC-SA 3.0';
    case ToolLicenseType.CCBYSA4: return 'Creative Commons CC BY-SA 4.0';
    case ToolLicenseType.CCBYSA3: return 'Creative Commons CC BY-SA 3.0';
    case ToolLicenseType.CCBYSA2: return 'Creative Commons CC BY-SA 2.0';
    case ToolLicenseType.CCNC30: return 'Creative Commons CC NC 3.0';
    case ToolLicenseType.CCNC25: return 'Creative Commons CC NC 2.5';
    case ToolLicenseType.CCBYNCND20: return 'Creative Commons CC BY-NC-ND 2.0';
    case ToolLicenseType.CCBYNCND30: return 'Creative Commons CC BY-NC-ND 3.0';
    case ToolLicenseType.CCBYNCND40: return 'Creative Commons CC BY-NC-ND 4.0';
    case ToolLicenseType.CC0_1: return 'Creative Commons CC0 1.0';
    case ToolLicenseType.MIT: return 'MIT License';
    case ToolLicenseType.MPL2: return 'Mozilla Public License Version 2.0';
    case ToolLicenseType.GPL3: return 'GNU GPL v3.0 License';
    case ToolLicenseType.GITHUB_DEFAULT: return 'Github Default License';
    case ToolLicenseType.GFDL: return 'GNU Free Documentation License';
    case ToolLicenseType.PUBLIC_DOMAIN: return 'Public Domain';
    case ToolLicenseType.NON_COMMERCIAL: return i18n(context, 'toollicenses_noncommercial');
    case ToolLicenseType.REPRODUCTION_NEEDED: return i18n(context, 'toollicenses_reproduction_needed');
    case ToolLicenseType.OFL11: return 'SIL Open Font License Version 1.1';
  }
}

Column toolLicenseEntry(List<Object> output) {
  return Column(
    children: output.map((element) {
      if (element is String) {
        return GCWText(text: element);
      } else {
        return Container(
          alignment: Alignment.topLeft,
          child: element as Widget,
        );
      }
    }).toList(),
  );
}

String toolLicenseTypeString(BuildContext context, ToolLicenseEntry toolLicense) {
  if (toolLicense is ToolLicenseOfflineBook) return i18n(context, 'toollicenses_offlinebook');
  if (toolLicense is ToolLicenseOnlineBook) return i18n(context, 'toollicenses_onlinebook');
  if (toolLicense is ToolLicenseOfflineArticle) return i18n(context, 'toollicenses_offlinearticle');
  if (toolLicense is ToolLicenseOnlineArticle) return i18n(context, 'toollicenses_onlinearticle');
  if (toolLicense is ToolLicenseCodeLibrary) return i18n(context, 'toollicenses_codelibrary');
  if (toolLicense is ToolLicensePortedCode) return i18n(context, 'toollicenses_portedcode');
  if (toolLicense is ToolLicenseImage) return i18n(context, 'toollicenses_image');
  if (toolLicense is ToolLicenseFont) return i18n(context, 'toollicenses_font');
  if (toolLicense is ToolLicenseAPI) return i18n(context, 'toollicenses_api');

  return '';
}

abstract class ToolLicenseEntry {
  const ToolLicenseEntry();

  List<Object> toRow();
}

/*
  Privately permitted usage (i.e. author explicitly allow usage via e-mail)  -> cite with:
  medium == how was use granted (e-mail, web forum, chat, ...)
  permissionYear, permissionMonth, permissionDay == at least the year: when was use granted
*/
class ToolLicensePrivatePermission {
  final BuildContext context;
  final String medium;
  final int permissionYear;
  final int? permissionMonth; // 01-12
  final int? permissionDay;
  final String? permissionAuthor;

  const ToolLicensePrivatePermission({
    required this.context,
    required this.medium,
    required this.permissionYear,
    this.permissionMonth,
    this.permissionDay,
    this.permissionAuthor,
  });

  @override
  String toString() {
    return i18n(context, 'toollicenses_usepermission') + ' '
        + medium
        + ' ('
          + (permissionAuthor != null ? permissionAuthor! + ', ' : '')
          + _getDate(context, permissionYear, permissionMonth, permissionDay)!
        + ')';
  }
}

String _getUseType(BuildContext context, ToolLicenseUseType useType) {
  switch (useType) {
    case ToolLicenseUseType.COPY: return i18n(context, 'toollicenses_usetype_copy');
    case ToolLicenseUseType.REPRODUCTION: return i18n(context, 'toollicenses_usetype_reproduction');
  }
}

String? _getDate(BuildContext context, int? year, int? month, int? day) {
  String? out;
  if (year == null) return out;

  out = year.toString();
  if (month == null) return out;

  out += '/' + month.toString().padLeft(2, '0');
  if (day == null) return out;

  var dateFormat = DateFormat('yMd', Localizations.localeOf(context).toString());
  return dateFormat.format(DateTime(year, month, day));
}

/*
 Real book, not online available -> cite with:
    author == author(s) and/or organisation(s);
    title == book title, maybe with chapter name if available; (My Great Book, Chapter 21: All or Nothing);
    year, date, month == if available
    isbn == ISBN if available
    publisher == publisher (Verlag) if available
    customComment == whatever, maybe a page number; license clarifications, ...
 */
class ToolLicenseOfflineBook extends ToolLicenseEntry {
  final BuildContext context;
  final String author;
  final String title;
  final String? customComment;
  final ToolLicensePrivatePermission? privatePermission;
  final String? isbn;
  final int? year;
  final int? month; // 01-12
  final int? day;
  final String? publisher;

  const ToolLicenseOfflineBook({
    required this.context,
    required this.author,
    required this.title,
    this.customComment,
    this.privatePermission,
    this.year, this.month, this.day,
    this.publisher,
    this.isbn
  });

  @override
  List<Object> toRow() {
    var out = <Object>[author, title];
    var date = _getDate(context, year, month, day);
    if (date != null) out.add(date);
    if (isbn != null) out.add('ISBN: ' + isbn!);
    if (publisher != null) out.add(publisher!);
    if (privatePermission != null) out.add(privatePermission.toString());
    if (customComment != null) out.add(customComment!);

    return out;
  }
}

/*
 Real book, online available -> cite with:
    author == author(s) and/or organisation(s);
    title == book title, maybe with chapter name if available; (My Great Book, Chapter 21: All or Nothing)
    year, date, month == if available
    isbn == ISBN if available
    publisher == publisher (Verlag) if available
    customComment == whatever, maybe a page number; license clarifications, ...
    sourceUrl == main URL of the source (in best case: Internet Archive snapshot)
    licenseType == if available: which license is the used source
    licenseUrl == if available: url of the license (in best case: Internet Archive snapshot)
 */
class ToolLicenseOnlineBook extends ToolLicenseEntry {
  final BuildContext context;
  final String author;
  final String title;
  final String? customComment;
  final ToolLicensePrivatePermission? privatePermission;
  final String? isbn;
  final int? year;
  final int? month; // 01-12
  final int? day;
  final String? publisher;
  final String sourceUrl;
  final String? licenseUrl;
  final ToolLicenseType? licenseType;

  const ToolLicenseOnlineBook({
    required this.context,
    required this.author,
    required this.title,
    this.customComment,
    this.privatePermission,
    this.year, this.month, this.day,
    this.publisher,
    required this.sourceUrl,
    this.licenseType,
    this.licenseUrl,
    this.isbn
  });

  @override
  List<Object> toRow() {
    var out = <Object>[author];
    var _title = title;
    out.add(buildUrl(_title, sourceUrl));
    var date = _getDate(context, year, month, day);
    if (date != null) out.add(date);
    if (isbn != null) out.add('ISBN: ' + isbn!);
    if (publisher != null) out.add(publisher!);
    if (privatePermission != null) out.add(privatePermission.toString());

    Object? _license;
    if (licenseType != null && licenseType != ToolLicenseType.PRIVATE_PERMISSION) {
      var _lType = _licenseType(context, licenseType!);
      if (licenseUrl != null) {
        _license = buildUrl(_lType, licenseUrl!);
      } else {
        _license = _lType;
      }
    }
    if (_license != null) out.add(_license);

    if (customComment != null) out.add(customComment!);

    return out;
  }
}

/*
 Article from magazines, newspaper, ... -> cite with:
    author == author(s) and/or organisation(s);
    title == magazine title and issue and article title (Time Magazine 2003/04, Best Geocaching Spots Alive)
    year, date, month == if available
    publisher == publisher (Verlag) if available
    customComment == whatever, maybe a page number; license clarifications, ...
 */
class ToolLicenseOfflineArticle extends ToolLicenseEntry {
  final BuildContext context;
  final String author;
  final String title;
  final String? customComment;
  final ToolLicensePrivatePermission? privatePermission;
  final int? year;
  final int? month; // 01-12
  final int? day;
  final String? publisher;

  const ToolLicenseOfflineArticle({
    required this.context,
    required this.author,
    required this.title,
    this.customComment,
    this.privatePermission,
    this.year, this.month, this.day,
    this.publisher
  });

  @override
  List<Object> toRow() {
    var out = <Object>[author, title];
    var date = _getDate(context, year, month, day);
    if (date != null) out.add(date);
    if (publisher != null) out.add(publisher!);
    if (privatePermission != null) out.add(privatePermission.toString());
    if (customComment != null) out.add(customComment!);

    return out;
  }
}

/*
 Online Article (blogs, Wikipedia, ...) ...  -> cite with:
    author == author(s) and/or organisation(s);
    title == website title and article title (Time Magazine 2003/04, Best Geocaching Spots Alive)
    year, date, month == if available
    publisher == publisher (Verlag) if available
    customComment == whatever, maybe a page number; license clarifications, ...
    sourceUrl == main URL of the source (in best case: Internet Archive snapshot or explicit Wikipedia history version)
    licenseType == if available: which license is the used source
    licenseUrl == if available: url of the license (in best case: Internet Archive snapshot)
 */
class ToolLicenseOnlineArticle extends ToolLicenseEntry {
  final BuildContext context;
  final String author;
  final String title;
  final String? customComment;
  final ToolLicensePrivatePermission? privatePermission;
  final int? year;
  final int? month; // 01-12
  final int? day;
  final String? publisher;
  final String sourceUrl;
  final String? licenseUrl;
  final ToolLicenseType? licenseType;

  const ToolLicenseOnlineArticle({
    required this.context,
    required this.author,
    required this.title,
    this.customComment,
    this.privatePermission,
    this.year, this.month, this.day,
    this.publisher,
    required this.sourceUrl,
    this.licenseType,
    this.licenseUrl
  });

  @override
  List<Object> toRow() {
    var out = <Object>[author];
    var _title = title;
    out.add(buildUrl(_title, sourceUrl));
    var date = _getDate(context, year, month, day);
    if (date != null) out.add(date);
    if (publisher != null) out.add(publisher!);
    if (privatePermission != null) out.add(privatePermission.toString());

    Object? _license;
    if (licenseType != null && licenseType != ToolLicenseType.PRIVATE_PERMISSION) {
      var _lType = _licenseType(context, licenseType!);
      if (licenseUrl != null) {
        _license = buildUrl(_lType, licenseUrl!);
      } else {
        _license = _lType;
      }
    }
    if (_license != null) out.add(_license);

    if (customComment != null) out.add(customComment!);

    return out;
  }
}

/*
 Code Dependency: A library or whatever directly used in the project (mainly Flutter/Dart libs from the pubspec.yaml)  -> cite with:
    author == author(s) and/or organisation(s);
    title == Library title
    version == if available
    customComment == whatever seems to be important..., license clarifications, ...
    sourceUrl == main URL of the source (in best case: Github fork or/and explicit repository commit)
    licenseType == if available: which license is the used source
    licenseUrl == if available: url of the license (in best case: Github fork or/and explicit repository commit)
 */
class ToolLicenseCodeLibrary extends ToolLicenseEntry {
  final BuildContext context;
  final String author;
  final String title;
  final String? customComment;
  final ToolLicensePrivatePermission? privatePermission;
  final String? version;
  final String sourceUrl;
  final String? licenseUrl;
  final ToolLicenseType licenseType;
  final int? year;
  final int? month; // 01-12
  final int? day;

  const ToolLicenseCodeLibrary({
    required this.context,
    required this.author,
    required this.title,
    this.customComment,
    this.privatePermission,
    this.year, this.month, this.day,
    required this.sourceUrl,
    this.licenseUrl,
    required this.licenseType,
    this.version
  });

  @override
  List<Object> toRow() {
    var out = <Object>[author];
    var _title = title;
    if (version != null) _title += ' (' + version! + ')';
    out.add(buildUrl(_title, sourceUrl));
    var date = _getDate(context, year, month, day);
    if (date != null) out.add(date);
    if (privatePermission != null) out.add(privatePermission.toString());

    if (licenseType != ToolLicenseType.PRIVATE_PERMISSION) {
      Object _license;
      if (licenseUrl != null) {
        _license = buildUrl(_licenseType(context, licenseType), licenseUrl!);
      } else {
        _license = _licenseType(context, licenseType);
      }
      out.add(_license);
    }

    if (customComment != null) out.add(customComment!);

    return out;
  }
}

/*
 Ported Code: Code that was copied/ported from an external source (i.e. ported C++ code like GeographicLib)  -> cite with:
    author == author(s) and/or organisation(s);
    title == Source title
    version == if available
    customComment == whatever seems to be important..., license clarifications, ...
    sourceUrl == main URL of the source (in best case: Github fork or/and explicit repository commit)
    licenseType == if available: which license is the used source
    licenseUrl == if available: url of the license (in best case: Github fork or/and explicit repository commit)
 */
class ToolLicensePortedCode extends ToolLicenseEntry {
  final BuildContext context;
  final String author;
  final String title;
  final String? customComment;
  final ToolLicensePrivatePermission? privatePermission;
  final String? version;
  final String sourceUrl;
  final String? licenseUrl;
  final ToolLicenseType licenseType;
  final int? year;
  final int? month; // 01-12
  final int? day;

  const ToolLicensePortedCode({
    required this.context,
    required this.author,
    required this.title,
    this.customComment,
    this.privatePermission,
    this.year, this.month, this.day,
    required this.sourceUrl,
    this.licenseUrl,
    required this.licenseType,
    this.version
  });

  @override
  List<Object> toRow() {
    var out = <Object>[author];
    var _title = title;
    if (version != null) _title += ' (' + version! + ')';
    out.add(sourceUrl.isEmpty ? _title : buildUrl(_title, sourceUrl));
    var date = _getDate(context, year, month, day);
    if (date != null) out.add(date);
    if (privatePermission != null) out.add(privatePermission.toString());

    if (licenseType != ToolLicenseType.PRIVATE_PERMISSION) {
      Object _license;
      if (licenseUrl != null) {
        _license = buildUrl(_licenseType(context, licenseType), licenseUrl!);
      } else {
        _license = _licenseType(context, licenseType);
      }
      out.add(_license);
    }

    if (customComment != null) out.add(customComment!);

    return out;
  }
}

/*
 Image: Images/Graphics/Pictures that are used from external sources (NOT images that we generated from fonts -> see Fonts) -> cite with:
    author == author(s) and/or organisation(s);
    title == Source title
    version == if available
    customComment == whatever seems to be important..., license clarifications, ...
    sourceUrl == main URL of the source (in best case: Github fork or/and explicit repository commit)
    licenseType == if available: which license is the used source
    licenseUrl == if available: url of the license (in best case: Github fork or/and explicit repository commit)
 */
class ToolLicenseImage extends ToolLicenseEntry {
  final BuildContext context;
  final String author;
  final String title;
  final String? customComment;
  final ToolLicensePrivatePermission? privatePermission;
  final String sourceUrl;
  final String? licenseUrl;
  final ToolLicenseType licenseType;
  final ToolLicenseUseType? useType;
  final String? version;
  final int? year;
  final int? month; // 01-12
  final int? day;

  const ToolLicenseImage({
    required this.context,
    required this.author,
    required this.title,
    required this.sourceUrl,
    this.licenseUrl,
    required this.licenseType,
    this.useType,
    this.privatePermission,
    this.year, this.month, this.day,
    this.version,
    this.customComment, required licenseUseType
  });

  @override
  List<Object> toRow() {
    var out = <Object>[author];
    var _title = title;
    if (version != null) _title += ' (' + version! + ')';
    out.add(buildUrl(_title, sourceUrl));
    var date = _getDate(context, year, month, day);
    if (date != null) out.add(date);
    if (privatePermission != null) out.add(privatePermission.toString());

    if (licenseType != ToolLicenseType.PRIVATE_PERMISSION) {
      Object _license;
      if (licenseUrl != null) {
        _license = buildUrl(_licenseType(context, licenseType), licenseUrl!);
      } else {
        _license = _licenseType(context, licenseType);
      }
      out.add(_license);
    }
    if (useType != null) {
      out.add(_getUseType(context, useType!));
    }

    if (customComment != null) out.add(customComment!);

    return out;
  }
}

/*
 Font: Fonts that are used directly (e.g. Roboto as the main font of the app) or from which images were created (e.g. for symbol tables) -> cite with:
    author == author(s) and/or organisation(s);
    title == Source title
    version == if available
    customComment == whatever seems to be important..., license clarifications, ...
    sourceUrl == main URL of the source (in best case: Github fork or/and explicit repository commit)
    licenseType == if available: which license is the used source
    licenseUrl == if available: url of the license (in best case: Github fork or/and explicit repository commit)
 */
class ToolLicenseFont extends ToolLicenseEntry {
  final BuildContext context;
  final String author;
  final String title;
  final String? customComment;
  final ToolLicensePrivatePermission? privatePermission;
  final String? version;
  final String sourceUrl;
  final String? licenseUrl;
  final ToolLicenseType licenseType;
  final int? year;
  final int? month; // 01-12
  final int? day;

  const ToolLicenseFont({
    required this.context,
    required this.author,
    required this.title,
    this.customComment,
    this.privatePermission,
    this.year, this.month, this.day,
    required this.sourceUrl,
    this.licenseUrl,
    required this.licenseType,
    this.version
  });

  @override
  List<Object> toRow() {
    var out = <Object>[author];
    var _title = title;
    if (version != null) _title += ' (' + version! + ')';
    out.add(buildUrl(_title, sourceUrl));
    var date = _getDate(context, year, month, day);
    if (date != null) out.add(date);
    if (privatePermission != null) out.add(privatePermission.toString());

    if (licenseType != ToolLicenseType.PRIVATE_PERMISSION) {
      Object _license;
      if (licenseUrl != null) {
        _license = buildUrl(_licenseType(context, licenseType), licenseUrl!);
      } else {
        _license = _licenseType(context, licenseType);
      }
      out.add(_license);
    }

    if (customComment != null) out.add(customComment!);

    return out;
  }
}

/*
 File: Any file type which is not yet specified separately -> cite with:
    author == author(s) and/or organisation(s);
    title == Source title
    version == if available
    customComment == whatever seems to be important..., license clarifications, ...
    sourceUrl == main URL of the source (in best case: Github fork or/and explicit repository commit)
    licenseType == if available: which license is the used source
    licenseUrl == if available: url of the license (in best case: Github fork or/and explicit repository commit)
 */
class ToolLicenseFile extends ToolLicenseEntry {
  final BuildContext context;
  final String author;
  final String title;
  final String? customComment;
  final ToolLicensePrivatePermission? privatePermission;
  final String sourceUrl;
  final String? licenseUrl;
  final ToolLicenseType licenseType;
  final ToolLicenseUseType? useType;
  final String? version;
  final int? year;
  final int? month; // 01-12
  final int? day;

  const ToolLicenseFile({
    required this.context,
    required this.author,
    required this.title,
    required this.sourceUrl,
    this.licenseUrl,
    required this.licenseType,
    this.useType,
    this.privatePermission,
    this.year, this.month, this.day,
    this.version,
    this.customComment, required licenseUseType
  });

  @override
  List<Object> toRow() {
    var out = <Object>[author];
    var _title = title;
    if (version != null) _title += ' (' + version! + ')';
    out.add(buildUrl(_title, sourceUrl));
    var date = _getDate(context, year, month, day);
    if (date != null) out.add(date);
    if (privatePermission != null) out.add(privatePermission.toString());

    if (licenseType != ToolLicenseType.PRIVATE_PERMISSION) {
      Object _license;
      if (licenseUrl != null) {
        _license = buildUrl(_licenseType(context, licenseType), licenseUrl!);
      } else {
        _license = _licenseType(context, licenseType);
      }
      out.add(_license);
    }
    if (useType != null) {
      out.add(_getUseType(context, useType!));
    }

    if (customComment != null) out.add(customComment!);

    return out;
  }
}

/*
 API: Public API that is used (e.g. the geo.crox.net API for the Dow Jones)
    author == author(s) and/or organisation(s);
    title == Source title
    version == if available
    customComment == whatever seems to be important..., license clarifications, ...
    sourceUrl == API entry point (could be invalid without parameters, which is ok I think)
    licenseType == if available: which license is the used source
    licenseUrl == if available: url of the license (in best case: Github fork or/and explicit repository commit)
 */
class ToolLicenseAPI extends ToolLicenseEntry {
  final BuildContext context;
  final String author;
  final String title;
  final String? customComment;
  final ToolLicensePrivatePermission? privatePermission;
  final String? version;
  final String sourceUrl;
  final String? licenseUrl;
  final ToolLicenseType licenseType;
  final int? year;
  final int? month; // 01-12
  final int? day;

  const ToolLicenseAPI({
    required this.context,
    required this.author,
    required this.title,
    this.customComment,
    this.privatePermission,
    this.year, this.month, this.day,
    required this.sourceUrl,
    this.licenseUrl,
    required this.licenseType,
    this.version
  });

  @override
  List<Object> toRow() {
    var out = <Object>[author];
    var _title = title;
    if (version != null) _title += ' (' + version! + ')';
    out.add(buildUrl(_title, sourceUrl));
    var date = _getDate(context, year, month, day);
    if (date != null) out.add(date);
    if (privatePermission != null) out.add(privatePermission.toString());

    if (licenseType != ToolLicenseType.PRIVATE_PERMISSION) {
      Object _license;
      if (licenseUrl != null) {
        _license = buildUrl(_licenseType(context, licenseType), licenseUrl!);
      } else {
        _license = _licenseType(context, licenseType);
      }
      out.add(_license);
    }

    if (customComment != null) out.add(customComment!);

    return out;
  }
}