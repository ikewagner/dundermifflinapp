import 'package:flutter/material.dart';
import 'package:dundermifflinapp/core/configs/theme/app_colors.dart';

class ContactMethodPage extends StatelessWidget {
  const ContactMethodPage({super.key});

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
              'Qual a melhor forma para entrarmos em contato com você?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Image.asset("assets/whatsapp.png"),
                    title: Text('WhatsApp'),
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  ListTile(
                    leading: Image.asset("assets/insta.png"),
                    title: Text('Instagram'),
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.sms, color: Colors.green),
                    title: Text('SMS (mensagem de texto)'),
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.phone, color: Colors.black),
                    title: Text('Ligação'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.black),
                    title: Text('E-mail'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Voltar'),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: AppColors.primaryBase,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
