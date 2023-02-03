/**
    Source of https://github.com/justkawal/xmp

    MIT License

    The flutter dependency in pubspec cannot be used because of version conflicts of internal using dependencies (xml package)
 */

part of 'package:gc_wizard/tools/images_and_files/exif_reader/logic/external_libs/justkawal.xmp/xmp.dart';

const _markerBegin = '<x:xmpmeta';
const _markerEnd = '</x:xmpmeta>';

const _listingTextTags = [
  'MicrosoftPhoto:LastKeywordXMP',
  'MicrosoftPhoto:LastKeywordIPTC',
  'MicrosoftPhoto:Rating',
  'Iptc4xmpCore:Location',
  'xmp:Rating',
  'dc:title',
  'dc:description',
  'dc:creator',
  'dc:subject',
  'dc:rights',
  'cc:attributionName',
  'xmpRights:UsageTerms',
  'Iptc4xmpCore:Scene',
  'Iptc4xmpCore:SubjectCode',
  'photoshop:SupplementalCategories',
  'Iptc4xmpExt:AOCreator',
  'Iptc4xmpExt:AOTitle',
  'Iptc4xmpExt:Event',
  'Iptc4xmpExt:ModelAge',
  'Iptc4xmpExt:OrganisationInImageCode',
  'Iptc4xmpExt:OrganisationInImageName',
  'Iptc4xmpExt:PersonInImage',
  'plus:ModelReleaseID',
  'plus:PropertyReleaseID',
  'crs:ToneCurvePV2012',
  'crs:ToneCurvePV2012Red',
  'crs:ToneCurvePV2012Green',
  'crs:ToneCurvePV2012Blue',
  'lr:hierarchicalSubject',
];

const _envelopeTags = [
  'rdf:bag',
  'rdf:alt',
  'rdf:seq',
  'rdf:li',
  'rdf:description',
];
