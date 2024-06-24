const List<String> categorysList = [
  "전체",
  "인기",
  "자유",
  "스터디/프로젝트",
  "취업",
  "대학원",
  "흥보",
];

Map<String, String> categoryCodesList = {
  "전체": "ALL",
  "인기": "HOT",
  "자유": "FREE",
  "스터디/프로젝트": "STUDY",
  "취업": "JOB",
  "대학원": "GRADUATE",
  "흥보": "PROMOTION",
};

Map<String, String> categoryCodesReverseList = {
  "HOT": "인기",
  "FREE": "자유",
  "STUDY": "스터디/프로젝트",
  "JOB": "취업",
  "GRADUATE": "대학원",
  "PROMOTION": "흥보",
};
