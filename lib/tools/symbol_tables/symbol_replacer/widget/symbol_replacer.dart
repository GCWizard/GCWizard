import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_slider.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_breaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_breaker_enums.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_breaker_result.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_logic_aggregator.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/widget/quadgram_loader.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/widget/substitution_breaker_items.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_container.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_table_tool.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/symbol_table.dart';
import 'package:gc_wizard/tools/symbol_tables/symbol_replacer/logic/symbol_replacer.dart';
import 'package:gc_wizard/tools/symbol_tables/symbol_replacer/widget/symbol_replacer_manual_control.dart';
import 'package:gc_wizard/tools/symbol_tables/symbol_replacer/widget/symbol_replacer_symboldata.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';
import 'package:tuple/tuple.dart';

class SymbolReplacer extends StatefulWidget {
  final GCWFile? platformFile;
  final String? symbolKey;

  const SymbolReplacer({Key? key, this.platformFile, this.symbolKey}) : super(key: key);

  @override
  _SymbolReplacerState createState() => _SymbolReplacerState();
}

class _SymbolReplacerState extends State<SymbolReplacer> {
  static String no_symbol_table_key = 'no_symbol_table';
  final no_symbol_table =
      SymbolReplacerSymbolTableViewData(symbolKey: no_symbol_table_key, toolName: null, icon: null, description: null);
  SymbolReplacerImage? _symbolImage;
  GCWFile? _platformFile;
  double _blackLevel = 50.0;
  double _similarityLevel = 90.0;
  double _similarityCompareLevel = 80.0;
  var _currentSimpleMode = GCWSwitchPosition.left;
  List<GCWDropDownMenuItem<SymbolReplacerSymbolTableViewData>> _compareSymbolItems = [];
  final _gcwTextStyle = gcwTextStyle();
  final _descriptionTextStyle = gcwDescriptionTextStyle();
  late SymbolReplacerSymbolTableViewData _currentSymbolTableViewData;
  final _quadgrams = <SubstitutionBreakerAlphabet, Quadgrams>{};
  SubstitutionBreakerAlphabet _currentAlphabet = SubstitutionBreakerAlphabet.GERMAN;
  final _isLoading = <bool>[false];
  double? _currentMergeDistance;
  var init = true;

  @override
  void initState() {
    super.initState();

    _currentSymbolTableViewData = no_symbol_table;
  }

  @override
  Widget build(BuildContext context) {
    if (init) {
      _initDropDownLists();
      _selectSymbolTableDataItem(widget.symbolKey);
      init = false;

      if (widget.platformFile != null) {
        _platformFile = widget.platformFile!;
        _replaceSymbols(true);
      }
    }

    return Column(children: <Widget>[
      GCWOpenFile(
        supportedFileTypes: SUPPORTED_IMAGE_TYPES,
        onLoaded: (_file) {
          if (_file == null) {
            showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'), context);
            return;
          }

          setState(() {
            _platformFile = _file;
            _symbolImage = null;
            _currentMergeDistance = null;
            _replaceSymbols(true);
          });
        },
      ),
      _buildSymbolTableDropDownRow(),
      GCWTwoOptionsSwitch(
        value: _currentSimpleMode,
        leftValue: i18n(context, 'common_mode_simple'),
        rightValue: i18n(context, 'common_mode_advanced'),
        onChanged: (value) {
          setState(() {
            _currentSimpleMode = value;
          });
        },
      ),
      _currentSimpleMode == GCWSwitchPosition.left ? Container() : _buildAdvancedModeControl(context),
      Container(height: 10),
      _symbolImage?.getBorderImage() != null
          ? GCWImageView(
              imageData: GCWImageViewData(GCWFile(bytes: _symbolImage!.getBorderImage()!)),
              suppressedButtons: const {GCWImageViewButtons.SAVE},
              suppressOpenInTool: const {GCWImageViewOpenInTools.HIDDENDATA},
            )
          : Container(),
      _symbolImage != null
          ? GCWButton(
              text: i18n(context, 'symbol_replacer_letters_manually'),
              onPressed: () {
                _navigateToSubPage();
              })
          : Container(),
      _buildOutput(),
    ]);
  }

