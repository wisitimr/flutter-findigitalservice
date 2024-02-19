import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/app_provider.dart';
import 'package:saved/user/company/user_company.dart';
import 'package:saved/constants/dimens.dart';
import 'package:saved/widgets/portal_master_layout/portal_master_layout.dart';

class UserCompanyPage extends StatefulWidget {
  final String id;

  const UserCompanyPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<UserCompanyPage> createState() => _UserCompanyPageState();
}

class _UserCompanyPageState extends State<UserCompanyPage> {
  @override
  Widget build(BuildContext context) {
    return PortalMasterLayout(
      body: BlocProvider(
        create: (context) {
          return UserCompanyBloc(
            provider: context.read<AppProvider>(),
          )..add(UserCompanyStarted(widget.id));
        },
        child: ListView(
            padding: const EdgeInsets.all(kDefaultPadding),
            children: const [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
                  child: UserCompanyForm()),
            ]),
      ),
    );
  }
}
