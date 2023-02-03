/**
    Source of https://github.com/justkawal/xmp

    MIT License

    The flutter dependency in pubspec cannot be used because of version conflicts of internal using dependencies (xml package)
 */

part of 'package:gc_wizard/tools/images_and_files/exif_reader/logic/external_libs/justkawal.xmp/xmp.dart';

const _replacement = {
  'Xmpmeta': '',
  'Xmptk': 'XMP Tool Kit',
  'RDF': '',
  'AddlModelInfo': 'Additional Model Info',
  'CreatorContactInfo': 'Creator',
  'CiAdrExtadr': 'Address',
  'CiAdrCity': 'City',
  'CiAdrRegion': 'Region',
  'CiAdrPcode': 'Pincode',
  'CiAdrCtry': 'Country',
  'CiTelWork': 'Telephone Work',
  'CiEmailWork': 'Email Work',
  'CiUrlWork': 'Url Work',
  'AOCreator': 'Artwork Creator',
  'AOTitle': 'Artwork Title',
  'AOSource': 'Source',
  'AOSourceInvNo': 'Source Inventory Number',
  'AOCopyrightNotice': 'Copyright Notice',
  'AODateCreated': 'Date Created',
  'RegistryId': 'Registry',
  'RegOrgId': 'Organization Id',
  'RegItemId': 'Item Id',
  'ImageSupplierID': 'ID',
  'ImageSupplierName': 'Name',
  'ImageCreatorID': 'ID',
  'ImageCreatorName': 'Name',
  'CopyrightOwnerID': 'ID',
  'CopyrightOwnerName': 'Name',
  'LicensorPostalCode': 'Postal Code',
  'LicensorTelephone1': 'Telephone 1',
  'LicensorID': 'ID',
  'LicensorRegion': 'Region',
  'LicensorCity': 'City',
  'LicensorTelephone2': 'Telephone 2',
  'LicensorEmail': 'Email',
  'LicensorStreetAddress': 'Street Address',
  'LicensorURL': 'URL',
  'LicensorExtendedAddress': 'Extended Address',
  'LicensorCountry': 'Country',
  'LicensorName': 'Name'
};
