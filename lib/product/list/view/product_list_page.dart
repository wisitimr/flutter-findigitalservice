import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:saved/product/list/product_list.dart';
import 'package:saved/app_router.dart';
import 'package:saved/constants/dimens.dart';
import 'package:saved/generated/l10n.dart';
import 'package:saved/app_provider.dart';
import 'package:saved/theme/theme_extensions/app_button_theme.dart';
import 'package:saved/theme/theme_extensions/app_data_table_theme.dart';
import 'package:saved/widgets/card_elements.dart';
import 'package:saved/widgets/portal_master_layout/portal_master_layout.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ProductPage());
  }
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();

    return PortalMasterLayout(
      body: BlocProvider(
        create: (context) {
          return ProductBloc()..add(ProductStarted(provider));
        },
        child: ListView(
          padding: const EdgeInsets.all(kDefaultPadding),
          children: const [
            Padding(
                padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
                child: Product()),
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
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appDataTableTheme = themeData.extension<AppDataTableTheme>()!;
    final dataTableHorizontalScrollController = ScrollController();

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
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
                                  GoRouter.of(context).go(RouteUri.productFrom),
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
                                  controller:
                                      dataTableHorizontalScrollController,
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
                                            columns: [
                                              DataColumn(
                                                  label: Text(lang.code)),
                                              DataColumn(
                                                  label: Text(lang.name)),
                                              DataColumn(
                                                  label: Text(lang.detail)),
                                              DataColumn(
                                                  label: Text(lang.price)),
                                              DataColumn(
                                                  label: Text(lang.createdAt)),
                                              DataColumn(
                                                  label: Text(lang.updatedAt)),
                                              const DataColumn(
                                                  label: Text('...')),
                                            ],
                                            source: _DataSource(
                                              data: state.products,
                                              context: context,
                                              onDetailButtonPressed: (data) =>
                                                  GoRouter.of(context).go(
                                                      '${RouteUri.productFrom}?id=${data.id}'),
                                              onDeleteButtonPressed: (data) {},
                                            ),
                                          )

                                          // DataTable(
                                          //   showCheckboxColumn: false,
                                          //   showBottomBorder: true,
                                          //   columns: [
                                          //     DataColumn(label: Text(lang.code)),
                                          //     DataColumn(label: Text(lang.name)),
                                          //     DataColumn(
                                          //         label: Text(lang.description)),
                                          //     DataColumn(
                                          //         label: Text(lang.createdAt)),
                                          //     DataColumn(
                                          //         label: Text(lang.updatedAt)),
                                          //   ],
                                          //   rows: List.generate(
                                          //       state.products.length, (index) {
                                          //     ProductModel row =
                                          //         state.products[index];
                                          //     var createdAt = inputFormat
                                          //         .parse(row.createdAt);
                                          //     var updatedAt = inputFormat
                                          //         .parse(row.updatedAt);
                                          //     return DataRow(
                                          //         cells: [
                                          //           DataCell(Text(row.code)),
                                          //           DataCell(Text(row.name)),
                                          //           DataCell(
                                          //               Text(row.description)),
                                          //           DataCell(Text(outputFormat
                                          //               .format(createdAt))),
                                          //           DataCell(Text(outputFormat
                                          //               .format(updatedAt))),
                                          //         ],
                                          //         onSelectChanged: (value) {
                                          //           final query = '?id=${row.id}';
                                          //           GoRouter.of(context).go(
                                          //               '${RouteUri.userForm}$query');
                                          //         });
                                          //   }).toList(),
                                          // ),
                                          ),
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
      },
    );
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
        DataCell(Text(row.detail)),
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
                  child: OutlinedButton(
                    onPressed: () => onDetailButtonPressed.call(row),
                    style: Theme.of(context)
                        .extension<AppButtonTheme>()!
                        .infoOutlined,
                    child: Text(Lang.of(context).crudDetail),
                  ),
                ),
                OutlinedButton(
                  onPressed: () => onDeleteButtonPressed.call(row),
                  style: Theme.of(context)
                      .extension<AppButtonTheme>()!
                      .errorOutlined,
                  child: Text(Lang.of(context).crudDelete),
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
