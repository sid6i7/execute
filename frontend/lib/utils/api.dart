import 'dart:async';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

Future<List<String>?> predictImage(Uint8List? bytes, String category) async {
  final img_bytes = bytes?.toList();
  const link = 'http://10.0.2.2:8000/recommend/';
  final url = Uri.parse(link);
  List<String>? items;
  var request = http.MultipartRequest("POST", url);
  request.fields['category'] = category;
  var picture = http.MultipartFile.fromBytes(
    'picture',
    img_bytes!,
    filename: "pic.png",
    contentType: (MediaType('image', 'png')),
  );
  request.files.add(picture);
  await request.send().then((response) async {
    if (response.statusCode == 200) {
      final resp = await response.stream.bytesToString();

      final data = jsonDecode(resp);
      items = List<String>.from(jsonDecode(data['items']));
      // print(items);
    } else {
      print(await response.stream.bytesToString());
    }
  });
  return items;
  // make the POST request
}
