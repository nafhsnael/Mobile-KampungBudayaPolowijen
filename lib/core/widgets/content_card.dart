import 'package:flutter/material.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({
    required this.title,
    required this.description,
    this.leadingIcon = Icons.auto_awesome_outlined,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final String description;
  final IconData leadingIcon;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading:
            Icon(leadingIcon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
