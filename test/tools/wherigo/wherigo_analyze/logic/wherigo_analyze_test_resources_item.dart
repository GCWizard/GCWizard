import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

WherigoItemData testOutputITEM = const WherigoItemData(
  ItemLUAName: 'objStrickanleitung1',
  ItemID: '4182ed28-3959-48e0-bd63-47d74aeef442',
  ItemName: 'Strickanleitung',
  ItemDescription: '',
  ItemVisible: 'true',
  ItemMedia: 'objStrickanleitung',
  ItemIcon: 'objicoStrickanleitung',
  ItemLocation: '',
  ItemZonepoint: WherigoZonePoint(),
  ItemContainer: 'Player',
  ItemLocked: 'false',
  ItemOpened: 'false',
);

String testInputITEM =
    'objStrickanleitung1 = Wherigo.ZItem({Cartridge = objKlausMastermindKlabuster, Container = Player})\n'+
    'objStrickanleitung1.Id = "4182ed28-3959-48e0-bd63-47d74aeef442"\n'+
    'objStrickanleitung1.Name = "Strickanleitung"\n'+
    'objStrickanleitung1.Description = ""\n'+
    'objStrickanleitung1.Visible = true\n'+
    'objStrickanleitung1.Media = objStrickanleitung\n'+
    'objStrickanleitung1.Icon = objicoStrickanleitung\n'+
    'objStrickanleitung1.Commands = {}\n'+
    'objStrickanleitung1.ObjectLocation = Wherigo.INVALID_ZONEPOINT\n'+
    'objStrickanleitung1.Locked = false\n'+
    'objStrickanleitung1.Opened = false';

void expectItem(WherigoItemData actual, WherigoItemData expected, ){
  expect(actual.ItemLUAName, expected.ItemLUAName);
  expect(actual.ItemID, expected.ItemID);
  expect(actual.ItemName, expected.ItemName);
  expect(actual.ItemDescription, expected.ItemDescription);
  expect(actual.ItemVisible, expected.ItemVisible);
  expect(actual.ItemMedia, expected.ItemMedia);
  expect(actual.ItemIcon, expected.ItemIcon);
  expect(actual.ItemLocation, expected.ItemLocation);
  expect(actual.ItemZonepoint, expected.ItemZonepoint);
  expect(actual.ItemContainer, expected.ItemContainer);
  expect(actual.ItemLocked, expected.ItemLocked);
  expect(actual.ItemOpened, expected.ItemOpened);
}