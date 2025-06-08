import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodlytics/features/chatbot/domain/models/conversation.dart';
import 'package:foodlytics/features/chatbot/domain/models/message.dart';

class ChatbotService {
  final Dio _dio = Dio();
  static const String _baseUrl =
      'https://foodlytics-backend-1.onrender.com/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Send a message to the chatbot
  Future<ChatbotResponse> sendMessage({
    required String message,
    String? conversationId,
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Unauthorized: Please login');
    }

    try {
      final response = await _dio.post(
        '$_baseUrl/chatbot/message',
        data: {
          'message': message,
          if (conversationId != null) 'conversationId': conversationId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ChatbotResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to send message');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Please login');
      } else if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['message'] ?? 'Bad request');
      }
      throw Exception('Failed to send message: ${e.message}');
    } catch (e) {
      debugPrint('Error sending message: $e');
      throw Exception('Failed to send message');
    }
  }

  /// Get all conversations for the current user
  Future<List<Conversation>> getConversations() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Unauthorized: Please login');
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/chatbot/conversations',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Conversation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load conversations');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Please login');
      }
      throw Exception('Failed to load conversations: ${e.message}');
    } catch (e) {
      debugPrint('Error loading conversations: $e');
      throw Exception('Failed to load conversations');
    }
  }

  /// Get a specific conversation with all messages
  Future<ConversationDetail> getConversation(String conversationId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Unauthorized: Please login');
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/chatbot/conversations/$conversationId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ConversationDetail.fromJson(response.data);
      } else {
        throw Exception('Failed to load conversation');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Please login');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Conversation not found');
      }
      throw Exception('Failed to load conversation: ${e.message}');
    } catch (e) {
      debugPrint('Error loading conversation: $e');
      throw Exception('Failed to load conversation');
    }
  }

  /// Delete a conversation
  Future<void> deleteConversation(String conversationId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Unauthorized: Please login');
    }

    try {
      final response = await _dio.delete(
        '$_baseUrl/chatbot/conversations/$conversationId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete conversation');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Please login');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Conversation not found');
      }
      throw Exception('Failed to delete conversation: ${e.message}');
    } catch (e) {
      debugPrint('Error deleting conversation: $e');
      throw Exception('Failed to delete conversation');
    }
  }
}

/// Response from sending a message
class ChatbotResponse {
  final String message;
  final String conversationId;
  final Map<String, dynamic>? usage;

  ChatbotResponse({
    required this.message,
    required this.conversationId,
    this.usage,
  });

  factory ChatbotResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotResponse(
      message: json['message'],
      conversationId: json['conversationId'],
      usage: json['usage'],
    );
  }
} 