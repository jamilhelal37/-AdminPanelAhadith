import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/app_user.dart';
import '../providers/admin_users_provider.dart';

Future<void> showAdminUserEditDialog(
  BuildContext context,
  WidgetRef ref,
  AppUser user,
) async {
  final id = user.id;
  if (id == null || id.isEmpty) return;

  UserType selectedType = user.type ?? UserType.member;
  bool isActivated = user.isActivated;
  bool isSaving = false;

  await showDialog<void>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('تعديل المستخدم'),
            content: SizedBox(
              width: 360,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<UserType>(
                    initialValue: selectedType,
                    items: UserType.values
                        .map(
                          (type) => DropdownMenuItem<UserType>(
                            value: type,
                            child: Text(type.name),
                          ),
                        )
                        .toList(),
                    onChanged: isSaving
                        ? null
                        : (value) {
                            if (value == null) return;
                            setDialogState(() {
                              selectedType = value;
                            });
                          },
                    decoration: InputDecoration(labelText: 'نوع المستخدم'),
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    value: isActivated,
                    contentPadding: EdgeInsets.zero,
                    title: Text('الحساب مفعل'),
                    onChanged: isSaving
                        ? null
                        : (value) {
                            setDialogState(() {
                              isActivated = value;
                            });
                          },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSaving ? null : () => Navigator.of(context).pop(),
                child: Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: isSaving
                    ? null
                    : () async {
                        setDialogState(() {
                          isSaving = true;
                        });

                        try {
                          await ref.read(
                            updateAdminUserProvider(
                              AdminUserUpdateParams(
                                id: id,
                                type: selectedType,
                                isActivated: isActivated,
                              ),
                            ).future,
                          );

                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                          ref.invalidate(adminUsersProvider);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تم تحديث المستخدم بنجاح')),
                          );
                        } catch (e) {
                          if (!context.mounted) return;
                          setDialogState(() {
                            isSaving = false;
                          });
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                child: isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('حفظ'),
              ),
            ],
          );
        },
      );
    },
  );
}
