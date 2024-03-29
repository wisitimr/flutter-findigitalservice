import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:findigitalservice/supplier/list/models/models.dart';
import 'package:findigitalservice/core/core.dart';
import 'package:findigitalservice/app_provider.dart';

part 'supplier_list_event.dart';
part 'supplier_list_state.dart';

class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  SupplierBloc(AppProvider provider)
      : _provider = provider,
        super(SupplierLoading()) {
    on<SupplierStarted>(_onStarted);
    on<SupplierSearchChanged>(_onSearchChanged);
    on<SupplierConfirm>(_onConfirm);
    on<SupplierDelete>(_onDelete);
  }

  final AppProvider _provider;
  final SupplierService _supplierService = SupplierService();

  Future<void> _onStarted(
      SupplierStarted event, Emitter<SupplierState> emit) async {
    emit(state.copyWith(status: SupplierStatus.loading));
    try {
      List<SupplierModel> suppliers = [];
      if (_provider.companyId.isNotEmpty) {
        Map<String, dynamic> param = {};
        param['company'] = _provider.companyId;
        final res = await _supplierService.findAll(_provider, param);
        if (res['statusCode'] == 200) {
          List data = res['data'];
          suppliers = data.map((item) => SupplierModel.fromJson(item)).toList();
        }
      }
      emit(
        state.copyWith(
          status: SupplierStatus.success,
          suppliers: suppliers,
          filter: suppliers,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: SupplierStatus.failure,
        message: e.toString(),
      ));
    }
  }

  void _onSearchChanged(
    SupplierSearchChanged event,
    Emitter<SupplierState> emit,
  ) {
    emit(state.copyWith(status: SupplierStatus.loading));
    var filter = event.text.isNotEmpty
        ? state.suppliers
            .where(
              (item) =>
                  item.code.toLowerCase().contains(event.text.toLowerCase()) ||
                  item.name.toLowerCase().contains(event.text.toLowerCase()),
            )
            .toList()
        : state.suppliers;
    emit(
      state.copyWith(
        status: SupplierStatus.success,
        suppliers: state.suppliers,
        filter: filter,
      ),
    );
  }

  Future<void> _onConfirm(
    SupplierConfirm event,
    Emitter<SupplierState> emit,
  ) async {
    emit(state.copyWith(status: SupplierStatus.loading));
    try {
      emit(
        state.copyWith(
          status: SupplierStatus.deleteConfirmation,
          selectedDeleteRowId: event.id,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: SupplierStatus.failure,
        message: e.toString(),
      ));
    }
  }

  Future<void> _onDelete(
    SupplierDelete event,
    Emitter<SupplierState> emit,
  ) async {
    emit(state.copyWith(status: SupplierStatus.loading));
    try {
      if (state.selectedDeleteRowId.isNotEmpty) {
        final res =
            await _supplierService.delete(_provider, state.selectedDeleteRowId);
        if (res['statusCode'] == 200) {
          emit(
            state.copyWith(
              status: SupplierStatus.deleted,
              message: res['statusMessage'],
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: SupplierStatus.failure,
              message: res['statusMessage'],
            ),
          );
        }
      } else {
        emit(state.copyWith(
          status: SupplierStatus.failure,
          message: "Invalid parameter",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: SupplierStatus.failure,
        message: e.toString(),
      ));
    }
  }
}
