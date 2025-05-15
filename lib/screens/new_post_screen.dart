import 'package:flutter/material.dart';
import '../models/post/post_dto.dart';
import '../services/api_service.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String? _selectedCategory;
  String? _selectedCondition;
  String? _selectedPaymentMethod;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newPost = PostDto(
        id: 0,
        title: _titleController.text,
        price: double.parse(_priceController.text),
        category: _selectedCategory!,
        condition: _selectedCondition!,
        location: _locationController.text,
        paymentMethod: _selectedPaymentMethod!,
        description: _descriptionController.text,
        phoneNumber: _phoneController.text,
        email: '', // Se completará del perfil
        whatsAppLink: '',
        imageUrl: '',
        author: '', // Se completará del perfil
        publishdate: DateTime.now(),
      );

      await ApiService().createPost(newPost);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Publicación'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección de Información Básica
              _buildSectionHeader('Información Básica'),
              const SizedBox(height: 16),
              
              // Campo Título
              _buildTextField(
                controller: _titleController,
                label: 'Título del producto',
                hint: 'Ej: iPhone 13 Pro Max',
                icon: Icons.title,
                validator: (value) => value!.isEmpty ? 'Este campo es requerido' : null,
              ),
              const SizedBox(height: 16),
              
              // Campo Precio
              _buildTextField(
                controller: _priceController,
                label: 'Precio',
                hint: '0.00',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                prefixText: '\$ ',
                validator: (value) {
                  if (value!.isEmpty) return 'Ingrese un precio';
                  if (double.tryParse(value) == null) return 'Precio inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Selector Categoría
              _buildDropdown(
                value: _selectedCategory,
                label: 'Categoría',
                hint: 'Seleccione una categoría',
                icon: Icons.category,
                items: ['Electrónica', 'Muebles', 'Ropa', 'Libros', 'Otros'],
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: (value) => value == null ? 'Seleccione una categoría' : null,
              ),
              const SizedBox(height: 16),
              
              // Selector Condición
              _buildDropdown(
                value: _selectedCondition,
                label: 'Condición',
                hint: 'Seleccione la condición',
                icon: Icons.assignment_turned_in,
                items: ['Nuevo', 'Como nuevo', 'Usado', 'Para partes'],
                onChanged: (value) => setState(() => _selectedCondition = value),
                validator: (value) => value == null ? 'Seleccione una condición' : null,
              ),
              const SizedBox(height: 24),
              
              // Sección de Ubicación
              _buildSectionHeader('Ubicación y Contacto'),
              const SizedBox(height: 16),
              
              // Campo Ubicación
              _buildTextField(
                controller: _locationController,
                label: 'Ubicación',
                hint: 'Ej: Av. San Martín #123',
                icon: Icons.location_on,
                validator: (value) => value!.isEmpty ? 'Ingrese una ubicación' : null,
              ),
              const SizedBox(height: 16),
              
              // Campo Teléfono
              _buildTextField(
                controller: _phoneController,
                label: 'Teléfono de contacto',
                hint: 'Ej: 77712345',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) return 'Ingrese un teléfono';
                  if (value.length < 7) return 'Teléfono muy corto';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Selector Método de Pago
              _buildDropdown(
                value: _selectedPaymentMethod,
                label: 'Método de pago',
                hint: 'Seleccione método de pago',
                icon: Icons.payment,
                items: ['Efectivo', 'Transferencia', 'Tarjeta', 'Otro'],
                onChanged: (value) => setState(() => _selectedPaymentMethod = value),
                validator: (value) => value == null ? 'Seleccione un método' : null,
              ),
              const SizedBox(height: 24),
              
              // Sección Descripción
              _buildSectionHeader('Descripción'),
              const SizedBox(height: 16),
              
              // Campo Descripción
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Describa su producto',
                  hintText: 'Incluya detalles importantes...',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: colors.surfaceVariant.withOpacity(0.3),
                ),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? 'Ingrese una descripción' : null,
              ),
              const SizedBox(height: 32),
              
              // Botón de Publicar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'PUBLICAR PRODUCTO',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    TextInputType? keyboardType,
    String? prefixText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        prefixText: prefixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
    required String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      ),
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      )).toList(),
      onChanged: onChanged,
      validator: validator,
      dropdownColor: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      icon: const Icon(Icons.arrow_drop_down),
      isExpanded: true,
    );
  }
}