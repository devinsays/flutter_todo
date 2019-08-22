import 'dart:convert';


List<Todo> todoFromJson(String str) => new List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

String todoToJson(List<Todo> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class Todo {
    DateTime createdAt;
    DateTime updatedAt;
    int id;
    String user;
    String value;
    String status;

    Todo({
        this.createdAt,
        this.updatedAt,
        this.id,
        this.user,
        this.value,
        this.status,
    });

    factory Todo.fromJson(Map<String, dynamic> json) => new Todo(
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        id: json["id"],
        user: json["user"],
        value: json["value"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "id": id,
        "user": user,
        "value": value,
        "status": status,
    };
}