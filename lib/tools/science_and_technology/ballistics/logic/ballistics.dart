import 'dart:math';

part 'package:gc_wizard/tools/science_and_technology/ballistics/logic/ballistics_datatypes.dart';

OutputBallistics calculateBallisticsNoDrag(double velocity, double angle, double acceleration, double startHeight){
  // https://de.wikipedia.org/wiki/Wurfparabel
  // http://www.dsemmler.de/Software/OnlineApps/SchieferWurf.php

  double time = 0.0;
  double height = 0.0;
  double distance = 0.0;
  double maxSpeed = 0.0;
  double maxHeight = 0.0;

  double v0x = velocity * cos(angle * pi / 180);
  double v0y = velocity * sin(angle * pi / 180);

  height = v0y * v0y / 2 / acceleration;
  maxHeight = startHeight + height;
  time = sqrt(2 * height / acceleration) + sqrt(2 * maxHeight / acceleration);
  distance = time * v0x;
  maxSpeed  = sqrt(2 * acceleration * maxHeight + v0x*v0x);

  return OutputBallistics(Time: time, Height: maxHeight, Distance: distance, maxSpeed: maxSpeed);
}

//TO DO calculation
OutputBallistics calculateBallisticsStokes(double velocity, double angle, double acceleration, double startHeight,  double mass, double diameter, double drag, double density){
// https://www.geogebra.org/m/tEypsSwj#material/sPGWKHD2

  const viscosityAir = 18.2; //μPa·s
  double k1 = 6 * pi * viscosityAir * velocity;
  angle = angle / 180 * pi;

  double XofT(double T){
    return mass * velocity * cos(angle) / k1 * (1 - pow(e, -k1 * T / mass));
  }

  double YofT(double T){
    return startHeight + mass / k1 * (velocity * sin(angle) + mass * acceleration / k1) * (1 - pow(e, -k1 * T / mass)) - mass * acceleration / k1 * T;
  }

  double time = 0.0;
  double distance = 0.0;
  double y = startHeight;
  double maxHeight = 0.0;


  double maxSpeed = 0.0;

  return OutputBallistics(Time: time, Height: maxHeight, Distance: distance, maxSpeed: maxSpeed);
}

