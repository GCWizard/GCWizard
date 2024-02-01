import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

WherigoZoneData testOutputZONE = const WherigoZoneData(
  ZoneLUAName: 'board',
  ZoneID: 'bbe8913e-8b76-46c3-9c03-e094b5c019e4',
  ZoneName: 'Spielfeld',
  ZoneDescription: 'Die ganze Welt ist Dein Spielfeld. Und doch wuerde ich Kladow vorziehen.',
  ZoneVisible: 'false',
  ZoneMediaName: 'objSpielfeld',
  ZoneIconName: 'objicoSpielfeld',
  ZoneActive: 'true',
  ZoneDistanceRange: 'Distance(-1, feet)',
  ZoneShowObjects: 'OnEnter',
  ZoneProximityRange: 'Distance(60, meters)',
  ZoneOriginalPoint: WherigoZonePoint(Latitude: 52.4619955882749, Longitude: 13.1230498819328, Altitude: 0),
  ZoneDistanceRangeUOM: 'Feet',
  ZoneProximityRangeUOM: 'Meters',
  ZoneOutOfRange: '',
  ZoneInRange: '',
  ZonePoints: [
    WherigoZonePoint(Latitude: 52.4620999265143, Longitude: 13.1231067868456, Altitude: 0),
    WherigoZonePoint(Latitude: 52.46192, Longitude: 13.12318, Altitude: 0),
    WherigoZonePoint(Latitude: 52.4619668383105, Longitude: 13.1228628589529, Altitude: 0)
  ],
);

String testInputZONE = 'board = Wherigo.Zone(objKlausMastermindKlabuster)\n' +
    'board.Id = "bbe8913e-8b76-46c3-9c03-e094b5c019e4"\n' +
    'board.Name = "Spielfeld"\n' +
    'board.Description = "Die ganze Welt ist Dein Spielfeld. Und doch wuerde ich Kladow vorziehen."\n' +
    'board.Visible = false\n' +
    'board.Media = objSpielfeld\n' +
    'board.Icon = objicoSpielfeld\n' +
    'board.Commands = {}\n' +
    'board.DistanceRange = Distance(-1, "feet")\n' +
    'board.ShowObjects = "OnEnter"\n' +
    'board.ProximityRange = Distance(60, "meters")\n' +
    'board.AllowSetPositionTo = false\n' +
    'board.Active = true\n' +
    'board.Points = {\n' +
    'ZonePoint(52.4620999265143, 13.1231067868456, 0),\n' +
    'ZonePoint(52.46192, 13.12318, 0),\n' +
    'ZonePoint(52.4619668383105, 13.1228628589529, 0)\n' +
    '}\n' +
    'board.OriginalPoint = ZonePoint(52.4619955882749, 13.1230498819328, 0)\n' +
    'board.DistanceRangeUOM = "Feet"\n' +
    'board.ProximityRangeUOM = "Meters"\n' +
    'board.OutOfRangeName = ""\n' +
    'board.InRangeName = ""';

void expectZone(WherigoZoneData actual, WherigoZoneData expected, ){
  expect(actual.ZoneLUAName, expected.ZoneLUAName);
  expect(actual.ZoneID, expected.ZoneID);
  expect(actual.ZoneName, expected.ZoneName);
  expect(actual.ZoneDescription, expected.ZoneDescription);
  expect(actual.ZoneVisible, expected.ZoneVisible);
  expect(actual.ZoneMediaName, expected.ZoneMediaName);
  expect(actual.ZoneIconName, expected.ZoneIconName);
  expect(actual.ZoneActive, expected.ZoneActive);
  expect(actual.ZoneDistanceRange, expected.ZoneDistanceRange);
  expect(actual.ZoneShowObjects, expected.ZoneShowObjects);
  expect(actual.ZoneProximityRange, expected.ZoneProximityRange);
  expect(actual.ZoneOriginalPoint.Latitude, expected.ZoneOriginalPoint.Latitude);
  expect(actual.ZoneOriginalPoint.Longitude, expected.ZoneOriginalPoint.Longitude);
  expect(actual.ZoneOriginalPoint.Altitude, expected.ZoneOriginalPoint.Altitude);
  expect(actual.ZoneDistanceRangeUOM, expected.ZoneDistanceRangeUOM);
  expect(actual.ZoneProximityRangeUOM, expected.ZoneProximityRangeUOM);
  expect(actual.ZoneOutOfRange, expected.ZoneOutOfRange);
  expect(actual.ZoneInRange, expected.ZoneInRange);
  for (int i = 0; i < actual.ZonePoints.length; i++){
    expect(actual.ZonePoints[i].Latitude, expected.ZonePoints[i].Latitude);
    expect(actual.ZonePoints[i].Longitude, expected.ZonePoints[i].Longitude);
    expect(actual.ZonePoints[i].Altitude, expected.ZonePoints[i].Altitude);
  }
}