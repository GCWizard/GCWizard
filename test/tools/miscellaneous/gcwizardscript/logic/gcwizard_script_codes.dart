part of 'gcwizard_scipt_test.dart';

List<Map<String, Object?>> _inputsCodesToExpected = [
  {'code' : code1c, 'expectedOutput' : '1       2       9       6'},
  {'code' : codeGC6GE197, 'expectedOutput' : 'Punkte im radius        197      sind   56151'},
  {'code' : codeGC6GE41,  'expectedOutput' : 'Punkte im radius        41       sind   2431'},
];

var code1c = ''' 
REM https://www.geocaching.com/geocache/GC98G??
for z = 1 to 9
 for a = 1 to 9
  for h = 1 to 9
   for l = 0 to 9
    c = 0
    u = z*1000 + a*100 + h*10 + l
    v = a*1000 + h*100 + z*10 + l
    w = h*1000 + a*100 + z*10 + l
    e=sqrt(u)
    f=sqrt(v)
    g=sqrt(w)
    k = frac(e)
    i = frac(f)
    j = frac(g)
    if k=0 then c=c+1
    endif
    if i=0 then c=c+1
    endif
    if j=0 then c=c+1
    endif
    if c=3 then print z,a,h,l
    endif
   next
  next
 next
next
end
''';

var codeGC6GE197 = '''
REM https://coord.info/GC6GE4R
r = 197
a = 50.9621667
o = 11.03585
c = 0
for m = 0 to 999
  for s = 1 to 2
    for n = 0 to 999
      x = 50 + (57 + m/1000)/60
      y = 11 + (s + n/1000)/60
      d = distance(a,o,x,y)
      if d<=r then c = c + 1
      endif
    next
  next
next
print "Punkte im radius ",r, " sind ",c
end 
''';

var codeGC6GE41 = '''
REM https://coord.info/GC6GE4R
r = 41
a = 50.9621667
o = 11.03585
c = 0
for m = 0 to 999
  for s = 1 to 2
    for n = 0 to 999
      x = 50 + (57 + m/1000)/60
      y = 11 + (s + n/1000)/60
      d = distance(a,o,x,y)
      if d<=r then c = c + 1
      endif
    next
  next
next
print "Punkte im radius ",r, " sind ",c
end 
''';