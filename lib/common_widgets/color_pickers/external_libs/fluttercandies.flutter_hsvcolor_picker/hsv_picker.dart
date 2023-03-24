/* forked and minimized from https://github.com/fluttercandies/flutter_hsvcolor_picker; */

part of 'package:gc_wizard/common_widgets/color_pickers/gcw_colorpicker.dart';

class _SliderPicker extends StatefulWidget {
  final double min;
  final double max;
  final double value;
  final ValueChanged<double> onChanged;
  final List<Color>? colors;

  const _SliderPicker({
    Key? key,
    this.min = 0.0,
    this.max = 1.0,
    required this.value,
    required this.onChanged,
    this.colors
  })  : assert(value >= min && value <= max),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SliderPickerState();
}

class _SliderPickerState extends State<_SliderPicker> {
  double get value => super.widget.value;
  double get min => super.widget.min;
  double get max => super.widget.max;

  double getRatio() => ((value - min) / (max - min)).clamp(0.0, 1.0);
  void setRatio(double ratio) => super.widget.onChanged((ratio * (max - min) + min).clamp(min, max));

  void onPanUpdate(DragUpdateDetails details, BoxConstraints box) {
    RenderBox? renderBox = super.context.findRenderObject() as RenderBox?;
    Offset offset = renderBox?.globalToLocal(details.globalPosition) ?? Offset.zero;
    double ratio = offset.dx / box.maxWidth;
    super.setState(() => setRatio(ratio));
  }

  BorderRadius radius = const BorderRadius.all(Radius.circular(20.0));

  Widget buildSlider(double maxWidth) {
    return SizedBox(
        width: maxWidth,
        child: CustomMultiChildLayout(delegate: _SliderLayout(), children: <Widget>[
          //Track
          LayoutId(
              id: _SliderLayout.track,
              child: (super.widget.colors == null)
                  ?

                  //child
                  DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: radius, border: Border.all(color: Colors.grey, width: 1)),
                      child: ClipRRect(borderRadius: radius))
                  :

                  //Color
                  DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: radius,
                          border: Border.all(color: Colors.grey, width: 1),
                          gradient: LinearGradient(colors: super.widget.colors!)))),

          //Thumb
          LayoutId(
              id: _SliderLayout.thumb,
              child: Transform(
                transform: Matrix4.identity()..translate(_ThumbPainter.getWidth(getRatio(), maxWidth)),
                child: CustomPaint(painter: _ThumbPainter()),
              )),

          //GestureContainer
          LayoutId(id: _SliderLayout.gestureContainer, child: LayoutBuilder(builder: buildGestureDetector))
        ]));
  }

  Widget buildGestureDetector(BuildContext context, BoxConstraints box) {
    return GestureDetector(
        child: Container(color: const Color(0x00000000)), onPanUpdate: (detail) => onPanUpdate(detail, box));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40.0, child: LayoutBuilder(builder: (context, box) => buildSlider(box.maxWidth)));
  }
}

/// Slider
class _SliderLayout extends MultiChildLayoutDelegate {
  static const String track = "track";
  static const String thumb = "thumb";
  static const String gestureContainer = "gesturecontainer";

  @override
  void performLayout(Size size) {
    //Track
    super.layoutChild(track, BoxConstraints.tightFor(width: size.width, height: _ThumbPainter.doubleTrackWidth));
    super.positionChild(track, Offset(0.0, size.height / 2 - _ThumbPainter.trackWidth));

    //Thumb
    super.layoutChild(thumb, BoxConstraints.tightFor(width: 10.0, height: size.height / 2));
    super.positionChild(thumb, Offset(0.0, size.height * 0.5));

    //GestureContainer
    super.layoutChild(gestureContainer, BoxConstraints.tightFor(width: size.width, height: size.height));
    super.positionChild(gestureContainer, Offset.zero);
  }

  @override
  bool shouldRelayout(_SliderLayout oldDelegate) => false;
}

/// Thumb
class _ThumbPainter extends CustomPainter {
  static double width = 12;
  static double trackWidth = 14;
  static double doubleTrackWidth = 28;
  static double getWidth(double value, double maxWidth) => (maxWidth - trackWidth - trackWidth) * value + trackWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintWhite = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    final Paint paintBlack = Paint()
      ..color = Colors.black
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset.zero, _ThumbPainter.width, paintBlack);
    canvas.drawCircle(Offset.zero, _ThumbPainter.width, paintWhite);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _HSVPicker extends StatefulWidget {
  final HSVColor color;
  final ValueChanged<HSVColor> onChanged;

  const _HSVPicker({Key? key, required this.color, required this.onChanged})
      : super(key: key);

  @override
  _HSVPickerState createState() => _HSVPickerState();
}

class _HSVPickerState extends State<_HSVPicker> {
  HSVColor get color => super.widget.color;

  //Hue
  void hueOnChange(double value) => super.widget.onChanged(color.withHue(value));
  List<Color> get hueColors => [
        color.withHue(0.0).toColor(),
        color.withHue(60.0).toColor(),
        color.withHue(120.0).toColor(),
        color.withHue(180.0).toColor(),
        color.withHue(240.0).toColor(),
        color.withHue(300.0).toColor(),
        color.withHue(0.0).toColor()
      ];

  //Saturation
  void saturationOnChange(double value) => super.widget.onChanged(color.withSaturation(value));
  List<Color> get saturationColors =>
      [color.withSaturation(0.0).toColor(), color.withSaturation(1.0).toColor()];

  //Value
  void valueOnChange(double value) => super.widget.onChanged(color.withValue(value));
  List<Color> get valueColors => [color.withValue(0.0).toColor(), color.withValue(1.0).toColor()];

  Widget buildTitle(String title, String text) {
    return SizedBox(
        height: 34.0,
        child: Row(children: <Widget>[
          Opacity(opacity: 0.5, child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
          Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18),
                  )))
        ]));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      //Hue
      _SliderPicker(
          value: color.hue, min: 0.0, max: 360.0, onChanged: hueOnChange, colors: hueColors),

      //Saturation
      _SliderPicker(
          value: color.saturation,
          min: 0.0,
          max: 1.0,
          onChanged: saturationOnChange,
          colors: saturationColors),

      //Value
      _SliderPicker(
          value: color.value, min: 0.0, max: 1.0, onChanged: valueOnChange, colors: valueColors)
    ]);
  }
}
