/* https://ktuusj.medium.com/flutter-custom-selection-toolbar-3acbe7937dd3 ***/
import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_paste_button.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';

typedef OffsetValue = void Function(int start, int end);

// TODO Maybe remove for https://api.flutter.dev/flutter/material/SelectableText/contextMenuBuilder.html

class GCWTextSelectionControls extends MaterialTextSelectionControls {
  // Padding between the toolbar and the anchor.
  static const double _kToolbarContentDistanceBelow = 20.0;
  static const double _kToolbarContentDistance = 8.0;

  /// Builder for material-style copy/paste text selection toolbar.
  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ClipboardStatusNotifier? clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) {
    final TextSelectionPoint startTextSelectionPoint = endpoints[0];
    final TextSelectionPoint endTextSelectionPoint = endpoints.length > 1 ? endpoints[1] : endpoints[0];
    final Offset anchorAbove = Offset(globalEditableRegion.left + selectionMidpoint.dx,
        globalEditableRegion.top + startTextSelectionPoint.point.dy - textLineHeight - _kToolbarContentDistance);
    final Offset anchorBelow = Offset(
      globalEditableRegion.left + selectionMidpoint.dx,
      globalEditableRegion.top + endTextSelectionPoint.point.dy + _kToolbarContentDistanceBelow,
    );

    return _GCWTextSelectionToolbar(
      anchorAbove: anchorAbove,
      anchorBelow: anchorBelow,
      clipboardStatus: clipboardStatus,
      delegate: delegate,
      handleCopy: canCopy(delegate)
          ? () {
              insertIntoGCWClipboard(
                  context, delegate.textEditingValue.selection.textInside(delegate.textEditingValue.text));
              handleCopy(delegate, clipboardStatus);
            }
          : () {},

      /// Custom code
      handleGCWPasteButton: canPaste(delegate)
          ? (String text, int start, int end) {
              // From original handlePaste code
              final TextEditingValue value = delegate.textEditingValue;

              var textBefore = value.text.substring(0, start);
              var textAfter = value.text.substring(end, value.text.length);

              delegate.userUpdateTextEditingValue(
                TextEditingValue(
                  text: textBefore + text + textAfter,
                  selection: TextSelection.collapsed(
                    offset: (textBefore.length + text.length).toInt(),
                  ),
                ),
                SelectionChangedCause.toolbar,
              );
              delegate.bringIntoView(delegate.textEditingValue.selection.extent);
              delegate.hideToolbar();
            }
          :  () {},
      handleCut: canCut(delegate)
          ? () {
              insertIntoGCWClipboard(
                  context, delegate.textEditingValue.selection.textInside(delegate.textEditingValue.text));
              handleCut(delegate, clipboardStatus);
            }
          :  () {},
      // handlePaste: canPaste(delegate) && handlePaste != null
      //     ? () => handlePaste(delegate)
      //     : null,
      handleSelectAll: canSelectAll(delegate) ? () => handleSelectAll(delegate) : () => {},
    );
  }
}

class _GCWTextSelectionToolbar extends StatefulWidget {
  const _GCWTextSelectionToolbar({
    Key? key,
    required this.anchorAbove,
    required this.anchorBelow,
    this.clipboardStatus,
    this.delegate,
    required this.handleCopy,
    required this.handleCut,
    // this.handlePaste,
    required this.handleSelectAll,

    /// Custom
    required this.handleGCWPasteButton,
  }) : super(key: key);

  final Offset anchorAbove;
  final Offset anchorBelow;
  final ClipboardStatusNotifier? clipboardStatus;
  final TextSelectionDelegate? delegate;
  final void Function()? handleCopy;
  final void Function()? handleCut;
  // final Function handlePaste;
  final void Function()? handleSelectAll;

  /// Custom
  final Function handleGCWPasteButton;

  @override
  _GCWTextSelectionToolbarState createState() => _GCWTextSelectionToolbarState();
}

class _GCWTextSelectionToolbarState extends State<_GCWTextSelectionToolbar> {
  int? start;
  int? end;

  void _onChangedClipboardStatus() {
    setState(() {
      // Inform the widget that the value of clipboardStatus has changed.
    });
  }

  @override
  void initState() {
    super.initState();
    widget.clipboardStatus?.addListener(_onChangedClipboardStatus);
    widget.clipboardStatus?.update();
  }

  @override
  void didUpdateWidget(_GCWTextSelectionToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clipboardStatus != oldWidget.clipboardStatus) {
      widget.clipboardStatus?.addListener(_onChangedClipboardStatus);
      oldWidget.clipboardStatus?.removeListener(_onChangedClipboardStatus);
    }
    widget.clipboardStatus?.update();
  }

  @override
  void dispose() {
    widget.clipboardStatus?.removeListener(_onChangedClipboardStatus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);

    final itemDatas = <Widget>[
      if (widget.handleCut != null)
        TextSelectionToolbarTextButton(
          padding: TextSelectionToolbarTextButton.getPadding(0, 4),
          onPressed: widget.handleCut,
          child: Text(localizations.cutButtonLabel),
        ),
      if (widget.handleCopy != null)
        TextSelectionToolbarTextButton(
          padding: TextSelectionToolbarTextButton.getPadding(1, 4),
          onPressed: widget.handleCopy,
          child: Text(localizations.copyButtonLabel),
        ),
      GCWPasteButton(
          isTextSelectionToolBarButton: true,
          textSelectionToolBarButtonPadding: TextSelectionToolbarTextButton.getPadding(2, 4),
          textSelectionToolBarButtonLabel: localizations.pasteButtonLabel,
          onBeforePressed: () {
            start = widget.delegate?.textEditingValue.selection.start;
            end = widget.delegate?.textEditingValue.selection.end;
          },
          onSelected: (text) {
            widget.handleGCWPasteButton(text, start, end);
          }),
      if (widget.handleSelectAll != null)
        TextSelectionToolbarTextButton(
          padding: TextSelectionToolbarTextButton.getPadding(3, 4),
          onPressed: widget.handleSelectAll,
          child: Text(localizations.selectAllButtonLabel),
        )
    ];

    return TextSelectionToolbar(
      anchorAbove: widget.anchorAbove,
      anchorBelow: widget.anchorBelow,
      toolbarBuilder: (BuildContext context, Widget child) {
        return Card(child: child);
      },
      children: itemDatas,
    );
  }
}
