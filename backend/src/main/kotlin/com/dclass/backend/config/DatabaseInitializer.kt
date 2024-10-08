package com.dclass.backend.config

import com.dclass.backend.application.CommentService
import com.dclass.backend.application.PostService
import com.dclass.backend.application.ReplyService
import com.dclass.backend.common.BulkInsertRepository
import com.dclass.backend.domain.belong.Belong
import com.dclass.backend.domain.belong.BelongRepository
import com.dclass.backend.domain.blacklist.Blacklist
import com.dclass.backend.domain.comment.Comment
import com.dclass.backend.domain.comment.CommentRepository
import com.dclass.backend.domain.community.Community
import com.dclass.backend.domain.community.CommunityRepository
import com.dclass.backend.domain.department.Department
import com.dclass.backend.domain.department.DepartmentRepository
import com.dclass.backend.domain.post.Post
import com.dclass.backend.domain.post.PostLikes
import com.dclass.backend.domain.post.PostRepository
import com.dclass.backend.domain.reply.Reply
import com.dclass.backend.domain.reply.ReplyRepository
import com.dclass.backend.domain.user.University
import com.dclass.backend.domain.user.UniversityRepository
import com.dclass.backend.domain.user.User
import com.dclass.backend.domain.user.UserRepository
import com.dclass.backend.security.JwtTokenProvider
import jakarta.persistence.EntityManager
import jakarta.transaction.Transactional
import org.springframework.boot.CommandLineRunner
import org.springframework.context.annotation.Profile
import org.springframework.stereotype.Component
import java.time.LocalDateTime

