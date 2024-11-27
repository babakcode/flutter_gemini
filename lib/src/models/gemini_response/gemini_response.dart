import '../candidates/candidates.dart';
import '../prompt_feedback/prompt_feedback.dart';

class GeminiResponse {
  List<Candidates>? candidates; // List of candidates, possibly empty or null
  PromptFeedback? promptFeedback; // Optional feedback related to the prompt

  // Constructor for GeminiResponse
  GeminiResponse({
    this.candidates,
    this.promptFeedback,
  });

  // Factory constructor to create a GeminiResponse object from a JSON map
  factory GeminiResponse.fromJson(Map<String, dynamic> json) => GeminiResponse(
        candidates: (json['candidates'] as List<dynamic>?)
            ?.map((e) => Candidates.fromJson(e as Map<String, dynamic>))
            .toList(), // Converts the candidates list from JSON to Candidate objects
        promptFeedback: json['promptFeedback'] == null
            ? null
            : PromptFeedback.fromJson(json['promptFeedback'] as Map<String,
                dynamic>), // Converts prompt feedback if it exists
      );

  // Method to convert a GeminiResponse object back to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'candidates': candidates, // Serializes candidates list to JSON
        'promptFeedback': promptFeedback, // Serializes prompt feedback to JSON
      };

  // Static method to convert a list of JSON objects to a list of GeminiResponse objects
  static List<GeminiResponse> jsonToList(List list) => list
      .map((e) => GeminiResponse.fromJson(e as Map<String, dynamic>))
      .toList();
}
