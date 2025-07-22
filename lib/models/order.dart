import 'dart:ui';

import 'package:flutter/material.dart';

class Order {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String paymentMethod;
  final bool isPaid;
  final String? notes;

  Order({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
    required this.paymentMethod,
    required this.isPaid,
    this.notes,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerAddress: json['customerAddress'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'].toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.pending,
      ),
      orderDate: DateTime.parse(json['orderDate']),
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
      paymentMethod: json['paymentMethod'],
      isPaid: json['isPaid'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status.toString().split('.').last,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'paymentMethod': paymentMethod,
      'isPaid': isPaid,
      'notes': notes,
    };
  }

  Order copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    List<OrderItem>? items,
    double? totalAmount,
    OrderStatus? status,
    DateTime? orderDate,
    DateTime? deliveryDate,
    String? paymentMethod,
    bool? isPaid,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPaid: isPaid ?? this.isPaid,
      notes: notes ?? this.notes,
    );
  }
}

class OrderItem {
  final String paintingId;
  final String paintingName;
  final String paintingImage;
  final double price;
  final int quantity;
  final String size;
  final String frame;

  OrderItem({
    required this.paintingId,
    required this.paintingName,
    required this.paintingImage,
    required this.price,
    required this.quantity,
    required this.size,
    required this.frame,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      paintingId: json['paintingId'],
      paintingName: json['paintingName'],
      paintingImage: json['paintingImage'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      size: json['size'],
      frame: json['frame'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paintingId': paintingId,
      'paintingName': paintingName,
      'paintingImage': paintingImage,
      'price': price,
      'quantity': quantity,
      'size': size,
      'frame': frame,
    };
  }

  double get subtotal => price * quantity;
}

enum OrderStatus {
  pending, // Chờ xác nhận
  confirmed, // Đã xác nhận
  preparing, // Đang chuẩn bị
  shipping, // Đang giao hàng
  delivered, // Đã giao hàng
  cancelled, // Đã hủy
  returned, // Đã trả hàng
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.confirmed:
        return 'Đã xác nhận';
      case OrderStatus.preparing:
        return 'Đang chuẩn bị';
      case OrderStatus.shipping:
        return 'Đang giao hàng';
      case OrderStatus.delivered:
        return 'Đã giao hàng';
      case OrderStatus.cancelled:
        return 'Đã hủy';
      case OrderStatus.returned:
        return 'Đã trả hàng';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.purple;
      case OrderStatus.shipping:
        return Colors.indigo;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.returned:
        return Colors.grey;
    }
  }
}

// Dữ liệu mẫu cho testing
class OrderData {
  static List<Order> sampleOrders = [
    Order(
      id: 'ORD001',
      customerId: 'CUST001',
      customerName: 'Nguyễn Văn An',
      customerPhone: '0912345678',
      customerAddress: '123 Đường Lê Lợi, Quận 1, TP.HCM',
      items: [
        OrderItem(
          paintingId: 'P001',
          paintingName: 'Phong Cảnh Núi Non',
          paintingImage: 'assets/images/painting1.jpg',
          price: 2500000,
          quantity: 1,
          size: '60x80cm',
          frame: 'Khung gỗ tự nhiên',
        ),
        OrderItem(
          paintingId: 'P002',
          paintingName: 'Hoa Sen Tím',
          paintingImage: 'assets/images/painting2.jpg',
          price: 1800000,
          quantity: 2,
          size: '40x60cm',
          frame: 'Khung nhôm trắng',
        ),
      ],
      totalAmount: 6100000,
      status: OrderStatus.pending,
      orderDate: DateTime.now().subtract(Duration(days: 1)),
      paymentMethod: 'COD',
      isPaid: false,
      notes: 'Giao hàng vào buổi sáng',
    ),
    Order(
      id: 'ORD002',
      customerId: 'CUST002',
      customerName: 'Trần Thị Bình',
      customerPhone: '0987654321',
      customerAddress: '456 Đường Nguyễn Huệ, Quận 3, TP.HCM',
      items: [
        OrderItem(
          paintingId: 'P003',
          paintingName: 'Trừu Tượng Hiện Đại',
          paintingImage: 'assets/images/painting3.jpg',
          price: 3200000,
          quantity: 1,
          size: '80x100cm',
          frame: 'Khung kim loại đen',
        ),
      ],
      totalAmount: 3200000,
      status: OrderStatus.confirmed,
      orderDate: DateTime.now().subtract(Duration(days: 3)),
      paymentMethod: 'Chuyển khoản',
      isPaid: true,
    ),
    Order(
      id: 'ORD003',
      customerId: 'CUST003',
      customerName: 'Lê Minh Cường',
      customerPhone: '0901234567',
      customerAddress: '789 Đường Pasteur, Quận 1, TP.HCM',
      items: [
        OrderItem(
          paintingId: 'P004',
          paintingName: 'Chân Dung Cổ Điển',
          paintingImage: 'assets/images/painting4.jpg',
          price: 4500000,
          quantity: 1,
          size: '50x70cm',
          frame: 'Khung gỗ cổ điển',
        ),
      ],
      totalAmount: 4500000,
      status: OrderStatus.shipping,
      orderDate: DateTime.now().subtract(Duration(days: 5)),
      deliveryDate: DateTime.now().add(Duration(days: 1)),
      paymentMethod: 'Thẻ tín dụng',
      isPaid: true,
      notes: 'Khách hàng VIP',
    ),
    Order(
      id: 'ORD004',
      customerId: 'CUST004',
      customerName: 'Phạm Thị Dung',
      customerPhone: '0934567890',
      customerAddress: '321 Đường Điện Biên Phủ, Quận Bình Thạnh, TP.HCM',
      items: [
        OrderItem(
          paintingId: 'P005',
          paintingName: 'Thiên Nhiên Hoang Dã',
          paintingImage: 'assets/images/painting5.jpg',
          price: 2800000,
          quantity: 1,
          size: '70x90cm',
          frame: 'Khung gỗ sồi',
        ),
      ],
      totalAmount: 2800000,
      status: OrderStatus.delivered,
      orderDate: DateTime.now().subtract(Duration(days: 10)),
      deliveryDate: DateTime.now().subtract(Duration(days: 2)),
      paymentMethod: 'COD',
      isPaid: true,
    ),
    Order(
      id: 'ORD005',
      customerId: 'CUST005',
      customerName: 'Hoàng Văn Em',
      customerPhone: '0967890123',
      customerAddress: '654 Đường Cộng Hòa, Quận Tân Bình, TP.HCM',
      items: [
        OrderItem(
          paintingId: 'P006',
          paintingName: 'Nghệ Thuật Đương Đại',
          paintingImage: 'assets/images/painting6.jpg',
          price: 1500000,
          quantity: 3,
          size: '30x40cm',
          frame: 'Khung nhựa',
        ),
      ],
      totalAmount: 4500000,
      status: OrderStatus.cancelled,
      orderDate: DateTime.now().subtract(Duration(days: 7)),
      paymentMethod: 'Chuyển khoản',
      isPaid: false,
      notes: 'Khách hàng hủy do thay đổi ý kiến',
    ),
  ];
}
