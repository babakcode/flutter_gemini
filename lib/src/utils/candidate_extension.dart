import 'package:flutter_gemini/src/models/candidates/candidates.dart';
import 'package:flutter_gemini/src/models/part/part.dart';

/// [CandidateExtension] used when wanna get [output] simply
extension CandidateExtension on Candidates {
  String? get output => (content?.parts?.lastOrNull as TextPart?)?.text;

  FileDataPart? get outputFile => (content?.parts?.lastOrNull as FilePart?)?.fileData;

  Part? get outputPart => content?.parts?.lastOrNull;
}
