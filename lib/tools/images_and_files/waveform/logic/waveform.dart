import 'dart:typed_data';
import 'package:audio_decoder/audio_decoder.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';

part 'package:gc_wizard/tools/images_and_files/waveform/logic/waveform_classes.dart';


Future<AudioInfo> _wavAudioInfo(Uint8List bytes) async {
  final info = await AudioDecoder.getAudioInfoBytes(bytes, formatHint: 'wav');
  return AudioInfo(
      duration: info.duration,
      sampleRate: info.sampleRate,
      channels: info.channels,
      bitRate: info.bitRate,
      format: info.format,
      bytes: bytes,
      status: AUDIO_INFO_STATUS.OK,
      error: '');
}


Future<AudioInfo> _bytesAudioInfo(Uint8List bytes, String format) async {

  final Uint8List pcmBytes = await AudioDecoder.convertToWavBytes(
    bytes,
    formatHint: format,
    includeHeader: true,
  );

  final info = await AudioDecoder.getAudioInfoBytes(bytes, formatHint: format);
  return AudioInfo(
      duration: info.duration,
      sampleRate: info.sampleRate,
      channels: info.channels,
      bitRate: info.bitRate,
      format: info.format,
      bytes: pcmBytes,
      status: AUDIO_INFO_STATUS.OK,
      error: '');
}

Future<AudioInfo> getSoundfileAudioInfo(Uint8List bytes) async {
  switch (getFileType(bytes)) {
    case FileType.WAV:
    case FileType.WMV:
      return _wavAudioInfo(bytes);
    case FileType.MP3:
      return _bytesAudioInfo(bytes, 'mp3');
    case FileType.OGG:
      return _bytesAudioInfo(bytes, 'ogg');
    default:
      return AudioInfo(
          duration: Duration(milliseconds: 0),
          sampleRate: 0,
          channels: 0,
          bitRate: 0,
          format: '',
          bytes: Uint8List.fromList([]),
          status: AUDIO_INFO_STATUS.ERROR,
          error: 'waveform_error_unsupported_audioformat'
      );
  }
}