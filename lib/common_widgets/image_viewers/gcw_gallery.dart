import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class GCWGallery extends StatefulWidget {
  final List<GCWImageViewData> imageData;
  final void Function(int)? onDoubleTap;

  const GCWGallery({Key? key, required this.imageData, this.onDoubleTap}) : super(key: key);

  @override
  _GCWGalleryState createState() => _GCWGalleryState();
}

class _GCWGalleryState extends State<GCWGallery> {
  int _currentImageIndex = 0;
  List<Image> _validImages = [];

  late ItemScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ItemScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _validImages = [];

    widget.imageData.asMap().forEach((index, element) {
      try {
        _validImages.add(Image.memory(widget.imageData[index].file.bytes));
      } catch (e) {}
    });

    if (_currentImageIndex >= _validImages.length) _currentImageIndex = 0;

    if (_validImages.isEmpty) return Container();

    return Column(children: <Widget>[
      Stack(
        children: [
          Positioned(
            top: 145,
            child: GCWIconButton(
              icon: Icons.arrow_back_ios,
              size: IconButtonSize.SMALL,
              onPressed: () {
                setState(() {
                  _currentImageIndex = modulo(_currentImageIndex - 1, _validImages.length).toInt();
                  _scrollController.jumpTo(index: _currentImageIndex, alignment: 0.4);
                });
              },
            ),
          ),
          //Expanded(child: Container(),)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GCWImageView(
              imageData: widget.imageData[_currentImageIndex],
              toolBarRight: false,
            ),
          ),

          Positioned(
              top: 145,
              right: 0,
              child: GCWIconButton(
                icon: Icons.arrow_forward_ios,
                size: IconButtonSize.SMALL,
                onPressed: () {
                  setState(() {
                    _currentImageIndex = modulo(_currentImageIndex + 1, _validImages.length).toInt();
                    _scrollController.jumpTo(index: _currentImageIndex, alignment: 0.5);
                  });
                },
              )),
        ],
      ),
      Container(
        margin: const EdgeInsets.only(top: 10),
        height: 50,
        child: ScrollablePositionedList.builder(
            itemScrollController: _scrollController,
            itemCount: _validImages.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => InkWell(
                  child: imageDecoration(index, _currentImageIndex == index),
                  onTap: () {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  onDoubleTap: () {
                    if (widget.onDoubleTap != null) widget.onDoubleTap!(index);
                  },
                )),
      )
    ]);
  }

  Widget imageDecoration(int index, bool currentImage) {
    var marked = (index < widget.imageData.length ? widget.imageData[index].marked : false) ?? false;
    if (currentImage) {
      return Container(
          decoration: BoxDecoration(
              border: Border.all(color: marked ? themeColors().focused() : themeColors().secondary(), width: 5)),
          child: _validImages[index]);
    } else if (marked) {
      return Container(
          decoration: BoxDecoration(border: Border.all(color: themeColors().focused(), width: 2)),
          child: _validImages[index]);
    } else {
      return _validImages[index];
    }
  }
}
