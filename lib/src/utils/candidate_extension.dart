import 'package:flutter_gemini/src/models/candidates/candidates.dart';

/// [CandidateExtension] used when wanna get [output] simply
extension CandidateExtension on Candidates {
  String? get output => content?.parts?.lastOrNull?.text;
}