OutputBallistics calculateBallisticsNewton(double V0, double Winkel, double g, double startHeight, double Masse, double a, double cw, double rho) {
// Newton    https://matheplanet.com/default3.html?call=article.php%3fsid=735&ref=http://www.google.ch/search%3fhlX=de%2526qX=Schiefer+wurf+F+%253D+k+*+v%255E2%2526metaX=
// https://www.geogebra.org/m/tEypsSwj#material/UCbRqoGb

// Source code from Thomas KoenigDickbauch" Bornhaupt from his software "Mopsos"
// procedure TGC_Wurf.OnButtonCalcClick(Sender: TObject);
// // http://www.matheplanet.com/matheplanet/nuke/html/article.php?sid=735
// //const
// //   g = 9.81;
// //   g = 9.80620;
// //   rho = 1.293;
// var
//    V0, Winkel: double;
//    Masse, A, Cw: double;
//    T, H, W: double;
//    k: double;
//    g: double;
//    rho: double;
//
//    Voo: double; // V-Undendlich
//    Vxo: double; // Vx Start
//    Vyo: double; // Vx Start
//    Tu: double; // Zeit bis Scheitel
//
//    // iteratinswerte
//    T1, T2, Tm: double;
//    H1, H2, Hm: double;
//
//    function XofT(T: double): double;
//    begin
//       result := Voo * Voo / g * ln(1 + Vxo * g * t / Voo / Voo);
//    end;
//
//    function YofTup(T: double): double;
//    begin
//       result := Voo * Voo / g * (ln(cos(g * (Tu - T) / Voo)) - ln(cos(g * Tu / Voo)));
//    end;
//
//    function YofTdown(T: double): double;
//    begin
//       result := Voo * Voo / g * (-g * (T - Tu) / Voo - ln((1 + exp(-2 * g * (T - Tu) / Voo)) / 2 * cos(g * Tu / Voo)));
//    end;
//
// begin
//    DecimalSeparator := '.';
//    ThousandSeparator := #0;
//    try
//       V0 := StrToFloatDef(Edits[0].Text, 0);
//       Winkel := StrToFloatDef(Edits[1].Text, 0);
//       G:=StrToFloatDef(Edits[2].Text, 9.81);
//
//       Vyo := V0 * sin(Winkel / 180 * pi);
//       Vxo := V0 * cos(Winkel / 180 * pi);
//       if Checkboxs[0].Check then begin
//
//          Masse := StrToFloatDef(Edits[3].Text, 0) / 1000;
//          Cw := StrToFloatDef(Edits[4].Text, 0);
//          A := power(StrToFloatDef(Edits[5].Text, 0) / 2, 2) * Pi;
//          rho := StrToFloatDef(Edits[6].Text, 1.293);
//
//          k := 1 / 2 * rho * cW * A;
//
//          Voo := sqrt(Masse * g / k);
//          Tu := Voo / g * arctan(Vyo / Voo);
//
//          H := YofTup(Tu);
//          T := Tu;
//          T1 := Tu;
//          T2 := Tu * 1.5;
//          H1 := YofTdown(T1);
//          H2 := YofTdown(T2);
//          while H2 > 0 do begin
//             T1 := T2;
//             H1 := H2;
//             T2 := T2 + Tu / 2;
//             H2 := YofTdown(T2);
//          end;
//
//          repeat
//             Tm := (T1 + T2)/2;
//             Hm := YofTdown(Tm);
//             if Hm > 0 then begin
//                T1 := Tm;
//             end
//             else begin
//                T2 := Tm;
//             end;
//          until abs(Hm) < 0.01;
//          T := (T1 + T2) / 2;
//          W := XofT(T);
//       end
//       else begin
//
//          Tu := Vyo / g;
//
//          H := -1 / 2 * g * tu * tu + Vyo * tu;
//          T := 2 * Vyo / g;
//          W := Vxo * T;
//
//       end;
//       Edits[7].Text := Format('%.1f s', [round(T * 10) / 10]);
//       Edits[8].Text := Format('%.1f m', [round(H * 10) / 10]);
//       Edits[9].Text := Format('%.1f m', [round(W * 10) / 10]);
//    except
//       AppErrorBox(Texte[136]);
//    end;
// end;

  double maxSpeed = -1.0;

  double T = 0.0; // Time
  double H = 0.0; // Height
  double W = 0.0; // Width,
  double k = 0.0;
  double Voo = 0.0; // V unendlich
  double Vxo = 0.0; // Vx Start
  double Vyo = 0.0; // Vx Start
  double Tu  = 0.0; // Zeit bis Scheitel

  // iterationswerte
  double  T1, T2, Tm, H1, H2, Hm;

  double ln(double x) {
    return log(x) / log(e);
  }

  double XofT(double T){
    return Voo * Voo / g * ln(1 + Vxo * g * T / Voo / Voo);
  }

  double YofTup(double T){
    return Voo * Voo / g * (ln(cos(g * (Tu - T) / Voo)) - ln(cos(g * Tu / Voo)));
  }

  double YofTdown(double T)  {
    return Voo * Voo / g * (-g * (T - Tu) / Voo - ln((1 + exp(-2 * g * (T - Tu) / Voo)) / 2 * cos(g * Tu / Voo)));
  }

  Vyo = V0 * sin(Winkel / 180 * pi);
  Vxo = V0 * cos(Winkel / 180 * pi);

  if (a == 0 || rho == 0 || Masse == 0) {
    return OutputBallistics(Time: 0.0, Height: 0.0, Distance: 0.0, maxSpeed: 0.0);
  }

  a = a * a / 4 * pi;
  k = rho * cw * a / 2;

  Voo = sqrt(Masse * g / k);
  Tu = Voo / g * atan(Vyo / Voo); // Time of Scheitelpunkt

  H = YofTup(Tu); // Height at Scheitelpunkt

  T = Tu;
  T1 = Tu;
  T2 = Tu * 1.5;
  H1 = YofTdown(T1);
  H2 = YofTdown(T2);
  while (H2 > 0) {
    T1 = T2;
    H1 = H2;
    T2 = T2 + Tu / 2;
    H2 = YofTdown(T2);
  }

  do {
    Tm = (T1 + T2)/2;
    Hm = YofTdown(Tm);
    if (Hm > 0) {
      T1 = Tm;
    } else {
      T2 = Tm;
    }
  } while (Hm.abs() > 0.01);
  T = (T1 + T2) / 2;
  W = XofT(T);

  W = XofT(T);

  return OutputBallistics(Time: T, Height: H, Distance: W, maxSpeed: maxSpeed);
}