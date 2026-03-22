import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/profile_state.dart';

class ProfilesPage extends StatelessWidget {
  const ProfilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.profiles.length + 1, // +1 for add button
                  itemBuilder: (context, index) {
                    if (index == state.profiles.length) {
                      // Add profile button
                      return _AddProfileButton(
                        onTap: () => _showCreateProfileDialog(context),
                      );
                    }

                    final profile = state.profiles[index];
                    final isActive = state.activeProfile?.id == profile.id;

                    return _ProfileCard(
                      profile: profile,
                      isActive: isActive,
                      onTap: () {
                        context.read<ProfileBloc>().add(
                              ProfileSetActiveRequested(profile.id),
                            );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCreateProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => _CreateProfileDialog(
        onCreateProfile: (name, avatarId) {
          context.read<ProfileBloc>().add(
                ProfileCreateRequested(name: name, avatarId: avatarId),
              );
        },
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final dynamic profile;
  final bool isActive;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.profile,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: isActive
              ? Border.all(color: AppTheme.primaryColor, width: 3)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
              child: Text(
                profile.name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              profile.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (isActive) ...[
              const SizedBox(height: 4),
              const Text(
                'Active',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AddProfileButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddProfileButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.textHint,
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 48,
              color: AppTheme.textHint,
            ),
            SizedBox(height: 8),
            Text(
              'Add Profile',
              style: TextStyle(color: AppTheme.textHint),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateProfileDialog extends StatefulWidget {
  final Function(String name, String avatarId) onCreateProfile;

  const _CreateProfileDialog({required this.onCreateProfile});

  @override
  State<_CreateProfileDialog> createState() => _CreateProfileDialogState();
}

class _CreateProfileDialogState extends State<_CreateProfileDialog> {
  final _nameController = TextEditingController();
  String _selectedAvatarId = 'avatar_1';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Profile'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Profile Name',
              hintText: 'Enter profile name',
            ),
          ),
          const SizedBox(height: 16),
          const Text('Select Avatar'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: List.generate(5, (index) {
              final avatarId = 'avatar_${index + 1}';
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAvatarId = avatarId;
                  });
                },
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: _selectedAvatarId == avatarId
                      ? AppTheme.primaryColor
                      : AppTheme.surfaceColor,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: _selectedAvatarId == avatarId
                          ? Colors.white
                          : AppTheme.textPrimary,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              widget.onCreateProfile(
                _nameController.text,
                _selectedAvatarId,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
