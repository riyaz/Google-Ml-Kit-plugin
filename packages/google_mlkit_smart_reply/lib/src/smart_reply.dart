import 'package:flutter/services.dart';

/// A class that suggests smart replies for given input text.
class SmartReply {
  static const MethodChannel _channel =
      MethodChannel('google_mlkit_smart_reply');

  final List<Message> _conversation = [];

  /// The sequence of chat [Message]s to generate a suggestion for.
  List<Message> get conversation => _conversation;

  /// Adds a [Message] to the [conversation] for local user.
  void addMessageToConversationFromLocalUser(
      String message, int timestamp) async {
    _conversation
        .add(Message(text: message, timestamp: timestamp, userId: 'local'));
  }

  /// Adds a [Message] to the [conversation] for a remote user.
  void addMessageToConversationFromRemoteUser(
      String message, int timestamp, String userId) async {
    _conversation
        .add(Message(text: message, timestamp: timestamp, userId: userId));
  }

  /// Clears the [conversation].
  void clearConversation() {
    _conversation.clear();
  }

  /// Suggests possible replies in the context of a chat [conversation].
  Future<SmartReplySuggestionResult> suggestReplies() async {
    if (_conversation.isEmpty) {
      return SmartReplySuggestionResult(
          status: SmartReplySuggestionResultStatus.noReply, suggestions: []);
    }

    final result = await _channel.invokeMethod(
        'nlp#startSmartReply', <String, dynamic>{
      'conversation': _conversation.map((message) => message.toJson()).toList()
    });

    return SmartReplySuggestionResult.fromJson(result);
  }

  /// Closes the underlying resources including models used for reply inference.
  Future<void> close() => _channel.invokeMethod('nlp#closeSmartReply');
}

/// Represents a text message from a certain user in a conversation, providing context for SmartReply to generate reply suggestions.
class Message {
  /// Text of the chat message.
  final String text;

  /// Timestamp of the chat message.
  final int timestamp;

  /// User id of the message sender.
  final String userId;

  /// Constructor to create an instance of [Message].
  Message({required this.text, required this.timestamp, required this.userId});

  Map<String, dynamic> toJson() => {
        'message': text,
        'timestamp': timestamp,
        'userId': userId,
      };
}

/// Specifies the status of the smart reply result.
enum SmartReplySuggestionResultStatus {
  success,
  notSupportedLanguage,
  noReply,
}

/// An object that contains the smart reply suggestion results.
class SmartReplySuggestionResult {
  /// Status of the smart reply suggestions result.
  SmartReplySuggestionResultStatus status;

  /// A list of the suggestions.
  List<String> suggestions;

  /// Constructor to create an instance of [SmartReplySuggestionResult].
  SmartReplySuggestionResult({required this.status, required this.suggestions});

  factory SmartReplySuggestionResult.fromJson(Map<dynamic, dynamic> json) {
    final status =
        SmartReplySuggestionResultStatus.values[json['status'].toInt()];
    final suggestions = <String>[];
    if (status == SmartReplySuggestionResultStatus.success) {
      for (final dynamic line in json['suggestions']) {
        suggestions.add(line);
      }
    }
    return SmartReplySuggestionResult(status: status, suggestions: suggestions);
  }

  Map<String, dynamic> toJson() =>
      {'status': status.name, 'suggestions': suggestions};
}
