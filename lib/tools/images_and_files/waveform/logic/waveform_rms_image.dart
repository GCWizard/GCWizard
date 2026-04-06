import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';

enum PARSE_STATUS { OK, ERROR }

class WaveformAndMorseResult {
  final Uint8List pngBytes;
  final int width;
  final int height;

  final String bits;
  final String morse;
  final String text;

  final PARSE_STATUS status;
  final String error;

  WaveformAndMorseResult({
    required this.pngBytes,
    required this.width,
    required this.height,
    required this.bits,
    required this.morse,
    required this.text,
    required this.status,
    required this.error,
  });
}

class WavData {
  final int sampleRate;
  final int numChannels;
  final List<List<double>> channels; // channels[c][i] in [-1, 1]
  final PARSE_STATUS status;
  final String error;

  WavData({
    required this.sampleRate,
    required this.numChannels,
    required this.channels,
    required this.status,
    required this.error,
  });

  int get length => channels.isEmpty ? 0 : channels[0].length;
}

class _SampleResult {
  final double sample;
  final PARSE_STATUS status;
  final String error;

  _SampleResult({
    required this.sample,
    required this.status,
    required this.error,
  });
}

// Parser to handle simple PCM/Float-WAV-Files
class WavParser {
  static Future<WavData> parse(Uint8List bytes) async {
    final bd = ByteData.sublistView(bytes);

    // simple RIFF/WAVE-Check
    if (bytes.length < 44) {
      return WavData(
        sampleRate: 0,
        numChannels: 0,
        channels: [],
        status: PARSE_STATUS.ERROR,
        error: 'waveform_error_parse_file_to_short',
      );
      // throw FormatException('File to short');
    }

    // if (String.fromCharCodes(bytes.sublist(0, 3)) == 'ID3') {
    //   int size = ByteData.sublistView(bytes).getInt32(6, Endian.big);
    // }

    // if (String.fromCharCodes(bytes.sublist(0, 4)) == 'OggS') {
    //   int size = ByteData.sublistView(bytes).getInt32(6, Endian.big);
    //   print(size);
    //   print('size      '+String.fromCharCodes(bytes.sublist(size, 3)));
    //   print('size + 10 '+String.fromCharCodes(bytes.sublist(size + 10, 3)));
    // }

    if (String.fromCharCodes(bytes.sublist(0, 4)) != 'RIFF') {
      return WavData(
        sampleRate: 0,
        numChannels: 0,
        channels: [],
        status: PARSE_STATUS.ERROR,
        error: 'waveform_error_parse_missing_riff_header',
      );
      // throw FormatException('Missing RIFF-Header');
    }
    if (String.fromCharCodes(bytes.sublist(8, 12)) != 'WAVE') {
      return WavData(
        sampleRate: 0,
        numChannels: 0,
        channels: [],
        status: PARSE_STATUS.ERROR,
        error: 'waveform_error_parse_missing_wav_header',
      );
      // throw FormatException('Missing WAVE-Header');
    }

    int offset = 12;
    int? audioFormat;
    int? numChannels;
    int? sampleRate;
    int? bitsPerSample;
    int? dataOffset;
    int? dataSize;

    // analyzing Chunks
    while (offset + 8 <= bytes.length) {
      final chunkId = String.fromCharCodes(bytes.sublist(offset, offset + 4));
      final chunkSize = bd.getUint32(offset + 4, Endian.little);
      final chunkDataStart = offset + 8;

      if (chunkId == 'fmt ') {
        audioFormat = bd.getUint16(chunkDataStart + 0, Endian.little);
        numChannels = bd.getUint16(chunkDataStart + 2, Endian.little);
        sampleRate = bd.getUint32(chunkDataStart + 4, Endian.little);
        // byteRate = bd.getUint32(chunkDataStart + 8, Endian.little);
        // blockAlign = bd.getUint16(chunkDataStart + 12, Endian.little);
        bitsPerSample = bd.getUint16(chunkDataStart + 14, Endian.little);
      } else if (chunkId == 'data') {
        dataOffset = chunkDataStart;
        dataSize = chunkSize;
      }

      offset = chunkDataStart + chunkSize;
      if (offset.isOdd) offset++; // Padding
      if (offset >= bytes.length) break;
    }

    if (audioFormat == null ||
        numChannels == null ||
        sampleRate == null ||
        bitsPerSample == null ||
        dataOffset == null ||
        dataSize == null) {
      return WavData(
        sampleRate: 0,
        numChannels: 0,
        channels: [],
        status: PARSE_STATUS.ERROR,
        error: 'waveform_error_parse_malformed_wav_header',
      );
      // throw FormatException('Malformed WAV-Header');
    }

    if (!(audioFormat == 1 || audioFormat == 3)) {
      return WavData(
        sampleRate: 0,
        numChannels: 0,
        channels: [],
        status: PARSE_STATUS.ERROR,
        error: 'waveform_error_parse_unsupported_format',
      );
      // throw FormatException('Unsupported Format - only PCM (1) or IEEE Float (3) are supported');
    }

    final bytesPerSample = bitsPerSample ~/ 8;
    final frameSize = bytesPerSample * numChannels;
    final totalFrames = dataSize ~/ frameSize;

    final channels = List.generate(
      numChannels,
      (_) => List<double>.filled(totalFrames, 0.0, growable: false),
    );

    int pos = dataOffset;
    for (int i = 0; i < totalFrames; i++) {
      for (int ch = 0; ch < numChannels; ch++) {
        final sample = _readSample(
          bd,
          pos,
          bitsPerSample,
          audioFormat,
        );
        if (sample.status == PARSE_STATUS.ERROR) {
          return WavData(
            sampleRate: 0,
            numChannels: 0,
            channels: [],
            status: PARSE_STATUS.ERROR,
            error: sample.error,
          );
        }
        channels[ch][i] = sample.sample;
        pos += bytesPerSample;
      }
    }

    return WavData(
      sampleRate: sampleRate,
      numChannels: numChannels,
      channels: channels,
      status: PARSE_STATUS.OK,
      error: '',
    );
  }

