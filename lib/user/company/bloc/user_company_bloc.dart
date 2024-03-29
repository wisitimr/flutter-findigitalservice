import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:findigitalservice/user/company/models/models.dart';
import 'package:findigitalservice/app_provider.dart';
import 'package:findigitalservice/core/core.dart';

part 'user_company_event.dart';
part 'user_company_state.dart';

class UserCompanyBloc extends Bloc<UserCompanyEvent, UserCompanyState> {
  UserCompanyBloc({
    required AppProvider provider,
  })  : _provider = provider,
        super(UserCompanyLoading()) {
    on<UserCompanyStarted>(_onStarted);
    on<UserCompanyIdChanged>(_onIdChanged);
    on<UserCompanyNameChanged>(_onNameChanged);
    on<UserCompanyDescriptionChanged>(_onDescriptionChanged);
    on<UserCompanyAddressChanged>(_onAddressChanged);
    on<UserCompanyPhoneChanged>(_onPhoneChanged);
    on<UserCompanyContactChanged>(_onContactChanged);
    on<UserCompanySubmitConfirm>(_onConfirm);
    on<UserCompanySubmitted>(_onSubmitted);
  }

  final AppProvider _provider;
  final CompanyService _companyService = CompanyService();

  Future<void> _onStarted(
      UserCompanyStarted event, Emitter<UserCompanyState> emit) async {
    emit(state.copyWith(status: UserCompanyStatus.loading));
    try {
      final company = UserCompanyTmp();
      if (event.id.isNotEmpty) {
        final res = await _companyService.findById(_provider, event.id);
        if (res != null && res['statusCode'] == 200) {
          UserCompanyModel data = UserCompanyModel.fromJson(res['data']);
          company.id = data.id;
          company.name = data.name;
          company.description = data.description;
          company.address = data.address;
          company.phone = data.phone;
          company.contact = data.contact;
        }
      }
      emit(state.copyWith(
        status: UserCompanyStatus.success,
        id: Id.dirty(company.id),
        name: Name.dirty(company.name),
        description: Description.dirty(company.description),
        address: Address.dirty(company.address),
        phone: Phone.dirty(company.phone),
        contact: Contact.dirty(company.contact),
        isValid: company.id.isNotEmpty,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UserCompanyStatus.failure,
        message: e.toString(),
      ));
    }
  }

  void _onIdChanged(
    UserCompanyIdChanged event,
    Emitter<UserCompanyState> emit,
  ) {
    final id = Id.dirty(event.id);
    emit(
      state.copyWith(
        id: id,
        isValid: Formz.validate(
          [
            state.name,
          ],
        ),
      ),
    );
  }

  void _onNameChanged(
    UserCompanyNameChanged event,
    Emitter<UserCompanyState> emit,
  ) {
    final name = Name.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
        isValid: Formz.validate(
          [
            name,
          ],
        ),
      ),
    );
  }

  void _onDescriptionChanged(
    UserCompanyDescriptionChanged event,
    Emitter<UserCompanyState> emit,
  ) {
    final description = Description.dirty(event.description);
    emit(
      state.copyWith(
        description: description,
        isValid: Formz.validate(
          [
            state.name,
            description,
            state.address,
            state.phone,
            state.contact,
          ],
        ),
      ),
    );
  }

  void _onAddressChanged(
    UserCompanyAddressChanged event,
    Emitter<UserCompanyState> emit,
  ) {
    final address = Address.dirty(event.address);
    emit(
      state.copyWith(
        address: address,
        isValid: Formz.validate(
          [
            state.name,
          ],
        ),
      ),
    );
  }

  void _onPhoneChanged(
    UserCompanyPhoneChanged event,
    Emitter<UserCompanyState> emit,
  ) {
    final phone = Phone.dirty(event.phone);
    emit(
      state.copyWith(
        phone: phone,
        isValid: Formz.validate(
          [
            state.name,
          ],
        ),
      ),
    );
  }

  void _onContactChanged(
    UserCompanyContactChanged event,
    Emitter<UserCompanyState> emit,
  ) {
    final contact = Contact.dirty(event.contact);
    emit(
      state.copyWith(
        contact: contact,
        isValid: Formz.validate(
          [
            state.name,
          ],
        ),
      ),
    );
  }

  Future<void> _onConfirm(
    UserCompanySubmitConfirm event,
    Emitter<UserCompanyState> emit,
  ) async {
    emit(state.copyWith(status: UserCompanyStatus.loading));
    try {
      emit(
        state.copyWith(
          status: UserCompanyStatus.submitConfirmation,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: UserCompanyStatus.failure,
        message: e.toString(),
      ));
    }
  }

  Future<void> _onSubmitted(
    UserCompanySubmitted event,
    Emitter<UserCompanyState> emit,
  ) async {
    try {
      final Map<String, dynamic> data = {};
      if (state.id.isValid) {
        data['id'] = state.id.value;
      } else {
        data['id'] = null;
      }
      data['name'] = state.name.value;
      data['description'] = state.description.value;
      data['address'] = state.address.value;
      data['phone'] = state.phone.value;
      data['contact'] = state.contact.value;

      dynamic res = await _companyService.save(_provider, data);

      if (res['statusCode'] == 200 || res['statusCode'] == 201) {
        emit(state.copyWith(
            status: UserCompanyStatus.success, message: res['statusMessage']));
      } else {
        emit(state.copyWith(
            status: UserCompanyStatus.failure, message: res['statusMessage']));
      }
    } catch (e) {
      emit(state.copyWith(
        status: UserCompanyStatus.failure,
        message: e.toString(),
      ));
    }
  }
}

class UserCompanyTmp {
  String id = '';
  String name = '';
  String description = '';
  String address = '';
  String phone = '';
  String contact = '';
}
