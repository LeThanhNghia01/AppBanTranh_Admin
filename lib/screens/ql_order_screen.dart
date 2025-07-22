import 'package:app_ban_tranh_admin/models/user.dart';
import 'package:app_ban_tranh_admin/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QlOrderScreen extends StatefulWidget {
  final User user;

  const QlOrderScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<QlOrderScreen> createState() => _QlOrderScreenState();
}

class _QlOrderScreenState extends State<QlOrderScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Order> _orders = [];
  List<Order> _filteredOrders = [];
  String _selectedStatus = 'Tất cả';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _loadOrders();

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _filterOrdersByTab();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadOrders() {
    setState(() {
      _orders = OrderData.sampleOrders;
      _filteredOrders = _orders;
    });
  }

  void _filterOrdersByTab() {
    setState(() {
      switch (_tabController.index) {
        case 0:
          _selectedStatus = 'Tất cả';
          _filteredOrders = _orders;
          break;
        case 1:
          _selectedStatus = 'Chờ xác nhận';
          _filteredOrders = _orders
              .where((order) => order.status == OrderStatus.pending)
              .toList();
          break;
        case 2:
          _selectedStatus = 'Đã xác nhận';
          _filteredOrders = _orders
              .where((order) => order.status == OrderStatus.confirmed)
              .toList();
          break;
        case 3:
          _selectedStatus = 'Đang chuẩn bị';
          _filteredOrders = _orders
              .where((order) => order.status == OrderStatus.preparing)
              .toList();
          break;
        case 4:
          _selectedStatus = 'Đang giao hàng';
          _filteredOrders = _orders
              .where((order) => order.status == OrderStatus.shipping)
              .toList();
          break;
        case 5:
          _selectedStatus = 'Đã giao hàng';
          _filteredOrders = _orders
              .where((order) => order.status == OrderStatus.delivered)
              .toList();
          break;
        case 6:
          _selectedStatus = 'Đã hủy';
          _filteredOrders = _orders
              .where((order) => order.status == OrderStatus.cancelled)
              .toList();
          break;
        case 7:
          _selectedStatus = 'Đã trả hàng';
          _filteredOrders = _orders
              .where((order) => order.status == OrderStatus.returned)
              .toList();
          break;
      }
      _applySearchFilter();
    });
  }

  void _applySearchFilter() {
    if (_searchQuery.isEmpty) return;

    setState(() {
      _filteredOrders = _filteredOrders.where((order) {
        return order.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            order.customerName.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            order.customerPhone.contains(_searchQuery);
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _filterOrdersByTab();
  }

  void _showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (context) => OrderDetailDialog(
        order: order,
        onStatusChanged: (newStatus) {
          _updateOrderStatus(order.id, newStatus);
        },
      ),
    );
  }

  void _updateOrderStatus(String orderId, OrderStatus newStatus) {
    setState(() {
      int index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(status: newStatus);
        _filterOrdersByTab();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(160),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/logo_art.png',
                        height: 40,
                        width: 40,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Quản Lý Đơn Hàng',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Text(
                          '${_filteredOrders.length} đơn hàng',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm theo mã đơn, tên khách hàng...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.blue[600],
            labelColor: Colors.blue[600],
            unselectedLabelColor: Colors.grey[600],
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: 'Tất cả'),
              Tab(text: 'Chờ xác nhận'),
              Tab(text: 'Đã xác nhận'),
              Tab(text: 'Đang chuẩn bị'),
              Tab(text: 'Đang giao'),
              Tab(text: 'Đã giao'),
              Tab(text: 'Đã hủy'),
              Tab(text: 'Trả hàng'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(8, (index) => _buildOrderList()),
      ),
    );
  }

  Widget _buildOrderList() {
    if (_filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'Không có đơn hàng nào',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Các đơn hàng sẽ hiển thị tại đây',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        _loadOrders();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _filteredOrders.length,
        itemBuilder: (context, index) {
          final order = _filteredOrders[index];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showOrderDetails(order),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: order.status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: order.status.color.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      order.status.displayName,
                      style: TextStyle(
                        color: order.status.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    order.id,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Customer Info
              Row(
                children: [
                  Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.customerName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Icon(Icons.phone_outlined, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    order.customerPhone,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Address
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.customerAddress,
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Items Preview
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.palette_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${order.items.length} sản phẩm',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      NumberFormat.currency(
                        locale: 'vi_VN',
                        symbol: 'đ',
                      ).format(order.totalAmount),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.red[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),

              // Footer
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                  SizedBox(width: 4),
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(
                        order.isPaid ? Icons.check_circle : Icons.schedule,
                        size: 14,
                        color: order.isPaid ? Colors.green : Colors.orange,
                      ),
                      SizedBox(width: 4),
                      Text(
                        order.isPaid ? 'Đã thanh toán' : 'Chưa thanh toán',
                        style: TextStyle(
                          fontSize: 12,
                          color: order.isPaid ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dialog hiển thị chi tiết đơn hàng
class OrderDetailDialog extends StatefulWidget {
  final Order order;
  final Function(OrderStatus) onStatusChanged;

  const OrderDetailDialog({
    Key? key,
    required this.order,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  State<OrderDetailDialog> createState() => _OrderDetailDialogState();
}

class _OrderDetailDialogState extends State<OrderDetailDialog> {
  late OrderStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Chi tiết đơn hàng',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Info
                    _buildInfoSection('Thông tin đơn hàng', [
                      _buildInfoRow('Mã đơn hàng:', widget.order.id),
                      _buildInfoRow(
                        'Ngày đặt:',
                        DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(widget.order.orderDate),
                      ),
                      _buildStatusRow(),
                      _buildInfoRow('Thanh toán:', widget.order.paymentMethod),
                      _buildInfoRow(
                        'Tình trạng:',
                        widget.order.isPaid
                            ? 'Đã thanh toán'
                            : 'Chưa thanh toán',
                      ),
                      if (widget.order.deliveryDate != null)
                        _buildInfoRow(
                          'Ngày giao:',
                          DateFormat(
                            'dd/MM/yyyy',
                          ).format(widget.order.deliveryDate!),
                        ),
                      if (widget.order.notes != null &&
                          widget.order.notes!.isNotEmpty)
                        _buildInfoRow('Ghi chú:', widget.order.notes!),
                    ]),

                    SizedBox(height: 20),

                    // Customer Info
                    _buildInfoSection('Thông tin khách hàng', [
                      _buildInfoRow('Họ tên:', widget.order.customerName),
                      _buildInfoRow(
                        'Số điện thoại:',
                        widget.order.customerPhone,
                      ),
                      _buildInfoRow('Địa chỉ:', widget.order.customerAddress),
                    ]),

                    SizedBox(height: 20),

                    // Products
                    _buildProductsSection(),

                    SizedBox(height: 20),

                    // Total
                    _buildTotalSection(),
                  ],
                ),
              ),
            ),

            // Action buttons
            if (_canUpdateStatus())
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey[400]!),
                        ),
                        child: Text('Đóng'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _showStatusUpdateDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('Cập nhật trạng thái'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color ?? Colors.black,
                fontWeight: color != null ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              'Trạng thái:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _currentStatus.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _currentStatus.color.withOpacity(0.3),
                ),
              ),
              child: Text(
                _currentStatus.displayName,
                style: TextStyle(
                  color: _currentStatus.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sản phẩm đã đặt',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12),
        ...widget.order.items.map((item) => _buildProductItem(item)).toList(),
      ],
    );
  }

  Widget _buildProductItem(OrderItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: Icon(Icons.image, color: Colors.grey[400]),
          ),
          SizedBox(width: 12),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.paintingName,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'Kích thước: ${item.size}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                Text(
                  'Khung: ${item.frame}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),

          // Price and Quantity
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'x${item.quantity}',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                NumberFormat.currency(
                  locale: 'vi_VN',
                  symbol: 'đ',
                ).format(item.price),
                style: TextStyle(
                  color: Colors.red[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Text(
            'Tổng cộng:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          Spacer(),
          Text(
            NumberFormat.currency(
              locale: 'vi_VN',
              symbol: 'đ',
            ).format(widget.order.totalAmount),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            ),
          ),
        ],
      ),
    );
  }

  bool _canUpdateStatus() {
    return _currentStatus != OrderStatus.delivered &&
        _currentStatus != OrderStatus.cancelled &&
        _currentStatus != OrderStatus.returned;
  }

  void _showStatusUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => StatusUpdateDialog(
        currentStatus: _currentStatus,
        onStatusSelected: (newStatus) {
          setState(() {
            _currentStatus = newStatus;
          });
          widget.onStatusChanged(newStatus);
          Navigator.pop(context);
        },
      ),
    );
  }
}

// Dialog cập nhật trạng thái
class StatusUpdateDialog extends StatelessWidget {
  final OrderStatus currentStatus;
  final Function(OrderStatus) onStatusSelected;

  const StatusUpdateDialog({
    Key? key,
    required this.currentStatus,
    required this.onStatusSelected,
  }) : super(key: key);

  List<OrderStatus> _getAvailableStatuses() {
    switch (currentStatus) {
      case OrderStatus.pending:
        return [OrderStatus.confirmed, OrderStatus.cancelled];
      case OrderStatus.confirmed:
        return [OrderStatus.preparing, OrderStatus.cancelled];
      case OrderStatus.preparing:
        return [OrderStatus.shipping, OrderStatus.cancelled];
      case OrderStatus.shipping:
        return [OrderStatus.delivered, OrderStatus.returned];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableStatuses = _getAvailableStatuses();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Cập nhật trạng thái',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Chọn trạng thái mới cho đơn hàng:',
            style: TextStyle(color: Colors.grey[700]),
          ),
          SizedBox(height: 16),
          ...availableStatuses
              .map(
                (status) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: status.color.withOpacity(0.3)),
                    ),
                    child: Text(
                      status.displayName,
                      style: TextStyle(
                        color: status.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  onTap: () => onStatusSelected(status),
                ),
              )
              .toList(),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Hủy')),
      ],
    );
  }
}
