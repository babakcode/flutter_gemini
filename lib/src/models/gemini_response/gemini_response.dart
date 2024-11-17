import '../candidates/candidates.dart';
import '../prompt_feedback/prompt_feedback.dart';

class GeminiResponse {
  List<Candidates>? candidates;
  PromptFeedback? promptFeedback;

  GeminiResponse({
    this.candidates,
    this.promptFeedback,
  });

  factory GeminiResponse.fromJson(Map<String, dynamic> json) => GeminiResponse(
        candidates: (json['candidates'] as List<dynamic>?)
            ?.map((e) => Candidates.fromJson(e as Map<String, dynamic>))
            .toList(),
        promptFeedback: json['promptFeedback'] == null
            ? null
            : PromptFeedback.fromJson(
                json['promptFeedback'] as Map<String, dynamic>,
              ),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'candidates': candidates,
        'promptFeedback': promptFeedback,
      };

  static List<GeminiResponse> jsonToList(List list) => list
      .map((e) => GeminiResponse.fromJson(e as Map<String, dynamic>))
      .toList();
}
