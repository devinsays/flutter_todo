import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/utils/exceptions.dart';
import 'package:flutter_todo/utils/todo_response.dart';
import 'package:flutter_todo/models/todo.dart';

class ApiService {

  AuthProvider authProvider;
  String token;

  // The AuthProvider is passed in when this class instantiated.
  // This provides access to the user token required for API calls.
  // It also allows us to log out a user when their token expires.
  ApiService(AuthProvider authProvider) {
    this.authProvider = authProvider;
    this.token = authProvider.token;
  }

  final String api = 'https://laravelreact.com/api/v1/todo';

  /*
  * Validates the response code from an API call.
  * A 401 indicates that the token has expired.
  * A 200 or 201 indicates the API call was successful.
  */
  void validateResponseStatus(int status, int validStatus) {
    if (status == 401) {
      throw new AuthException( "401", "Unauthorized" ); 
    }

    if (status != validStatus) {
      throw new ApiException( status.toString(), "API Error" ); 
    }
  }

  // Returns a list of todos.
  Future<TodoResponse> getTodos(String status, { String url = '' }) async {
    // Defaults to the first page if no url is set.
    if ('' == url) {
      url = "$api?status=$status";
    }

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    validateResponseStatus(response.statusCode, 200);

    Map<String, dynamic> apiResponse = json.decode(response.body);
    List<dynamic> data = apiResponse['data'];

    List<Todo> todos = todoFromJson(json.encode(data));
    String next = apiResponse['links']['next'];

    return TodoResponse(todos, next);
  }

  // Toggles the status of a todo.
  toggleTodoStatus(int id, String status) async {
    final url = 'https://laravelreact.com/api/v1/todo/$id';

    Map<String, String> body = {
      'status': status,
    };

    final response = await http.patch(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: body
    );

    validateResponseStatus(response.statusCode, 200);
  }

  // Adds a new todo.
  addTodo(String text) async {
    Map<String, String> body = {
      'value': text,
    };

    final response = await http.post(
      api,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: body
    );

    validateResponseStatus(response.statusCode, 201);

    // Returns the id of the newly created item.
    Map<String, dynamic> apiResponse = json.decode(response.body);
    int id = apiResponse['id'];
    return id;
  }

}