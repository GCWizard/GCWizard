import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_soundplayer.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_double_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_threeoptionsswitch.dart';
import 'package:gc_wizard/tools/images_and_files/hex_viewer/widget/hex_viewer.dart';
import 'package:gc_wizard/tools/images_and_files/waveform/logic/waveform.dart';
import 'package:gc_wizard/tools/images_and_files/waveform/logic/waveform_rms_image.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';

class WaveForm extends StatefulWidget {
  const WaveForm({super.key});

  @override
  WaveFormState createState() => WaveFormState();
}

class WaveFormState extends State<WaveForm> {
  Uint8List _bytes = Uint8List.fromList([]);
  Uint8List _soundfilePNGImage = Uint8List.fromList([]);

  AudioInfo _audioInfo = AudioInfo(
      duration: Duration(milliseconds: 0),
      sampleRate: 0,
      channels: 0,
      bitRate: 0,
      format: '',
      bytes: Uint8List.fromList([]),
      status: AUDIO_INFO_STATUS.ERROR,
      error: '');

  String _decodedMorseCode = '';
  String _decodedMorseText = '';
  String _currentError = '';

  bool _parseError = false;
  bool _spectrumCreated = false;

  int _currentSmoothingWindow = 5;
  double _currentThresholdFactor = 4.0;
  int _currentMinRunLength = 3;
  double _currentUnitTolerance = 0.40;

