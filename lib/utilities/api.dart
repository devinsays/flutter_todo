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

/*
 * Returns a list of todos.
 */
 Future<TodoResponse> getTodos(BuildContext context, String status, { String url = '' }) async {
  
  // Defaults to the first page if no url is set.
  if ('' == url) {
    url = 'https://laravelreact.com/api/v1/todo?status=$status';
  }

  String token = await Provider.of<AuthProvider>(context).getToken();

  final response = await http.get(
    url,
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
  );

  if (response.statusCode == 401) {
    await Provider.of<AuthProvider>(context).logOut(true);
    return TodoResponse([], null);
  }

  LinkedHashMap<String, dynamic> apiResponse = json.decode(response.body);
  List<dynamic> data = apiResponse['data'];

  List<Todo> todos = todoFromJson(json.encode(data));
  String next = apiResponse['links']['next'];

  return TodoResponse(todos, next);
}

toggleTodoStatus(context, int id, String status) async {
  final url = 'https://laravelreact.com/api/v1/todo/$id';

  String token = await Provider.of<AuthProvider>(context).getToken();

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
    await Provider.of<AuthProvider>(context).logOut(true);
    return false;
  }

  return true;
}

addTodo(context, String text) async {
  final url = 'https://laravelreact.com/api/v1/todo';

  String token = await Provider.of<AuthProvider>(context).getToken();

  Map<String, String> body = {
    'value': text,
  };

  final response = await http.post(
    url,
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
    body: body
  );

  if (response.statusCode == 401) {
    await Provider.of<AuthProvider>(context).logOut(true);
    return false;
  }

  return true;
}