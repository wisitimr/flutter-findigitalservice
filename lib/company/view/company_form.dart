import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:saved/app_provider.dart';
import 'package:saved/app_router.dart';
import 'package:saved/company/bloc/company_bloc.dart';
import 'package:saved/constants/dimens.dart';
import 'package:saved/generated/l10n.dart';
import 'package:saved/theme/theme_extensions/app_button_theme.dart';
import 'package:saved/widgets/card_elements.dart';

class CompanyForm extends StatelessWidget {
  const CompanyForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final formKey = GlobalKey<FormBuilderState>();
    final provider = context.read<AppProvider>();
    return BlocListener<CompanyBloc, CompanyState>(
      listener: (context, state) async {
        // print(state.status);
        if (state.status.isFailure) {
          final dialog = AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            desc: state.message,
            width: kDialogWidth,
            btnOkText: 'OK',
            btnOkOnPress: () {},
          );

          dialog.show();
        } else if (state.status.isSuccess) {
          final dialog = AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            desc: state.message,
            width: kDialogWidth,
            btnOkText: 'OK',
            btnOkOnPress: () async {
              GoRouter.of(context).go(RouteUri.myProfile);
            },
          );

          dialog.show();
        }
      },
      child: BlocBuilder<CompanyBloc, CompanyState>(
        builder: (context, state) {
          switch (state.isLoading) {
            case true:
              return const Center(child: CircularProgressIndicator());
            case false:
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
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                initialValue: state.name.value,
                                validator: FormBuilderValidators.required(),
                                onChanged: (name) => context
                                    .read<CompanyBloc>()
                                    .add(CompanyNameChanged(name!)),
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
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                initialValue: state.description.value,
                                // validator: FormBuilderValidators.required(),
                                onChanged: (description) => context
                                    .read<CompanyBloc>()
                                    .add(CompanyNameChanged(description!)),
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
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                initialValue: state.address.value,
                                validator: FormBuilderValidators.required(),
                                onChanged: (address) => context
                                    .read<CompanyBloc>()
                                    .add(CompanyAddressChanged(address!)),
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
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                initialValue: state.phone.value,
                                validator: FormBuilderValidators.required(),
                                onChanged: (phone) => context
                                    .read<CompanyBloc>()
                                    .add(CompanyPhoneChanged(phone!)),
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
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                initialValue: state.contact.value,
                                validator: FormBuilderValidators.required(),
                                onChanged: (contact) => context
                                    .read<CompanyBloc>()
                                    .add(CompanyContactChanged(contact!)),
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
                                    onPressed: () => GoRouter.of(context)
                                        .go(provider.previous),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: kDefaultPadding * 0.5),
                                          child: Icon(
                                            Icons.arrow_circle_left_outlined,
                                            size: (themeData.textTheme
                                                    .labelLarge!.fontSize! +
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
                                              context.read<CompanyBloc>().add(
                                                  const CompanySubmitted());
                                            }
                                          : null),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: kDefaultPadding * 0.5),
                                            child: Icon(
                                              Icons.save_rounded,
                                              size: (themeData.textTheme
                                                      .labelLarge!.fontSize! +
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
          }
        },
      ),
    );
  }
}
