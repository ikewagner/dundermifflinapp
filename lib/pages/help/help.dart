import 'package:dundermifflinapp/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'help_detail.dart'; // Import the new file

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Solicitação de atendimento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Qual o motivo do atendimento?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildListItem(
                      context, Icons.flash_on, 'Solução de problemas técnicos'),
                  _buildListItem(context, Icons.person,
                      'Marcação de visita para solução de problema técnico'),
                  _buildListItem(context, Icons.help_outline,
                      'Dúvidas sobre utilização de algum produto ou serviço'),
                  _buildListItem(
                      context, Icons.cancel, 'Cancelamento de pedido'),
                  _buildListItem(context, Icons.edit, 'Alteração de pedido'),
                  _buildListItem(context, Icons.redo,
                      'Redirecionamento para todos os setores da empresa'),
                  _buildListItem(context, Icons.info,
                      'Informações sobre produtos ou serviços'),
                ],
              ),
            ),
            const SizedBox(height: 46),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: AppColors.primaryBase,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, IconData icon, String text) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HelpDetailPage(),
            ),
          );
        },
      ),
    );
  }
}
