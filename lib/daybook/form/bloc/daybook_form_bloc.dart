import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:saved/core/customer.dart';
import 'package:saved/core/document.dart';
import 'package:saved/core/daybook.dart';
import 'package:saved/app_provider.dart';
import 'package:saved/core/supplier.dart';
import 'package:saved/daybook/form/models/models.dart';
import 'package:saved/models/master/ms_customer.dart';
import 'package:saved/models/master/ms_document.dart';
import 'package:saved/models/master/ms_supplier.dart';

part 'daybook_form_event.dart';
part 'daybook_form_state.dart';

class DaybookFormBloc extends Bloc<DaybookFormEvent, DaybookFormState> {
  DaybookFormBloc() : super(DaybookFormLoading()) {
    on<DaybookFormStarted>(_onStarted);
    on<DaybookFormIdChanged>(_onIdChanged);
    on<DaybookFormNumberChanged>(_onNumberChanged);
    on<DaybookFormInvoiceChanged>(_onInvoiceChanged);
    on<DaybookFormDocumentChanged>(_onDocumentChanged);
    on<DaybookFormTransactionDateChanged>(_onTransactionDateChanged);
    on<DaybookFormCompanyChanged>(_onCompanyChanged);
    on<DaybookFormSupplierChanged>(_onSupplierChanged);
    on<DaybookFormCustomerChanged>(_onCustomerChanged);
    on<DaybookSubmitted>(_onSubmitted);
  }

  final DayBookService _daybookService = DayBookService();
  final DocumentService _documentService = DocumentService();
  final SupplierService _supplierService = SupplierService();
  final CustomerService _customerService = CustomerService();

  Future<void> _onStarted(
      DaybookFormStarted event, Emitter<DaybookFormState> emit) async {
    // emit(DaybookFormLoading());
    // emit(state.copyWith(isLoading: true));
    try {
      final AppProvider provider = event.provider;
      final [docRes, supRes, cusRes] = await Future.wait([
        _documentService.findAll(provider, {}),
        _supplierService.findAll(provider, {}),
        _customerService.findAll(provider, {}),
      ]);
      List<MsDocument> documents = [];
      List<MsSupplier> suppliers = [];
      List<MsCustomer> customers = [];
      final daybook = DaybookFormTmp();
      daybook.company = provider.companyId;
      if (event.id.isNotEmpty) {
        final invRes = await _daybookService.findById(provider, event.id);
        if (invRes != null && invRes['statusCode'] == 200) {
          DaybookFormModel data = DaybookFormModel.fromJson(invRes['data']);
          daybook.id = data.id;
          daybook.number = data.number;
          daybook.invoice = data.invoice;
          daybook.document = data.document;
          daybook.transactionDate = data.transactionDate;
          daybook.supplier = data.supplier;
          daybook.customer = data.customer;
          daybook.daybookDetail = data.daybookDetail;
        }
      }
      if (docRes['statusCode'] == 200) {
        List data = docRes['data'];
        documents = data.map((item) => MsDocument.fromJson(item)).toList();
      }
      if (supRes['statusCode'] == 200) {
        List data = supRes['data'];
        suppliers.addAll([
          const MsSupplier(
              id: '',
              code: '',
              name: '-- Select --',
              address: '',
              tax: '',
              phone: '',
              contact: '',
              company: ''),
          ...data.map((item) => MsSupplier.fromJson(item)).toList(),
        ]);
      }
      if (cusRes['statusCode'] == 200) {
        List data = cusRes['data'];
        customers.addAll([
          const MsCustomer(
              id: '',
              code: '',
              name: '-- Select --',
              address: '',
              tax: '',
              phone: '',
              contact: '',
              company: ''),
          ...data.map((item) => MsCustomer.fromJson(item)).toList(),
        ]);
      }
      if (documents.isNotEmpty) {
        if (daybook.document.isEmpty) {
          daybook.document = documents[0].id;
          daybook.documentType = documents[0].code;
        } else {
          for (var doc in documents) {
            if (doc.id == daybook.document) {
              daybook.documentType = doc.code;
            }
          }
        }
      }
      emit(state.copyWith(
        isLoading: false,
        msDocument: documents,
        msSupplier: suppliers,
        msCustomer: customers,
        id: Id.dirty(daybook.id),
        number: Number.dirty(daybook.number),
        invoice: Invoice.dirty(daybook.invoice),
        document: Document.dirty(daybook.document),
        documentType: daybook.documentType,
        transactionDate: TransactionDate.dirty(daybook.transactionDate),
        company: Company.dirty(daybook.company),
        supplier: Supplier.dirty(daybook.supplier),
        customer: Customer.dirty(daybook.customer),
        daybookDetail: daybook.daybookDetail,
        isValid: daybook.id.isNotEmpty,
      ));
    } catch (e) {
      // ignore: avoid_print
      print("Exception occured: $e");
      emit(DaybookFormError());
    }
  }

  void _onIdChanged(
    DaybookFormIdChanged event,
    Emitter<DaybookFormState> emit,
  ) {
    final id = Id.dirty(event.id);
    emit(
      state.copyWith(
        id: id,
        isValid: validateWithDocumentInput(
          [
            state.number,
            state.invoice,
            state.document,
            state.transactionDate,
            state.company
          ],
          false,
        ),
      ),
    );
  }

