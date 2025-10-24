/// Model class for an onboarding carousel item.
///
/// This class represents the data structure for an item in the onboarding carousel,
/// including an optional ID, title, description, and image URL.

class OnboardingCarousel {
  /// The ID of the onboarding carousel item.
  String? id;

  /// The title of the onboarding carousel item.
  String? title;

  /// The description of the onboarding carousel item.
  String? description;

  /// The image URL of the onboarding carousel item.
  String? imgUrl;

  /// Constructor for creating an instance of OnboardingCarousel.
  ///
  /// [id] is the optional identifier of the carousel item.
  /// [title] is the optional title of the carousel item.
  /// [description] is the optional description of the carousel item.
  /// [imgUrl] is the optional image URL of the carousel item.
  OnboardingCarousel({this.id, this.title, this.description, this.imgUrl});

  /// Creates an instance of OnboardingCarousel from a JSON object.
  ///
  /// [json] is a Map representing the JSON object.
  OnboardingCarousel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    imgUrl = json['imgUrl'];
  }

  /// Converts the OnboardingCarousel instance to a JSON object.
  ///
  /// Returns a Map representing the JSON object.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['imgUrl'] = imgUrl;
    return data;
  }
}
