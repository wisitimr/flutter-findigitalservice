import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/app_provider.dart';
import 'package:saved/company/company.dart';
import 'package:saved/constants/dimens.dart';
import 'package:saved/widgets/portal_master_layout/portal_master_layout.dart';

class CompanyPage extends StatefulWidget {
  final String id;

  const CompanyPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  @override
  Widget build(BuildContext context) {
    return PortalMasterLayout(
      body: BlocProvider(
        create: (context) {
          return CompanyBloc(
            provider: context.read<AppProvider>(),
          )..add(CompanyStarted(widget.id));
        },
        child: ListView(
            padding: const EdgeInsets.all(kDefaultPadding),
            children: const [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
                  child: CompanyForm()),
            ]),
      ),
    );
  }
}
