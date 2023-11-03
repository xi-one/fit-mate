import 'package:ethereum_addresses/ethereum_addresses.dart';
import 'package:flutter/material.dart';

class EthereumAddressInputDialog {
  final TextEditingController _addressController = TextEditingController();

  Future<String?> show(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('지갑 주소 입력'),
          content: TextField(
            controller: _addressController,
            decoration: InputDecoration(hintText: 'ex) 0x1234...'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                String inputAddress = _addressController.text;
                if (isValidEthereumAddress(inputAddress)) {
                  Navigator.of(context).pop(inputAddress);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('유효하지 않은 주소'),
                        content: Text('올바른 계정 주소를 입력하세요.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('확인'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }
}
