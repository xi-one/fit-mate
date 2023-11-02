import 'package:fit_mate_app/model/Post.dart';
import 'package:fit_mate_app/providers/PostService.dart';
import 'package:fit_mate_app/providers/UserService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPostPage extends StatefulWidget {
  final postId;
  const EditPostPage(this.postId, {super.key});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final _contentsFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedPost = Post(
      id: null,
      title: '',
      contents: '',
      datetime: null,
      userId: '',
      sports: '',
      location: '',
      numOfRecruits: '',
      numOfParticipants: '',
      isRecruiting: null);

  var _initValues = {
    'title': '',
    'contents': '',
    'sports': '운동 종목 선택',
    'location': '지역 선택',
    'numOfRecruits': '모집인원 선택'
  };

  var sports = "운동 종목 선택";
  var location = "지역 선택";
  var numOfRecruits = "모집인원 선택";

  var _isInit = true;
  var _isLoading = false;
  var arguments = null;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final postId = widget.postId;
      if (postId != null) {
        _editedPost = Provider.of<PostService>(context, listen: false)
            .items
            .firstWhere((post) => post.id == postId);
        _initValues = {
          'title': _editedPost.title ?? '',
          'contents': _editedPost.contents ?? '',
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _contentsFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate() &&
        sports != _initValues['sports'] &&
        location != _initValues['location'] &&
        numOfRecruits != _initValues['numOfRecruits'];
    if (!isValid) {
      print("invalid value!!!");
      return;
    }
    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedPost.id != null) {
      await Provider.of<PostService>(context, listen: false)
          .updatePost(_editedPost.id!, _editedPost);
    } else {
      try {
        await Provider.of<PostService>(context, listen: false)
            .addPost(_editedPost, sports, location, numOfRecruits);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error ocurred.'),
            content: Text('오류가 발생했습니다.'),
            actions: <Widget>[
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  void _showModal(BuildContext context, String domain) async {
    final sportsList = ['농구', '테니스', '축구', '배드민턴', '헬스', '러닝', '야구', '배구'];
    final citiesList = ['서울/경기', '충북', '충남', '경북', '경남', '전북', '전남', '강원'];
    final numberList = List.generate(27, (index) => index + 3);

    var list;
    if (domain == 'sports') {
      list = sportsList;
    } else if (domain == 'city')
      list = citiesList;
    else if (domain == 'num')
      list = numberList;
    else
      ;
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5, // 모달의 높이를 설정합니다.
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(list[index].toString()),
                onTap: () {
                  // 사용자가 운동 종목을 선택했을 때 할 작업을 여기에 추가합니다.
                  print('선택한 운동 종목: ${list[index].toString()}');
                  if (domain == 'sports') {
                    setState(() {
                      sports = list[index];
                    });
                  } else if (domain == 'city') {
                    setState(() {
                      location = list[index];
                    });
                  } else if (domain == 'num') {
                    setState(() {
                      numOfRecruits = list[index].toString();
                    });
                  } else
                    ;
                  Navigator.of(context).pop(); // 모달을 닫습니다.
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserService>(context).userId;

    return Scaffold(
      appBar: AppBar(
        title: widget.postId != null ? Text('글 수정') : Text('글 작성'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // 운동 종목 설정
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "종목",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _showModal(context, 'sports');
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                sports, // 힌트 텍스트
                                style: TextStyle(color: Colors.grey),
                              ),
                              Icon(Icons.keyboard_arrow_down), // 아래표시 화살표 아이콘
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 1,
                      ),

                      // 지역 설정
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "지역",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _showModal(context, 'city');
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                location, // 힌트 텍스트
                                style: TextStyle(color: Colors.grey),
                              ),
                              Icon(Icons.keyboard_arrow_down), // 아래표시 화살표 아이콘
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 1,
                      ),

                      // 모집 인원 설정
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "인원",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _showModal(context, 'num');
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                numOfRecruits, // 힌트 텍스트
                                style: TextStyle(color: Colors.grey),
                              ),
                              Icon(Icons.keyboard_arrow_down), // 아래표시 화살표 아이콘
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 1,
                      ),
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          labelText: '제목',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_contentsFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '제목을 입력해주세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedPost = Post(
                            title: value,
                            contents: _editedPost.contents,
                            datetime: _editedPost.datetime,
                            userId: userId,
                            id: _editedPost.id,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['contents'],
                        decoration: InputDecoration(labelText: '내용'),
                        maxLines: 15,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        focusNode: _contentsFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '내용을 입력해주세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedPost = Post(
                            title: _editedPost.title,
                            contents: value,
                            datetime: _editedPost.datetime,
                            id: _editedPost.id,
                            userId: _editedPost.userId,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
