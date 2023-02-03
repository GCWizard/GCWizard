import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart'; // https://pub.dev/packages/audioplayers
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

enum PlayerState { stopped, playing, paused }

class GCWSoundPlayer extends StatefulWidget {
  final GCWFile file;

  const GCWSoundPlayer({Key key, @required this.file}) : super(key: key);

  @override
  _GCWSoundPlayerState createState() => _GCWSoundPlayerState();
}

class _GCWSoundPlayerState extends State<GCWSoundPlayer> {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer;

  StreamSubscription<Duration> _onPositionChangedStream;
  StreamSubscription<Duration> _onDurationChangedStream;
  StreamSubscription _onCompletionStream;

  File _audioFile;
  var _loadedFileBytes;

  var _currentPositionInMS;
  var _totalDurationInMS;

  var _isLoaded = false;

  var _currentSliderPosition = 0.0;

  @override
  void initState() {
    super.initState();

    advancedPlayer = AudioPlayer(playerId: Uuid().v4());

    if (kIsWeb) {
      // Calls to Platform.isIOS fails on web
      return;
    }
    if (Platform.isIOS) {
      //audioCache.fixedPlayer?.notificationService.startHeadlessService();
    }

    _onDurationChangedStream = advancedPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _totalDurationInMS = d.inMilliseconds;
      });
    });

    _onPositionChangedStream = advancedPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _currentPositionInMS = p.inMilliseconds;

        if (_totalDurationInMS == null || _totalDurationInMS == 0.0) {
          _currentSliderPosition = 0.0;
        } else {
          _currentSliderPosition = min(1.0, _currentPositionInMS / _totalDurationInMS);
        }
      });
    });

    _onCompletionStream = advancedPlayer.onPlayerComplete.listen((event) {
      onComplete();
    });
  }

  Future _initAudioFile() async {
    await _audioPlayerStop();

    // save byteData to File
    var byteData = widget.file.bytes;

    if (kIsWeb) {
      // do nothing - web does not support local filö or byte array
    } else {
      _audioFile = await _writeToFile(ByteData.sublistView(byteData)); // <= returns File
    }

    _loadedFileBytes = widget.file.bytes.length;
    _isLoaded = true;

    if (!mounted) // prevents setState when currently disposing widget.
      return;

    setState(() {});
  }

  @override
  Future<void> dispose() async {
    _onPositionChangedStream.cancel();
    _onDurationChangedStream.cancel();
    _onCompletionStream.cancel();

    Future.delayed(Duration.zero, () async {
      await advancedPlayer.stop();
      await _audioFile.delete();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadedFileBytes == null || _loadedFileBytes != widget.file.bytes.length) {
      _currentPositionInMS = null;
      _totalDurationInMS = null;
      _isLoaded = false;
      _initAudioFile();
    }

    return Row(
      children: [
        GCWIconButton(
          icon: isPlaying ? Icons.pause : Icons.play_arrow,
          iconColor: _isLoaded ? null : themeColors().inActive(),
          onPressed: isPlaying ? () => _audioPlayerPause() : () => _audioPlayerPlay(),
        ),
        GCWIconButton(
          icon: Icons.stop,
          iconColor: _isLoaded && !isStopped ? null : themeColors().inActive(),
          onPressed: isPlaying || isPaused ? () => _audioPlayerStop() : null,
        ),
        Expanded(
            child: Slider(
          value: _currentSliderPosition,
          min: 0.0,
          max: 1.0,
          onChangeStart: (value) {
            setState(() {
              _audioPlayerPause();
            });
          },
          onChanged: (value) {
            setState(() {
              _currentSliderPosition = value;
            });
          },
          onChangeEnd: (value) {
            setState(() {
              _audioPlayerPlay(seek: true);
            });
          },
          activeColor: themeColors().switchThumb2(),
          inactiveColor: themeColors().switchTrack2(),
        )),
        GCWText(text: _durationText())
      ],
    );
  }

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;
  get isStopped => playerState == PlayerState.stopped;

  void onComplete() {
    setState(() {
      playerState = PlayerState.stopped;
      _currentSliderPosition = 0.0;
    });
  }

  _audioPlayerPause() async {
    await advancedPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  _audioPlayerPlay({bool seek: false}) async {
    if (kIsWeb) {
      // do nothing - web does not support local filö or byte array
    } else {
      if (playerState == PlayerState.paused) {
        if (seek && _totalDurationInMS != null && _totalDurationInMS > 0) {
          var newPosition = (_totalDurationInMS * _currentSliderPosition).floor();
          await advancedPlayer.seek(Duration(milliseconds: newPosition));
        }

        await advancedPlayer.resume();
      } else {
        await advancedPlayer.play(DeviceFileSource(_audioFile.path));
      }

      setState(() => playerState = PlayerState.playing);
    }
  }

  Future _audioPlayerStop() async {
    await advancedPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      _currentSliderPosition = 0.0;
      _currentPositionInMS = 0.0;
    });
  }

  Future<File> _writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getApplicationDocumentsDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath + '/${advancedPlayer.playerId}.tmp';
    return new File(filePath).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  _durationText() {
    var total = '--:--';
    if (_totalDurationInMS != null && _totalDurationInMS >= 0) {
      var totalInS = (_totalDurationInMS / 1000).floor();

      var min = (totalInS / 60).floor();
      var sec = (totalInS % 60).floor();
      total = min.toString().padLeft(2, '0') + ':' + sec.toString().padLeft(2, '0');
    }

    var position = '--:--';
    if (_currentPositionInMS != null && _currentPositionInMS >= 0) {
      var positionInS = (_currentPositionInMS / 1000).floor();

      var min = (positionInS / 60).floor();
      var sec = (positionInS % 60).floor();
      position = min.toString().padLeft(2, '0') + ':' + sec.toString().padLeft(2, '0');
    }

    return '$position / $total';
  }
}
