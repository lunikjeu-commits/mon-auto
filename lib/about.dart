import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'storage.dart';
import 'theme.dart';

void showOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Options', style: kTitle),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.copy_rounded),
            title: const Text('Copier la sauvegarde'),
            subtitle: const Text('Colle-la ensuite dans une note'),
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: Store.i.exportJson()));
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) snack(context, 'Sauvegarde copiée');
            },
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Restaurer depuis le presse-papiers'),
            subtitle: const Text('Remplace les données actuelles'),
            onTap: () async {
              final d = await Clipboard.getData(Clipboard.kTextPlain);
              final ok = Store.i.importJson(d?.text ?? '');
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) snack(context, ok ? 'Sauvegarde restaurée' : 'Sauvegarde invalide');
            },
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Mon auto v1.0'),
            subtitle: Text('Créée par lunikapp'),
          ),
        ]),
      ),
    ),
  );
}
