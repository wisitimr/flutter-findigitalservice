part of 'my_profile_bloc.dart';

enum MyProfileStatus {
  loading,
  success,
  failure,
  deleteConfirmation,
  deleted,
  submitConfirmation,
  submited,
  selected,
}

extension MyProfileStatusX on MyProfileStatus {
  bool get isLoading => this == MyProfileStatus.loading;
  bool get isSuccess => this == MyProfileStatus.success;
  bool get isFailure => this == MyProfileStatus.failure;
  bool get isDeleteConfirmation => this == MyProfileStatus.deleteConfirmation;
  bool get isDeleted => this == MyProfileStatus.deleted;
  bool get isSubmitConfirmation => this == MyProfileStatus.submitConfirmation;
  bool get isSubmited => this == MyProfileStatus.submited;
  bool get isSelected => this == MyProfileStatus.selected;
}

final class MyProfileState extends Equatable {
  const MyProfileState({
    this.status = MyProfileStatus.loading,
    this.message = '',
    this.imageUrl = '',
    this.id = const Id.pure(),
    this.username = const Username.pure(),
    this.firstName = const FirstName.pure(),
    this.lastName = const LastName.pure(),
    this.email = const Email.pure(),
    this.role = const Role.pure(),
    this.companies = const <CompanyModel>[],
    this.companySelected = '',
    this.companyNameSelected = '',
    this.selectedDeleteRowId = '',
    this.isValid = false,
  });

  final MyProfileStatus status;
  final String message;
  final String imageUrl;
  final Id id;
  final Username username;
  final FirstName firstName;
  final LastName lastName;
  final Email email;
  final Role role;
  final List<CompanyModel> companies;
  final String companySelected;
  final String companyNameSelected;
  final String selectedDeleteRowId;
  final bool isValid;

  MyProfileState copyWith({
    MyProfileStatus? status,
    String? message,
    String? imageUrl,
    Id? id,
    Username? username,
    FirstName? firstName,
    LastName? lastName,
    Email? email,
    Role? role,
    List<CompanyModel>? companies,
    String? companySelected,
    String? companyNameSelected,
    String? selectedDeleteRowId,
    bool? isValid,
  }) {
    return MyProfileState(
      status: status ?? this.status,
      message: message ?? this.message,
      imageUrl: imageUrl ?? this.imageUrl,
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
      companies: companies ?? this.companies,
      companySelected: companySelected ?? this.companySelected,
      companyNameSelected: companyNameSelected ?? this.companyNameSelected,
      selectedDeleteRowId: selectedDeleteRowId ?? this.selectedDeleteRowId,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [
        status,
        imageUrl,
        id,
        username,
        firstName,
        lastName,
        email,
        role,
        companies,
        companySelected,
        companyNameSelected,
        selectedDeleteRowId,
        isValid
      ];
}

final class MyProfileLoading extends MyProfileState {
  @override
  List<Object> get props => [];
}

final class MyProfileError extends MyProfileState {
  @override
  List<Object> get props => [];
}