  int _currentMode = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setData(Uint8List bytes) {
    _bytes = bytes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWOpenFile(
          supportedFileTypes: const [FileType.WAV, FileType.MP3, FileType.OGG],
          onLoaded: (_file) async {
            if (_file == null) {
              showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'),
                  context);
              return;
            }
            _setData(_file.bytes);
            _audioInfo = await getSoundfileAudioInfo(_bytes);
            renderAndAnalyzeWav(
                    wavBytes: _audioInfo.bytes,
                    height: 400,
                    params: MorseParams())
                .then((value) {
              if (value.status == PARSE_STATUS.ERROR) {
                setState(() {
                  _spectrumCreated = false;
                  _parseError = true;
                  _currentError = value.error;
                });
              } else {
                setState(() {
                  _soundfilePNGImage = value.pngBytes;
                  _decodedMorseCode = value.morse;
                  _decodedMorseText = value.text;
                  _spectrumCreated = true;
                  _parseError = false;
                });
              }
            });
          },
        ),
        GCWSoundPlayer(
          file: GCWFile(bytes: _bytes),
        ),
        _buildOutputWaveFormImage(),
        _buildOutputDecodingParameter(),
        _buildOutputWaveFormMorse(),
        _buildOutputWaveFormInfo(),
        GCWOutput(
          title: i18n(context, 'waveform_output_hexview'),
          child: i18n(context, 'waveform_output_hexview_hint'),
          suppressCopyButton: true,
          trailing: Row(children: <Widget>[
            GCWIconButton(
              iconColor: themeColors().mainFont(),
              size: IconButtonSize.SMALL,
              icon: Icons.input,
              onPressed: () {
                openInHexViewer(context, GCWFile(bytes: _bytes));
              },
            ),
          ]),
        )
      ],
    );
  }

  Widget _buildOutputWaveFormImage() {
    return Column(children: [
      GCWTextDivider(text: i18n(context, 'waveform_output_amplitudes_graph'),
      suppressTopSpace: false,),
      (_spectrumCreated)
          ? GCWImageView(
              imageData: GCWImageViewData(GCWFile(bytes: _soundfilePNGImage)),
              suppressOpenInTool: const {
                GCWImageViewOpenInTools.COLORCORRECTIONS,
                GCWImageViewOpenInTools.HIDDENDATA,
                GCWImageViewOpenInTools.FLIPROTATE
              },
            )
          : GCWOutputText(
              text: _errorText('waveform_error_image_no_data'),
            ),
    ]);
  }

  Widget _buildOutputDecodingParameter() {
    // Morse‑Decoder – Einstellungen
    // Signalverarbeitung
    // smoothingWindow  Slider (1–25)     Standard: 5
    //
    // thresholdFactor  Slider (1.0–10.0) Standard: 4.0
    // (höher = weniger empfindlich)
    //
    // minRunLength     Stepper (1–20)    Standard: 3
    // (entfernt kurze Störimpulse)
    //
    // Morse‑Interpretation
    // unitTolerance    Slider (0–0.8)    Standard: 0.40
    // (höher = toleranter gegenüber unregelmäßigem Morse)
    //
    return GCWExpandableTextDivider(
      suppressTopSpace: false,
      text: i18n(context, 'waveform_settings'),
      expanded: false,
      child: Column(
        children: [
          GCWThreeOptionsSwitch(
              notitle: true,
              labels: [
                i18n(context, 'waveform_settings_threshold'),
                i18n(context, 'waveform_settings_mode_tolerant'),
                i18n(context, 'waveform_settings_mode_cluster')
              ],
              position: _currentMode,
              onChanged: (position) {
                setState(() {
                  _currentMode = position;
                  renderAndAnalyzeWav(
                      wavBytes: _audioInfo.bytes,
                      height: 400,
                      params: MorseParams(
                          smoothingWindow: _currentSmoothingWindow,
                          thresholdFactor: _currentThresholdFactor,
                          minRunLength: _currentMinRunLength,
                          unitTolerance: _currentUnitTolerance,
                          mode: morseUnitModeMap[_currentMode]!))
                      .then((value) {
                    if (value.status == PARSE_STATUS.ERROR) {
                      setState(() {
                        _spectrumCreated = false;
                        _parseError = true;
                        _currentError = value.error;
                      });
                    } else {
                      setState(() {
                        _soundfilePNGImage = value.pngBytes;
                        _decodedMorseCode = value.morse;
                        _decodedMorseText = value.text;
                        _spectrumCreated = true;
                        _parseError = false;
                      });
                    }
                  });
                });
              }),
          GCWIntegerSpinner(
              title: i18n(context, 'waveform_settings_smoothing'),
              min: 1,
              max: 25,
              value: _currentSmoothingWindow,
              onChanged: (value) {
                setState(() {
                  _currentSmoothingWindow = value;
                  renderAndAnalyzeWav(
                          wavBytes: _audioInfo.bytes,
                          height: 400,
                          params: MorseParams(
                              smoothingWindow: _currentSmoothingWindow,
                              thresholdFactor: _currentThresholdFactor,
                              minRunLength: _currentMinRunLength,
                              unitTolerance: _currentUnitTolerance,
                              mode: morseUnitModeMap[_currentMode]!))
                      .then((value) {
                    if (value.status == PARSE_STATUS.ERROR) {
                      setState(() {
                        _spectrumCreated = false;
                        _parseError = true;
                        _currentError = value.error;
                      });
                    } else {
                      setState(() {
                        _soundfilePNGImage = value.pngBytes;
                        _decodedMorseCode = value.morse;
                        _decodedMorseText = value.text;
                        _spectrumCreated = true;
                        _parseError = false;
                      });
                    }
                  });
                });
              }),
          GCWDoubleSpinner(
              title: i18n(context, 'waveform_settings_threshold'),
              min: 1.0,
              max: 10.0,
              value: _currentThresholdFactor,
              onChanged: (value) {
                setState(() {
                  _currentThresholdFactor = value;
                  renderAndAnalyzeWav(
                          wavBytes: _audioInfo.bytes,
                          height: 400,
                          params: MorseParams(
                              smoothingWindow: _currentSmoothingWindow,
                              thresholdFactor: _currentThresholdFactor,
                              minRunLength: _currentMinRunLength,
                              unitTolerance: _currentUnitTolerance,
                              mode: morseUnitModeMap[_currentMode]!))
                      .then((value) {
                    if (value.status == PARSE_STATUS.ERROR) {
                      setState(() {
                        _spectrumCreated = false;
                        _parseError = true;
                        _currentError = value.error;
                      });
                    } else {
                      setState(() {
                        _soundfilePNGImage = value.pngBytes;
                        _decodedMorseCode = value.morse;
                        _decodedMorseText = value.text;
                        _spectrumCreated = true;
                        _parseError = false;
                      });
                    }
                  });
                });
              }),
          GCWIntegerSpinner(
              title: i18n(context, 'waveform_settings_minrunlength'),
              min: 1,
              max: 20,
              value: _currentMinRunLength,
              onChanged: (value) {
                setState(() {
                  _currentMinRunLength = value;
                  renderAndAnalyzeWav(
                          wavBytes: _audioInfo.bytes,
                          height: 400,
                          params: MorseParams(
                              smoothingWindow: _currentSmoothingWindow,
                              thresholdFactor: _currentThresholdFactor,
                              minRunLength: _currentMinRunLength,
                              unitTolerance: _currentUnitTolerance,
                              mode: morseUnitModeMap[_currentMode]!))
                      .then((value) {
                    if (value.status == PARSE_STATUS.ERROR) {
                      setState(() {
                        _spectrumCreated = false;
                        _parseError = true;
                        _currentError = value.error;
                      });
                    } else {
                      setState(() {
                        _soundfilePNGImage = value.pngBytes;
                        _decodedMorseCode = value.morse;
                        _decodedMorseText = value.text;
                        _spectrumCreated = true;
                        _parseError = false;
                      });
                    }
                  });
                });
              }),
          GCWDoubleSpinner(
              title: i18n(context, 'waveform_settings_tolerance'),
              min: 0,
              max: 0.8,
              value: _currentUnitTolerance,
              onChanged: (value) {
                setState(() {
                  _currentUnitTolerance = value;
                  renderAndAnalyzeWav(
                          wavBytes: _audioInfo.bytes,
                          height: 400,
                          params: MorseParams(
                              smoothingWindow: _currentSmoothingWindow,
                              thresholdFactor: _currentThresholdFactor,
                              minRunLength: _currentMinRunLength,
                              unitTolerance: _currentUnitTolerance))
                      .then((value) {
                    if (value.status == PARSE_STATUS.ERROR) {
                      setState(() {
                        _spectrumCreated = false;
                        _parseError = true;
                        _currentError = value.error;
                      });
                    } else {
                      setState(() {
                        _soundfilePNGImage = value.pngBytes;
                        _decodedMorseCode = value.morse;
                        _decodedMorseText = value.text;
                        _spectrumCreated = true;
                        _parseError = false;
                      });
                    }
                  });
                });
              }),
        ],
      ),
    );
  }

  Widget _buildOutputWaveFormMorse() {
    return Column(children: [
      (_soundfilePNGImage.isNotEmpty)
          ? GCWExpandableTextDivider(
              text: i18n(context, 'waveform_output_morsecode'),
              expanded: false,
              suppressTopSpace: false,
              child: Column(
                children: <Widget>[
                  GCWOutputText(text: _decodedMorseCode),
                  GCWOutputText(text: _decodedMorseText),
                ],
              ),
            )
          : GCWOutputText(
              text: _errorText('waveform_error_png_not_created'),
            ),
    ]);
  }

  String _errorText(String text) {
    String result = '';
    if (_parseError) {
      if (_currentError.contains('depth') ||
          _currentError.contains('audioformat')) {
        var errorcode = _currentError.split(':');
        result = i18n(context, errorcode[0]) + errorcode[1];
      } else {
        result = i18n(context, _currentError);
      }
    } else {
      result = i18n(context, text);
    }
    return result;
  }

  Widget _buildOutputWaveFormInfo() {
    List<List<String>> data = [
      [
        i18n(context, 'waveform_output_metadata_size'),
        _bytes.length.toString() + ' Bytes'
      ],
      [
        i18n(context, 'waveform_output_metadata_duration'),
        _audioInfo.duration.toString() + ' ms'
      ],
      [
        i18n(context, 'waveform_output_metadata_samplerate'),
        _audioInfo.sampleRate.toString() + ' Hz'
      ],
      [
        i18n(context, 'waveform_output_metadata_channel'),
        _audioInfo.channels.toString()
      ],
      [
        i18n(context, 'waveform_output_metadata_bitrate'),
        _audioInfo.bitRate.toString() + ' bit/s'
      ],
      [i18n(context, 'waveform_output_metadata_format'), _audioInfo.format],
    ];
    return GCWColumnedMultilineOutput(data: data);
  }

}
