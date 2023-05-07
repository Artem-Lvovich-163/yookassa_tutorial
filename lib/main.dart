import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/link.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ЮКасса',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyPayScreen(),
    );
  }
}

class MyPayScreen extends StatefulWidget {
  const MyPayScreen({super.key});

  @override
  State<MyPayScreen> createState() => _MyPayScreenState();
}

class _MyPayScreenState extends State<MyPayScreen> {
  bool isLoad = true;

  Map? kas;
  String link = '';
  //функция оплаты
  // myPayment() async {
  //   var uname = '313686';
  //   var pword = 'test_GSoR53-6rrsfNbr2OhxhO7TKya002h8rHn8Ty0qEMG8';
  //   var auth = 'Basic  ${base64Encode(utf8.encode('$uname:$pword'))}';

  //   var headers = {
  //     'Idempotence-Key': '${DateTime.now()}',
  //     'Content-Type': 'application/json',
  //     'Authorization': auth,
  //   };
  //   var data =
  //       '{"amount": {"value": "100.00","currency": "RUB"},"capture": true,"confirmation": {"type": "redirect","return_url": "https://www.example.com/return_url"},"description": "Заказ №1"}';
  //   var url = Uri.parse('https://api.yookassa.ru/v3/payments');
  //   var res = await http.post(url, headers: headers, body: data);
  //   kas = json.decode(res.body);

  //   //link = kas!['confirmation']['confirmation_url'];
  //   print(kas);

  //   if (res.statusCode == 200) {
  //     isLoad = false;
  //     // Navigator.of(context).push(
  //     //   MaterialPageRoute(
  //     //     builder: (context) => WebViewPage(link: '$link'),
  //     //   ),
  //     // );
  //   } else {
  //     print(res.statusCode);
  //   }
  // }

  postTo(summa) async {
    var uname = '313686';
    var pword = 'test_GSoR53-6rrsfNbr2OhxhO7TKya002h8rHn8Ty0qEMG8';
    var authn = 'Basic ${base64Encode(utf8.encode('$uname:$pword'))}';

    var headers = {
      'Idempotence-Key': '${DateTime.now()}',
      'Content-Type': 'application/json',
      'Authorization': authn,
    };

    var data =
        '{"amount":{"value":"$summa.00","currency":"RUB"},"payment_method_data":{"type":"bank_card", "type":"sbp"},"confirmation":{"type":"redirect","return_url":"https://www.example.com/return_url"},"description":"Заказ #1752"}';

    var url = Uri.parse('https://api.yookassa.ru/v3/payments');
    var res = await http.post(url, headers: headers, body: data);
    kas = json.decode(res.body);

    print(kas);
    if (res.statusCode == 200) {
      setState(() {
        link = kas!['confirmation']['confirmation_url'];
      });
    } else {}
  }

  @override
  void initState() {
    postTo('13000');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: const [
            Text('ЮКАССА'),
            Text(
              'Тест платежа',
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
      body:
          // isLoad == true
          //     ? const Center(
          //         child: CircularProgressIndicator(),
          //       )
          //:
          Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Закрытый клуб',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const Text(
              '13000 рублей в месяц',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Link(
              target: LinkTarget.self,
              uri: Uri.parse('$link'),
              builder: (context, followLink) => ElevatedButton(
                onPressed: followLink,
                child: const Text(
                  'Оплатить и вступить',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
