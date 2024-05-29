package com.dclass.backend.domain.report

enum class ReportReason(val value: String) {
    INSULTING("욕설/비하"),
    COMMERCIAL("상업적 광고 및 판매"),
    INAPPROPRIATE("게시판 성격에 부적절함"),
    FRAUD("유출/사칭/사기"),
    SPAM("낚시/놀람/도배"),
    PORNOGRAPHIC("음란물/불건전한 만남 및 대화"),
}
