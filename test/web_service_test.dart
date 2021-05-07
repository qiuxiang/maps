import 'package:flutter_test/flutter_test.dart';
import 'package:maps/main.dart';

void main() {
  test('reverse geocode', () async {
    final result = await reGeocode(const LatLng(28.7033487,115.8660847));
    print(result);
    expect(result['result']['address'], '江西省南昌市红谷滩区凤凰北大道');
  });

  test('get suggestions', () async {
    final result = await getSuggestions('万象城', '南宁');
    print(result);
  });
}
