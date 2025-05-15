import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/post/post_details_dto.dart';
import '../models/post/post_dto.dart';
import '../models/post/post_simple_dto.dart';
import '../models/user/token_dto.dart';
import '../models/user/user_info_dto.dart';
import '../models/user/user_login_dto.dart';
import '../models/user/user_register_dto.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal();

  final String _baseUrl = 'https://app-250504041114.azurewebsites.net/api';
  String? _token;
  UserInfoDto? _currentUser;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  UserInfoDto? get currentUser => _currentUser;

  void _setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
    _currentUser = null;
  }

  // ---------------- Auth ----------------

  Future<void> register(UserRegisterDto dto) async {
    final url = Uri.parse('$_baseUrl/Auth/register');
    final res = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(dto.toJson()),
    );
    if (res.statusCode >= 400) {
      throw Exception('Error al registrar usuario: ${res.body}');
    }
  }

  Future<TokenDto> login(UserLoginDto dto) async {
    final url = Uri.parse('$_baseUrl/Auth/login');
    final res = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(dto.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception('Login inválido');
    }
    final token = TokenDto.fromJson(jsonDecode(res.body));
    _setToken(token.token);
    return token;
  }

  // ---------------- User ----------------

  Future<UserInfoDto> getProfile({bool forceRefresh = false}) async {
    if (!forceRefresh && _currentUser != null) {
      return _currentUser!;
    }

    final url = Uri.parse('$_baseUrl/Users');
    final res = await http.get(url, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('No se pudo obtener el perfil');
    }

    _currentUser = UserInfoDto.fromJson(jsonDecode(res.body));
    return _currentUser!;
  }

  // ---------------- Posts ----------------

  Future<List<PostSimpleDto>> getAllPosts() async {
    final url = Uri.parse('$_baseUrl/Posts');
    final res = await http.get(url, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Error al obtener posts: ${res.statusCode}');
    }

    final List<dynamic> data = jsonDecode(res.body);
    return data.map((json) => PostSimpleDto.fromJson(json)).toList();
  }

  Future<PostDetailDto> getPostDetails(int postId) async {
    final url = Uri.parse('$_baseUrl/Posts/$postId');
    final res = await http.get(url, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Error al obtener detalles del post');
    }

    return PostDetailDto.fromJson(jsonDecode(res.body));
  }

  Future<PostDto> createPost(PostDto post) async {
    final url = Uri.parse('$_baseUrl/Posts');
    final res = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(post.toJson()),
    );

    if (res.statusCode != 201) {
      throw Exception('Error al crear post: ${res.body}');
    }

    return PostDto.fromJson(jsonDecode(res.body));
  }

  Future<void> updatePost(PostDto post) async {
    final url = Uri.parse('$_baseUrl/Posts/${post.id}');
    final res = await http.put(
      url,
      headers: _headers,
      body: jsonEncode(post.toJson()),
    );

    if (res.statusCode != 204) {
      throw Exception('Error al actualizar post');
    }
  }

  Future<void> deletePost(int postId) async {
    final url = Uri.parse('$_baseUrl/Posts/$postId');
    final res = await http.delete(url, headers: _headers);

    if (res.statusCode != 204) {
      throw Exception('Error al eliminar post');
    }
  }

  // ---------------- Image Upload ----------------

  Future<String> uploadImage(String imagePath) async {
    final url = Uri.parse('$_baseUrl/Images/upload');
    final request = http.MultipartRequest('POST', url)
      ..headers.addAll(_headers)
      ..files.add(await http.MultipartFile.fromPath('file', imagePath));

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Error al subir imagen: $responseData');
    }

    final jsonResponse = jsonDecode(responseData);
    return jsonResponse['url'] as String;
  }
}