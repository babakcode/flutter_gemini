import 'package:flutter_gemini/src/models/candidates/candidates.dart';
import 'package:flutter_gemini/src/models/part/part.dart';

/// [CandidateExtension] used when wanna get [output] simply
/// Extension for the `Candidates` class that provides convenient getters
/// to access the last part of the `content` in different formats (text, file, or generic part).
/// This extension is useful for extracting the relevant output from the `Candidates`
/// object based on the response type (text, file, or other parts).
extension CandidateExtension on Candidates {
  /// Retrieves the last `TextPart` from the content and returns the `text` property.
  /// This is useful for getting the AI-generated text response from the `Candidates` object.
  ///
  /// **Returns:**
  /// - `String?`: The text of the last part if it is a `TextPart`, or `null` if not found.
  String? get output => (content?.parts?.lastOrNull as TextPart?)?.text;

  /// Retrieves the last `FilePart` from the content and returns its `fileData`.
  /// This is useful for handling file responses (such as images or documents) from the AI.
  ///
  /// **Returns:**
  /// - `FileDataPart?`: The `FileDataPart` object containing the file data, or `null` if not found.
  FileDataPart? get outputFile =>
      (content?.parts?.lastOrNull as FilePart?)?.fileData;

  /// Retrieves the last `Part` from the content, regardless of its type (text, file, etc.).
  /// This provides a more generic access to the last part of the response.
  ///
  /// **Returns:**
  /// - `Part?`: The last `Part` object, or `null` if not found.
  Part? get outputPart => content?.parts?.lastOrNull;
}
