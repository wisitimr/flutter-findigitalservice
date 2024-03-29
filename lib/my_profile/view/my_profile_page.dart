import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:findigitalservice/app_provider.dart';
import 'package:findigitalservice/constants/dimens.dart';
import 'package:findigitalservice/my_profile/bloc/my_profile_bloc.dart';
import 'package:findigitalservice/my_profile/view/view.dart';
import 'package:findigitalservice/widgets/portal_master_layout/portal_master_layout.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();

    return PortalMasterLayout(
      body: BlocProvider(
        create: (context) {
          return MyProfileBloc(provider)..add(const MyProfileStarted());
        },
        child: ListView(
          padding: const EdgeInsets.all(kDefaultPadding),
          children: const [
            Padding(
                padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
                child: MyProfileForm()),
          ],
        ),
      ),
    );
  }
}
