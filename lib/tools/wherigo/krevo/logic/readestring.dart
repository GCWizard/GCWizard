import 'package:gc_wizard/tools/wherigo/krevo/logic/readustring.dart';

int find(String palette, String char) {
  for (int i = 0; i < palette.length; i++) {
    if (palette[i] == char) return (i + 1);
  }
  return -1;
}

String gsub_wig(String str) {
  String result = '';
  String rot_palette = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@.-~";
  int plen = rot_palette.length;
  const magic = {
    ["\x01"]: "B",
    ["\x02"]: "R",
    ["\x03"]: ""
  };
  String? x;

  str = str.replaceAll('\\001', '\x01').replaceAll('\\002', '\x02').replaceAll('\\003', '\x03');
  str = str.replaceAll('nbsp;', ' ').replaceAll('&lt;', '\x04').replaceAll('&gt;', '\x05').replaceAll('&amp;', '\x06');

  for (int i = 0; i < str.length; i++) {
    String c = str[i];
    int p = find(rot_palette, c);
    if (p != -1) {
      int jump = (i % 8) + 9;
      p = p + jump;
      if (plen < p) p = p - plen;
      c = rot_palette[p - 1];
    } else {
      x = magic[c];
      if (x != null) c = x;
    }
    result = result + c;
  }
  result = result.replaceAll('\x04', '&lt;').replaceAll('\x05', '&gt;').replaceAll('\x06', '&amp;');
  return result;
}

String wwb_deobf(String str) {
  // Qo, fwt! Rtq4 x82 üos6quv e2s67ko2qvqwN eyp o2wnpl457 -n1oq0 sq0p tvs6 n135 5tsq3 zvqw91H<\001\002>\n\003\003\003\003Xrut3 ctq o01n Rqts282äzqs -rooq4 p3 ss3r1 fuk4. 82t 5p3yo78nx evs tj2 SrzäwnpJ
  // He, Sie! Hier ist überall Sperrbereich. Und angefasst werden darf hier erst recht nichts.\onq\krr\ono\krv\b\mln\qpr\mln\qprKdfdu Rhd Zksd Fdfdmzsämcd 3hdcdq Zu hgqdm WkZsy tmk udqkZrzdm Rhd kZr Fdkämcd@
  String result = '';
  String rot_palette = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@.-~";
  int plen = rot_palette.length;
  const magic = {
    ["\\001"]: "B",
    ["\\002"]: "R",
    ["\\003"]: ""
  };
  String? x = '';
  int d = 0;
  int jump = 0;

  str = str.replaceAll('<', '\\004').replaceAll('>', '\\005').replaceAll('&', '\\006');
  str = luaStringToString(str);

  for (int i = 0; i < str.length; i++) {
    String c = str[i];
    int p = find(rot_palette, c);
    if (p != -1) {
      jump = (d % 8) + 9;
      p = p - jump;
      if (p < 1) p = p + plen;
      c = rot_palette[p - 1];
    } else {
      x = magic[c];
      if (x != null) c = x;
    }
    d++;
    if (c.codeUnitAt(0) > 127) d++;
    result = result + c;
  }
  result = result.replaceAll('\\004', '<').replaceAll('\\005', '>').replaceAll('\\006', '&');
  return result;
}
