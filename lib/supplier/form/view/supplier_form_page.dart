import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:findigitalservice/app_provider.dart';
import 'package:findigitalservice/constants/dimens.dart';
import 'package:findigitalservice/supplier/form/supplier_form.dart';
import 'package:findigitalservice/supplier/form/view/supplier_form.dart';
import 'package:findigitalservice/widgets/portal_master_layout/portal_master_layout.dart';

class SupplierFormPage extends StatefulWidget {
  final String id;

  const SupplierFormPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<SupplierFormPage> createState() => _SupplierFormPageState();
}

class _SupplierFormPageState extends State<SupplierFormPage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();
    final themeData = Theme.of(context);

    return PortalMasterLayout(
      body: BlocProvider(
        create: (context) {
          return SupplierFormBloc(provider)
            ..add(SupplierFormStarted(widget.id));
        },
        child:
            ListView(padding: const EdgeInsets.all(kDefaultPadding), children: [
          Text(
            provider.companyName,
            style: themeData.textTheme.headlineMedium,
          ),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
              child: SupplierForm()),
        ]),
      ),
    );
  }
}
