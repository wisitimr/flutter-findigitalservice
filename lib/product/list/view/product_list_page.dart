import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:findigitalservice/product/list/product_list.dart';
import 'package:findigitalservice/app_router.dart';
import 'package:findigitalservice/constants/dimens.dart';
import 'package:findigitalservice/generated/l10n.dart';
import 'package:findigitalservice/app_provider.dart';
import 'package:findigitalservice/theme/theme_extensions/app_button_theme.dart';
import 'package:findigitalservice/theme/theme_extensions/app_color_scheme.dart';
import 'package:findigitalservice/theme/theme_extensions/app_data_table_theme.dart';
import 'package:findigitalservice/widgets/card_elements.dart';
import 'package:findigitalservice/widgets/portal_master_layout/portal_master_layout.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();
    final themeData = Theme.of(context);
    final appColorScheme = themeData.extension<AppColorScheme>()!;
    final lang = Lang.of(context);

    return PortalMasterLayout(
      body: BlocProvider(
        create: (context) {
          return ProductBloc(provider)..add(const ProductStarted());
        },
        child: ListView(
          padding: const EdgeInsets.all(kDefaultPadding),
          children: [
            Text(
              provider.companyName,
              style: themeData.textTheme.headlineMedium,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
              child: BlocListener<ProductBloc, ProductState>(
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
                  } else if (state.status.isDeleteConfirmation) {
                    final dialog = AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      desc: lang.confirmDeleteRecord,
                      width: kDialogWidth,
                      btnOkText: lang.ok,
                      btnOkColor: appColorScheme.error,
                      btnOkOnPress: () {
                        context.read<ProductBloc>().add(const ProductDelete());
                      },
                      btnCancelText: lang.cancel,
                      btnCancelColor: appColorScheme.secondary,
                      btnCancelOnPress: () {},
                    );

                    dialog.show();
                  } else if (state.status.isDeleted) {
                    final dialog = AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      desc: state.message,
                      width: kDialogWidth,
                      btnOkText: lang.ok,
                      btnOkOnPress: () async {
                        context.read<ProductBloc>().add(const ProductStarted());
                      },
                    );

                    dialog.show();
                  }
                },
                child: const Product(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product extends StatelessWidget {
  const Product({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        switch (state.status) {
          case ProductListStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ProductListStatus.failure:
            return const ProductCard();
          case ProductListStatus.deleted:
            return const ProductCard();
          case ProductListStatus.deleteConfirmation:
            return const ProductCard();
          case ProductListStatus.success:
            return const ProductCard();
        }
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appDataTableTheme = themeData.extension<AppDataTableTheme>()!;
    final dataTableHorizontalScrollController = ScrollController();
    final key = GlobalKey<PaginatedDataTableState>();

    return BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardHeader(
              title: lang.product,
            ),
            CardBody(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: kDefaultPadding),
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: kTextPadding,
                      runSpacing: kTextPadding,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextField(
                                  decoration: InputDecoration(
                                    labelText: lang.search,
                                    hintText: lang.search,
                                    border: const OutlineInputBorder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    isDense: true,
                                    suffixIcon: const Icon(Icons.search),
                                  ),
                                  onChanged: (text) => {
                                        context
                                            .read<ProductBloc>()
                                            .add(ProductSearchChanged(text)),
                                        key.currentState?.pageTo(0),
                                      }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: kDefaultPadding * 0.5),
                        child: SizedBox(
                          height: 40.0,
                          child: ElevatedButton(
                            style: themeData
                                .extension<AppButtonTheme>()!
                                .successElevated,
                            onPressed: () =>
                                GoRouter.of(context).go(RouteUri.productForm),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: kDefaultPadding * 0.5),
                                  child: Icon(
                                    Icons.add,
                                    size: (themeData
                                            .textTheme.labelLarge!.fontSize! +
                                        4.0),
                                  ),
                                ),
                                Text(lang.crudNew),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: kDefaultPadding * 2.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final double dataTableWidth =
                                  max(kScreenWidthMd, constraints.maxWidth);

                              return Scrollbar(
                                controller: dataTableHorizontalScrollController,
                                thumbVisibility: true,
                                trackVisibility: true,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller:
                                      dataTableHorizontalScrollController,
                                  child: SizedBox(
                                    width: dataTableWidth,
                                    child: Theme(
                                        data: themeData.copyWith(
                                          cardTheme:
                                              appDataTableTheme.cardTheme,
                                          dataTableTheme: appDataTableTheme
                                              .dataTableThemeData,
                                        ),
                                        child: PaginatedDataTable(
                                          key: key,
                                          showFirstLastButtons: true,
                                          columns: [
                                            DataColumn(label: Text(lang.code)),
                                            DataColumn(label: Text(lang.name)),
                                            DataColumn(label: Text(lang.price)),
                                            DataColumn(
                                                label: Text(lang.createdAt)),
                                            DataColumn(
                                                label: Text(lang.updatedAt)),
                                            const DataColumn(
                                                label: Text('...')),
                                          ],
                                          source: _DataSource(
                                            data: state.filter,
                                            context: context,
                                            onDetailButtonPressed: (data) =>
                                                GoRouter.of(context).go(
                                                    '${RouteUri.productForm}?id=${data.id}'),
                                            onDeleteButtonPressed: (data) =>
                                                context.read<ProductBloc>().add(
                                                    ProductDeleteConfirm(
                                                        data.id)),
                                          ),
                                        )),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class SearchForm {
  String company = '';
  String code = '';
  String number = '';
  String type = '';
}

class _DataSource extends DataTableSource {
  final List<ProductModel> data;
  final BuildContext context;
  final void Function(ProductModel data) onDetailButtonPressed;
  final void Function(ProductModel data) onDeleteButtonPressed;

  _DataSource({
    required this.data,
    required this.context,
    required this.onDetailButtonPressed,
    required this.onDeleteButtonPressed,
  });
  final inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ssZ');
  final outputFormat = DateFormat('dd/MM/yyyy');

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    ProductModel row = data[index];
    var createdAt = inputFormat.parse(row.createdAt);
    var updatedAt = inputFormat.parse(row.updatedAt);
    return DataRow(
      cells: [
        DataCell(Text(row.code)),
        DataCell(Text(row.name)),
        DataCell(Text(row.price.toStringAsFixed(2))),
        DataCell(Text(outputFormat.format(createdAt))),
        DataCell(Text(outputFormat.format(updatedAt))),
        DataCell(Builder(
          builder: (context) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: kDefaultPadding),
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.edit_document),
                    onPressed: () => onDetailButtonPressed.call(row),
                    style: Theme.of(context)
                        .extension<AppButtonTheme>()!
                        .primaryOutlined,
                    label: Text(Lang.of(context).crudDetail),
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.delete_rounded),
                  onPressed: () => onDeleteButtonPressed.call(row),
                  style: Theme.of(context)
                      .extension<AppButtonTheme>()!
                      .errorOutlined,
                  label: Text(Lang.of(context).crudDelete),
                ),
              ],
            );
          },
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
