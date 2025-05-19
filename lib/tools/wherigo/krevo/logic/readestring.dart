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
    '\u0001': 'B',
    '\u0002': 'R',
    '\u0003': ''
  };
  String? x;

  str = str
      .replaceAll('\\001', '\u0001')
      .replaceAll('\\002', '\u0002')
      .replaceAll('\\003', '\u0003')
      .replaceAll('nbsp;', ' ')
      .replaceAll('&lt;', '\u0004')
      .replaceAll('&gt;', '\u0005')
      .replaceAll('&amp;', '\u0006');

  for (int i = 0; i < str.length; i++) {
    String c = str[i];
    int p = find(rot_palette, c);
    if (p != -1) {
      int jump = (i % 8) + 9;
      p += jump;
      if (plen < p) p = p - plen;
      c = rot_palette[p - 1];
    } else {
      x = magic[c];
      if (x != null) c = x;
    }
    result += c;
  }
  result = result
      .replaceAll('\u0004', '&lt;')
      .replaceAll('\u0005', '&gt;')
      .replaceAll('\u0006', '&amp;');
  return result;
}

String wwb_deobf(String str) {
  // Qo, fwt! Rtq4 x82 üos6quv e2s67ko2qvqwN eyp o2wnpl457 -n1oq0 sq0p tvs6 n135 5tsq3 zvqw91H<\001\002>\n\003\003\003\003Xrut3 ctq o01n Rqts282äzqs -rooq4 p3 ss3r1 fuk4. 82t 5p3yo78nx evs tj2 SrzäwnpJ
  // He, Sie! Hier ist überall Sperrbereich. Und angefasst werden darf hier erst recht nichts.\onq\krr\ono\krv\b\mln\qpr\mln\qprKdfdu Rhd Zksd Fdfdmzsämcd 3hdcdq Zu hgqdm WkZsy tmk udqkZrzdm Rhd kZr Fdkämcd@
  String result = '';
  String rot_palette = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@.-~";
  int plen = rot_palette.length;
  const magic = {
    '\\001': 'B',
    '\\002': 'R',
    '\\003': ''
  };
  String? x = '';
  int d = 0;
  int jump = 0;

  str = str
      .replaceAll('<', '\\004')
      .replaceAll('>', '\\005')
      .replaceAll('&', '\\006');
  str = luaStringToString(str);

  for (int i = 0; i < str.length; i++) {
    String c = str[i];
    int p = find(rot_palette, c);
    if (p != -1) {
      jump = (d % 8) + 9;
      p -= jump;
      if (p < 1) p = p + plen;
      c = rot_palette[p - 1];
    } else {
      x = magic[c];
      if (x != null) c = x;
    }
    d++;
    if (c.codeUnitAt(0) > 127) d++;
    result += c;
  }
  result = result
      .replaceAll('\\004', '<')
      .replaceAll('\\005', '>')
      .replaceAll('\\006', '&');
  return result;
}