  void _replaceSymbols(bool useAsyncExecuter) async {
    useAsyncExecuter =
        ((useAsyncExecuter || (_symbolImage?.symbolGroups == null) || (_symbolImage!.symbolGroups.isEmpty)) &&
            ((_platformFile?.bytes.length != null) && _platformFile!.bytes.length > 100000));

    if (!useAsyncExecuter) {
      var _jobData = await _buildJobDataReplacer();

      _showOutput(await replaceSymbolsAsync(_jobData));
    } else {
      showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: SizedBox(
              height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
              width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
              child: GCWAsyncExecuter<SymbolReplacerImage?>(
                isolatedFunction: replaceSymbolsAsync,
                parameter: _buildJobDataReplacer,
                onReady: (data) => _showOutput(data),
                isOverlay: true,
              ),
            ),
          );
        },
      );
    }
  }

  Future<GCWAsyncExecuterParameters?> _buildJobDataReplacer() async {
    if (_currentSymbolTableViewData.data == null) await _currentSymbolTableViewData.initialize(context);

    if (_platformFile?.bytes == null) return null;

    return GCWAsyncExecuterParameters(ReplaceSymbolsInput(
        image: _platformFile!.bytes,
        blackLevel: _blackLevel.toInt(),
        similarityLevel: _similarityLevel,
        symbolImage: _symbolImage,
        compareSymbols: _currentSymbolTableViewData.data?.images,
        similarityCompareLevel: _similarityCompareLevel,
        mergeDistance: _currentMergeDistance));
  }

  void _showOutput(SymbolReplacerImage? output) {
    _symbolImage = output;
    setState(() {});
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {});
    // });
  }

  Widget _buildAdvancedModeControl(BuildContext context) {
    return Column(children: <Widget>[
      GCWSlider(
          title: i18n(context, 'symbol_replacer_similarity_level'),
          value: _similarityLevel,
          min: 80,
          max: 100,
          onChanged: (value) => {},
          onChangeEnd: (value) {
            _similarityLevel = value;
            _replaceSymbols(false);
          }),
      GCWSlider(
          title: i18n(context, 'symbol_replacer_black_level'),
          value: _blackLevel,
          min: 1,
          max: 100,
          onChanged: (value) => {},
          onChangeEnd: (value) {
            _blackLevel = value;
            _replaceSymbols(true);
          }),
      _buildSymbolTableConfig(),
      _buildSymbolSizeRow()
    ]);
  }

  Widget _buildSymbolTableConfig() {
    return Column(children: <Widget>[
      GCWTextDivider(text: i18n(context, 'symbol_replacer_symbol_table')),
      GCWSlider(
          title: i18n(context, 'symbol_replacer_similarity_level'),
          value: _similarityCompareLevel,
          min: 0,
          max: 100,
          onChanged: (value) {
            _similarityCompareLevel = value;
            if (_symbolImage?.getCompareImage != null) _replaceSymbols(false);
          }),
    ]);
  }

  Widget _buildSymbolSizeRow() {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: GCWText(
              text: i18n(context, 'symbol_replacer_symbol_size') + ':',
            )),
        GCWIconButton(
          icon: Icons.remove,
          iconColor: _symbolImage == null ? themeColors().inActive() : null,
          onPressed: () {
            if (_symbolImage != null) {
              _currentMergeDistance = _symbolImage!.prevMergeDistance(_currentMergeDistance);
              if (_currentMergeDistance != null) _replaceSymbols(false);
            }
          },
        ),
        GCWIconButton(
          icon: Icons.add,
          iconColor: _symbolImage == null ? themeColors().inActive() : null,
          onPressed: () {
            if (_symbolImage != null) {
              _currentMergeDistance = _symbolImage!.nextMergeDistance(_currentMergeDistance);
              _replaceSymbols(false);
            }
          },
        ),
        Expanded(flex: 1, child: Container())
      ],
    );
  }

  Widget _buildSymbolTableDropDownRow() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: GCWDropDown<SymbolReplacerSymbolTableViewData>(
            value: _currentSymbolTableViewData,
            onChanged: (value) {
              setState(() {
                _currentSymbolTableViewData = value;
              });
              if (_symbolImage != null) {
                if (_currentSymbolTableViewData.data == null && _currentSymbolTableViewData != no_symbol_table) {
                  _currentSymbolTableViewData.initialize(context).then((_) {
                    _symbolImage!.compareSymbols = _currentSymbolTableViewData.data?.images;
                  });
                } else {
                  _symbolImage!.compareSymbols = _currentSymbolTableViewData.data?.images;
                }
              }
            },
            items: _compareSymbolItems,
            selectedItemBuilder: (BuildContext context) {
              return _compareSymbolItems.map((item) {
                return _buildDropDownMenuItem(
                    item.value.icon,
                    (item.value == no_symbol_table)
                        ? i18n(context, 'symbol_replacer_no_symbol_table')
                        : item.value.toolName,
                    null);
              }).toList();
            },
          ),
        ),
        Container(width: 5),
        GCWIconButton(
            icon: Icons.alt_route,
            iconColor: _symbolImage == null ? themeColors().inActive() : null,
            onPressed: () {
              if (_symbolImage != null) {
                _symbolImage!.resetGroupText();

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _replaceSymbols(false);
                });
              }
            }),
        Container(width: 5),
        GCWIconButton(
            icon: Icons.auto_fix_high,
            iconColor: _symbolImage == null ? themeColors().inActive() : null,
            onPressed: () {
              _showAutoSearchDialog();
            }),
      ],
    );
  }

  Widget _buildOutput() {
    if (_symbolImage == null) return Container();

    return Column(children: <Widget>[
      GCWDefaultOutput(child: _symbolImage!.getTextOutput()),
    ]);
  }

  void _showAutoSearchDialog() {
    showGCWDialog(
        context,
        '',
        Column(children: <Widget>[
          GCWTextDivider(
            text: i18n(context, 'symbol_replacer_automatic_header'),
            style: gcwDialogTextStyle(),
            suppressTopSpace: true,
          ),
          GCWDropDown<SubstitutionBreakerAlphabet>(
            value: _currentAlphabet,
            alternativeColor: true,
            onChanged: (value) {
              setState(() {
                _currentAlphabet = value;
              });
            },
            items: SubstitutionBreakerAlphabetItems(context).entries.map((alphabet) {
              return GCWDropDownMenuItem(
                value: alphabet.key,
                child: alphabet.value,
              );
            }).toList(),
          ),
          GCWDialogButton(
            text: i18n(context, 'symbol_replacer_start'),
            onPressed: () {
              _startSubstitutionBreaker();
            },
          ),
          Container(height: 20),
          GCWTextDivider(text: i18n(context, 'symbol_replacer_symboltable_search_header'), style: gcwDialogTextStyle()),
          GCWDialogButton(
            text: i18n(context, 'symbol_replacer_start'),
            onPressed: () {
              _startJobDataSearchSymbolTable();
            },
          ),
        ]),
        []);
  }

  void _startSubstitutionBreaker() async {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
            width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
            child: GCWAsyncExecuter<SubstitutionBreakerResult?>(
              isolatedFunction: break_cipherAsync,
              parameter: _buildSubstitutionBreakerJobData,
              onReady: (data) => _showSubstitutionBreakerOutput(data),
              isOverlay: true,
            ),
          ),
        );
      },
    );
  }

  void _startJobDataSearchSymbolTable() {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
            width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
            child: GCWAsyncExecuter<List<Map<String, SymbolReplacerSymbolData>>?>(
              isolatedFunction: searchSymbolTableAsync,
              parameter: _buildJobDataSearchSymbolTable,
              onReady: (data) => _showJobDataSearchSymbolTableOutput(data),
              isOverlay: true,
            ),
          ),
        );
      },
    );
  }

  void _initDropDownLists() {
    if (_compareSymbolItems.isEmpty) {
      List<GCWTool> _toolList = registeredTools.where((element) {
        return [
          className(const SymbolTable()),
        ].contains(className(element.tool));
      }).toList();
      _toolList.sort((a, b) => sortToolList(a, b));

      _compareSymbolItems = _toolList.map((tool) {
        return GCWDropDownMenuItem(
            value: SymbolReplacerSymbolTableViewData(
                symbolKey: (tool as GCWSymbolTableTool).symbolKey,
                icon: tool.icon,
                toolName: tool.toolName,
                description: tool.description),
            child: _buildDropDownMenuItem(tool.icon, tool.toolName, null));
      }).toList();
      _compareSymbolItems.insert(
          0,
          GCWDropDownMenuItem(
              value: _currentSymbolTableViewData,
              child: _buildDropDownMenuItem(null, i18n(context, 'symbol_replacer_no_symbol_table'), null)));
    }
  }

  void _selectSymbolTableDataItem(String? symbolKey) {
    if ((symbolKey != null)) {
      for (var item in _compareSymbolItems) {
        if (item.value.symbolKey == symbolKey) {
          _currentSymbolTableViewData = item.value;
          break;
        }
      }
    }
  }

  Widget _buildDropDownMenuItem(GCWSymbolContainer? icon, String? toolName, String? description) {
    return Row(children: [
      Container(
        margin: const EdgeInsets.only(left: 2, top: 2, bottom: 2, right: 10),
        child: (icon != null) ? icon : Container(width: 50),
      ),
      Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(toolName ?? '', style: _gcwTextStyle),
            (description != null) ? Text(description, style: _descriptionTextStyle) : Container(),
          ]))
    ]);
  }

  Future<GCWAsyncExecuterParameters?> _buildSubstitutionBreakerJobData() async {
    if (_symbolImage == null) return null;

    var quadgrams = await loadQuadgramsAssets(_currentAlphabet, context, _quadgrams, _isLoading);
    if (quadgrams == null) return null;

    if (_symbolImage!.symbolGroups.length > quadgrams.alphabet.length) {
      showSnackBar(i18n(context, 'symbol_replacer_automatic_groups'), context);
      return null;
    }

    var input = '';
    for (var line in _symbolImage!.lines) {
      for (var symbol in line.symbols) {
        if (symbol.symbolGroup != null) {
          var index = _symbolImage!.symbolGroups.indexOf(symbol.symbolGroup!);
          if (index >= 0) input += quadgrams.alphabet[index];
        }
      }
    }
    input = input.trim();

    return GCWAsyncExecuterParameters(SubstitutionBreakerJobData(input: input, quadgrams: quadgrams));
  }

  void _showSubstitutionBreakerOutput(SubstitutionBreakerResult? output) {
    if (output == null || _symbolImage == null) return;

    if (output.errorCode == SubstitutionBreakerErrorCode.OK) {
      var len = min(_symbolImage!.symbolGroups.length, output.alphabet.length);
      for (int i = 0; i < len; i++) {
        var index = output.key.indexOf(output.alphabet[i]);
        if (index < output.alphabet.length) _symbolImage!.symbolGroups[i].text = output.alphabet[index].toUpperCase();
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _replaceSymbols(false);
    });
  }

  Future<GCWAsyncExecuterParameters?> _buildJobDataSearchSymbolTable() async {
    var list = <List<Map<String, SymbolReplacerSymbolData>>>[];
    if (_symbolImage == null) return null;

    list = await Future.wait(_compareSymbolItems.map((_symbolTableViewData) async {
      var symbolTableViewData = _symbolTableViewData.value;
      if (symbolTableViewData.data == null) await symbolTableViewData.initialize(context);

      return symbolTableViewData.data?.images ?? [];
    }));

    return GCWAsyncExecuterParameters(
        Tuple2<SymbolReplacerImage, List<List<Map<String, SymbolReplacerSymbolData>>>>(_symbolImage!, list));
  }

  void _showJobDataSearchSymbolTableOutput(List<Map<String, SymbolReplacerSymbolData>>? output) {
    _selectSymbolDataItem1(output);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (output != null && _symbolImage != null) _symbolImage!.resetGroupText();
        _replaceSymbols(false);
      });
    });
  }

  void _selectSymbolDataItem1(List<Map<String, SymbolReplacerSymbolData>>? imageData) {
    if (imageData == null) return;
    for (var item in _compareSymbolItems) {
      var found = true;
      var images = item.value.data?.images;
      if (images?.length == imageData.length) {
        for (var i = 0; i < imageData.length; i++) {
          if (!const ListEquality<int>().equals(imageData[i].values.first.bytes, images?[i].values.first.bytes)) {
            found = false;
            break;
          }
        }
        if (found) {
          _currentSymbolTableViewData = item.value;
          break;
        }
      }
    }
  }

  void _navigateToSubPage() {
    if (_symbolImage == null) return;
    var subPageTool = GCWTool(
        autoScroll: false,
        tool: SymbolReplacerManualControl(symbolImage: _symbolImage!),
        id: 'symbol_replacer',
        searchKeys: const ['symbol_replacer']);

    Navigator.push(context, NoAnimationMaterialPageRoute<GCWTool>(builder: (context) => subPageTool)).whenComplete(() {
      setState(() {});
    });
  }
}
