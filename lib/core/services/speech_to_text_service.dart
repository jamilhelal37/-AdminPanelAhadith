import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  final SpeechToText _speech = SpeechToText();

  bool get isListening => _speech.isListening;

  Future<bool> initialize({
    required void Function(String status) onStatus,
    required void Function(String message) onError,
  }) {
    return _speech.initialize(
      onStatus: onStatus,
      onError: (SpeechRecognitionError error) {
        onError(error.errorMsg);
      },
      debugLogging: false,
    );
  }

  Future<void> startListening({
    required void Function(String recognizedWords, bool isFinal) onResult,
    String localeId = 'ar_SA',
  }) {
    return _speech.listen(
      localeId: localeId,
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      ),
      onResult: (SpeechRecognitionResult result) {
        onResult(result.recognizedWords, result.finalResult);
      },
    );
  }

  Future<void> stop() => _speech.stop();

  Future<void> cancel() => _speech.cancel();
}
