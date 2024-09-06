import 'package:dundermifflinapp/api/updateProfile_bloc.dart' as update_profile;
import 'package:dundermifflinapp/core/configs/theme/app_colors.dart';
import 'package:dundermifflinapp/core/helpers/validators.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditProfilePage extends StatefulWidget {
  final int userId;
  String userName;
  String userEmail;
  String biography;

  EditProfilePage({
    super.key,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.biography,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _emailController = TextEditingController(text: widget.userEmail);
    _bioController = TextEditingController(text: widget.biography);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    try {
      await update_profile.ApiService().updateProfile(
        id: widget.userId,
        name: _nameController.text,
        email: _emailController.text,
        biography: _bioController.text,
      );
      Navigator.pop(context, {
        'userName': _nameController.text,
        'userEmail': _emailController.text,
        'biography': _bioController.text,
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                color: AppColors.primary90,
                padding: const EdgeInsets.all(20.0),
                child: const Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://www.w3schools.com/w3images/avatar2.png"),
                    radius: 30.0,
                  ),
                ),
              ),
              const SizedBox(height: 36.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome Completo',
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryBase),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryBase),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _nameController.clear();
                    },
                  ),
                ),
                validator: ValidatorsProfile.validateFullName,
                onFieldSubmitted: (value) {
                  setState(() {
                    _nameController.text = value;
                  });
                },
              ),
              const SizedBox(height: 36.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryBase),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryBase),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _emailController.clear();
                    },
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  return ValidatorsProfile.validateEmail(value);
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    _emailController.text = value.toLowerCase();
                  });
                },
              ),
              const SizedBox(height: 26.0),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'Biografia (opcional)',
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryBase),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryBase),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _bioController.clear();
                    },
                  ),
                  alignLabelWithHint: false,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                maxLines: 4,
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 36.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _updateProfile();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBase,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save, color: Colors.white),
                    SizedBox(width: 8.0),
                    Text(
                      'Salvar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
