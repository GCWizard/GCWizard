import 'dart:math';

String kToImage(String kString) {
  List<String> imageBinary = [];
  String line = '';
  String pixel = '0';

  BigInt k = BigInt.parse(kString);
  BigInt n17 = BigInt.from(17);

  int x = 0;
  BigInt y = BigInt.zero;

  double value = 0.0;

  if (k % n17 == BigInt.zero) {
    x = 0;
    while (x < 106) {
      line = '';
      y = k;
      while (y < k + n17) {
        value = ((y / n17).floorToDouble() * pow(2, -1 * 17 * x - (y.toDouble() % 17))) % 2;
        if (value > 0.5) {
          pixel = '1';
        } else {
          pixel = '0';
        }
        line = line + pixel;
        y = y + BigInt.one;
      }
      x = x + 1;
      imageBinary.add(line);
    }
  //  for x in range (width):
  //    for y in range (height):
  //      if ((k+y)//17//2**(17*int(x)+int(y)%17))%2 > 0.5:
  //        # Image need to be flipped vertically - therefore y = height-y-1
  //        image.putpixel((x, height-y-1), (0,0,0))

  }
  print(imageBinary.join('\n'));
  return imageBinary.join('\n');
}