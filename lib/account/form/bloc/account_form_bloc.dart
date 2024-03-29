import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:findigitalservice/core/core.dart';
import 'package:findigitalservice/app_provider.dart';
import 'package:findigitalservice/account/form/models/account_form_model.dart';
import 'package:findigitalservice/account/form/models/models.dart';

part 'account_form_event.dart';
part 'account_form_state.dart';

class AccountFormBloc extends Bloc<AccountFormEvent, AccountFormState> {
  AccountFormBloc(AppProvider provider)
      : _provider = provider,
        super(AccountFormLoading()) {
    on<AccountFormStarted>(_onStarted);
    on<AccountFormIdChanged>(_onIdChanged);
    on<AccountFormCodeChanged>(_onCodeChanged);
    on<AccountFormNameChanged>(_onNameChanged);
    on<AccountFormDescriptionChanged>(_onDescriptionChanged);
    on<AccountFormTypeChanged>(_onTypeChanged);
    on<AccountFormSubmitConfirm>(_onConfirm);
    on<AccountSubmitted>(_onSubmitted);
  }

  final AppProvider _provider;
  final AccountService _accountService = AccountService();

  Future<void> _onStarted(
      AccountFormStarted event, Emitter<AccountFormState> emit) async {
    // emit(AccountFormLoading());
    emit(state.copyWith(status: AccountFormStatus.loading));
    try {
      final account = AccountFormTmp();
      if (event.id.isNotEmpty) {
        final res = await _accountService.findById(_provider, event.id);
        if (res != null && res['statusCode'] == 200) {
          AccountFormModel data = AccountFormModel.fromJson(res['data']);
          account.id = data.id;
          account.code = data.code;
          account.name = data.name;
          account.description = data.description;
          account.type = data.type;
        }
      }
      final id = Id.dirty(account.id);
      final code = Code.dirty(account.code);
      final name = Name.dirty(account.name);
      final description = Description.dirty(account.description);
      final type = Type.dirty(account.type);

      emit(state.copyWith(
        status: AccountFormStatus.success,
        id: id,
        code: code,
        name: name,
        description: description,
        type: type,
        isValid: Formz.validate(
          [
            state.code,
            state.name,
          ],
        ),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AccountFormStatus.failure,
        message: e.toString(),
      ));
    }
  }

  void _onIdChanged(
    AccountFormIdChanged event,
    Emitter<AccountFormState> emit,
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
    AccountFormCodeChanged event,
    Emitter<AccountFormState> emit,
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
    AccountFormNameChanged event,
    Emitter<AccountFormState> emit,
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
    AccountFormDescriptionChanged event,
    Emitter<AccountFormState> emit,
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

  void _onTypeChanged(
    AccountFormTypeChanged event,
    Emitter<AccountFormState> emit,
  ) {
    final type = Type.dirty(event.type);
    emit(
      state.copyWith(
        type: type,
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
    AccountFormSubmitConfirm event,
    Emitter<AccountFormState> emit,
  ) async {
    emit(state.copyWith(status: AccountFormStatus.loading));
    try {
      emit(
        state.copyWith(
          status: AccountFormStatus.submitConfirmation,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: AccountFormStatus.failure,
        message: e.toString(),
      ));
    }
  }

  Future<void> _onSubmitted(
    AccountSubmitted event,
    Emitter<AccountFormState> emit,
  ) async {
    if (state.isValid) {
      try {
        final Map<String, dynamic> data = {};
        data['id'] = state.id.value;
        data['code'] = state.code.value;
        data['name'] = state.name.value;
        data['description'] = state.description.value;
        data['type'] = state.type.value;
        data['company'] = _provider.companyId;
        dynamic res = await _accountService.save(_provider, data);
        if (res['statusCode'] == 200 || res['statusCode'] == 201) {
          emit(state.copyWith(
            status: AccountFormStatus.submited,
            message: res['statusMessage'],
          ));
        } else {
          emit(state.copyWith(
            status: AccountFormStatus.failure,
            message: res['statusMessage'],
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          status: AccountFormStatus.failure,
          message: e.toString(),
        ));
      }
    }
  }
}

class AccountFormTmp {
  String id = '';
  String code = '';
  String name = '';
  String description = '';
  String type = '';
}
