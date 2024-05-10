import 'package:printex_business_app/model/apm.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApmDAO {
  SupabaseClient supabase = Supabase.instance.client;
  Future<List<APM>> getRegisteredAPM() async {
    var userID = supabase.auth.currentUser!.id;
    var data = await supabase.from('apms').select('''
          apmid,
          printername,
          pictureurl,
          picture_url_2,
          paper_amount,
          apmaddresses ( address1, address2, city, state, lat, lng )
          ''').match({'owned_by': userID});

    // parse data

    List<APM> returnData = [];

    for (var rawData in data) {
      returnData.add(APM(
          apmID: rawData['apmid'],
          printerName: rawData['printername'],
          pictureUrl: rawData['pictureurl'],
          pictureUrl2: rawData['picture_url_2'],
          paperAmount: rawData['paper_amount'],
          address1: rawData['apmaddresses']['address1'],
          address2: rawData['apmaddresses']['address2'],
          city: rawData['apmaddresses']['city'],
          state: rawData['apmaddresses']['state'],
          lat: rawData['apmaddresses']['lat'],
          lng: rawData['apmaddresses']['lng']));
    }

    return returnData;
  }
}
