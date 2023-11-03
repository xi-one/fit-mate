import 'package:dio/dio.dart';
import 'package:fit_mate_app/pages/FramePage.dart';
import 'package:fit_mate_app/apiConstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class Sports {
  final int id;
  final String name;

  Sports({
    required this.id,
    required this.name,
  });
}

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  static final List<Sports?> _sports = [
    Sports(id: 1, name: "농구"),
    Sports(id: 2, name: "축구"),
    Sports(id: 3, name: "헬스"),
    Sports(id: 4, name: "러닝"),
    Sports(id: 5, name: "야구"),
    Sports(id: 6, name: "배드민턴"),
    Sports(id: 7, name: "배구"),
  ];
  final _items = _sports
      .map((sports) => MultiSelectItem<Sports?>(sports, sports!.name))
      .toList();

  List<Sports?> _selectedSports = [];

  final _cities = ['서울/경기', '충북', '충남', '경북', '경남', '전북', '전남', '강원'];
  String? _selectedCity;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //
  final TextEditingController _nicknameController = TextEditingController();
  String _selectedGender = 'MALE';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedCity = _cities[0];
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원 정보')),
      body: SafeArea(
          child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nicknameController,
                          validator: (value) {
                            // trim : 앞뒤 공백 제거
                            if (value != null && value.trim().isEmpty) {
                              return '닉네임을 입력하세요.';
                            }
                            return null;
                          },
                          // 외곽선이 있고, 힌트 텍스트 표시
                          decoration: InputDecoration(
                            labelText: '닉네임',
                            border: OutlineInputBorder(),
                            hintText: 'ex) 닉네임',
                          ),
                          // 숫자만 입력할 수 있다.
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "성별",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Radio<String>(
                                value: 'MALE',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value!;
                                  });
                                },
                              ),
                              Text('남자'),
                              Radio<String>(
                                value: 'FEMALE',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value!;
                                  });
                                },
                              ),
                              Text('여자'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "생년월일",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          // 날짜 선택 버튼
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 16.0,
                              ),
                              ElevatedButton(
                                onPressed: () => {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  ).then((selectedDate) {
                                    print("선택한 날짜");
                                    print(selectedDate);
                                    setState(() {
                                      _selectedDate = selectedDate;
                                    });
                                  })
                                },
                                child: const Text('날짜선택'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "관심 종목",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        MultiSelectBottomSheetField<Sports?>(
                          initialChildSize: 0.4,
                          listType: MultiSelectListType.CHIP,
                          searchable: true,
                          buttonText: Text("Favorite Sports"),
                          title: Text("Sports"),
                          items: _items,
                          onConfirm: (values) {
                            _selectedSports = values;
                          },
                          chipDisplay: MultiSelectChipDisplay(
                            onTap: (value) {
                              setState(() {
                                _selectedSports.remove(value);
                              });
                            },
                          ),
                        ),
                        _selectedSports.isEmpty
                            ? Container(
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "None selected",
                                  style: TextStyle(color: Colors.black54),
                                ))
                            : Container(),
                        SizedBox(
                          height: 16.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "지역",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DropdownButton(
                          value: _selectedCity,
                          items: _cities
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCity = value!;
                            });
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16.0),
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () async {
                              // 폼에 입력된 값 검증

                              if (_formKey.currentState!.validate()) {
                                // Flutter Secure Storage에서 JWT 토큰 읽어오기
                                final storage = FlutterSecureStorage();
                                String? jwtToken =
                                    await storage.read(key: 'accessToken');

                                // Dio 인스턴스 생성 및 기본 설정
                                Dio dio = Dio(BaseOptions(
                                  baseUrl: ApiConstants.baseUrl,
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'Bearer $jwtToken',
                                  },
                                ));
                                print(_selectedSports[0]);
                                // POST 요청 데이터 준비
                                Map<String, dynamic> data = {
                                  'nickname': _nicknameController.text,
                                  'region': _selectedCity,
                                  'birth': _selectedDate!.toIso8601String(),
                                  'sex': _selectedGender,
                                  'sports': _selectedSports
                                      .map((e) => e!.name)
                                      .toList(),
                                  // 다른 필드들도 추가할 수 있음
                                };

                                // POST 요청 보내기
                                try {
                                  Response response =
                                      await dio.post('/userinfo', data: data);
                                  print('Response: ${response.data}');
                                  // 요청 성공 시 처리
                                } catch (error) {
                                  print('Error: $error');
                                  // 요청 실패 시 처리
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PageList()),
                                );
                              }
                            },
                            icon: Icon(Icons.arrow_forward),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
