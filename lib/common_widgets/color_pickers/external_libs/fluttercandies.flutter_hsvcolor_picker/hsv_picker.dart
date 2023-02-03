/* forked and minimized from https://github.com/fluttercandies/flutter_hsvcolor_picker; */

part of 'package:gc_wizard/common_widgets/color_pickers/gcw_colorpicker.dart';

class _SliderPicker extends StatefulWidget {
  final double min;
  final double max;
  final double value;
  final ValueChanged<double> onChanged;
  final List<Color> colors;
  final Widget child;

  const _SliderPicker({
    Key key,
    this.min = 0.0,
    this.max = 1.0,
    @required this.value,
    @required this.onChanged,
    this.colors,
    this.child,
  })  : assert(value != null),
        assert(value >= min && value <= max),
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
    RenderBox renderBox = super.context.findRenderObject();
    Offset offset = renderBox.globalToLocal(details.globalPosition);
    double ratio = offset.dx / box.maxWidth;
    super.setState(() => this.setRatio(ratio));
  }

  BorderRadius radius = const BorderRadius.all(const Radius.circular(20.0));

  Widget buildSlider(double maxWidth) {
    return new Container(
        width: maxWidth,
        child: new CustomMultiChildLayout(delegate: new _SliderLayout(), children: <Widget>[
          //Track
          new LayoutId(
              id: _SliderLayout.track,
              child: (super.widget.colors == null)
                  ?

                  //child
                  new DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: this.radius, border: new Border.all(color: Colors.grey, width: 1)),
                      child: new ClipRRect(borderRadius: this.radius, child: super.widget.child))
                  :

                  //Color
                  new DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: this.radius,
                          border: new Border.all(color: Colors.grey, width: 1),
                          gradient: new LinearGradient(colors: super.widget.colors)))),

          //Thumb
          new LayoutId(
              id: _SliderLayout.thumb,
              child: new Transform(
                transform: new Matrix4.identity()..translate(_ThumbPainter.getWidth(this.getRatio(), maxWidth)),
                child: new CustomPaint(painter: new _ThumbPainter()),
              )),

          //GestureContainer
          new LayoutId(id: _SliderLayout.gestureContainer, child: new LayoutBuilder(builder: this.buildGestureDetector))
        ]));
  }

  Widget buildGestureDetector(BuildContext context, BoxConstraints box) {
    return new GestureDetector(
        child: new Container(color: const Color(0)), onPanUpdate: (detail) => this.onPanUpdate(detail, box));
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
        height: 40.0, child: new LayoutBuilder(builder: (context, box) => this.buildSlider(box.maxWidth)));
  }
}

/// Slider
class _SliderLayout extends MultiChildLayoutDelegate {
  static final String track = "track";
  static final String thumb = "thumb";
  static final String gestureContainer = "gesturecontainer";

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
    final Paint paintWhite = new Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    final Paint paintBlack = new Paint()
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

  _HSVPicker({Key key, @required this.color, @required this.onChanged})
      : assert(color != null),
        super(key: key);

  @override
  _HSVPickerState createState() => new _HSVPickerState();
}

class _HSVPickerState extends State<_HSVPicker> {
  HSVColor get color => super.widget.color;

  //Hue
  void hueOnChange(double value) => super.widget.onChanged(this.color.withHue(value));
  List<Color> get hueColors => [
        this.color.withHue(0.0).toColor(),
        this.color.withHue(60.0).toColor(),
        this.color.withHue(120.0).toColor(),
        this.color.withHue(180.0).toColor(),
        this.color.withHue(240.0).toColor(),
        this.color.withHue(300.0).toColor(),
        this.color.withHue(0.0).toColor()
      ];

  //Saturation
  void saturationOnChange(double value) => super.widget.onChanged(this.color.withSaturation(value));
  List<Color> get saturationColors =>
      [this.color.withSaturation(0.0).toColor(), this.color.withSaturation(1.0).toColor()];

  //Value
  void valueOnChange(double value) => super.widget.onChanged(this.color.withValue(value));
  List<Color> get valueColors => [this.color.withValue(0.0).toColor(), this.color.withValue(1.0).toColor()];

  Widget buildTitle(String title, String text) {
    return new SizedBox(
        height: 34.0,
        child: new Row(children: <Widget>[
          new Opacity(opacity: 0.5, child: new Text(title, style: Theme.of(context).textTheme.headline6)),
          new Expanded(
              child: new Align(
                  alignment: Alignment.centerRight,
                  child: new Text(
                    text,
                    style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 18),
                  )))
        ]));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      //Hue
      new _SliderPicker(
          value: this.color.hue, min: 0.0, max: 360.0, onChanged: this.hueOnChange, colors: this.hueColors),

      //Saturation
      new _SliderPicker(
          value: this.color.saturation,
          min: 0.0,
          max: 1.0,
          onChanged: this.saturationOnChange,
          colors: this.saturationColors),

      //Value
      new _SliderPicker(
          value: this.color.value, min: 0.0, max: 1.0, onChanged: this.valueOnChange, colors: this.valueColors)
    ]);
  }
}