  static _SampleResult _readSample(
    ByteData bd,
    int offset,
    int bitsPerSample,
    int audioFormat,
  ) {
    // PCM
    if (audioFormat == 1) {
      switch (bitsPerSample) {
        case 8:
          final v = bd.getUint8(offset);
          return _SampleResult(
            sample: (v - 128) / 128.0,
            status: PARSE_STATUS.OK,
            error: '',
          );
        case 16:
          final v = bd.getInt16(offset, Endian.little);
          return _SampleResult(
            sample: v / 32768.0,
            status: PARSE_STATUS.OK,
            error: '',
          );
        case 24:
          // 24-bit little endian, sign-extend auf 32-bit
          final b0 = bd.getUint8(offset);
          final b1 = bd.getUint8(offset + 1);
          final b2 = bd.getUint8(offset + 2);
          int v = (b2 << 16) | (b1 << 8) | b0;
          if (v & 0x800000 != 0) {
            v |= 0xFF000000;
          }
          return _SampleResult(
            sample: v / 8388608.0, // 2^23
            status: PARSE_STATUS.OK,
            error: '',
          );
        case 32:
          final v = bd.getInt32(offset, Endian.little);
          return _SampleResult(
            sample: v / 2147483648.0, // 2^31
            status: PARSE_STATUS.OK,
            error: '',
          );
        default:
          return _SampleResult(
              sample: 0.0,
              status: PARSE_STATUS.ERROR,
              error: 'waveform_error_parse_unsupported_pcm_bit_depth' +
                  ':' +
                  bitsPerSample.toString());
        // throw FormatException('waveform_error_unsupported_pcm_bit_depth: $bitsPerSample');
      }
    }

    // IEEE Float
    if (audioFormat == 3) {
      if (bitsPerSample == 32) {
        final v = bd.getFloat32(offset, Endian.little);
        return _SampleResult(
          sample: v.clamp(-1.0, 1.0),
          status: PARSE_STATUS.OK,
          error: '',
        );
      } else {
        return _SampleResult(
            sample: 0.0,
            status: PARSE_STATUS.ERROR,
            error: 'waveform_error_parse_unsupported_float_bit_depth' +
                ':' +
                bitsPerSample.toString());
        // throw FormatException('waveform_error_unsupported_float_bit_depth: $bitsPerSample');
      }
    }
    return _SampleResult(
        sample: 0.0,
        status: PARSE_STATUS.ERROR,
        error: 'waveform_error_parse_unsupported_audioformat' +
            ':' +
            audioFormat.toString());
    // throw FormatException('waveform_error_unsupported_audioformat: $audioFormat');
  }
}