@Profile("local")
@Transactional
@Component
class DatabaseInitializer(
    private val database: Database,
    private val entityManager: EntityManager,
    private val universityRepository: UniversityRepository,
    private val departmentRepository: DepartmentRepository,
    private val communityRepository: CommunityRepository,
    private val belongRepository: BelongRepository,
    private val userRepository: UserRepository,
    private val postRepository: PostRepository,
    private val commentRepository: CommentRepository,
    private val replyRepository: ReplyRepository,
    private val commentService: CommentService,
    private val replyService: ReplyService,
    private val postService: PostService,
    private val bulkInsertRepository: BulkInsertRepository,
) : CommandLineRunner {

    private fun prev(){
        entityManager.createNativeQuery("set foreign_key_checks = 0").executeUpdate()
        entityManager.createNativeQuery("set autocommit = 0").executeUpdate()
    }

    private fun nxt(){
        entityManager.createNativeQuery("commit").executeUpdate()
        entityManager.createNativeQuery("set foreign_key_checks = 1").executeUpdate()
        entityManager.createNativeQuery("set autocommit = 1").executeUpdate()
    }

    override fun run(vararg args: String) {
        cleanUp()
        populate()
    }

    private fun cleanUp() {
        database.clear(database.retrieveTables())
    }

    private fun populate() {
        populateUniversity()
        populateDepartment()
        populateCommunity()
        populateUser()
//        populateBlacklist()
//        populateDummyPosts()
//        populateDummyComments()
//        populateDummyReplies()
    }

    private fun populateUniversity() {
        val universities = listOf(
            University(name = "가천길대학", emailSuffix = "gachon.ac.kr"),
            University(name = "가톨릭상지대학교", emailSuffix = "csj.ac.kr"),
            University(name = "강동대학교", emailSuffix = "gangdong.ac.kr"),
            University(name = "강릉영동대학교", emailSuffix = "gyc.ac.kr"),
            University(name = "강원관광대학", emailSuffix = "kt.ac.kr"),
            University(name = "강원도립대학", emailSuffix = "gw.ac.kr"),
            University(name = "거제대학교", emailSuffix = "koje.ac.kr"),
            University(name = "경기과학기술대학교", emailSuffix = "gtec.ac.kr"),
            University(name = "경남도립거창대학", emailSuffix = "gc.ac.kr"),
            University(name = "경남도립남해대학", emailSuffix = "namhae.ac.kr"),
            University(name = "경남정보대학교", emailSuffix = "kit.ac.kr"),
            University(name = "경민대학교", emailSuffix = "kyungmin.ac.kr"),
            University(name = "경복대학교", emailSuffix = "kbu.ac.kr"),
            University(name = "경북과학대학교", emailSuffix = "kbsc.ac.kr"),
            University(name = "경북도립대학교", emailSuffix = "gpc.ac.kr"),
            University(name = "경북전문대학교", emailSuffix = "kbc.ac.kr"),
            University(name = "경산1대학교", emailSuffix = "gs.ac.kr"),
            University(name = "경원전문대학", emailSuffix = "kwc.ac.kr"),
            University(name = "경인여자대학교", emailSuffix = "kic.ac.kr"),
            University(name = "계명문화대학교", emailSuffix = "kmcu.ac.kr"),
            University(name = "계원예술대학교", emailSuffix = "kaywon.ac.kr"),
            University(name = "고구려대학교", emailSuffix = "kgrc.ac.kr"),
            University(name = "광양보건대학교", emailSuffix = "kwangyang.ac.kr"),
            University(name = "광주보건대학교", emailSuffix = "ghu.ac.kr"),
            University(name = "구미대학교", emailSuffix = "gumi.ac.kr"),
            University(name = "구세군사관학교", emailSuffix = "saotc.ac.kr"),
            University(name = "국제대학교", emailSuffix = "kookje.ac.kr"),
            University(name = "군산간호대학교", emailSuffix = "kcn.ac.kr"),
            University(name = "군장대학교", emailSuffix = "kunjang.ac.kr"),
            University(name = "기독간호대학교", emailSuffix = "ccn.ac.kr"),
            University(name = "김천과학대학", emailSuffix = "kcs.ac.kr"),
            University(name = "김천대학", emailSuffix = "gimcheon.ac.kr"),
            University(name = "김포대학교", emailSuffix = "kimpo.ac.kr"),
            University(name = "김해대학교", emailSuffix = "gimhae.ac.kr"),
            University(name = "농협대학교", emailSuffix = "nonghyup.ac.kr"),
            University(name = "대경대학교", emailSuffix = "tk.ac.kr"),
            University(name = "대구공업대학교", emailSuffix = "ttc.ac.kr"),
            University(name = "대구과학대학교", emailSuffix = "tsu.ac.kr"),
            University(name = "대구미래대학교", emailSuffix = "dfc.ac.kr"),
            University(name = "대구보건대학교", emailSuffix = "dhc.ac.kr"),
            University(name = "대덕대학교", emailSuffix = "ddu.ac.kr"),
            University(name = "대동대학교", emailSuffix = "daedong.ac.kr"),
            University(name = "대림대학교", emailSuffix = "daelim.ac.kr"),
            University(name = "대원대학교", emailSuffix = "daewon.ac.kr"),
            University(name = "대전보건대학교", emailSuffix = "hit.ac.kr"),
            University(name = "동강대학교", emailSuffix = "dkc.ac.kr"),
            University(name = "동남보건대학교", emailSuffix = "dongnam.ac.kr"),
            University(name = "동명대학", emailSuffix = "tu.ac.kr"),
            University(name = "동부산대학교", emailSuffix = "dpc.ac.kr"),
            University(name = "동서울대학교", emailSuffix = "dsc.ac.kr"),
            University(name = "동아방송예술대학교", emailSuffix = "dima.ac.kr"),
            University(name = "동아인재대학교", emailSuffix = "dongac.ac.kr"),
            University(name = "동양미래대학교", emailSuffix = "dongyang.ac.kr"),
            University(name = "동우대학", emailSuffix = "duc.ac.kr"),
            University(name = "동원과학기술대학교", emailSuffix = "dist.ac.kr"),
            University(name = "동원대학교", emailSuffix = "tw.ac.kr"),
            University(name = "동의과학대학교", emailSuffix = "dit.ac.kr"),
            University(name = "동주대학교", emailSuffix = "dongju.ac.kr"),
            University(name = "두원공과대학교", emailSuffix = "doowon.ac.kr"),
            University(name = "마산대학교", emailSuffix = "masan.ac.kr"),
            University(name = "명지전문대학", emailSuffix = "mjc.ac.kr"),
            University(name = "목포과학대학교", emailSuffix = "mokpo-c.ac.kr"),
            University(name = "문경대학교", emailSuffix = "mkc.ac.kr"),
            University(name = "배화여자대학교", emailSuffix = "baewha.ac.kr"),
            University(name = "백석문화대학교", emailSuffix = "bscu.ac.kr"),
            University(name = "백제예술대학교", emailSuffix = "paekche.ac.kr"),
            University(name = "벽성대학", emailSuffix = "bs.ac.kr"),
            University(name = "부산경상대학교", emailSuffix = "bsks.ac.kr"),
            University(name = "부산과학기술대학교", emailSuffix = "bist.ac.kr"),
            University(name = "부산여자대학교", emailSuffix = "bwc.ac.kr"),
            University(name = "부산예술대학교", emailSuffix = "busanarts.ac.kr"),
            University(name = "부천대학교", emailSuffix = "bc.ac.kr"),
            University(name = "삼육보건대학", emailSuffix = "shu.ac.kr"),
            University(name = "삼육의명대학", emailSuffix = "syu.ac.kr"),
            University(name = "상지영서대학교", emailSuffix = "sy.ac.kr"),
            University(name = "서라벌대학교", emailSuffix = "sorabol.ac.kr"),
            University(name = "서영대학교", emailSuffix = "seoyeong.ac.kr"),
            University(name = "서울보건대학", emailSuffix = "shjc.ac.kr"),
            University(name = "서울여자간호대학교", emailSuffix = "snjc.ac.kr"),
            University(name = "서울예술대학교", emailSuffix = "seoularts.ac.kr"),
            University(name = "서일대학교", emailSuffix = "seoil.ac.kr"),
            University(name = "서정대학교", emailSuffix = "seojeong.ac.kr"),
            University(name = "서해대학", emailSuffix = "sohae.ac.kr"),
            University(name = "선린대학교", emailSuffix = "sunlin.ac.kr"),
            University(name = "성덕대학교", emailSuffix = "sdc.ac.kr"),
            University(name = "성심외국어대학", emailSuffix = "sungsim.ac.kr"),
            University(name = "세경대학교", emailSuffix = "saekyung.ac.kr"),
            University(name = "송곡대학교", emailSuffix = "songgok.ac.kr"),
            University(name = "송원대학", emailSuffix = "songwon.ac.kr"),
            University(name = "송호대학교", emailSuffix = "songho.ac.kr"),
            University(name = "수성대학교", emailSuffix = "sc.ac.kr"),
            University(name = "수원과학대학교", emailSuffix = "ssc.ac.kr"),
            University(name = "수원여자대학교", emailSuffix = "swc.ac.kr"),
            University(name = "순천제일대학", emailSuffix = "suncheon.ac.kr"),
            University(name = "숭의여자대학교", emailSuffix = "sewc.ac.kr"),
            University(name = "신구대학교", emailSuffix = "shingu.ac.kr"),
            University(name = "신성대학교", emailSuffix = "shinsung.ac.kr"),
            University(name = "신안산대학교", emailSuffix = "sau.ac.kr"),
            University(name = "신흥대학교", emailSuffix = "shc.ac.kr"),
            University(name = "아주자동차대학", emailSuffix = "motor.ac.kr"),
            University(name = "안동과학대학교", emailSuffix = "asc.ac.kr"),
            University(name = "안산대학교", emailSuffix = "ansan.ac.kr"),
            University(name = "여주대학교", emailSuffix = "yit.ac.kr"),
            University(name = "연성대학교", emailSuffix = "yeonsung.ac.kr"),
            University(name = "연암공과대학교", emailSuffix = "yc.ac.kr"),
            University(name = "영남외국어대학", emailSuffix = "yflc.ac.kr"),
            University(name = "영남이공대학교", emailSuffix = "ync.ac.kr"),
            University(name = "영진사이버대학", emailSuffix = "ycc.ac.kr"),
            University(name = "영진전문대학", emailSuffix = "yjc.ac.kr"),
            University(name = "오산대학교", emailSuffix = "osan.ac.kr"),
            University(name = "용인송담대학교", emailSuffix = "ysc.ac.kr"),
            University(name = "우송공업대학", emailSuffix = "wst.ac.kr"),
            University(name = "우송정보대학", emailSuffix = "wsi.ac.kr"),
            University(name = "울산과학대학교", emailSuffix = "uc.ac.kr"),
            University(name = "웅지세무대학", emailSuffix = "wat.ac.kr"),
            University(name = "원광보건대학교", emailSuffix = "wkhc.ac.kr"),
            University(name = "원주대학", emailSuffix = "wonju.ac.kr"),
            University(name = "유한대학교", emailSuffix = "yuhan.ac.kr"),
            University(name = "인덕대학교", emailSuffix = "induk.ac.kr"),
            University(name = "인천재능대학교", emailSuffix = "jeiu.ac.kr"),
            University(name = "인천전문대학", emailSuffix = "icc.ac.kr"),
            University(name = "인하공업전문대학", emailSuffix = "itc.ac.kr"),
            University(name = "장안대학교", emailSuffix = "jangan.ac.kr"),
            University(name = "적십자간호대학", emailSuffix = "cau.ac.kr"),
            University(name = "전남과학대학교", emailSuffix = "chunnam-c.ac.kr"),
            University(name = "전남도립대학교", emailSuffix = "dorip.ac.kr"),
            University(name = "전북과학대학교", emailSuffix = "jbsc.ac.kr"),
            University(name = "전주기전대학", emailSuffix = "jk.ac.kr"),
            University(name = "전주비전대학교", emailSuffix = "jvision.ac.kr"),
            University(name = "제주관광대학교", emailSuffix = "ctc.ac.kr"),
            University(name = "제주산업정보대학", emailSuffix = "jeju.ac.kr"),
            University(name = "제주한라대학교", emailSuffix = "chu.ac.kr"),
            University(name = "조선간호대학교", emailSuffix = "cnc.ac.kr"),
            University(name = "조선이공대학교", emailSuffix = "cst.ac.kr"),
            University(name = "진주보건대학교", emailSuffix = "jhc.ac.kr"),
            University(name = "창신대학", emailSuffix = "csc.ac.kr"),
            University(name = "창원문성대학", emailSuffix = "cmu.ac.kr"),
            University(name = "천안연암대학", emailSuffix = "yonam.ac.kr"),
            University(name = "청강문화산업대학교", emailSuffix = "chungkang.academy"),
            University(name = "청암대학교", emailSuffix = "scjc.ac.kr"),
            University(name = "춘해보건대학교", emailSuffix = "ch.ac.kr"),
            University(name = "충남도립청양대학", emailSuffix = "cyc.ac.kr"),
            University(name = "충북도립대학", emailSuffix = "cpu.ac.kr"),
            University(name = "충북보건과학대학교", emailSuffix = "chsu.ac.kr"),
            University(name = "충청대학교", emailSuffix = "ok.ac.kr"),
            University(name = "포항대학교", emailSuffix = "pohang.ac.kr"),
            University(name = "한국골프대학", emailSuffix = "kg.ac.kr"),
            University(name = "한국관광대학교", emailSuffix = "ktc.ac.kr"),
            University(name = "한국농수산대학", emailSuffix = "af.ac.kr"),
            University(name = "한국복지대학교", emailSuffix = "hanrw.ac.kr"),
            University(name = "한국복지사이버대학", emailSuffix = "corea.ac.kr"),
            University(name = "한국승강기대학교", emailSuffix = "klc.ac.kr"),
            University(name = "한국영상대학교", emailSuffix = "pro.ac.kr"),
            University(name = "한국정보통신기능대학", emailSuffix = "icpc.ac.kr"),
            University(name = "한국철도대학", emailSuffix = "krc.ac.kr"),
            University(name = "한국폴리텍", emailSuffix = "kopo.ac.kr "),
            University(name = "한림성심대학교", emailSuffix = "hsc.ac.kr"),
            University(name = "한양여자대학교", emailSuffix = "hywoman.ac.kr"),
            University(name = "한영대학", emailSuffix = "hanyeong.ac.kr"),
            University(name = "혜전대학", emailSuffix = "hj.ac.kr"),
            University(name = "혜천대학교", emailSuffix = "hu.ac.kr"),
            University(name = "가야대학교", emailSuffix = "kaya.ac.kr"),
            University(name = "가천대학교", emailSuffix = "gachon.ac.kr"),
            University(name = "가천의과학대학교", emailSuffix = "gachon.ac.kr"),
            University(name = "가톨릭대학교", emailSuffix = "catholic.ac.kr"),
            University(name = "감리교신학대학교", emailSuffix = "mtu.ac.kr"),
            University(name = "강남대학교", emailSuffix = "kangnam.ac.kr"),
            University(name = "강릉원주대학교", emailSuffix = "gwnu.ac.kr"),
            University(name = "강원대학교", emailSuffix = "kangwon.ac.kr"),
            University(name = "건국대학교", emailSuffix = "konkuk.ac.kr"),
            University(name = "건국대학교(글로컬)", emailSuffix = "kku.ac.kr"),
            University(name = "건양대학교", emailSuffix = "konyang.ac.kr"),
            University(name = "건양사이버대학교", emailSuffix = "kycu.ac.kr"),
            University(name = "경기대학교", emailSuffix = "kyonggi.ac.kr"),
            University(name = "경남과학기술대학교", emailSuffix = "gntech.ac.kr"),
            University(name = "경남대학교", emailSuffix = "hanma.kr"),
            University(name = "경동대학교", emailSuffix = "k1.ac.kr"),
            University(name = "경북대학교", emailSuffix = "knu.ac.kr"),
            University(name = "경북외국어대학교", emailSuffix = "kufs.ac.kr"),
            University(name = "경상대학교", emailSuffix = "gnu.ac.kr"),
            University(name = "경성대학교", emailSuffix = "ks.ac.kr"),
            University(name = "경운대학교", emailSuffix = "ikw.ac.kr"),
            University(name = "경운대학교(산업대)", emailSuffix = "ikw.ac.kr"),
            University(name = "경인교육대학교", emailSuffix = "ginue.ac.kr"),
            University(name = "경일대학교", emailSuffix = "kiu.kr"),
            University(name = "경주대학교", emailSuffix = "gju.ac.kr"),
            University(name = "경희대학교", emailSuffix = "khu.ac.kr"),
            University(name = "경희사이버대학교", emailSuffix = "khcu.ac.kr"),
            University(name = "계명대학교", emailSuffix = "kmu.ac.kr"),
            University(name = "고려대학교", emailSuffix = "korea.ac.kr"),
            University(name = "고려대학교(세종)", emailSuffix = "korea.ac.kr"),
            University(name = "고려사이버대학교", emailSuffix = "cuk.edu"),
            University(name = "고신대학교", emailSuffix = "kosin.ac.kr"),
            University(name = "공주교육대학교", emailSuffix = "gjue.ac.kr"),
            University(name = "공주대학교", emailSuffix = "smail.kongju.ac.kr"),
            University(name = "가톨릭관동대학교", emailSuffix = "cku.ac.kr"),
            University(name = "광신대학교", emailSuffix = "kwangshin.ac.kr"),
            University(name = "광운대학교", emailSuffix = "kw.ac.kr"),
            University(name = "광주가톨릭대학교", emailSuffix = "kjcatholic.ac.kr"),
            University(name = "GIST", emailSuffix = "gist.ac.kr"),
            University(name = "광주교육대학교", emailSuffix = "gnue.ac.kr"),
            University(name = "광주대학교", emailSuffix = "gwangju.ac.kr"),
            University(name = "광주대학교(산업대)", emailSuffix = "gwangju.ac.kr"),
            University(name = "광주여자대학교", emailSuffix = "kwu.ac.kr"),
            University(name = "국민대학교", emailSuffix = "kookmin.ac.kr"),
            University(name = "국제사이버대학교", emailSuffix = "gcu.ac"),
            University(name = "군산대학교", emailSuffix = "kunsan.ac.kr"),
            University(name = "그리스도대학교", emailSuffix = "kcu.ac.kr"),
            University(name = "극동대학교", emailSuffix = "kdu.ac.kr"),
            University(name = "글로벌사이버대학교", emailSuffix = "global.ac.kr"),
            University(name = "금강대학교", emailSuffix = "ggu.ac.kr"),
            University(name = "금오공과대학교", emailSuffix = "kumoh.ac.kr"),
            University(name = "김천대학교", emailSuffix = "gimcheon.ac.kr"),
            University(name = "꽃동네대학교", emailSuffix = "kkot.ac.kr"),
            University(name = "나사렛대학교", emailSuffix = "kornu.ac.kr"),
            University(name = "남부대학교", emailSuffix = "nambu.ac.kr"),
            University(name = "남서울대학교", emailSuffix = "nsu.ac.kr"),
            University(name = "남서울대학교(산업대)", emailSuffix = "nsu.ac.kr"),
            University(name = "단국대학교", emailSuffix = "dankook.ac.kr"),
            University(name = "대구가톨릭대학교", emailSuffix = "cu.ac.kr"),
            University(name = "DGIST", emailSuffix = "dgist.ac.kr"),
            University(name = "대구교육대학교", emailSuffix = "dnue.ac.kr"),
            University(name = "대구대학교", emailSuffix = "daegu.ac.kr"),
            University(name = "대구사이버대학교", emailSuffix = "dcu.ac.kr"),
            University(name = "대구예술대학교", emailSuffix = "dgau.ac.kr"),
            University(name = "대구외국어대학교", emailSuffix = "dufs.ac.kr"),
            University(name = "대구한의대학교", emailSuffix = "dhu.ac.kr"),
            University(name = "대신대학교", emailSuffix = "daeshin.ac.kr"),
            University(name = "대전가톨릭대학교", emailSuffix = "dcatholic.ac.kr"),
            University(name = "대전대학교", emailSuffix = "edu.dju.ac.kr"),
            University(name = "대전신학교", emailSuffix = "daejeon.ac.kr"),
            University(name = "대전신학대학교", emailSuffix = "daejeon.ac.kr"),
            University(name = "대진대학교", emailSuffix = "daejin.ac.kr"),
            University(name = "덕성여자대학교", emailSuffix = "duksung.ac.kr"),
            University(name = "동국대학교", emailSuffix = "dongguk.edu"),
            University(name = "동국대학교(경주)", emailSuffix = "dongguk.ac.kr"),
            University(name = "동덕여자대학교", emailSuffix = "dongduk.ac.kr"),
            University(name = "동명대학교", emailSuffix = "tu.ac.kr"),
            University(name = "동명정보대학교", emailSuffix = "tu.ac.kr"),
            University(name = "동서대학교", emailSuffix = "dongseo.ac.kr"),
            University(name = "동신대학교", emailSuffix = "dsu.kr"),
            University(name = "동아대학교", emailSuffix = "donga.ac.kr"),
            University(name = "동양대학교", emailSuffix = "dyu.ac.kr"),
            University(name = "동의대학교", emailSuffix = "deu.ac.kr"),
            University(name = "디지털서울문화예술대학교", emailSuffix = "scau.ac.kr"),
            University(name = "루터대학교", emailSuffix = "ltu.ac.kr"),
            University(name = "명지대학교", emailSuffix = "mju.ac.kr"),
            University(name = "목원대학교", emailSuffix = "mokwon.ac.kr"),
            University(name = "목포가톨릭대학교", emailSuffix = "mcu.ac.kr"),
            University(name = "목포대학교", emailSuffix = "mokpo.ac.kr"),
            University(name = "목포해양대학교", emailSuffix = "mmu.ac.kr"),
            University(name = "배재대학교", emailSuffix = "pcu.ac.kr"),
            University(name = "백석대학교", emailSuffix = "bu.ac.kr"),
            University(name = "부경대학교", emailSuffix = "pukyong.ac.kr"),
            University(name = "부산가톨릭대학교", emailSuffix = "cup.ac.kr"),
            University(name = "부산교육대학교", emailSuffix = "bnue.ac.kr"),
            University(name = "부산대학교", emailSuffix = "pusan.ac.kr"),
            University(name = "부산디지털대학교", emailSuffix = "bdu.ac.kr"),
            University(name = "부산외국어대학교", emailSuffix = "bufs.ac.kr"),
            University(name = "부산장신대학교", emailSuffix = "bpu.ac.kr"),
            University(name = "사이버한국외국어대학교", emailSuffix = "cufs.ac.kr"),
            University(name = "삼육대학교", emailSuffix = "syuin.ac.kr"),
            University(name = "상명대학교", emailSuffix = "sangmyung.kr"),
            University(name = "상명대학교(천안)", emailSuffix = "sangmyung.kr"),
            University(name = "상주대학교", emailSuffix = "knu.ac.kr"),
            University(name = "상지대학교", emailSuffix = "sangji.ac.kr"),
            University(name = "서강대학교", emailSuffix = "sogang.ac.kr"),
            University(name = "서경대학교", emailSuffix = "skuniv.ac.kr"),
            University(name = "서남대학교", emailSuffix = "seonam.ac.kr"),
            University(name = "서울과학기술대학교", emailSuffix = "seoultech.ac.kr"),
            University(name = "서울과학기술대학교(산업대)", emailSuffix = "seoultech.ac.kr"),
            University(name = "서울교육대학교", emailSuffix = "snue.ac.kr"),
            University(name = "서울기독대학교", emailSuffix = "scu.ac.kr"),
            University(name = "서울대학교", emailSuffix = "snu.ac.kr"),
            University(name = "서울디지털대학교", emailSuffix = "sdu.ac.kr"),
            University(name = "서울사이버대학교", emailSuffix = "iscu.ac.kr"),
            University(name = "서울시립대학교", emailSuffix = "uos.ac.kr"),
            University(name = "서울신학대학교", emailSuffix = "stu.ac.kr"),
            University(name = "서울여자대학교", emailSuffix = "swu.ac.kr"),
            University(name = "서울장신대학교", emailSuffix = "sjs.ac.kr"),
            University(name = "서원대학교", emailSuffix = "seowon.ac.kr"),
            University(name = "선문대학교", emailSuffix = "sunmoon.ac.kr"),
            University(name = "성결대학교", emailSuffix = "sungkyul.ac.kr"),
            University(name = "성공회대학교", emailSuffix = "skhu.ac.kr"),
            University(name = "성균관대학교", emailSuffix = "skku.edu"),
            University(name = "성신여자대학교", emailSuffix = "sungshin.ac.kr"),
            University(name = "세명대학교", emailSuffix = "semyung.ac.kr"),
            University(name = "세종대학교", emailSuffix = "sju.ac.kr"),
            University(name = "세종사이버대학교", emailSuffix = "sjcu.ac.kr"),
            University(name = "세한대학교", emailSuffix = "sehan.ac.kr"),
            University(name = "송원대학교", emailSuffix = "songwon.ac.kr"),
            University(name = "수원가톨릭대학교", emailSuffix = "suwoncatholic.ac.kr"),
            University(name = "수원대학교", emailSuffix = "suwon.ac.kr"),
            University(name = "숙명여자대학교", emailSuffix = "sookmyung.ac.kr"),
            University(name = "순복음총회신학교", emailSuffix = "kcc.ac.kr"),
            University(name = "순천대학교", emailSuffix = "scnu.ac.kr"),
            University(name = "순천향대학교", emailSuffix = "sch.ac.kr"),
            University(name = "숭실대학교", emailSuffix = "soongsil.ac.kr"),
            University(name = "숭실사이버대학교", emailSuffix = "kcu.ac"),
            University(name = "신경대학교", emailSuffix = "sgu.ac.kr"),
            University(name = "신라대학교", emailSuffix = "silla.ac.kr"),
            University(name = "아세아연합신학대학교", emailSuffix = "acts.ac.kr"),
            University(name = "아주대학교", emailSuffix = "ajou.ac.kr"),
            University(name = "안동대학교", emailSuffix = "anu.ac.kr"),
            University(name = "안양대학교", emailSuffix = "ayum.anyang.ac.kr"),
            University(name = "연세대학교", emailSuffix = "yonsei.ac.kr"),
            University(name = "연세대학교(원주)", emailSuffix = "yonsei.ac.kr"),
            University(name = "열린사이버대학교", emailSuffix = "ocu.ac.kr"),
            University(name = "영남대학교", emailSuffix = "ynu.ac.kr"),
            University(name = "영남신학대학교", emailSuffix = "ytus.ac.kr"),
            University(name = "유원대학교", emailSuffix = "u1.ac.kr"),
            University(name = "영산대학교", emailSuffix = "ysu.ac.kr"),
            University(name = "영산대학교(산업대)", emailSuffix = "ysu.ac.kr"),
            University(name = "영산선학대학교", emailSuffix = "youngsan.ac.kr"),
            University(name = "예수대학교", emailSuffix = "jesus.ac.kr"),
            University(name = "예원예술대학교", emailSuffix = "yewon.ac.kr"),
            University(name = "용인대학교", emailSuffix = "yiu.ac.kr"),
            University(name = "우석대학교", emailSuffix = "woosuk.ac.kr"),
            University(name = "우송대학교", emailSuffix = "wsu.ac.kr"),
            University(name = "우송대학교(산업대)", emailSuffix = "wsu.ac.kr"),
            University(name = "UNIST", emailSuffix = "unist.ac.kr"),
            University(name = "울산대학교", emailSuffix = "ulsan.ac.kr"),
            University(name = "원광대학교", emailSuffix = "wonkwang.ac.kr"),
            University(name = "원광디지털대학교", emailSuffix = "wdu.ac.kr"),
            University(name = "위덕대학교", emailSuffix = "uu.ac.kr"),
            University(name = "을지대학교", emailSuffix = "eulji.ac.kr"),
            University(name = "이화여자대학교", emailSuffix = "ewhain.net"),
            University(name = "인제대학교", emailSuffix = "inje.ac.kr"),
            University(name = "인천가톨릭대학교", emailSuffix = "iccu.ac.kr"),
            University(name = "인천대학교", emailSuffix = "inu.ac.kr"),
            University(name = "인하대학교", emailSuffix = "inha.edu"),
            University(name = "장로회신학대학교", emailSuffix = "pcts.ac.kr"),
            University(name = "전남대학교", emailSuffix = "jnu.ac.kr"),
            University(name = "전북대학교", emailSuffix = "jbnu.ac.kr"),
            University(name = "전주교육대학교", emailSuffix = "jnue.kr"),
            University(name = "전주대학교", emailSuffix = "jj.ac.kr"),
            University(name = "정석대학", emailSuffix = "jit.ac.kr"),
            University(name = "제주교육대학교", emailSuffix = "jejue.ac.kr"),
            University(name = "제주국제대학교", emailSuffix = "jeju.ac.kr"),
            University(name = "제주대학교", emailSuffix = "jejunu.ac.kr"),
            University(name = "조선대학교", emailSuffix = "chosun.kr"),
            University(name = "중부대학교", emailSuffix = "jmail.ac.kr"),
            University(name = "중앙대학교", emailSuffix = "cau.ac.kr"),
            University(name = "중앙대학교(안성)", emailSuffix = "cau.ac.kr"),
            University(name = "중앙승가대학교", emailSuffix = "sangha.ac.kr"),
            University(name = "중원대학교", emailSuffix = "jwu.ac.kr"),
            University(name = "진주교육대학교", emailSuffix = "cue.ac.kr"),
            University(name = "진주산업대학교(산업대)", emailSuffix = "gntech.ac.kr"),
            University(name = "차의과학대학교", emailSuffix = "cha.ac.kr"),
            University(name = "창신대학교", emailSuffix = "cs.ac.kr"),
            University(name = "창원대학교", emailSuffix = "changwon.ac.kr"),
            University(name = "청운대학교", emailSuffix = "chungwoon.ac.kr"),
            University(name = "청주교육대학교", emailSuffix = "cje.ac.kr"),
            University(name = "청주대학교", emailSuffix = "cju.ac.kr"),
            University(name = "초당대학교", emailSuffix = "chodang.ac.kr"),
            University(name = "초당대학교(산업대)", emailSuffix = "chodang.ac.kr"),
            University(name = "총신대학교", emailSuffix = "chongshin.ac.kr"),
            University(name = "추계예술대학교", emailSuffix = "chugye.ac.kr"),
            University(name = "춘천교육대학교", emailSuffix = "cnue.ac.kr"),
            University(name = "충남대학교", emailSuffix = "cnu.ac.kr"),
            University(name = "충북대학교", emailSuffix = "chungbuk.ac.kr"),
            University(name = "침례신학대학교", emailSuffix = "kbtus.ac.kr"),
            University(name = "칼빈대학교", emailSuffix = "calvin.ac.kr"),
            University(name = "탐라대학교", emailSuffix = "tnu.ac.kr"),
            University(name = "평택대학교", emailSuffix = "ptu.ac.kr"),
            University(name = "POSTECH", emailSuffix = "postech.ac.kr"),
            University(name = "한경대학교", emailSuffix = "hknu.ac.kr"),
            University(name = "한경대학교(산업대)", emailSuffix = "hknu.ac.kr"),
            University(name = "KAIST", emailSuffix = "kaist.ac.kr"),
            University(name = "한국교원대학교", emailSuffix = "knue.ac.kr"),
            University(name = "한국교통대학교", emailSuffix = "ut.ac.kr"),
            University(name = "한국교통대학교(산업대)", emailSuffix = "ut.ac.kr"),
            University(name = "한국국제대학교", emailSuffix = "iuk.ac.kr"),
            University(name = "한국기술교육대학교", emailSuffix = "koreatech.ac.kr"),
            University(name = "한국방송통신대학교", emailSuffix = "knou.ac.kr"),
            University(name = "한국산업기술대학교", emailSuffix = "kpu.ac.kr"),
            University(name = "한국산업기술대학교(산업대)", emailSuffix = "kpu.ac.kr"),
            University(name = "한국성서대학교", emailSuffix = "bible.ac.kr"),
            University(name = "한국예술종합학교", emailSuffix = "karts.ac.kr"),
            University(name = "한국외국어대학교", emailSuffix = "hufs.ac.kr"),
            University(name = "한국전통문화대학교", emailSuffix = "nuch.ac.kr"),
            University(name = "한국체육대학교", emailSuffix = "knsu.ac.kr"),
            University(name = "한국항공대학교", emailSuffix = "kau.kr"),
            University(name = "한국해양대학교", emailSuffix = "kmou.ac.kr"),
            University(name = "한남대학교", emailSuffix = "hannam.ac.kr"),
            University(name = "한동대학교", emailSuffix = "handong.edu"),
            University(name = "한라대학교", emailSuffix = "halla.ac.kr"),
            University(name = "한려대학교", emailSuffix = "hanlyo.ac.kr"),
            University(name = "한려대학교(산업대)", emailSuffix = "hanlyo.ac.kr"),
            University(name = "한림대학교", emailSuffix = "hallym.ac.kr"),
            University(name = "한민학교", emailSuffix = "hanmin.ac.kr"),
            University(name = "한밭대학교", emailSuffix = "hanbat.ac.kr"),
            University(name = "한밭대학교(산업대)", emailSuffix = "hanbat.ac.kr"),
            University(name = "한북대학교", emailSuffix = "hanbuk.ac.kr"),
            University(name = "한서대학교", emailSuffix = "hanseo.ac.kr"),
            University(name = "한성대학교", emailSuffix = "hansung.ac.kr"),
            University(name = "한세대학교", emailSuffix = "uohs.ac.kr"),
            University(name = "한신대학교", emailSuffix = "hs.ac.kr"),
            University(name = "한양대학교", emailSuffix = "hanyang.ac.kr"),
            University(name = "한양대학교(ERICA)", emailSuffix = "hanyang.ac.kr"),
            University(name = "한양사이버대학교", emailSuffix = "hycu.ac.kr"),
            University(name = "한영신학대학교", emailSuffix = "hytu.ac.kr"),
            University(name = "한일장신대학교", emailSuffix = "hanil.ac.kr"),
            University(name = "한중대학교", emailSuffix = "hanzhong.ac.kr"),
            University(name = "협성대학교", emailSuffix = "uhs.ac.kr"),
            University(name = "호남대학교", emailSuffix = "honam.ac.kr"),
            University(name = "호남신학대학교", emailSuffix = "htus.ac.kr"),
            University(name = "호서대학교", emailSuffix = "hoseo.edu"),
            University(name = "호원대학교", emailSuffix = "howon.ac.kr"),
            University(name = "홍익대학교", emailSuffix = "hongik.ac.kr"),
            University(name = "홍익대학교(세종)", emailSuffix = "hongik.ac.kr"),
            University(name = "화신사이버대학교", emailSuffix = "hscu.ac.kr"),
        )
        universityRepository.saveAll(universities)
    }

    private fun populateDepartment() {
        val departments = listOf(
            Department(title = "언어정보학과"),
            Department(title = "국어국문학과"),
            Department(title = "독어독문학과"),
            Department(title = "노어노문학과"),
            Department(title = "영어영문학과"),
            Department(title = "일어일문학과"),
            Department(title = "중어중문학과"),
            Department(title = "불어불문학과"),
            Department(title = "서어서문학과"),
            Department(title = "북한학과"),
            Department(title = "철학과"),
            Department(title = "사학과"),
            Department(title = "문화인류학과"),
            Department(title = "문예창작학과"),
            Department(title = "문헌정보학과"),
            Department(title = "관광학과"),
            Department(title = "한문학과"),
            Department(title = "신학과"),
            Department(title = "불교학과"),
            Department(title = "자율전공학과"),
            Department(title = "경영학과"),
            Department(title = "경제학과"),
            Department(title = "경영정보학과"),
            Department(title = "국제통상학과"),
            Department(title = "광고홍보학과"),
            Department(title = "금융학과"),
            Department(title = "회계학과"),
            Department(title = "세무학과"),
            Department(title = "심리학과"),
            Department(title = "법학과"),
            Department(title = "사회학과"),
            Department(title = "도시학과"),
            Department(title = "정치외교학과"),
            Department(title = "국제학과"),
            Department(title = "사회복지학과"),
            Department(title = "미디어커뮤니케이션학과"),
            Department(title = "지리학과"),
            Department(title = "행정학과"),
            Department(title = "군사학과"),
            Department(title = "경찰행정학과"),
            Department(title = "아동가족학과"),
            Department(title = "소비자학과"),
            Department(title = "물류학과"),
            Department(title = "무역학과"),
            Department(title = "호텔경영학과"),
            Department(title = "가정교육과"),
            Department(title = "건설공학교육과"),
            Department(title = "과학교육과"),
            Department(title = "전기전자통신공학교육과"),
            Department(title = "기계재료공학교육과"),
            Department(title = "기술교육과"),
            Department(title = "농업교육과"),
            Department(title = "물리교육과"),
            Department(title = "미술교육과"),
            Department(title = "사회교육과"),
            Department(title = "생물교육과"),
            Department(title = "수학교육과"),
            Department(title = "수해양산업교육과"),
            Department(title = "아동교육과"),
            Department(title = "언어치료학과"),
            Department(title = "언어교육학과"),
            Department(title = "역사교육과"),
            Department(title = "음악교육과"),
            Department(title = "윤리교육과"),
            Department(title = "종교교육과"),
            Department(title = "지구과학교육과"),
            Department(title = "지리교육과"),
            Department(title = "체육교육과"),
            Department(title = "초등교육과"),
            Department(title = "컴퓨터교육과"),
            Department(title = "특수교육과"),
            Department(title = "한문교육과"),
            Department(title = "화학교육과"),
            Department(title = "환경교육과"),
            Department(title = "컴퓨터공학과"),
            Department(title = "조선공학과"),
            Department(title = "산업공학과"),
            Department(title = "멀티미디어학과"),
            Department(title = "게임공학과"),
            Department(title = "미디어출판과"),
            Department(title = "재료공학과"),
            Department(title = "화장품과"),
            Department(title = "건축학과"),
            Department(title = "물류시스템공학과"),
            Department(title = "해양공학과"),
            Department(title = "고분자공학과"),
            Department(title = "광학공학과"),
            Department(title = "교통공학과"),
            Department(title = "국방기술학과"),
            Department(title = "금속공학과"),
            Department(title = "금형설계과"),
            Department(title = "기계공학과"),
            Department(title = "나노공학과"),
            Department(title = "냉동공조공학과"),
            Department(title = "도시공학과"),
            Department(title = "로봇공학과"),
            Department(title = "무인항공학과"),
            Department(title = "반도체과"),
            Department(title = "산업설비자동화과"),
            Department(title = "섬유과"),
            Department(title = "세라믹공학과"),
            Department(title = "소방방재학과"),
            Department(title = "시스템공학과"),
            Department(title = "신소재공학과"),
            Department(title = "신재생에너지과"),
            Department(title = "안전공학과"),
            Department(title = "에너지자원공학과"),
            Department(title = "원자력공학과"),
            Department(title = "자동차과"),
            Department(title = "전기공학과"),
            Department(title = "전자공학과"),
            Department(title = "정보보호학과"),
            Department(title = "제어계측공학과"),
            Department(title = "제지공학과"),
            Department(title = "조경과"),
            Department(title = "지구해양과학과"),
            Department(title = "철도교통과"),
            Department(title = "측지정보과"),
            Department(title = "토목공학과"),
            Department(title = "특수장비과"),
            Department(title = "항공공학과"),
            Department(title = "화학공학과"),
            Department(title = "환경화학과"),
            Department(title = "생명공학과"),
            Department(title = "조리학과"),
            Department(title = "원예과"),
            Department(title = "농수산과"),
            Department(title = "환경공학과"),
            Department(title = "동물학과"),
            Department(title = "제약공학과"),
            Department(title = "식품학과"),
            Department(title = "수의학과"),
            Department(title = "천문학과"),
            Department(title = "물리학과"),
            Department(title = "수학과"),
            Department(title = "화학과"),
            Department(title = "의류학과"),
            Department(title = "임산공학"),
            Department(title = "지질학과"),
            Department(title = "지리학과(자연)"),
            Department(title = "의예과"),
            Department(title = "간호학과"),
            Department(title = "약학과"),
            Department(title = "치의학과"),
            Department(title = "물리치료학과"),
            Department(title = "한의예과"),
            Department(title = "환경보건학과"),
            Department(title = "응급구조학과"),
            Department(title = "의무행정과"),
            Department(title = "의료장비공학과"),
            Department(title = "임상병리학과"),
            Department(title = "방사선과"),
            Department(title = "소방안전관리과"),
            Department(title = "예술치료학과"),
            Department(title = "언어재활과"),
            Department(title = "순수미술과"),
            Department(title = "응용미술과"),
            Department(title = "조형과"),
            Department(title = "공예과"),
            Department(title = "공업디자인과"),
            Department(title = "그래픽디자인과"),
            Department(title = "미디어영상학과"),
            Department(title = "애니메이션과"),
            Department(title = "기악과"),
            Department(title = "성악과"),
            Department(title = "음악과"),
            Department(title = "실용음악과"),
            Department(title = "연극영화과"),
            Department(title = "패션디자인과"),
            Department(title = "실내디자인과"),
            Department(title = "광고디자인과"),
            Department(title = "댄스스포츠과"),
            Department(title = "사회체육과"),
            Department(title = "경호학과"),
            Department(title = "건강관리과"),
            Department(title = "메이크업아티스트과"),
            Department(title = "모델과"),
            Department(title = "보석감정과"),
            Department(title = "산업잠수과"),
            Department(title = ""),

        )

        departmentRepository.saveAll(departments)
    }

    private fun populateUser() {
        val university = universityRepository.findById(205).get()!!

        val users = listOf(
            User(
                name = "김덕배",
                email = "duck@kookmin.ac.kr",
                nickname = "duckduck",
                password = "123123a",
                university = university,
            ),
            User(
                name = "홍길동",
                email = "hong@kookmin.ac.kr",
                nickname = "honggildong",
                password = "123123a",
                university = university,
            ),
            User(
                name = "김철수",
                email = "chulsu@kookmin.ac.kr",
                nickname = "chulsukim",
                password = "5678efgh",
                university = university,
            ),
            User(
                name = "이영희",
                email = "zerotwo@kookmin.ac.kr",
                nickname = "zerotwo",
                password = "9012ijkl",
                university = university,
            ),
            User(
                name = "박민수",
                email = "minsu@kookmin.ac.kr",
                nickname = "minsupark",
                password = "3456mnop",
                university = university,
            ),
            User(
                name = "최영희",
                email = "younghee@kookmin.ac.kr",
                nickname = "youngheec",
                password = "7890qrst",
                university = university,
            ),
            User(
                name = "김응수",
                email = "yeswater@kookmin.ac.kr",
                nickname = "yeswater",
                password = "4567uvwx",
                university = university,
            ),
            User(
                name = "김민수",
                email = "minsoo@kookmin.ac.kr",
                nickname = "mskim",
                password = "1234abcd",
                university = university,
            ),
            User(
                name = "이다은",
                email = "daeun@kookmin.ac.kr",
                nickname = "daeunlee",
                password = "9012ijkl",
                university = university,
            ),
            User(
                name = "이승민",
                email = "seungmin@kookmin.ac.kr",
                nickname = "seungmine",
                password = "7890qrst",
                university = university,
            ),
        )

        val savedUser = userRepository.saveAll(users)

        belongRepository.saveAll(
            savedUser.map {
                Belong(userId = it.id, ids = listOf(75, 163))
            },
        )
    }

    private fun populateCommunity() {
        val departments = departmentRepository.findAll()
            .forEach {
                communityRepository.saveAll(
                    listOf(
                        Community(title = "FREE", departmentId = it.id),
                        Community(title = "GRADUATE", departmentId = it.id),
                        Community(title = "JOB", departmentId = it.id),
                        Community(title = "STUDY", departmentId = it.id),
                        Community(title = "QUESTION", departmentId = it.id),
                        Community(title = "PROMOTION", departmentId = it.id),
                    ),
                )
            }
    }

    private fun populateDummyPosts() {
        val users = userRepository.findAll()
        val communityIds = (445L..450L).toList()

        val dummyPosts = mutableListOf<Post>()
        val batchSize = 10000
        var number = 1

        for (user in users) {
            for (i in 1..100000) {
                val communityId = communityIds.random()
                val community = communityRepository.findById(communityId).get()
                val post = createDummyPost(user, community, number)
                dummyPosts.add(post)
                number++


                if (dummyPosts.size >= batchSize) {
                    prev()
                    bulkInsertRepository.bulkInsert(dummyPosts)
                    nxt()
                    dummyPosts.clear()
                }
            }
        }
    }

    private fun populateBlacklist(){
        val blacklists = mutableListOf<Blacklist>()
        var number = 1L
        val batchSize = 100000
        val totalSize = 100000 * 30
        for(i in 1..totalSize){
            val blacklist= Blacklist(invalidRefreshToken = generateRandomString(100),id=i.toLong())
            blacklists.add(blacklist)
            if(blacklists.size >= batchSize){
                prev()
                bulkInsertRepository.bulkBlacklistInsert(blacklists)
                nxt()
                blacklists.clear()
            }
        }
    }

    fun generateRandomString(length: Int): String {
        val chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        return (1..length)
            .map { chars.random() }
            .joinToString("")
    }

    private fun createDummyPost(user: User, community: Community, number: Int): Post {
        val title = "Dummy Post Title $number"
        val content = "Dummy Post Content"
        val createdDateTime = LocalDateTime.now()

        return Post(user.id, community.id, title, content, PostLikes(), createdDateTime = createdDateTime,id=number.toLong())
    }

    private fun populateDummyComments() {
        val users = userRepository.findAll()
        val posts = postRepository.findAll()

        val dummyComments = mutableListOf<Comment>()

        var num = 1
        for (user in users) {
            for (post in posts) {
                val comment = createDummyComment(user, post, num)
                dummyComments.add(comment)
                num++
                post.increaseCommentReplyCount()
            }
        }

        commentRepository.saveAll(dummyComments)
    }

    private fun createDummyComment(user: User, post: Post, num: Int): Comment {
        val content = "댓글 $num"
        val createdDateTime = LocalDateTime.now()

        return Comment(user.id, post.id, content, createdDateTime = createdDateTime)
    }

    private fun populateDummyReplies() {
        val users = userRepository.findAll()
        val comments = commentRepository.findAll()
        val posts = postRepository.findAll()

        val dummyReplies = mutableListOf<Reply>()

        var num = 1
        for (user in users) {
            for (comment in comments) {
                val reply = createDummyReply(user, comment, num)
                dummyReplies.add(reply)
                num++
                comment.increaseReplyCount()

                val post = posts.find { it.id == comment.postId }
                post?.increaseCommentReplyCount()
            }
        }

        replyRepository.saveAll(dummyReplies)
    }

    private fun createDummyReply(user: User, comment: Comment, num: Int): Reply {
        val content = "대댓글 $num"
        val createdDateTime = LocalDateTime.now()

        return Reply(user.id, comment.id, content, createdDateTime = createdDateTime)
    }
}
