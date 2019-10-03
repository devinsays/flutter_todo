import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:collection';
import 'package:provider/provider.dart';

import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/widgets/todo_response.dart';

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
  * Returns a list of todos.
  */
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

    if (response.statusCode == 401) {
      await authProvider.logOut(true);
      return TodoResponse([], null);
    }

    Map<String, dynamic> apiResponse = json.decode(response.body);
    List<dynamic> data = apiResponse['data'];

    List<Todo> todos = todoFromJson(json.encode(data));
    String next = apiResponse['links']['next'];

    return TodoResponse(todos, next);
  }

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

    if (response.statusCode == 401) {
      await authProvider.logOut(true);
      return false;
    }

    return true;
  }

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

    if (response.statusCode == 401) {
      await authProvider.logOut(true);
      return false;
    }

    return true;
  }

}