// Painter to draw waveform
// - Multichannel: channels are stacked vertically
// - per channel: centerline
class WavWaveformPainter extends CustomPainter {
  final WavData data;
  final Color backgroundColor;
  final Color waveformColor;
  final double strokeWidth;

  WavWaveformPainter({
    required this.data,
    required this.backgroundColor,
    required this.waveformColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintBg = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, paintBg);

    if (data.length == 0 || data.numChannels == 0) return;

    final numChannels = data.numChannels;
    final channelHeight = size.height / numChannels;

    final paintWave = Paint()
      ..color = waveformColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    for (int ch = 0; ch < numChannels; ch++) {
      _drawChannel(canvas, size, ch, channelHeight, paintWave);
    }
  }

  void _drawChannel(
    Canvas canvas,
    Size size,
    int channelIndex,
    double channelHeight,
    Paint paintWave,
  ) {
    final samples = data.channels[channelIndex];
    final totalSamples = samples.length;

    if (totalSamples == 0) return;

    final top = channelIndex * channelHeight;
    final midY = top + channelHeight / 2;

    // Centerline
    final zeroPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawLine(
      Offset(0, midY),
      Offset(size.width, midY),
      zeroPaint,
    );

    // Downsampling: for every pixel a Min/Max-Aggregation
    final width = size.width;
    if (width <= 0) return;

    final samplesPerPixel = math.max(1, (totalSamples / width).floor());
    final path = Path();

    for (int x = 0; x < width; x++) {
      final start = x * samplesPerPixel;
      if (start >= totalSamples) break;
      final end = math.min(start + samplesPerPixel, totalSamples);

      double minVal = 1.0;
      double maxVal = -1.0;
      for (int i = start; i < end; i++) {
        final v = samples[i];
        if (v < minVal) minVal = v;
        if (v > maxVal) maxVal = v;
      }

      final xPos = x.toDouble();
      final yMin = midY - minVal * (channelHeight / 2);
      final yMax = midY - maxVal * (channelHeight / 2);

      path.moveTo(xPos, yMin);
      path.lineTo(xPos, yMax);
    }

    canvas.drawPath(path, paintWave);
  }

