import 'package:flutter/material.dart';
import '../models/post/post_details_dto.dart';
import '../services/api_service.dart';

class PostDetailsScreen extends StatefulWidget {
  final int postId;

  const PostDetailsScreen({super.key, required this.postId});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  late Future<PostDetailDto> _postFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _postFuture = ApiService().getPostDetails(widget.postId);
  }

  Future<void> _deletePost(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      await ApiService().deletePost(widget.postId);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles')),
      body: FutureBuilder<PostDetailDto>(
        future: _postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final post = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.imageUrl.isNotEmpty)
                  Image.network(post.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
                const SizedBox(height: 16),
                Text(post.title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('\$${post.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                _buildDetailItem('Categoría', post.category),
                _buildDetailItem('Condición', post.condition),
                _buildDetailItem('Ubicación', post.location),
                const SizedBox(height: 16),
                const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(post.description),
                const SizedBox(height: 24),
                const Divider(),
                const Text('Contacto', style: TextStyle(fontWeight: FontWeight.bold)),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Vendedor'),
                  subtitle: Text(post.author),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Teléfono'),
                  subtitle: Text(post.phoneNumber),
                ),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: () => _deletePost(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('ELIMINAR PUBLICACIÓN'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}