import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:findigitalservice/app_provider.dart';
import 'package:findigitalservice/theme/theme_extensions/app_color_scheme.dart';
import 'package:findigitalservice/user/company/bloc/user_company_bloc.dart';
import 'package:findigitalservice/constants/dimens.dart';
import 'package:findigitalservice/generated/l10n.dart';
import 'package:findigitalservice/theme/theme_extensions/app_button_theme.dart';
import 'package:findigitalservice/widgets/card_elements.dart';

class UserCompanyForm extends StatelessWidget {
  const UserCompanyForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();
    final themeData = Theme.of(context);
    final appColorScheme = themeData.extension<AppColorScheme>()!;
    final lang = Lang.of(context);

    return BlocListener<UserCompanyBloc, UserCompanyState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          final dialog = AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            desc: state.message,
            width: kDialogWidth,
            btnOkText: lang.ok,
            btnOkOnPress: () {},
          );

          dialog.show();
        } else if (state.status.isSubmitConfirmation) {
          final dialog = AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            desc: lang.confirmSubmitRecord,
            width: kDialogWidth,
            btnOkText: lang.ok,
            btnOkColor: appColorScheme.primary,
            btnOkOnPress: () {
              context.read<UserCompanyBloc>().add(const UserCompanySubmitted());
            },
            btnCancelText: lang.cancel,
            btnCancelColor: appColorScheme.secondary,
            btnCancelOnPress: () {},
          );

          dialog.show();
        } else if (state.status.isSubmited) {
          final dialog = AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            desc: state.message,
            width: kDialogWidth,
            btnOkText: lang.ok,
            btnOkOnPress: () => GoRouter.of(context).go(provider.previous),
          );

          dialog.show();
        }
      },
      child: BlocBuilder<UserCompanyBloc, UserCompanyState>(
        builder: (context, state) {
          switch (state.status) {
            case UserCompanyStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case UserCompanyStatus.failure:
              return const UserCompanyDetail();
            case UserCompanyStatus.submited:
              return const UserCompanyDetail();
            case UserCompanyStatus.submitConfirmation:
              return const UserCompanyDetail();
            case UserCompanyStatus.success:
              return const UserCompanyDetail();
          }
        },
      ),
    );
  }
}

class UserCompanyDetail extends StatelessWidget {
  const UserCompanyDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final formKey = GlobalKey<FormBuilderState>();

    return BlocBuilder<UserCompanyBloc, UserCompanyState>(
      builder: (context, state) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardHeader(
                title: lang.company,
              ),
              CardBody(
                child: FormBuilder(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: kDefaultPadding * 2.0,
                            top: kDefaultPadding * 2.0),
                        child: FormBuilderTextField(
                          name: lang.name,
                          decoration: InputDecoration(
                            labelText: lang.name,
                            hintText: lang.name,
                            border: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          initialValue: state.name.value,
                          validator: FormBuilderValidators.required(),
                          onChanged: (name) => context
                              .read<UserCompanyBloc>()
                              .add(UserCompanyNameChanged(name!)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: kDefaultPadding * 2.0),
                        child: FormBuilderTextField(
                          name: lang.description,
                          decoration: InputDecoration(
                            labelText: lang.description,
                            hintText: lang.description,
                            border: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          initialValue: state.description.value,
                          // validator: FormBuilderValidators.required(),
                          onChanged: (description) => context
                              .read<UserCompanyBloc>()
                              .add(UserCompanyNameChanged(description!)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: kDefaultPadding * 2.0),
                        child: FormBuilderTextField(
                          name: lang.address,
                          decoration: InputDecoration(
                            labelText: lang.address,
                            hintText: lang.address,
                            border: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          initialValue: state.address.value,
                          validator: FormBuilderValidators.required(),
                          onChanged: (address) => context
                              .read<UserCompanyBloc>()
                              .add(UserCompanyAddressChanged(address!)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: kDefaultPadding * 2.0),
                        child: FormBuilderTextField(
                          name: lang.phone,
                          decoration: InputDecoration(
                            labelText: lang.phone,
                            hintText: lang.phone,
                            border: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          initialValue: state.phone.value,
                          validator: FormBuilderValidators.required(),
                          onChanged: (phone) => context
                              .read<UserCompanyBloc>()
                              .add(UserCompanyPhoneChanged(phone!)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: kDefaultPadding * 2.0),
                        child: FormBuilderTextField(
                          name: lang.contact,
                          decoration: InputDecoration(
                            labelText: lang.contact,
                            hintText: lang.contact,
                            border: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          initialValue: state.contact.value,
                          validator: FormBuilderValidators.required(),
                          onChanged: (contact) => context
                              .read<UserCompanyBloc>()
                              .add(UserCompanyContactChanged(contact!)),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 40.0,
                            child: ElevatedButton(
                              style: themeData
                                  .extension<AppButtonTheme>()!
                                  .secondaryElevated,
                              onPressed: () async =>
                                  GoRouter.of(context).go(provider.previous),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: kDefaultPadding * 0.5),
                                    child: Icon(
                                      Icons.arrow_circle_left_outlined,
                                      size: (themeData
                                              .textTheme.labelLarge!.fontSize! +
                                          4.0),
                                    ),
                                  ),
                                  Text(lang.crudBack),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 40.0,
                              child: ElevatedButton(
                                style: themeData
                                    .extension<AppButtonTheme>()!
                                    .primaryElevated,
                                onPressed: (state.isValid
                                    ? () {
                                        context.read<UserCompanyBloc>().add(
                                            const UserCompanySubmitConfirm());
                                      }
                                    : null),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: kDefaultPadding * 0.5),
                                      child: Icon(
                                        Icons.save_rounded,
                                        size: (themeData.textTheme.labelLarge!
                                                .fontSize! +
                                            4.0),
                                      ),
                                    ),
                                    Text(lang.save),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
