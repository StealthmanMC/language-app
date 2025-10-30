import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final Set<String> selectedLanguages = {};

  void _toggleLanguage(String language) {
    setState(() {
      if (selectedLanguages.contains(language)) {
        selectedLanguages.remove(language);
      } else {
        selectedLanguages.add(language);
      }
    });
  }

  Future<void> _continue() async {
    if (selectedLanguages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one language')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    await authProvider.updateLanguagePreferences(selectedLanguages.toList());

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Languages'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Text(
              'Which languages would you like to learn?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You can always change this later in settings',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  _LanguageCard(
                    flag: '🇮🇳',
                    language: 'Hindi',
                    description: 'Devanagari script - 260M speakers',
                    isSelected: selectedLanguages.contains('hindi'),
                    onTap: () => _toggleLanguage('hindi'),
                  ),
                  const SizedBox(height: 16),
                  _LanguageCard(
                    flag: '🇮🇳',
                    language: 'Telugu',
                    description: 'Telugu script - 80M speakers',
                    isSelected: selectedLanguages.contains('telugu'),
                    onTap: () => _toggleLanguage('telugu'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _continue,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String flag;
  final String language;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.flag,
    required this.language,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.blue.shade50 : Colors.white,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Colors.blue[600],
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
