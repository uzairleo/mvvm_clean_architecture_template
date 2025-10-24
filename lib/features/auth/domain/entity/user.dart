/// This file defines the User class, which represents a user in the Zarpay application.
/// It includes properties for user information and methods for JSON serialization and deserialization.

/// A list of potential story IDs that a user can see.
final List<String> potentialStoryIds = [
  'learn_about',
  'virtual_card',
  'zar-text-logo',
  'frequent_question'
];

/// The User class represents a user in the Zarpay application.
class User {
  String? id;
  String? pincode;
  String? idToken;
  String? phoneNumber;
  String? lastUpdatedAt;
  bool? isContactSynced;
  bool? isXFollowed;
  bool? isFacebookFollowed;
  bool? isInstagramFollowed;
  bool? isDiscordJoined;
  Map<String, bool>? seenStories;

  /// Constructor for the User class.
  ///
  /// Initializes the user properties and sets up the [seenStories] map with default values if not provided.
  ///
  /// [id] The unique identifier of the user.
  /// [pincode] The pincode set by the user.
  /// [idToken] The ID token associated with the user.
  /// [phoneNumber] The user's phone number.
  /// [lastUpdatedAt] The last updated timestamp for the user's data.
  /// [isContactSynced] Whether the user's contacts are synced.
  /// [isXFollowed] Whether the user follows on X.
  /// [isFacebookFollowed] Whether the user follows on Facebook.
  /// [isInstagramFollowed] Whether the user follows on Instagram.
  /// [isDiscordJoined] Whether the user has joined Discord.
  /// [seenStories] A map of story IDs to a boolean indicating if the user has seen them.
  User({
    this.id,
    this.pincode,
    this.idToken,
    this.phoneNumber,
    this.lastUpdatedAt,
    this.isContactSynced,
    this.isXFollowed,
    this.isFacebookFollowed,
    this.isInstagramFollowed,
    this.isDiscordJoined,
    Map<String, bool>? seenStories,
  }) : seenStories =
            seenStories ?? {for (var name in potentialStoryIds) name: false};

  /// Factory constructor to create a User instance from a JSON map.
  ///
  /// [json] The JSON map containing user data.
  /// Returns a User instance.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? "",
      pincode: json['pincode'] ?? "",
      idToken: json['idToken'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      lastUpdatedAt: json['lastUpdatedAt'] ?? "",
      isContactSynced: json['isContactSynced'] ?? false,
      isXFollowed: json['isXFollowed'] ?? false,
      isFacebookFollowed: json['isFacebookFollowed'] ?? false,
      isInstagramFollowed: json['isInstagramFollowed'] ?? false,
      isDiscordJoined: json['isDiscordJoined'] ?? false,
      seenStories: json['seenStories'] != null
          ? (json['seenStories'] as Map<String, dynamic>).cast<String, bool>()
          : {for (var name in potentialStoryIds) name: false},
    );
  }

  /// Converts the User instance to a JSON map.
  ///
  /// Returns a JSON map representing the user data.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pincode'] = pincode ?? "";
    data['idToken'] = idToken ?? "";
    data['phoneNumber'] = phoneNumber ?? "";
    data['lastUpdatedAt'] = lastUpdatedAt ?? "";
    data['isContactSynced'] = isContactSynced ?? false;
    data['isXFollowed'] = isXFollowed ?? false;
    data['isFacebookFollowed'] = isFacebookFollowed ?? false;
    data['isInstagramFollowed'] = isInstagramFollowed ?? false;
    data['isDiscordJoined'] = isDiscordJoined ?? false;
    data['seenStories'] = seenStories;
    return data;
  }

  /// Equality operator to compare two User instances.
  ///
  /// [other] The other User instance to compare with.
  /// Returns true if the phone numbers of both users are equal, false otherwise.
  @override
  bool operator ==(other) {
    if (other is! User) return false;
    return phoneNumber == other.phoneNumber;
  }

  /// Generates a hash code for the User instance.
  ///
  /// Returns the hash code based on the user's phone number.
  @override
  int get hashCode => phoneNumber.hashCode;
}
