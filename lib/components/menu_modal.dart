import 'package:dundermifflinapp/api/getAccount_bloc.dart';
import 'package:dundermifflinapp/pages/profile/edit_profile_modal.dart';
import 'package:flutter/material.dart';
import 'package:dundermifflinapp/core/configs/theme/app_colors.dart';
import 'package:dundermifflinapp/pages/auth/auth.dart';
import 'package:dundermifflinapp/components/loading_screen.dart';

class MenuModal extends StatefulWidget {
  final BuildContext parentContext;

  const MenuModal({Key? key, required this.parentContext}) : super(key: key);

  @override
  _MenuModalState createState() => _MenuModalState();
}

class _MenuModalState extends State<MenuModal> {
  int userId = 0;
  String userName = "";
  String userEmail = "";
  String version = "";
  String biography = "";
  bool isLoading = true;
  String originalEmail = "";

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final apiService = ApiService();
      final data = await apiService.getCurrentLoginInformations();
      setState(() {
        userId = data['result']['user']['id'] ?? 'Unknown';
        version = data['result']['application']['version'] ?? 'Unknown';
        userName = data['result']['user']['name'] ?? 'Unknown';
        userEmail = data['result']['user']['emailAddress'] ?? 'Unknown';
        biography = data['result']['user']['biography'] ?? '';
        originalEmail = userEmail;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        version = 'Error';
        userName = 'Error';
        userEmail = 'Error';
        biography = 'Error';
        isLoading = false;
      });
    }
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
  }

  void _openEditProfilePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          userName: userName,
          userEmail: userEmail,
          userId: userId,
          biography: biography,
        ),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        userName = result['userName'] ?? userName;
        userEmail = result['userEmail'] ?? userEmail;
        biography = result['biography'] ?? biography;
      });
      if (userEmail != originalEmail) {
        _showEmailChangeDialog(userEmail);
      }
    } else {
      _showUnsavedChangesDialog();
    }
  }

  void _showEmailChangeDialog(String newEmail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alteração de e-mail'),
          content: Text(
              'O e-mail de acesso ao aplicativo foi alterado para $newEmail'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Confirmar',
                style: TextStyle(
                  color: AppColors.primaryBase,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBase,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edições não salvas'),
          content: const Text(
              'Ao fechar, as edições feitas serão perdidas. Deseja continuar?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBase,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.white,
              ),
              child: const Text(
                'Continuar',
                style: TextStyle(
                  color: AppColors.primaryBase,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingScreen();
    }

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 52.0,
                    left: 26.0,
                    right: 26.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: AppColors.primary90,
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://github.com/ikewagner.png"),
                            radius: 30.0,
                          ),
                          const SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                userEmail,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: _openEditProfilePage,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Configurações'),
                  subtitle: Text('Configurações do aplicativo'),
                ),
                const ListTile(
                  leading: Icon(Icons.payment),
                  title: Text('Formas de pagamento'),
                  subtitle: Text('Minhas formas de pagamento'),
                ),
                const ListTile(
                  leading: Icon(Icons.card_giftcard),
                  title: Text('Cupons'),
                  subtitle: Text('Meus cupons de desconto'),
                ),
                const ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text('Favoritos'),
                  subtitle: Text('Meus produtos favoritos'),
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Sair da conta'),
                  subtitle: const Text('Sair da minha conta'),
                  onTap: () => _logout(widget.parentContext),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  version,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
