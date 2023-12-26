import 'gemini_safety_category.dart';
import 'gemini_safety_threshold.dart';

/// [SafetySetting]
///Safety Settings
/// Safety settings are part of the request you send to the text service.
/// It can be adjusted for each request you make to the API.
/// The following table lists the categories that you can set and describes the type of harm that each category encompasses.
class SafetySetting {
  final SafetyCategory category;
  final SafetyThreshold threshold;

  SafetySetting({
    required this.category,
    required this.threshold,
  });
}
