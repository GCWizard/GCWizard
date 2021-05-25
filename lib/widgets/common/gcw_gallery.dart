import 'package:flutter/material.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/utils/common_utils.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/gcw_imageview.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class GCWGallery extends StatefulWidget {
  final List<GCWImageViewData> imageData;

  const GCWGallery({Key key, @required this.imageData}) : super(key: key);

  @override
  _GCWGalleryState createState() => _GCWGalleryState();
}

class _GCWGalleryState extends State<GCWGallery> {
  int _currentImageIndex = 0;
  List<Image> _validImages = [];

  ItemScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ItemScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _validImages = [];

    widget.imageData.asMap().forEach((index, element) {
      MemoryImage _img;
      try {
        if (widget.imageData[index] != null) _img = MemoryImage(widget.imageData[index].bytes);

        if (_img != null) {
          _validImages.add(Image.memory(widget.imageData[index].bytes));
        }
      } catch (e) {}
    });

    if (_currentImageIndex >= _validImages.length) _currentImageIndex = 0;

    if (_validImages.length == 0) return Container();

    return Column(children: <Widget>[
      Stack(
        children: [
          Positioned(
            top: 145,
            child: GCWIconButton(
              iconData: Icons.arrow_back_ios,
              size: IconButtonSize.SMALL,
              onPressed: () {
                setState(() {
                  _currentImageIndex = modulo(_currentImageIndex - 1, _validImages.length);
                  _scrollController.jumpTo(index: _currentImageIndex, alignment: 0.4);
                });
              },
            ),
          ),
          //Expanded(child: Container(),)
          Container(
            child: GCWImageView(
              imageData: widget.imageData[_currentImageIndex],
              toolBarRight: false,
            ),
            padding: EdgeInsets.symmetric(horizontal: 30),
          ),

          Positioned(
              top: 145,
              right: 0,
              child: GCWIconButton(
                iconData: Icons.arrow_forward_ios,
                size: IconButtonSize.SMALL,
                onPressed: () {
                  setState(() {
                    _currentImageIndex = modulo(_currentImageIndex + 1, _validImages.length);
                    _scrollController.jumpTo(index: _currentImageIndex, alignment: 0.5);
                  });
                },
              )),
        ],
      ),
      Container(
        margin: EdgeInsets.only(top: 10),
        height: 50,
        child: ScrollablePositionedList.builder(
            itemScrollController: _scrollController,
            itemCount: _validImages.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => InkWell(
                  child: _currentImageIndex == index
                      ? Container(
                          decoration: BoxDecoration(border: Border.all(color: themeColors().accent(), width: 5)),
                          child: _validImages[index])
                      : _validImages[index],
                  onTap: () {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                )),
      )
    ]);
  }
}
