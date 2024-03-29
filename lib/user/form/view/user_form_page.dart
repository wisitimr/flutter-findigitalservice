import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:findigitalservice/app_provider.dart';
import 'package:findigitalservice/constants/dimens.dart';
import 'package:findigitalservice/user/form/user_form.dart';
import 'package:findigitalservice/user/form/view/user_form.dart';
import 'package:findigitalservice/widgets/portal_master_layout/portal_master_layout.dart';

class UserFormPage extends StatefulWidget {
  final String id;

  const UserFormPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();

    return PortalMasterLayout(
      body: BlocProvider(
        create: (context) {
          return UserFormBloc(provider)..add(UserFormStarted(widget.id));
        },
        child:
            ListView(padding: const EdgeInsets.all(kDefaultPadding), children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
              child: UserForm(id: widget.id)),
        ]),
      ),
    );
  }
}