  void _onNumberChanged(
    DaybookFormNumberChanged event,
    Emitter<DaybookFormState> emit,
  ) {
    final number = Number.dirty(event.number);
    emit(
      state.copyWith(
        number: number,
        isValid: validateWithDocumentInput(
          [
            number,
            state.invoice,
            state.document,
            state.transactionDate,
            state.company,
          ],
          false,
        ),
      ),
    );
  }

  void _onInvoiceChanged(
    DaybookFormInvoiceChanged event,
    Emitter<DaybookFormState> emit,
  ) {
    final invoice = Invoice.dirty(event.invoice);
    emit(
      state.copyWith(
        invoice: invoice,
        isValid: validateWithDocumentInput(
          [
            state.number,
            invoice,
            state.document,
            state.transactionDate,
            state.company,
          ],
          false,
        ),
      ),
    );
  }

  void _onDocumentChanged(
    DaybookFormDocumentChanged event,
    Emitter<DaybookFormState> emit,
  ) {
    final document = Document.dirty(event.document);
    String documentType = '';
    if (state.msDocument.isNotEmpty) {
      for (var doc in state.msDocument) {
        if (doc.id == document.value) {
          documentType = doc.code;
          break;
        }
      }
    }
    switch (documentType) {
      case 'PAY':
        emit(state.copyWith(customer: const Customer.dirty("")));
        break;
      case 'REC':
        emit(state.copyWith(supplier: const Supplier.dirty("")));
        break;
    }
    emit(
      state.copyWith(
        document: document,
        documentType: documentType,
        isValid: validateWithDocumentInput(
          [
            state.number,
            state.invoice,
            document,
            state.transactionDate,
            state.company,
          ],
          false,
        ),
      ),
    );
  }

  void _onTransactionDateChanged(
    DaybookFormTransactionDateChanged event,
    Emitter<DaybookFormState> emit,
  ) {
    final transactionDate = TransactionDate.dirty(event.transactionDate);
    emit(
      state.copyWith(
        transactionDate: transactionDate,
        isValid: validateWithDocumentInput(
          [
            state.number,
            state.invoice,
            state.document,
            transactionDate,
            state.company,
          ],
          false,
        ),
      ),
    );
  }

  void _onCompanyChanged(
    DaybookFormCompanyChanged event,
    Emitter<DaybookFormState> emit,
  ) {
    final company = Company.dirty(event.company);
    emit(
      state.copyWith(
        company: company,
        isValid: validateWithDocumentInput(
          [
            state.number,
            state.invoice,
            state.document,
            state.transactionDate,
            company,
          ],
          false,
        ),
      ),
    );
  }

  void _onSupplierChanged(
    DaybookFormSupplierChanged event,
    Emitter<DaybookFormState> emit,
  ) {
    final supplier = Supplier.dirty(event.supplier);
    emit(
      state.copyWith(
        supplier: supplier,
        isValid: validateWithDocumentInput(
          [
            state.number,
            state.invoice,
            state.document,
            state.transactionDate,
            state.company,
            supplier,
          ],
          true,
        ),
      ),
    );
  }

  void _onCustomerChanged(
    DaybookFormCustomerChanged event,
    Emitter<DaybookFormState> emit,
  ) {
    final customer = Customer.dirty(event.customer);
    emit(
      state.copyWith(
        customer: customer,
        isValid: validateWithDocumentInput(
          [
            state.number,
            state.invoice,
            state.document,
            state.transactionDate,
            state.company,
            customer,
          ],
          true,
        ),
      ),
    );
  }

  Future<void> _onSubmitted(
    DaybookSubmitted event,
    Emitter<DaybookFormState> emit,
  ) async {
    final AppProvider provider = event.provider;
    if (state.isValid) {
      try {
        final Map<String, dynamic> data = {};
        data['id'] = state.id.value;
        data['number'] = state.number.value;
        data['invoice'] = state.invoice.value;
        data['document'] = state.document.value;
        data['transactionDate'] = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
            .format(DateTime.parse(state.transactionDate.value));
        data['company'] = state.company.value;
        switch (state.documentType) {
          case 'PAY':
            data['supplier'] = state.supplier.value;
            data['customer'] = null;
            break;
          case 'REC':
            data['supplier'] = null;
            data['customer'] = state.customer.value;
            break;
        }
        List<String> daybookDetail = [];
        if (state.daybookDetail.isNotEmpty) {
          for (var d in state.daybookDetail) {
            daybookDetail.add(d.id);
          }
        }
        data['daybookDetails'] = daybookDetail;
        dynamic res = await _daybookService.save(provider, data);

        if (res['statusCode'] == 200 || res['statusCode'] == 201) {
          emit(state.copyWith(
              status: FormzSubmissionStatus.success,
              message: res['statusMessage']));
        } else {
          emit(state.copyWith(
              status: FormzSubmissionStatus.failure,
              message: res['statusMessage']));
        }
      } catch (e) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }

  bool validateWithDocumentInput(
      List<FormzInput<dynamic, dynamic>> validateInput, bool ignore) {
    if (!ignore) {
      switch (state.documentType) {
        case 'PAY':
          validateInput.add(state.supplier);
          break;
        case 'REC':
          validateInput.add(state.customer);
          break;
      }
    }
    return Formz.validate(validateInput);
  }
}

class DaybookFormTmp {
  String id = '';
  String number = '';
  String invoice = '';
  String document = '';
  String documentType = '';
  String transactionDate =
      DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now());
  String company = '';
  String supplier = '';
  String customer = '';
  List<DaybookDetailListModel> daybookDetail = [];
}
