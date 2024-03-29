import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:findigitalservice/core/core.dart';
import 'package:findigitalservice/app_provider.dart';
import 'package:findigitalservice/product/form/models/product_form_model.dart';
import 'package:findigitalservice/product/form/models/models.dart';

part 'product_form_event.dart';
part 'product_form_state.dart';

class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  ProductFormBloc(AppProvider provider)
      : _provider = provider,
        super(ProductFormLoading()) {
    on<ProductFormStarted>(_onStarted);
    on<ProductFormIdChanged>(_onIdChanged);
    on<ProductFormCodeChanged>(_onCodeChanged);
    on<ProductFormNameChanged>(_onNameChanged);
    on<ProductFormDescriptionChanged>(_onDescriptionChanged);
    on<ProductFormPriceChanged>(_onPriceChanged);
    on<ProductFormSubmitConfirm>(_onConfirm);
    on<ProductSubmitted>(_onSubmitted);
  }

  final AppProvider _provider;
  final ProductService _productService = ProductService();

  Future<void> _onStarted(
      ProductFormStarted event, Emitter<ProductFormState> emit) async {
    // emit(ProductFormLoading());
    emit(state.copyWith(status: ProductFormStatus.loading));
    try {
      final product = ProductFormTmp();
      if (event.id.isNotEmpty) {
        final res = await _productService.findById(_provider, event.id);
        if (res != null && res['statusCode'] == 200) {
          ProductFormModel data = ProductFormModel.fromJson(res['data']);
          product.id = data.id;
          product.code = data.code;
          product.name = data.name;
          product.description = data.description;
          product.price = data.price.toStringAsFixed(2);
        }
      }

      final id = Id.dirty(product.id);
      final code = Code.dirty(product.code);
      final name = Name.dirty(product.name);
      final description = Description.dirty(product.description);
      final price = Price.dirty(product.price);

      emit(
        state.copyWith(
          status: ProductFormStatus.success,
          id: id,
          code: code,
          name: name,
          description: description,
          price: price,
          isValid: Formz.validate(
            [
              state.code,
              state.name,
            ],
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductFormStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  void _onIdChanged(
    ProductFormIdChanged event,
    Emitter<ProductFormState> emit,
  ) {
    final id = Id.dirty(event.id);
    emit(
      state.copyWith(
        id: id,
        isValid: Formz.validate(
          [
            state.code,
            state.name,
          ],
        ),
      ),
    );
  }

  void _onCodeChanged(
    ProductFormCodeChanged event,
    Emitter<ProductFormState> emit,
  ) {
    final code = Code.dirty(event.code);
    emit(
      state.copyWith(
        code: code,
        isValid: Formz.validate(
          [
            code,
            state.name,
          ],
        ),
      ),
    );
  }

  void _onNameChanged(
    ProductFormNameChanged event,
    Emitter<ProductFormState> emit,
  ) {
    final name = Name.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
        isValid: Formz.validate(
          [
            state.code,
            name,
          ],
        ),
      ),
    );
  }

  void _onDescriptionChanged(
    ProductFormDescriptionChanged event,
    Emitter<ProductFormState> emit,
  ) {
    final description = Description.dirty(event.description);
    emit(
      state.copyWith(
        description: description,
        isValid: Formz.validate(
          [
            state.code,
            state.name,
          ],
        ),
      ),
    );
  }

  void _onPriceChanged(
    ProductFormPriceChanged event,
    Emitter<ProductFormState> emit,
  ) {
    final price = Price.dirty(event.price);
    emit(
      state.copyWith(
        price: price,
        isValid: Formz.validate(
          [
            state.code,
            state.name,
          ],
        ),
      ),
    );
  }

  Future<void> _onConfirm(
    ProductFormSubmitConfirm event,
    Emitter<ProductFormState> emit,
  ) async {
    emit(state.copyWith(status: ProductFormStatus.loading));
    try {
      emit(
        state.copyWith(
          status: ProductFormStatus.submitConfirmation,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: ProductFormStatus.failure,
        message: e.toString(),
      ));
    }
  }

  Future<void> _onSubmitted(
    ProductSubmitted event,
    Emitter<ProductFormState> emit,
  ) async {
    if (state.isValid) {
      try {
        final Map<String, dynamic> data = {};
        data['id'] = state.id.value;
        data['code'] = state.code.value;
        data['name'] = state.name.value;
        data['description'] = state.description.value;
        data['price'] = double.parse(state.price.value);
        data['company'] = _provider.companyId;

        dynamic res = await _productService.save(_provider, data);
        if (res['statusCode'] == 200 || res['statusCode'] == 201) {
          emit(state.copyWith(
              status: ProductFormStatus.submited,
              message: res['statusMessage']));
        } else {
          emit(state.copyWith(
              status: ProductFormStatus.failure,
              message: res['statusMessage']));
        }
      } catch (e) {
        emit(state.copyWith(status: ProductFormStatus.failure));
      }
    }
  }
}

class ProductFormTmp {
  String id = '';
  String code = '';
  String name = '';
  String description = '';
  String price = '';
}
