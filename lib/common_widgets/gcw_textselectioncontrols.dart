/* https://ktuusj.medium.com/flutter-custom-selection-toolbar-3acbe7937dd3 ***/
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_paste_button.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';

typedef OffsetValue = void Function(int start, int end);

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
    ClipboardStatusNotifier clipboardStatus,
    Offset lastSecondaryTapDownPosition,
  ) {
    final TextSelectionPoint startTextSelectionPoint = endpoints[0];
    final TextSelectionPoint endTextSelectionPoint = endpoints.length > 1 ? endpoints[1] : endpoints[0];
    final Offset anchorAbove = Offset(globalEditableRegion.left + selectionMidpoint.dx,
        globalEditableRegion.top + startTextSelectionPoint.point.dy - textLineHeight - _kToolbarContentDistance);
    final Offset anchorBelow = Offset(
      globalEditableRegion.left + selectionMidpoint.dx,
      globalEditableRegion.top + endTextSelectionPoint.point.dy + _kToolbarContentDistanceBelow,
    );

    return GCWTextSelectionToolbar(
      anchorAbove: anchorAbove,
      anchorBelow: anchorBelow,
      clipboardStatus: clipboardStatus,
      delegate: delegate,
      handleCopy: canCopy(delegate) && handleCopy != null
          ? () {
              insertIntoGCWClipboard(
                  context, delegate.textEditingValue.selection.textInside(delegate.textEditingValue.text));
              handleCopy(delegate, clipboardStatus);
            }
          : null,

      /// Custom code
      handleGCWPasteButton: canPaste(delegate) && handlePaste != null
          ? (text, start, end) {
              // From original handlePaste code
              final TextEditingValue value = delegate.textEditingValue;
              if (start == null) start = 0;
              if (end == null) end = 0;

              if (text != null) {
                var textBefore = value.text.substring(0, start);
                var textAfter = value.text.substring(end, value.text.length);

                delegate.userUpdateTextEditingValue(
                  TextEditingValue(
                    text: textBefore + text + textAfter,
                    selection: TextSelection.collapsed(
                      offset: textBefore.length + text.length,
                    ),
                  ),
                  SelectionChangedCause.toolbar,
                );
              }
              delegate.bringIntoView(delegate.textEditingValue.selection.extent);
              delegate.hideToolbar();
            }
          : null,
      handleCut: canCut(delegate) && handleCut != null
          ? () {
              insertIntoGCWClipboard(
                  context, delegate.textEditingValue.selection.textInside(delegate.textEditingValue.text));
              handleCut(delegate, clipboardStatus);
            }
          : null,
      // handlePaste: canPaste(delegate) && handlePaste != null
      //     ? () => handlePaste(delegate)
      //     : null,
      handleSelectAll: canSelectAll(delegate) && handleSelectAll != null ? () => handleSelectAll(delegate) : null,
    );
  }
}

class GCWTextSelectionToolbar extends StatefulWidget {
  const GCWTextSelectionToolbar({
    Key key,
    this.anchorAbove,
    this.anchorBelow,
    this.clipboardStatus,
    this.delegate,
    this.handleCopy,
    this.handleCut,
    // this.handlePaste,
    this.handleSelectAll,

    /// Custom
    this.handleGCWPasteButton,
  }) : super(key: key);

  final Offset anchorAbove;
  final Offset anchorBelow;
  final ClipboardStatusNotifier clipboardStatus;
  final TextSelectionDelegate delegate;
  final VoidCallback handleCopy;
  final VoidCallback handleCut;
  // final VoidCallback handlePaste;
  final VoidCallback handleSelectAll;

  /// Custom
  final Function handleGCWPasteButton;

  @override
  GCWTextSelectionToolbarState createState() => GCWTextSelectionToolbarState();
}

class GCWTextSelectionToolbarState extends State<GCWTextSelectionToolbar> {
  var start;
  var end;

  void _onChangedClipboardStatus() {
    setState(() {
      // Inform the widget that the value of clipboardStatus has changed.
    });
  }

  @override
  void initState() {
    super.initState();
    widget.clipboardStatus.addListener(_onChangedClipboardStatus);
    widget.clipboardStatus.update();
  }

  @override
  void didUpdateWidget(GCWTextSelectionToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clipboardStatus != oldWidget.clipboardStatus) {
      widget.clipboardStatus.addListener(_onChangedClipboardStatus);
      oldWidget.clipboardStatus.removeListener(_onChangedClipboardStatus);
    }
    widget.clipboardStatus.update();
  }

  @override
  void dispose() {
    super.dispose();
    if (!widget.clipboardStatus.disposed) {
      widget.clipboardStatus.removeListener(_onChangedClipboardStatus);
    }
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
      if (widget.handleGCWPasteButton != null)
        GCWPasteButton(
            isTextSelectionToolBarButton: true,
            textSelectionToolBarButtonPadding: TextSelectionToolbarTextButton.getPadding(2, 4),
            textSelectionToolBarButtonLabel: localizations.pasteButtonLabel,
            onBeforePressed: () {
              start = widget.delegate.textEditingValue.selection.start;
              end = widget.delegate.textEditingValue.selection.end;
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