  @override
  bool shouldRepaint(covariant WavWaveformPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.waveformColor != waveformColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class MorseAnalysisResult {
  final String bits; // z.B. "111000111000000..."
  final String morse; // z.B. "... --- ..."
  final String text; // z.B. "SOS"

  MorseAnalysisResult({
    required this.bits,
    required this.morse,
    required this.text,
  });
}

// ------------------------------------------------------------
// PARAMETER-KLASSE (für GCWizard-UI einstellbar)
// ------------------------------------------------------------
enum MorseUnitMode {
  threshold,   // klassische Methode
  tolerant,    // deine bisherige tolerante Variante
  cluster      // neue automatische Clustering-Variante
}

Map<int, MorseUnitMode> morseUnitModeMap = {
  0: MorseUnitMode.threshold,
  1: MorseUnitMode.tolerant,
  2: MorseUnitMode.cluster
};

class MorseParams {
  final int smoothingWindow;
  final double thresholdFactor;
  final int minRunLength;
  final double unitTolerance;
  final MorseUnitMode mode;

  const MorseParams({
    this.smoothingWindow = 5,
    this.thresholdFactor = 4.0,
    this.minRunLength = 3,
    this.unitTolerance = 0.40,
    this.mode = MorseUnitMode.tolerant,
  });
}


const Map<String, String> _morseMap = {
  '.-': 'A',
  '-...': 'B',
  '-.-.': 'C',
  '-..': 'D',
  '.': 'E',
  '..-.': 'F',
  '--.': 'G',
  '....': 'H',
  '..': 'I',
  '.---': 'J',
  '-.-': 'K',
  '.-..': 'L',
  '--': 'M',
  '-.': 'N',
  '---': 'O',
  '.--.': 'P',
  '--.-': 'Q',
  '.-.': 'R',
  '...': 'S',
  '-': 'T',
  '..-': 'U',
  '...-': 'V',
  '.--': 'W',
  '-..-': 'X',
  '-.--': 'Y',
  '--..': 'Z',
  '-----': '0',
  '.----': '1',
  '..---': '2',
  '...--': '3',
  '....-': '4',
  '.....': '5',
  '-....': '6',
  '--...': '7',
  '---..': '8',
  '----.': '9',
};

// ------------------------------------------------------------
// PCM → MONO
// ------------------------------------------------------------
List<double> _toMono(WavData wav) {
  if (wav.channels.isEmpty) return const [];
  if (wav.channels.length == 1) return wav.channels[0];

  final mono = List<double>.filled(wav.channels[0].length, 0.0);
  for (int i = 0; i < mono.length; i++) {
    double sum = 0;
    for (int c = 0; c < wav.channels.length; c++) {
      sum += wav.channels[c][i];
    }
    mono[i] = sum / wav.channels.length;
  }
  return mono;
}

// ------------------------------------------------------------
// smoothen amplitudes
// ------------------------------------------------------------
List<double> _smoothEnvelope(List<double> env, int window) {
  if (env.isEmpty || window <= 1) return env;
  final out = List<double>.filled(env.length, 0.0);
  final half = window ~/ 2;

  for (int i = 0; i < env.length; i++) {
    double sum = 0;
    int count = 0;
    for (int j = i - half; j <= i + half; j++) {
      if (j < 0 || j >= env.length) continue;
      sum += env[j];
      count++;
    }
    out[i] = sum / count;
  }
  return out;
}

// ------------------------------------------------------------
// estimate thresholds using parameter
// ------------------------------------------------------------
double _estimateThreshold(List<double> env, MorseParams p) {
  if (env.isEmpty) return 0.1;
  final sorted = [...env]..sort();
  final median = sorted[sorted.length ~/ 2];
  return (median * p.thresholdFactor).clamp(0.02, 0.5);
}

// ------------------------------------------------------------
// get RUNS (0/1-Segments)
// ------------------------------------------------------------
class _Run {
  final int value; // 0 oder 1
  final int length;
  const _Run(this.value, this.length);
}

List<_Run> _compressRuns(List<int> bits) {
  if (bits.isEmpty) return [];
  final runs = <_Run>[];
  int current = bits[0];
  int len = 1;

  for (int i = 1; i < bits.length; i++) {
    if (bits[i] == current) {
      len++;
    } else {
      runs.add(_Run(current, len));
      current = bits[i];
      len = 1;
    }
  }
  runs.add(_Run(current, len));
  return runs;
}

// ------------------------------------------------------------
// cleaning runs (using parameter)
// ------------------------------------------------------------
List<_Run> _compressRunsClean(List<int> bits, MorseParams p) {
  final raw = _compressRuns(bits);
  final cleaned = <_Run>[];

  for (final r in raw) {
    if (r.length < p.minRunLength) continue;

    if (cleaned.isNotEmpty &&
        cleaned.last.value == r.value &&
        cleaned.last.length < p.minRunLength) {
      final last = cleaned.removeLast();
      cleaned.add(_Run(r.value, last.length + r.length));
    } else {
      cleaned.add(r);
    }
  }
  return cleaned;
}

// ------------------------------------------------------------
// estimate units (Dot-length)
// ------------------------------------------------------------
class _Units {
  final double dot;
  final double dash;
  const _Units(this.dot, this.dash);
}

double _median(List<int> xs) {
  if (xs.isEmpty) return 1.0;
  xs.sort();
  return xs[xs.length ~/ 2].toDouble().clamp(1.0, double.infinity);
}

_Units _estimateUnitsCluster(List<_Run> runs) {
  final on = <int>[];
  final off = <int>[];

  for (final r in runs) {
    if (r.value == 1) {
      on.add(r.length);
    } else {
      off.add(r.length);
    }
  }

  final onCenters = _kMeans1D(on, 2);   // dot, dash
  // final offCenters = _kMeans1D(off, 3); // intra, letter, word

  return _Units(
    onCenters[0],          // dot
    onCenters[1],          // dash
  );
}

_Units _estimateUnits(List<_Run> runs) {
  final on = <int>[];
  for (final r in runs) {
    if (r.value == 1) on.add(r.length);
  }
  final dot = _median(on);
  return _Units(dot, dot * 3);
}

// ------------------------------------------------------------
// classification of tolerance
// ------------------------------------------------------------
bool _isDot(int len, double dot, MorseParams p) =>
    len >= dot * (1 - p.unitTolerance) && len <= dot * (1 + p.unitTolerance);

bool _isDash(int len, double dot, MorseParams p) =>
    len >= dot * (3 - 3 * p.unitTolerance) &&
    len <= dot * (3 + 3 * p.unitTolerance);

String _classifyPause(int len, double dot, MorseParams p) {
  if (len < dot * (2 + 2 * p.unitTolerance)) return ""; // intra-symbol
  if (len < dot * (5 + 5 * p.unitTolerance)) return " "; // letter
  return " | "; // word
}

List<double> _kMeans1D(List<int> values, int k, {int iterations = 20}) {
  if (values.isEmpty) return List.filled(k, 1.0);

  final data = values.map((e) => e.toDouble()).toList()..sort();

  // Initial centers: pick evenly spaced values
  final centers = List<double>.generate(k, (i) {
    int idx = ((i + 1) * data.length / (k + 1)).floor();
    return data[idx.clamp(0, data.length - 1)];
  });

  for (int iter = 0; iter < iterations; iter++) {
    final clusters = List.generate(k, (_) => <double>[]);

    for (final v in data) {
      int best = 0;
      double bestDist = (v - centers[0]).abs();
      for (int i = 1; i < k; i++) {
        final d = (v - centers[i]).abs();
        if (d < bestDist) {
          bestDist = d;
          best = i;
        }
      }
      clusters[best].add(v);
    }

    for (int i = 0; i < k; i++) {
      if (clusters[i].isNotEmpty) {
        centers[i] = clusters[i].reduce((a, b) => a + b) / clusters[i].length;
      }
    }
  }

  centers.sort();
  return centers;
}

// ------------------------------------------------------------
// RUNS → MORSE
// ------------------------------------------------------------
String _runsToMorse(List<_Run> runs, _Units u, MorseParams p) {
  final out = StringBuffer();
  bool lastWasOn = false;

  for (final r in runs) {
    if (r.value == 1) {
      if (_isDot(r.length, u.dot, p)) {
        out.write('.');
      } else if (_isDash(r.length, u.dot, p)) {
        out.write('-');
      }
      lastWasOn = true;
    } else {
      if (!lastWasOn) continue;
      out.write(_classifyPause(r.length, u.dot, p));
      lastWasOn = false;
    }
  }
  return out.toString().trim();
}

// ------------------------------------------------------------
// MORSE → TEXT
// ------------------------------------------------------------
String _decodeMorse(String morse) {
  if (morse.isEmpty) return "";
  final words = morse.split(" | ");
  final out = StringBuffer();

  for (int w = 0; w < words.length; w++) {
    final letters = words[w].split(" ");
    for (final l in letters) {
      if (l.isEmpty) continue;
      out.write(_morseMap[l] ?? "?");
    }
    if (w < words.length - 1) out.write(" ");
  }
  return out.toString();
}

// ------------------------------------------------------------
// Main: PCM → MORSE → TEXT
// ------------------------------------------------------------
Future<MorseAnalysisResult> analyzeMorseFromWavBytes(
  Uint8List bytes, {
  MorseParams params = const MorseParams()
}) async {
  final wav = await WavParser.parse(bytes);
  final mono = _toMono(wav);

  final env = mono.map((x) => x.abs()).toList();
  final smooth = _smoothEnvelope(env, params.smoothingWindow);

  final threshold = _estimateThreshold(smooth, params);
  final bits = smooth.map((v) => v > threshold ? 1 : 0).toList();

  final runs = _compressRunsClean(bits, params);
  final units = switch (params.mode) {
    MorseUnitMode.threshold => _estimateUnits(runs),
    MorseUnitMode.tolerant  => _estimateUnits(runs),
    MorseUnitMode.cluster   => _estimateUnitsCluster(runs),
  };


  final morse = _runsToMorse(runs, units, params);
  final text = _decodeMorse(morse);

  return MorseAnalysisResult(
    bits: bits.join(),
    morse: morse,
    text: text,
  );
}

Future<WaveformAndMorseResult> renderAndAnalyzeWav({
  required Uint8List wavBytes,
  required double height,
  int? maxWidth,
  int minWidth = 300,
  Color backgroundColor = Colors.black,
  Color waveformColor = Colors.orange,
  double strokeWidth = 1.0,
  MorseParams params = const MorseParams(
    smoothingWindow: 5,
    thresholdFactor: 4.0,
    minRunLength: 3,
    unitTolerance: 0.40,
  ),
}) async {
  final wavData = await WavParser.parse(wavBytes);

  if (wavData.status == PARSE_STATUS.ERROR) {
    return WaveformAndMorseResult(
      // rgbaBytes: rgbaBytes,
      pngBytes: Uint8List.fromList([]),
      width: 0,
      height: 0,
      bits: '',
      morse: '',
      text: '',
      status: PARSE_STATUS.ERROR,
      error: wavData.error,
    );
  }

  const int webMaxTextureSize = 8192; // WebGL Limit

  final totalSamples = wavData.length;

  // Downsampling-Faktor
  // double samplesPerPixel = 1.0;
  //
  // if (totalSamples > webMaxTextureSize) {
  //   samplesPerPixel = totalSamples / webMaxTextureSize;
  // }

  int width = math.min(totalSamples, webMaxTextureSize);

  if (width < minWidth) width = minWidth;

  final recorder = ui.PictureRecorder();
  final canvas =
      Canvas(recorder, Rect.fromLTWH(0, 0, width.toDouble(), height));

  final painter = WavWaveformPainter(
    data: wavData,
    backgroundColor: backgroundColor,
    waveformColor: waveformColor,
    strokeWidth: strokeWidth,
  );

  painter.paint(canvas, Size(width.toDouble(), height));

  final picture = recorder.endRecording();
  final uiImage = await picture.toImage(width, height.toInt());

  final pngData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
  if (pngData == null) {
    return WaveformAndMorseResult(
      pngBytes: Uint8List.fromList([]),
      width: 0,
      height: 0,
      bits: '',
      morse: '',
      text: '',
      status: PARSE_STATUS.ERROR,
      error: 'waveform_error_png_not_created',
    );
  }
  final pngBytes = pngData.buffer.asUint8List();

  final morse = await analyzeMorseFromWavBytes(wavBytes, params: params);

  return WaveformAndMorseResult(
    // rgbaBytes: rgbaBytes,
    pngBytes: pngBytes,
    width: width,
    height: height.toInt(),
    bits: morse.bits,
    morse: morse.morse,
    text: morse.text,
    status: PARSE_STATUS.OK,
    error: '',
  );
}
