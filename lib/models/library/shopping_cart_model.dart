import 'package:biblia_palabra_de_vida_app/models/library/book_model.dart';

class ShoppingCartModel {
  final CartModel? cart;
  final List<CartItemModel> items;
  final int total;
  final int total_items;

  ShoppingCartModel(
      {this.cart,
      this.items = const [],
      required this.total,
      required this.total_items});

  factory ShoppingCartModel.fromJson(Map<String, dynamic> json) {
    return ShoppingCartModel(
        cart: json['cart'] != null ? CartModel.fromJson(json['cart']) : null,
        items: (json['items'] as List<dynamic>?)
                ?.map((item) => CartItemModel.fromJson(item))
                .toList() ??
            [],
        total: json['total'] ?? 0,
        total_items: json['total_items'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      "cart": cart?.toJson(),
      "items": items.map((item) => item.toJson()).toList(),
      "total": total,
      "total_items": total_items
    };
  }
}

class CartModel {
  final int id;
  final String user_id;
  final String? session_id;
  final String? created_at;
  final String? updated_at;

  CartModel({
    required this.id,
    required this.user_id,
    required this.session_id,
    required this.created_at,
    required this.updated_at,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        id: json['id'],
        user_id: json['user_id'],
        session_id: json['session_id'],
        created_at: json['created_at'],
        updated_at: json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": user_id,
      "session_id": session_id,
      "created_at": created_at,
      "updated_at": updated_at
    };
  }
}

class CartItemModel {
  final String id;
  final String cart_id;
  final String book_id;
  final BookModel? book;
  final int quantity;
  final double? unit_price;
  final String? format_type;
  final bool? selected;
  final DateTime? created_at;
  final DateTime? updated_at;

  CartItemModel({
    required this.id,
    required this.cart_id,
    required this.book_id,
    this.book,
    required this.quantity,
    this.format_type,
    this.unit_price= 0.0,
    this.selected = false,
    required this.created_at,
    required this.updated_at,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
        id: json['id'].toString(),
        cart_id: json['cart_id'].toString(),
        book_id: json['book_id'].toString(),
        book: json['book'] != null ? BookModel.fromJson(json['book']) : null,
        quantity: json['quantity'],
        format_type: json['format_type'],
        unit_price: json['unit_price'] != null
            ? double.parse(json['unit_price'].toString())
            : 0.0,
        selected: json['selected'] ?? false,
        created_at: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        updated_at: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null);
  }

  CartItemModel copyWith({
    String? id,
    String? cart_id,
    String? book_id,
    BookModel? book,
    int? quantity,
    String? format_type,  
    bool? selected,
    DateTime? created_at,
    DateTime? updated_at,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      cart_id: cart_id ?? this.cart_id,
      book_id: book_id ?? this.book_id,
      format_type: format_type ?? this.format_type,
      book: book ?? this.book,
      quantity: quantity ?? this.quantity,
      unit_price: unit_price ?? this.unit_price,
      selected: selected ?? this.selected,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "cart_id": cart_id,
      "book_id": book_id,
      "quantity": quantity,
      "selected": selected,
      "format_type": format_type,
      "unit_price": unit_price,
      "created_at": created_at,
      "updated_at": updated_at
    };
  }
}
