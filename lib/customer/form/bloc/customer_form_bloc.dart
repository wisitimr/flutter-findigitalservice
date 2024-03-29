import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:findigitalservice/core/core.dart';
import 'package:findigitalservice/app_provider.dart';
import 'package:findigitalservice/customer/form/models/customer_form_model.dart';
import 'package:findigitalservice/customer/form/models/models.dart';

part 'customer_form_event.dart';
part 'customer_form_state.dart';

class CustomerFormBloc extends Bloc<CustomerFormEvent, CustomerFormState> {
  CustomerFormBloc(AppProvider provider)
      : _provider = provider,
        super(CustomerFormLoading()) {
    on<CustomerFormStarted>(_onStarted);
    on<CustomerFormIdChanged>(_onIdChanged);
    on<CustomerFormCodeChanged>(_onCodeChanged);
    on<CustomerFormNameChanged>(_onNameChanged);
    on<CustomerFormAddressChanged>(_onAddressChanged);
    on<CustomerFormPhoneChanged>(_onPhoneChanged);
    on<CustomerFormContactChanged>(_onContactChanged);
    on<CustomerFormSubmitConfirm>(_onConfirm);
    on<CustomerSubmitted>(_onSubmitted);
  }

  final AppProvider _provider;
  final CustomerService _customerService = CustomerService();

  Future<void> _onStarted(
      CustomerFormStarted event, Emitter<CustomerFormState> emit) async {
    // emit(CustomerFormLoading());
    emit(state.copyWith(status: CustomerFormStatus.loading));
    try {
      final customer = CustomerFormTmp();
      if (event.id.isNotEmpty) {
        final res = await _customerService.findById(_provider, event.id);
        if (res != null && res['statusCode'] == 200) {
          CustomerFormModel data = CustomerFormModel.fromJson(res['data']);
          customer.id = data.id;
          customer.code = data.code;
          customer.name = data.name;
          customer.address = data.address;
          customer.phone = data.phone;
          customer.contact = data.contact;
        }
      }

      final id = Id.dirty(customer.id);
      final code = Code.dirty(customer.code);
      final name = Name.dirty(customer.name);
      final address = Address.dirty(customer.address);
      final phone = Phone.dirty(customer.phone);
      final contact = Contact.dirty(customer.contact);

      emit(state.copyWith(
        status: CustomerFormStatus.success,
        id: id,
        code: code,
        name: name,
        address: address,
        phone: phone,
        contact: contact,
        isValid: Formz.validate(
          [
            state.code,
            state.name,
          ],
        ),
      ));
    } catch (e) {
      emit(
        state.copyWith(
          status: CustomerFormStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  void _onIdChanged(
    CustomerFormIdChanged event,
    Emitter<CustomerFormState> emit,
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
    CustomerFormCodeChanged event,
    Emitter<CustomerFormState> emit,
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
    CustomerFormNameChanged event,
    Emitter<CustomerFormState> emit,
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

  void _onAddressChanged(
    CustomerFormAddressChanged event,
    Emitter<CustomerFormState> emit,
  ) {
    final address = Address.dirty(event.address);
    emit(
      state.copyWith(
        address: address,
        isValid: Formz.validate(
          [
            state.code,
            state.name,
          ],
        ),
      ),
    );
  }

  void _onPhoneChanged(
    CustomerFormPhoneChanged event,
    Emitter<CustomerFormState> emit,
  ) {
    final phone = Phone.dirty(event.phone);
    emit(
      state.copyWith(
        phone: phone,
        isValid: Formz.validate(
          [
            state.code,
            state.name,
          ],
        ),
      ),
    );
  }

  void _onContactChanged(
    CustomerFormContactChanged event,
    Emitter<CustomerFormState> emit,
  ) {
    final contact = Contact.dirty(event.contact);
    emit(
      state.copyWith(
        contact: contact,
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
    CustomerFormSubmitConfirm event,
    Emitter<CustomerFormState> emit,
  ) async {
    emit(state.copyWith(status: CustomerFormStatus.loading));
    try {
      emit(
        state.copyWith(
          status: CustomerFormStatus.submitConfirmation,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: CustomerFormStatus.failure,
        message: e.toString(),
      ));
    }
  }

  Future<void> _onSubmitted(
    CustomerSubmitted event,
    Emitter<CustomerFormState> emit,
  ) async {
    if (state.isValid) {
      try {
        final Map<String, dynamic> data = {};
        data['id'] = state.id.value;
        data['code'] = state.code.value;
        data['name'] = state.name.value;
        data['address'] = state.address.value;
        data['phone'] = state.phone.value;
        data['contact'] = state.contact.value;
        data['company'] = _provider.companyId;

        dynamic res = await _customerService.save(_provider, data);
        if (res['statusCode'] == 200 || res['statusCode'] == 201) {
          emit(state.copyWith(
              status: CustomerFormStatus.submited,
              message: res['statusMessage']));
        } else {
          emit(state.copyWith(
              status: CustomerFormStatus.failure,
              message: res['statusMessage']));
        }
      } catch (e) {
        emit(state.copyWith(status: CustomerFormStatus.failure));
      }
    }
  }
}

class CustomerFormTmp {
  String id = '';
  String code = '';
  String name = '';
  String address = '';
  String phone = '';
  String contact = '';
}
