import 'package:crypto/crypto.dart';
import 'package:http/http.dart';

import 'main.dart';

const key = 'LZSBZ-XUVOQ-ZPJ5I-GRV6B-BLCJ5-ZZBIV';
const baseUrl = 'https://apis.map.qq.com';
const secretKey = 'S8jOdT87Y8tthmLIzklkSaro1Es67DrI';

Future request(String path, Map params) async {
  path = '/ws/$path?';
  params['key'] = key;
  final keys = params.keys.toList()..sort();
  final query = keys.map((key) => '$key=${params[key]}').join('&');
  final sig = md5.convert(utf8.encode('$path$query$secretKey'));
  final response = await get(Uri.parse('$baseUrl$path$query&sig=$sig'));
  return jsonDecode(response.body);
}

Future reGeocode(LatLng latLng) async {
  return request('geocoder/v1', {'location': '$latLng'});
}

Future getSuggestions(String keyword, String region) async {
  return request('place/v1/suggestion', {'keyword': keyword, 'region': region});
}
