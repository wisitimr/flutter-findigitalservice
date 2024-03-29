part of 'product_list_bloc.dart';

@immutable
sealed class ProductEvent extends Equatable {
  const ProductEvent();
}

final class ProductStarted extends ProductEvent {
  const ProductStarted();

  @override
  List<Object> get props => [];
}

final class ProductSearchChanged extends ProductEvent {
  const ProductSearchChanged(this.text);

  final String text;

  @override
  List<Object> get props => [text];
}

final class ProductDeleteConfirm extends ProductEvent {
  const ProductDeleteConfirm(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

final class ProductDelete extends ProductEvent {
  const ProductDelete();

  @override
  List<Object> get props => [];
}
