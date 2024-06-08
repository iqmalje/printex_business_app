import 'package:intl/intl.dart';
import 'package:printex_business_app/model/order.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderDAO {
  SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, int>> getBriefOrderInfo({DateTime? timeSelected}) async {
    var data = await supabase.rpc('get_brief_order_info', params: {
      'currdate': timeSelected != null
          ? DateFormat('yyyy-MM%').format(timeSelected)
          : DateFormat('yyyy-MM-dd%')
              .format(DateTime.now().subtract(Duration(hours: 8)))
    }).single();

    print(DateFormat('yyyy-MM')
        .format(DateTime.now().subtract(Duration(hours: 8))));
    print("DAHHHHH");
    return {
      'total_order': data['total_order'],
      'successful_order': data['successful_order'],
      'failed_order': data['failed_order'],
    };
  }

  Future<List<Order>> getOrdersAssociated(
      {DateTime? startdate, DateTime? enddate}) async {
    List<Order> orders = [];

    if (enddate != null && startdate != null) {
      String startdateString = DateFormat("yyyy-MM-dd").format(startdate);
      String enddateString = DateFormat("yyyy-MM-dd").format(enddate);

      var data = await supabase
          .from('orders')
          .select('''
cost,
orderid,
status,
date
''')
          .gte('date', startdateString)
          .lte('date', enddateString)
          .neq('accountid', supabase.auth.currentUser!.id)
          .order('date', ascending: false)
          .limit(20);

      for (var element in data) {
        orders.add(Order(
            orderID: element['orderid'],
            status: element['status'],
            cost: double.parse(element['cost'].toString()),
            date: DateTime.parse(element['date'])));
      }

      return orders;
    } else {
      var data = await supabase
          .from('orders')
          .select('''
cost,
orderid,
status,
date
''')
          .neq('accountid', supabase.auth.currentUser!.id)
          .order('date', ascending: false)
          .limit(20);

      for (var element in data) {
        orders.add(Order(
            orderID: element['orderid'],
            status: element['status'],
            cost: double.parse(element['cost'].toString()),
            date: DateTime.parse(element['date'])));
      }

      return orders;
    }
  }

  Future<Map<String, dynamic>> getBriefRevenueInfo(
      {DateTime? timeSelected}) async {
    var data = await supabase.rpc('get_brief_revenue_info', params: {
      'currdate': timeSelected != null
          ? DateFormat('yyyy-MM%').format(timeSelected)
          : DateFormat('yyyy-MM-dd%')
              .format(DateTime.now().add(Duration(hours: 8)))
    }).single();

    print(data);

    return {
      'revenue': double.parse(data['revenue'].toString()),
      'payments': data['payments'],
      'customers': data['customers'],
    };
  }

  Future<Map<String, dynamic>> getRevenueInfo(
      DateTime startdate, DateTime enddate) async {
    //testing
    var dataTest = await supabase
        .from('orders')
        .select('*')
        .gte('date', DateFormat('yyyy-MM-dd').format(startdate))
        .lte('date',
            DateFormat('yyyy-MM-dd').format(enddate.add(Duration(days: 1))));
    print(dataTest);
    var data = await supabase.rpc('get_revenue_duration', params: {
      'startdate': DateFormat('yyyy-MM-dd').format(startdate),
      'enddate':
          DateFormat('yyyy-MM-dd').format(enddate.add(Duration(days: 1))),
    }).single();

    print(data);

    return {
      'revenue': double.parse(data['revenue'].toString()),
      'payments': data['payments'],
      'customers': data['customers'],
    };
  }
}
