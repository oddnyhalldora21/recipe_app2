import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/profile_page/profile_data_provider.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Blocking, non-dismissible prompt shown the first time a signed-in user
/// has no profiles_sweettreats row yet — they must pick a username before
/// continuing. Bio/avatar stay optional and are edited later from Profile.
class UsernameSetupDialog extends ConsumerStatefulWidget {
  const UsernameSetupDialog({super.key});

  @override
  ConsumerState<UsernameSetupDialog> createState() =>
      _UsernameSetupDialogState();
}

class _UsernameSetupDialogState extends ConsumerState<UsernameSetupDialog> {
  final _controller = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final username = _controller.text.trim();
    if (username.length < 3) {
      setState(() => _error = 'Username must be at least 3 characters.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final success = await ref
          .read(profileProvider.notifier)
          .createProfile(username);
      if (!mounted) return;
      if (success) {
        Navigator.of(context).pop();
      } else {
        setState(() {
          _busy = false;
          _error = 'Could not save that username — please try again.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().toLowerCase();
      setState(() {
        _busy = false;
        _error =
            message.contains('duplicate') || message.contains('unique')
                ? 'That username is already taken.'
                : 'Could not save that username — please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text('Choose a username', style: AppText.serif(fontSize: 20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pick a public username so other Sweet Treats users can find your profile and recipes. You can add a bio and photo later.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              autofocus: true,
              enabled: !_busy,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                hintText: 'e.g. sweettreatsam',
                errorText: _error,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: _busy ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brown,
              foregroundColor: Colors.white,
            ),
            child:
                _busy
                    ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
