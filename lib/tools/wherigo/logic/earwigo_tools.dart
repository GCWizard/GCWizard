import 'package:gc_wizard/tools/wherigo/krevo/logic/readestring.dart';

enum EARWIGO_DEOBFUSCATION { WWB_DEOBF, GSUB_WIG, URWIGO }

String deobfuscateEarwigoText(String text, EARWIGO_DEOBFUSCATION tool) {
  if (text.isEmpty) return '';

  switch (tool) {
    case EARWIGO_DEOBFUSCATION.GSUB_WIG:
      return gsub_wig(text);
    case EARWIGO_DEOBFUSCATION.WWB_DEOBF:
      return wwb_deobf(text);
    default: return '';
  }
}

String obfuscateEarwigoText(String text, EARWIGO_DEOBFUSCATION tool) {
  switch (tool) {
    case EARWIGO_DEOBFUSCATION.GSUB_WIG:
      return _gsub_wig_obfuscation(text);
    case EARWIGO_DEOBFUSCATION.WWB_DEOBF:
      return _wwb_deobf_obfuscation(text);
    default: return '';
  }
}

String _gsub_wig_obfuscation(String text) {
  if (text.isEmpty) return '';

  String result = '';
  String rot_palette = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@.-~";
  int plen = rot_palette.length;

  for (int i = 0; i < text.length; i++) {
    String c = text[i];
    int p = find(rot_palette, c);
    int jump = (i % 8) + 9;
    if (p != -1) {
      if ((p - 1) < jump) {
        p = p + plen;
      }
      p = p - jump;
      c = rot_palette[p - 1];
    }
    result = result + c;
  }

  return result;
}

String _wwb_deobf_obfuscation(String str) {
  // actual  Qo, fwt! Rtq4 x82 üos6quv e2s67ko2qvqwN eyp o2wnpl457 -n1oq0 sq0p tvs6 n135 5tsq3 zvqw91H<\001\002>\n\003\003\003\003Xrut3 ctq o01n Rqts282äzqs -rooq4 p3 ss3r1 fuk4. 82t 5p3yo78nx evs tj2 SrzäwnpJ
  // expect  Qo, fwt! Rtq4 x82 üos6quv e2s67ko2qvqwN eyp o2wnpl457 -n1oq0 sq0p tvs6 n135 5tsq3 zvqw91H<\001\002>\n\003\003\003\003Xrut3 ctq o01n Rqts282äzqs -rooq4 p3 ss3r1 fuk4. 82t 5p3yo78nx evs tj2 SrzäwnpJ
  // plain   He, Sie! Hier ist überall Sperrbereich. Und angefasst werden darf hier erst recht nichts.
  // Legen Sie alle Gegenstände wieder an ihren Platz und verlassen Sie das Gelände.
  if (str.isEmpty) return '';

  String result = '';
  String rot_palette = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@.-~";
  int plen = rot_palette.length;

  var magic = {
    ["\x01"]: "B",
    ["\x02"]: "R",
    ["\x03"]: ""
  };

  str = str
      .replaceAll(String.fromCharCode(4), '<')
      .replaceAll(String.fromCharCode(5), '>')
      .replaceAll(String.fromCharCode(6), '&');

  String? x = '';
  int d = 0;

  for (int i = 0; i < str.length; i++) {
    String c = str[i];
    int p = find(rot_palette, c);
    if (p != -1) {
      int jump = (d % 8) + 9;
      p = p + jump;
      if (p > plen) p = p - plen;
      if (p - 1 >= 0) c = rot_palette[p - 1];
    } else {
      x = magic[c];
      if (x != null) c = x;
    }
    d++;
    if (c.codeUnitAt(0) > 127) {
      d++;
    }
    result = result + c;
  }
  result = result
      .replaceAll(String.fromCharCode(4), '<')
      .replaceAll(String.fromCharCode(5), '>')
      .replaceAll(String.fromCharCode(6), '&')
      .replaceAll(String.fromCharCode(10), '\\n')
      .replaceAll(String.fromCharCode(3), '\\003')
      .replaceAll(String.fromCharCode(2), '\\002')
      .replaceAll(String.fromCharCode(1), '\\001');
  return result;
}
