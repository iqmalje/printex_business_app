import 'dart:io';

import 'package:image_picker/image_picker.dart';
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
          status,
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
          lat: double.parse(rawData['apmaddresses']['lat'].toString()),
          lng: double.parse(rawData['apmaddresses']['lng'].toString()),
          isActive: rawData['status'] == 'Active'));
    }

    return returnData;
  }

  Future<List<String>> uploadAPMPictures(
      XFile picture1, XFile picture2, String apmID) async {
    List<String> urls = ["", ""];
    print('$apmID/${picture1.name}');
    print(picture1.path);

    print(File(picture1.path).path);
    await supabase.storage
        .from('apms')
        .upload('$apmID/${picture1.name}', File(picture1.path));
    urls[0] =
        supabase.storage.from('apms').getPublicUrl('$apmID/${picture1.name}');
    await supabase.storage
        .from('apms')
        .upload('$apmID/${picture2.name}', File(picture2.path));
    urls[1] =
        supabase.storage.from('apms').getPublicUrl('$apmID/${picture2.name}');
    return urls;
  }

  Future<void> updateAPM(APM apm, APMDetails details,
      APMOperatingHours operatingHours, APMPricing pricing) async {
    await supabase.from('apms').update({
      'printername': apm.printerName,
      'paper_amount': 0,
      'owned_by': supabase.auth.currentUser!.id,
      'status': apm.isActive ? 'Active' : 'Maintenance',
    }).eq('apmid', apm.apmID);

    await supabase.from('apmdetails').update({
      'type': details.type,
      'bwprint': details.bwprint == 'Yes' ? true : false,
      'colorprint': details.colorprint == 'Yes' ? true : false,
      'bothsideprint': details.bothsideprint == 'Yes' ? true : false,
      'layout': details.layout,
      'papersize': details.papersize
    }).eq('apmid', apm.apmID);
    // kene masukan coordinate
    await supabase.from('apmaddresses').update({
      'address1': apm.address1,
      'address2': apm.address2,
      'city': apm.city,
      'state': apm.state,
      'lat': 1.56651,
      'lng': 103.62383
    }).eq('apmid', apm.apmID);

    await supabase.from('apm_costs').update({
      'black_white_single': pricing.blackWhiteSingle,
      'black_white_both': pricing.blackWhiteBoth,
      'color_single': pricing.colorSingle,
      'color_both': pricing.colorBoth,
      'service_fee': 0.1
    }).eq('apmid', apm.apmID);

    await supabase
        .from('operatinghours')
        .update(operatingHours.toMap())
        .eq('apmid', apm.apmID);
  }

  Future<void> createAPM(
      APM apm,
      APMDetails details,
      APMOperatingHours operatingHours,
      APMPricing pricing,
      XFile picture1,
      XFile picture2) async {
    var apmCreated = await supabase
        .from('apms')
        .insert({
          'printername': apm.printerName,
          'pictureurl': 'apm.pictureUrl',
          'picture_url_2': 'apm.pictureUrl2',
          'paper_amount': 0,
          'owned_by': supabase.auth.currentUser!.id,
          'status': apm.isActive ? 'Active' : 'Maintenance',
        })
        .select()
        .single();
    print("apmCreated = $apmCreated");
    // upload

    List<String> urls =
        await uploadAPMPictures(picture1, picture2, apmCreated['apmid']);
    apm.apmID = apmCreated['apmid'];

    await supabase.from('apms').update({
      'pictureurl': urls[0],
      'picture_url_2': urls[1],
    }).eq('apmid', apm.apmID);

    await supabase.from('apmdetails').insert({
      'apmid': apm.apmID,
      'type': details.type,
      'bwprint': details.bwprint,
      'colorprint': details.colorprint,
      'bothsideprint': details.bothsideprint,
      'layout': details.layout,
      'papersize': details.papersize
    });
    // kene masukan coordinate
    await supabase.from('apmaddresses').insert({
      'apmid': apm.apmID,
      'address1': apm.address1,
      'address2': apm.address2,
      'city': apm.city,
      'state': apm.state,
      'lat': 1.56651,
      'lng': 103.62383
    });

    await supabase.from('apm_costs').insert({
      'apmid': apm.apmID,
      'black_white_single': pricing.blackWhiteSingle,
      'black_white_both': pricing.blackWhiteBoth,
      'color_single': pricing.colorSingle,
      'color_both': pricing.colorBoth,
      'service_fee': 0.1
    });

    await supabase.from('operatinghours').insert({
      'apmid': apm.apmID,
      'monday': operatingHours.monday,
      'tuesday': operatingHours.tuesday,
      'wednesday': operatingHours.wednesday,
      'thursday': operatingHours.thursday,
      'friday': operatingHours.friday,
      'saturday': operatingHours.saturday,
      'sunday': operatingHours.sunday,
    });
  }

  Future<APMDetails> getAPMDetails(String apmID) async {
    var data = await supabase
        .from('apmdetails')
        .select('*')
        .eq('apmid', apmID)
        .single();
    print("data = $data");
    APMDetails details = APMDetails(
        data['type'],
        data['papersize'],
        data['layout'],
        data['bwprint'],
        data['colorprint'],
        data['bothsideprint']);

    return details;
  }

  Future<APMOperatingHours> getAPMOperatingHours(String apmID) async {
    var data = await supabase
        .from('operatinghours')
        .select('*')
        .eq('apmid', apmID)
        .single();

    APMOperatingHours operatingHours = APMOperatingHours(
        monday: data['monday'],
        tuesday: data['tuesday'],
        wednesday: data['wednesday'],
        thursday: data['thursday'],
        friday: data['friday'],
        saturday: data['saturday'],
        sunday: data['sunday']);

    return operatingHours;
  }

  Future<APMPricing> getPricing(String apmID) async {
    var data = await supabase
        .from('apm_costs')
        .select('*')
        .eq('apmid', apmID)
        .single();

    return APMPricing(
        blackWhiteSingle: double.parse(data['black_white_single'].toString()),
        blackWhiteBoth: double.parse(data['black_white_both'].toString()),
        colorSingle: double.parse(data['color_single'].toString()),
        colorBoth: double.parse(data['color_both'].toString()));
  }

  Future<void> deleteAPM(String apmID) async {
    await supabase.from('apms').delete().eq('apmid', apmID);
  }
}
