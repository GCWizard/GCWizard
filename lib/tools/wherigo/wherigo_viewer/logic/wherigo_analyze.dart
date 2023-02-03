import 'package:gc_wizard/tools/wherigo/wherigo_viewer/logic/wherigo_analyze_gwc.dart';
import 'package:gc_wizard/tools/wherigo/wherigo_viewer/logic/wherigo_analyze_lua.dart';
import 'package:gc_wizard/tools/wherigo/wherigo_viewer/logic/wherigo_dataobjects.dart';

Future<Map<String, dynamic>> getCartridgeAsync(dynamic jobData) async {
  var output;
  switch (jobData.parameters['dataType']) {
    case DATA_TYPE_GWC:
      output = await getCartridgeGWC(jobData.parameters["byteListGWC"], jobData.parameters["offline"],
          sendAsyncPort: jobData.sendAsyncPort);
      break;
    case DATA_TYPE_LUA:
      output = await getCartridgeLUA(jobData.parameters["byteListLUA"], jobData.parameters["offline"],
          sendAsyncPort: jobData.sendAsyncPort);
      break;
  }

  if (jobData.sendAsyncPort != null) {
    jobData.sendAsyncPort.send(output);
  }
  return output;
}
