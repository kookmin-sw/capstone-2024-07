import 'dart:io';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

const emulatorIp = '10.0.2.2:8080';
const simulatorIp = '127.0.0.1:8080';

final ip = Platform.isIOS == true ? simulatorIp : emulatorIp;

Map<String, String> categoryCodes = {
  "인기게시판": "HOT",
  "자유게시판": "FREE",
  "대학원게시판": "GRADUATE",
  "스터디모집": "STUDY",
  "질문게시판": "QUESTION",
  "홍보게시판": "PROMOTION",
};