create table authentication_code
(
    authenticated     bit          not null,
    deleted           bit          not null,
    created_date_time datetime(6) not null,
    id                bigint       not null auto_increment,
    code              char(6)      not null,
    email             varchar(255) not null,
    primary key (id)
) engine=InnoDB;

create table belong
(
    deleted            bit     not null,
    major_index        integer not null,
    id                 bigint  not null auto_increment,
    modified_date_time datetime(6) not null,
    user_id            bigint  not null,
    primary key (id),
    constraint UK_belong_user_id unique (user_id)
) engine=InnoDB;

create table blacklist
(
    deleted               bit          not null,
    id                    bigint       not null auto_increment,
    invalid_refresh_token varchar(255) not null,
    primary key (id)
) engine=InnoDB;

create table comment
(
    deleted            bit          not null,
    created_date_time  datetime(6) not null,
    id                 bigint       not null auto_increment,
    modified_date_time datetime(6) not null,
    post_id            bigint       not null,
    user_id            bigint       not null,
    content            varchar(255) not null,
    primary key (id)
) engine=InnoDB;

create table comment_likes
(
    comment_id bigint not null,
    users_id   bigint not null,
    constraint FK_comment_likes_comment_id foreign key (comment_id) references comment (id)
) engine=InnoDB;

create table community
(
    deleted       bit          not null,
    department_id bigint       not null,
    id            bigint       not null auto_increment,
    title         varchar(100) not null,
    description   varchar(255) not null,
    primary key (id)
) engine=InnoDB;

create table department
(
    deleted bit          not null,
    id      bigint       not null auto_increment,
    title   varchar(255) not null,
    primary key (id)
) engine=InnoDB;

create table join_department
(
    _department_ids bigint,
    belong_id bigint not null,
    constraint FK_join_department_belong_id foreign key (belong_id) references belong (id)
) engine=InnoDB;

create table post
(
    comment_reply_count integer,
    deleted             bit          not null,
    is_question         bit          not null,
    like_count          integer,
    scrap_count         integer,
    community_id        bigint       not null,
    created_date_time   datetime(6) not null,
    id                  bigint       not null auto_increment,
    modified_date_time  datetime(6) not null,
    user_id             bigint       not null,
    title               varchar(100) not null,
    content             varchar(255) not null,
    primary key (id)
) engine=InnoDB;

create table post_images
(
    post_id   bigint       not null,
    image_key varchar(255) not null,
    constraint FK_post_images_post_id foreign key (post_id) references post (id)
) engine=InnoDB;

create table post_likes
(
    post_id  bigint not null,
    users_id bigint not null,
    constraint FK_post_likes_post_id foreign key (post_id) references post (id)
) engine=InnoDB;

create table reply
(
    deleted            bit          not null,
    comment_id         bigint       not null,
    created_date_time  datetime(6) not null,
    id                 bigint       not null auto_increment,
    modified_date_time datetime(6) not null,
    user_id            bigint       not null,
    content            varchar(255) not null,
    primary key (id)
) engine=InnoDB;

create table reply_likes
(
    reply_id bigint not null,
    users_id bigint not null,
    constraint FK_reply_likes_reply_id foreign key (reply_id) references reply (id)
) engine=InnoDB;

create table scrap
(
    deleted bit    not null,
    id      bigint not null auto_increment,
    post_id bigint not null,
    user_id bigint not null,
    primary key (id)
) engine=InnoDB;

create table university
(
    id           bigint       not null auto_increment,
    email_suffix varchar(255) not null,
    logo         varchar(255) not null,
    name         varchar(255) not null,
    primary key (id)
) engine=InnoDB;

create table users
(
    deleted       bit          not null,
    id            bigint       not null auto_increment,
    university_id bigint       not null,
    nickname      varchar(13)  not null,
    name          varchar(30)  not null,
    email         varchar(255) not null,
    password      varchar(255) not null,
    primary key (id),
    constraint UK_users_email unique (email),
    constraint FK_users_university_id foreign key (university_id) references university (id)
) engine=InnoDB;

INSERT INTO department (deleted, title) VALUES (0, '언어정보학과');
INSERT INTO department (deleted, title) VALUES (0, '국어국문학과');
INSERT INTO department (deleted, title) VALUES (0, '독어독문학과');
INSERT INTO department (deleted, title) VALUES (0, '노어노문학과');
INSERT INTO department (deleted, title) VALUES (0, '영어영문학과');
INSERT INTO department (deleted, title) VALUES (0, '일어일문학과');
INSERT INTO department (deleted, title) VALUES (0, '중어중문학과');
INSERT INTO department (deleted, title) VALUES (0, '불어불문학과');
INSERT INTO department (deleted, title) VALUES (0, '서어서문학과');
INSERT INTO department (deleted, title) VALUES (0, '북한학과');
INSERT INTO department (deleted, title) VALUES (0, '철학과');
INSERT INTO department (deleted, title) VALUES (0, '사학과');
INSERT INTO department (deleted, title) VALUES (0, '문화인류학과');
INSERT INTO department (deleted, title) VALUES (0, '문예창작학과');
INSERT INTO department (deleted, title) VALUES (0, '문헌정보학과');
INSERT INTO department (deleted, title) VALUES (0, '관광학과');
INSERT INTO department (deleted, title) VALUES (0, '한문학과');
INSERT INTO department (deleted, title) VALUES (0, '신학과');
INSERT INTO department (deleted, title) VALUES (0, '불교학과');
INSERT INTO department (deleted, title) VALUES (0, '자율전공학과');
INSERT INTO department (deleted, title) VALUES (0, '경영학과');
INSERT INTO department (deleted, title) VALUES (0, '경제학과');
INSERT INTO department (deleted, title) VALUES (0, '경영정보학과');
INSERT INTO department (deleted, title) VALUES (0, '국제통상학과');
INSERT INTO department (deleted, title) VALUES (0, '광고홍보학과');
INSERT INTO department (deleted, title) VALUES (0, '금융학과');
INSERT INTO department (deleted, title) VALUES (0, '회계학과');
INSERT INTO department (deleted, title) VALUES (0, '세무학과');
INSERT INTO department (deleted, title) VALUES (0, '심리학과');
INSERT INTO department (deleted, title) VALUES (0, '법학과');
INSERT INTO department (deleted, title) VALUES (0, '사회학과');
INSERT INTO department (deleted, title) VALUES (0, '도시학과');
INSERT INTO department (deleted, title) VALUES (0, '정치외교학과');
INSERT INTO department (deleted, title) VALUES (0, '국제학과');
INSERT INTO department (deleted, title) VALUES (0, '사회복지학과');
INSERT INTO department (deleted, title) VALUES (0, '미디어커뮤니케이션학과');
INSERT INTO department (deleted, title) VALUES (0, '지리학과');
INSERT INTO department (deleted, title) VALUES (0, '행정학과');
INSERT INTO department (deleted, title) VALUES (0, '군사학과');
INSERT INTO department (deleted, title) VALUES (0, '경찰행정학과');
INSERT INTO department (deleted, title) VALUES (0, '아동가족학과');
INSERT INTO department (deleted, title) VALUES (0, '소비자학과');
INSERT INTO department (deleted, title) VALUES (0, '물류학과');
INSERT INTO department (deleted, title) VALUES (0, '무역학과');
INSERT INTO department (deleted, title) VALUES (0, '호텔경영학과');
INSERT INTO department (deleted, title) VALUES (0, '가정교육과');
INSERT INTO department (deleted, title) VALUES (0, '건설공학교육과');
INSERT INTO department (deleted, title) VALUES (0, '과학교육과');
INSERT INTO department (deleted, title) VALUES (0, '전기전자통신공학교육과');
INSERT INTO department (deleted, title) VALUES (0, '기계재료공학교육과');
INSERT INTO department (deleted, title) VALUES (0, '기술교육과');
INSERT INTO department (deleted, title) VALUES (0, '농업교육과');
INSERT INTO department (deleted, title) VALUES (0, '물리교육과');
INSERT INTO department (deleted, title) VALUES (0, '미술교육과');
INSERT INTO department (deleted, title) VALUES (0, '사회교육과');
INSERT INTO department (deleted, title) VALUES (0, '생물교육과');
INSERT INTO department (deleted, title) VALUES (0, '수학교육과');
INSERT INTO department (deleted, title) VALUES (0, '수해양산업교육과');
INSERT INTO department (deleted, title) VALUES (0, '아동교육과');
INSERT INTO department (deleted, title) VALUES (0, '언어치료학과');
INSERT INTO department (deleted, title) VALUES (0, '언어교육학과');
INSERT INTO department (deleted, title) VALUES (0, '역사교육과');
INSERT INTO department (deleted, title) VALUES (0, '음악교육과');
INSERT INTO department (deleted, title) VALUES (0, '윤리교육과');
INSERT INTO department (deleted, title) VALUES (0, '종교교육과');
INSERT INTO department (deleted, title) VALUES (0, '지구과학교육과');
INSERT INTO department (deleted, title) VALUES (0, '지리교육과');
INSERT INTO department (deleted, title) VALUES (0, '체육교육과');
INSERT INTO department (deleted, title) VALUES (0, '초등교육과');
INSERT INTO department (deleted, title) VALUES (0, '컴퓨터교육과');
INSERT INTO department (deleted, title) VALUES (0, '특수교육과');
INSERT INTO department (deleted, title) VALUES (0, '한문교육과');
INSERT INTO department (deleted, title) VALUES (0, '화학교육과');
INSERT INTO department (deleted, title) VALUES (0, '환경교육과');
INSERT INTO department (deleted, title) VALUES (0, '컴퓨터공학과');
INSERT INTO department (deleted, title) VALUES (0, '조선공학과');
INSERT INTO department (deleted, title) VALUES (0, '산업공학과');
INSERT INTO department (deleted, title) VALUES (0, '멀티미디어학과');
INSERT INTO department (deleted, title) VALUES (0, '게임공학과');
INSERT INTO department (deleted, title) VALUES (0, '미디어출판과');
INSERT INTO department (deleted, title) VALUES (0, '재료공학과');
INSERT INTO department (deleted, title) VALUES (0, '화장품과');
INSERT INTO department (deleted, title) VALUES (0, '건축학과');
INSERT INTO department (deleted, title) VALUES (0, '물류시스템공학과');
INSERT INTO department (deleted, title) VALUES (0, '해양공학과');
INSERT INTO department (deleted, title) VALUES (0, '고분자공학과');
INSERT INTO department (deleted, title) VALUES (0, '광학공학과');
INSERT INTO department (deleted, title) VALUES (0, '교통공학과');
INSERT INTO department (deleted, title) VALUES (0, '국방기술학과');
INSERT INTO department (deleted, title) VALUES (0, '금속공학과');
INSERT INTO department (deleted, title) VALUES (0, '금형설계과');
INSERT INTO department (deleted, title) VALUES (0, '기계공학과');
INSERT INTO department (deleted, title) VALUES (0, '나노공학과');
INSERT INTO department (deleted, title) VALUES (0, '냉동공조공학과');
INSERT INTO department (deleted, title) VALUES (0, '도시공학과');
INSERT INTO department (deleted, title) VALUES (0, '로봇공학과');
INSERT INTO department (deleted, title) VALUES (0, '무인항공학과');
INSERT INTO department (deleted, title) VALUES (0, '반도체과');
INSERT INTO department (deleted, title) VALUES (0, '산업설비자동화과');
INSERT INTO department (deleted, title) VALUES (0, '섬유과');
INSERT INTO department (deleted, title) VALUES (0, '세라믹공학과');
INSERT INTO department (deleted, title) VALUES (0, '소방방재학과');
INSERT INTO department (deleted, title) VALUES (0, '시스템공학과');
INSERT INTO department (deleted, title) VALUES (0, '신소재공학과');
INSERT INTO department (deleted, title) VALUES (0, '신재생에너지과');
INSERT INTO department (deleted, title) VALUES (0, '안전공학과');
INSERT INTO department (deleted, title) VALUES (0, '에너지자원공학과');
INSERT INTO department (deleted, title) VALUES (0, '원자력공학과');
INSERT INTO department (deleted, title) VALUES (0, '자동차과');
INSERT INTO department (deleted, title) VALUES (0, '전기공학과');
INSERT INTO department (deleted, title) VALUES (0, '전자공학과');
INSERT INTO department (deleted, title) VALUES (0, '정보보호학과');
INSERT INTO department (deleted, title) VALUES (0, '제어계측공학과');
INSERT INTO department (deleted, title) VALUES (0, '제지공학과');
INSERT INTO department (deleted, title) VALUES (0, '조경과');
INSERT INTO department (deleted, title) VALUES (0, '지구해양과학과');
INSERT INTO department (deleted, title) VALUES (0, '철도교통과');
INSERT INTO department (deleted, title) VALUES (0, '측지정보과');
INSERT INTO department (deleted, title) VALUES (0, '토목공학과');
INSERT INTO department (deleted, title) VALUES (0, '특수장비과');
INSERT INTO department (deleted, title) VALUES (0, '항공공학과');
INSERT INTO department (deleted, title) VALUES (0, '화학공학과');
INSERT INTO department (deleted, title) VALUES (0, '환경화학과');
INSERT INTO department (deleted, title) VALUES (0, '생명공학과');
INSERT INTO department (deleted, title) VALUES (0, '조리학과');
INSERT INTO department (deleted, title) VALUES (0, '원예과');
INSERT INTO department (deleted, title) VALUES (0, '농수산과');
INSERT INTO department (deleted, title) VALUES (0, '환경공학과');
INSERT INTO department (deleted, title) VALUES (0, '동물학과');
INSERT INTO department (deleted, title) VALUES (0, '제약공학과');
INSERT INTO department (deleted, title) VALUES (0, '식품학과');
INSERT INTO department (deleted, title) VALUES (0, '수의학과');
INSERT INTO department (deleted, title) VALUES (0, '천문학과');
INSERT INTO department (deleted, title) VALUES (0, '물리학과');
INSERT INTO department (deleted, title) VALUES (0, '수학과');
INSERT INTO department (deleted, title) VALUES (0, '화학과');
INSERT INTO department (deleted, title) VALUES (0, '의류학과');
INSERT INTO department (deleted, title) VALUES (0, '임산공학');
INSERT INTO department (deleted, title) VALUES (0, '지질학과');
INSERT INTO department (deleted, title) VALUES (0, '지리학과');
INSERT INTO department (deleted, title) VALUES (0, '의예과');
INSERT INTO department (deleted, title) VALUES (0, '간호학과');
INSERT INTO department (deleted, title) VALUES (0, '약학과');
INSERT INTO department (deleted, title) VALUES (0, '치의학과');
INSERT INTO department (deleted, title) VALUES (0, '물리치료학과');
INSERT INTO department (deleted, title) VALUES (0, '한의예과');
INSERT INTO department (deleted, title) VALUES (0, '환경보건학과');
INSERT INTO department (deleted, title) VALUES (0, '응급구조학과');
INSERT INTO department (deleted, title) VALUES (0, '의무행정과');
INSERT INTO department (deleted, title) VALUES (0, '의료장비공학과');
INSERT INTO department (deleted, title) VALUES (0, '임상병리학과');
INSERT INTO department (deleted, title) VALUES (0, '방사선과');
INSERT INTO department (deleted, title) VALUES (0, '소방안전관리과');
INSERT INTO department (deleted, title) VALUES (0, '예술치료학과');
INSERT INTO department (deleted, title) VALUES (0, '언어재활과');
INSERT INTO department (deleted, title) VALUES (0, '순수미술과');
INSERT INTO department (deleted, title) VALUES (0, '응용미술과');
INSERT INTO department (deleted, title) VALUES (0, '조형과');
INSERT INTO department (deleted, title) VALUES (0, '공예과');
INSERT INTO department (deleted, title) VALUES (0, '공업디자인과');
INSERT INTO department (deleted, title) VALUES (0, '그래픽디자인과');
INSERT INTO department (deleted, title) VALUES (0, '미디어영상학과');
INSERT INTO department (deleted, title) VALUES (0, '애니메이션과');
INSERT INTO department (deleted, title) VALUES (0, '기악과');
INSERT INTO department (deleted, title) VALUES (0, '성악과');
INSERT INTO department (deleted, title) VALUES (0, '음악과');
INSERT INTO department (deleted, title) VALUES (0, '실용음악과');
INSERT INTO department (deleted, title) VALUES (0, '연극영화과');
INSERT INTO department (deleted, title) VALUES (0, '패션디자인과');
INSERT INTO department (deleted, title) VALUES (0, '실내디자인과');
INSERT INTO department (deleted, title) VALUES (0, '광고디자인과');
INSERT INTO department (deleted, title) VALUES (0, '댄스스포츠과');
INSERT INTO department (deleted, title) VALUES (0, '사회체육과');
INSERT INTO department (deleted, title) VALUES (0, '경호학과');
INSERT INTO department (deleted, title) VALUES (0, '건강관리과');
INSERT INTO department (deleted, title) VALUES (0, '메이크업아티스트과');
INSERT INTO department (deleted, title) VALUES (0, '모델과');
INSERT INTO department (deleted, title) VALUES (0, '보석감정과');
INSERT INTO department (deleted, title) VALUES (0, '산업잠수과');

INSERT INTO university (email_suffix, logo, name) VALUES ('gachon.ac.kr','','가천길대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('csj.ac.kr','','가톨릭상지대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gangdong.ac.kr','','강동대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gyc.ac.kr','','강릉영동대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kt.ac.kr','','강원관광대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('gw.ac.kr','','강원도립대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('koje.ac.kr','','거제대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gtec.ac.kr','','경기과학기술대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gc.ac.kr','','경남도립거창대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('namhae.ac.kr','','경남도립남해대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('kit.ac.kr','','경남정보대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kyungmin.ac.kr','','경민대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kbu.ac.kr','','경복대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kbsc.ac.kr','','경북과학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gpc.ac.kr','','경북도립대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kbc.ac.kr','','경북전문대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gs.ac.kr','','경산1대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kwc.ac.kr','','경원전문대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('kic.ac.kr','','경인여자대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kmcu.ac.kr','','계명문화대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kaywon.ac.kr','','계원예술대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kgrc.ac.kr','','고구려대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kwangyang.ac.kr','','광양보건대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ghu.ac.kr','','광주보건대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gumi.ac.kr','','구미대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('saotc.ac.kr','','구세군사관학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kookje.ac.kr','','국제대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kcn.ac.kr','','군산간호대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kunjang.ac.kr','','군장대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ccn.ac.kr','','기독간호대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kcs.ac.kr','','김천과학대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('gimcheon.ac.kr','','김천대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('kimpo.ac.kr','','김포대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gimhae.ac.kr','','김해대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('nonghyup.ac.kr','','농협대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('tk.ac.kr','','대경대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ttc.ac.kr','','대구공업대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('tsu.ac.kr','','대구과학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dfc.ac.kr','','대구미래대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dhc.ac.kr','','대구보건대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ddu.ac.kr','','대덕대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('daedong.ac.kr','','대동대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('daelim.ac.kr','','대림대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('daewon.ac.kr','','대원대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hit.ac.kr','','대전보건대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dkc.ac.kr','','동강대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dongnam.ac.kr','','동남보건대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('tu.ac.kr','','동명대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('dpc.ac.kr','','동부산대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dsc.ac.kr','','동서울대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dima.ac.kr','','동아방송예술대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dongac.ac.kr','','동아인재대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dongyang.ac.kr','','동양미래대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('duc.ac.kr','','동우대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('dist.ac.kr','','동원과학기술대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('tw.ac.kr','','동원대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dit.ac.kr','','동의과학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dongju.ac.kr','','동주대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('doowon.ac.kr','','두원공과대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('masan.ac.kr','','마산대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('mjc.ac.kr','','명지전문대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('mokpo-c.ac.kr','','목포과학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('mkc.ac.kr','','문경대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('baewha.ac.kr','','배화여자대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('bscu.ac.kr','','백석문화대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('paekche.ac.kr','','백제예술대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('bs.ac.kr','','벽성대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('bsks.ac.kr','','부산경상대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('bist.ac.kr','','부산과학기술대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('bwc.ac.kr','','부산여자대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('busanarts.ac.kr','','부산예술대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('bc.ac.kr','','부천대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('shu.ac.kr','','삼육보건대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('syu.ac.kr','','삼육의명대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('sy.ac.kr','','상지영서대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sorabol.ac.kr','','서라벌대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('seoyeong.ac.kr','','서영대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('shjc.ac.kr','','서울보건대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('snjc.ac.kr','','서울여자간호대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('seoularts.ac.kr','','서울예술대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('seoil.ac.kr','','서일대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('seojeong.ac.kr','','서정대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sohae.ac.kr','','서해대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('sunlin.ac.kr','','선린대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sdc.ac.kr','','성덕대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sungsim.ac.kr','','성심외국어대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('saekyung.ac.kr','','세경대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('songgok.ac.kr','','송곡대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('songwon.ac.kr','','송원대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('songho.ac.kr','','송호대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sc.ac.kr','','수성대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ssc.ac.kr','','수원과학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('swc.ac.kr','','수원여자대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('suncheon.ac.kr','','순천제일대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('sewc.ac.kr','','숭의여자대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('shingu.ac.kr','','신구대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('shinsung.ac.kr','','신성대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sau.ac.kr','','신안산대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('shc.ac.kr','','신흥대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('motor.ac.kr','','아주자동차대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('asc.ac.kr','','안동과학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ansan.ac.kr','','안산대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('yit.ac.kr','','여주대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('yeonsung.ac.kr','','연성대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('yc.ac.kr','','연암공과대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('yflc.ac.kr','','영남외국어대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('ync.ac.kr','','영남이공대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ycc.ac.kr','','영진사이버대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('yjc.ac.kr','','영진전문대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('osan.ac.kr','','오산대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ysc.ac.kr','','용인송담대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('wst.ac.kr','','우송공업대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('wsi.ac.kr','','우송정보대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('uc.ac.kr','','울산과학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('wat.ac.kr','','웅지세무대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('wkhc.ac.kr','','원광보건대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('wonju.ac.kr','','원주대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('yuhan.ac.kr','','유한대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('induk.ac.kr','','인덕대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('jeiu.ac.kr','','인천재능대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('icc.ac.kr','','인천전문대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('itc.ac.kr','','인하공업전문대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('jangan.ac.kr','','장안대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('cau.ac.kr','','적십자간호대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('chunnam-c.ac.kr','','전남과학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dorip.ac.kr','','전남도립대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('jbsc.ac.kr','','전북과학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('jk.ac.kr','','전주기전대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('jvision.ac.kr','','전주비전대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ctc.ac.kr','','제주관광대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('jeju.ac.kr','','제주산업정보대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('chu.ac.kr','','제주한라대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('cnc.ac.kr','','조선간호대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('cst.ac.kr','','조선이공대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('jhc.ac.kr','','진주보건대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('csc.ac.kr','','창신대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('cmu.ac.kr','','창원문성대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('yonam.ac.kr','','천안연암대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('chungkang.academy','','청강문화산업대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('scjc.ac.kr','','청암대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ch.ac.kr','','춘해보건대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('cyc.ac.kr','','충남도립청양대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('cpu.ac.kr','','충북도립대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('chsu.ac.kr','','충북보건과학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ok.ac.kr','','충청대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('pohang.ac.kr','','포항대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kg.ac.kr','','한국골프대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('ktc.ac.kr','','한국관광대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('af.ac.kr','','한국농수산대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('hanrw.ac.kr','','한국복지대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('corea.ac.kr','','한국복지사이버대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('klc.ac.kr','','한국승강기대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('pro.ac.kr','','한국영상대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('icpc.ac.kr','','한국정보통신기능대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('krc.ac.kr','','한국철도대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('kopo.ac.kr ','','한국폴리텍');
INSERT INTO university (email_suffix, logo, name) VALUES ('hsc.ac.kr','','한림성심대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hywoman.ac.kr','','한양여자대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hanyeong.ac.kr','','한영대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('hj.ac.kr','','혜전대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('hu.ac.kr','','혜천대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kaya.ac.kr','','가야대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gachon.ac.kr','','가천대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gachon.ac.kr','','가천의과학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('catholic.ac.kr','','가톨릭대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('mtu.ac.kr','','감리교신학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kangnam.ac.kr','','강남대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gwnu.ac.kr','','강릉원주대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kangwon.ac.kr','','강원대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('konkuk.ac.kr','','건국대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kku.ac.kr','','건국대학교(글로컬)');
INSERT INTO university (email_suffix, logo, name) VALUES ('konyang.ac.kr','','건양대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kycu.ac.kr','','건양사이버대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kyonggi.ac.kr','','경기대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gntech.ac.kr','','경남과학기술대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hanma.kr','','경남대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('k1.ac.kr','','경동대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('knu.ac.kr','','경북대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kufs.ac.kr','','경북외국어대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gnu.ac.kr','','경상대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ks.ac.kr','','경성대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ikw.ac.kr','','경운대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ikw.ac.kr','','경운대학교(산업대)');
INSERT INTO university (email_suffix, logo, name) VALUES ('ginue.ac.kr','','경인교육대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kiu.kr','','경일대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gju.ac.kr','','경주대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('khu.ac.kr','','경희대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('khcu.ac.kr','','경희사이버대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kmu.ac.kr','','계명대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('korea.ac.kr','','고려대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('korea.ac.kr','','고려대학교(세종)');
INSERT INTO university (email_suffix, logo, name) VALUES ('cuk.edu','','고려사이버대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kosin.ac.kr','','고신대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gjue.ac.kr','','공주교육대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('smail.kongju.ac.kr','','공주대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('cku.ac.kr','','가톨릭관동대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kwangshin.ac.kr','','광신대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kw.ac.kr','','광운대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kjcatholic.ac.kr','','광주가톨릭대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gist.ac.kr','','GIST');
INSERT INTO university (email_suffix, logo, name) VALUES ('gnue.ac.kr','','광주교육대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gwangju.ac.kr','','광주대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gwangju.ac.kr','','광주대학교(산업대)');
INSERT INTO university (email_suffix, logo, name) VALUES ('kwu.ac.kr','','광주여자대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kookmin.ac.kr','','국민대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gcu.ac','','국제사이버대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kunsan.ac.kr','','군산대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kcu.ac.kr','','그리스도대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kdu.ac.kr','','극동대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('global.ac.kr','','글로벌사이버대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ggu.ac.kr','','금강대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kumoh.ac.kr','','금오공과대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gimcheon.ac.kr','','김천대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kkot.ac.kr','','꽃동네대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kornu.ac.kr','','나사렛대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('nambu.ac.kr','','남부대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('nsu.ac.kr','','남서울대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('nsu.ac.kr','','남서울대학교(산업대)');
INSERT INTO university (email_suffix, logo, name) VALUES ('dankook.ac.kr','','단국대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('cu.ac.kr','','대구가톨릭대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dgist.ac.kr','','DGIST');
INSERT INTO university (email_suffix, logo, name) VALUES ('dnue.ac.kr','','대구교육대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('daegu.ac.kr','','대구대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dcu.ac.kr','','대구사이버대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dgau.ac.kr','','대구예술대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dufs.ac.kr','','대구외국어대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dhu.ac.kr','','대구한의대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('daeshin.ac.kr','','대신대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dcatholic.ac.kr','','대전가톨릭대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('edu.dju.ac.kr','','대전대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('daejeon.ac.kr','','대전신학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('daejeon.ac.kr','','대전신학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('daejin.ac.kr','','대진대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('duksung.ac.kr','','덕성여자대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dongguk.edu','','동국대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dongguk.ac.kr','','동국대학교(경주)');
INSERT INTO university (email_suffix, logo, name) VALUES ('dongduk.ac.kr','','동덕여자대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('tu.ac.kr','','동명대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('tu.ac.kr','','동명정보대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dongseo.ac.kr','','동서대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dsu.kr','','동신대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('donga.ac.kr','','동아대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('dyu.ac.kr','','동양대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('deu.ac.kr','','동의대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('scau.ac.kr','','디지털서울문화예술대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ltu.ac.kr','','루터대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('mju.ac.kr','','명지대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('mokwon.ac.kr','','목원대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('mcu.ac.kr','','목포가톨릭대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('mokpo.ac.kr','','목포대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('mmu.ac.kr','','목포해양대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('pcu.ac.kr','','배재대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('bu.ac.kr','','백석대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('pukyong.ac.kr','','부경대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('cup.ac.kr','','부산가톨릭대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('bnue.ac.kr','','부산교육대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('pusan.ac.kr','','부산대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('bdu.ac.kr','','부산디지털대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('bufs.ac.kr','','부산외국어대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('bpu.ac.kr','','부산장신대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('cufs.ac.kr','','사이버한국외국어대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('syuin.ac.kr','','삼육대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sangmyung.kr','','상명대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sangmyung.kr','','상명대학교(천안)');
INSERT INTO university (email_suffix, logo, name) VALUES ('knu.ac.kr','','상주대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sangji.ac.kr','','상지대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sogang.ac.kr','','서강대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('skuniv.ac.kr','','서경대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('seonam.ac.kr','','서남대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('seoultech.ac.kr','','서울과학기술대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('seoultech.ac.kr','','서울과학기술대학교(산업대)');
INSERT INTO university (email_suffix, logo, name) VALUES ('snue.ac.kr','','서울교육대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('scu.ac.kr','','서울기독대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('snu.ac.kr','','서울대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sdu.ac.kr','','서울디지털대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('iscu.ac.kr','','서울사이버대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('uos.ac.kr','','서울시립대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('stu.ac.kr','','서울신학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('swu.ac.kr','','서울여자대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sjs.ac.kr','','서울장신대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('seowon.ac.kr','','서원대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sunmoon.ac.kr','','선문대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sungkyul.ac.kr','','성결대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('skhu.ac.kr','','성공회대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('skku.edu','','성균관대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sungshin.ac.kr','','성신여자대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('semyung.ac.kr','','세명대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sju.ac.kr','','세종대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sjcu.ac.kr','','세종사이버대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sehan.ac.kr','','세한대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('songwon.ac.kr','','송원대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('suwoncatholic.ac.kr','','수원가톨릭대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('suwon.ac.kr','','수원대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sookmyung.ac.kr','','숙명여자대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kcc.ac.kr','','순복음총회신학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('scnu.ac.kr','','순천대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sch.ac.kr','','순천향대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('soongsil.ac.kr','','숭실대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kcu.ac','','숭실사이버대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('sgu.ac.kr','','신경대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('silla.ac.kr','','신라대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('acts.ac.kr','','아세아연합신학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ajou.ac.kr','','아주대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('anu.ac.kr','','안동대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ayum.anyang.ac.kr','','안양대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('yonsei.ac.kr','','연세대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('yonsei.ac.kr','','연세대학교(원주)');
INSERT INTO university (email_suffix, logo, name) VALUES ('ocu.ac.kr','','열린사이버대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ynu.ac.kr','','영남대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ytus.ac.kr','','영남신학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('u1.ac.kr','','유원대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ysu.ac.kr','','영산대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ysu.ac.kr','','영산대학교(산업대)');
INSERT INTO university (email_suffix, logo, name) VALUES ('youngsan.ac.kr','','영산선학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('jesus.ac.kr','','예수대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('yewon.ac.kr','','예원예술대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('yiu.ac.kr','','용인대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('woosuk.ac.kr','','우석대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('wsu.ac.kr','','우송대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('wsu.ac.kr','','우송대학교(산업대)');
INSERT INTO university (email_suffix, logo, name) VALUES ('unist.ac.kr','','UNIST');
INSERT INTO university (email_suffix, logo, name) VALUES ('ulsan.ac.kr','','울산대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('wonkwang.ac.kr','','원광대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('wdu.ac.kr','','원광디지털대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('uu.ac.kr','','위덕대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('eulji.ac.kr','','을지대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ewhain.net','','이화여자대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('inje.ac.kr','','인제대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('iccu.ac.kr','','인천가톨릭대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('inu.ac.kr','','인천대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('inha.edu','','인하대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('pcts.ac.kr','','장로회신학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('jnu.ac.kr','','전남대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('jbnu.ac.kr','','전북대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('jnue.kr','','전주교육대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('jj.ac.kr','','전주대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('jit.ac.kr','','정석대학');
INSERT INTO university (email_suffix, logo, name) VALUES ('jejue.ac.kr','','제주교육대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('jeju.ac.kr','','제주국제대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('jejunu.ac.kr','','제주대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('chosun.kr','','조선대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('jmail.ac.kr','','중부대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('cau.ac.kr','','중앙대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('cau.ac.kr','','중앙대학교(안성)');
INSERT INTO university (email_suffix, logo, name) VALUES ('sangha.ac.kr','','중앙승가대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('jwu.ac.kr','','중원대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('cue.ac.kr','','진주교육대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('gntech.ac.kr','','진주산업대학교(산업대)');
INSERT INTO university (email_suffix, logo, name) VALUES ('cha.ac.kr','','차의과학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('cs.ac.kr','','창신대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('changwon.ac.kr','','창원대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('chungwoon.ac.kr','','청운대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('cje.ac.kr','','청주교육대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('cju.ac.kr','','청주대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('chodang.ac.kr','','초당대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('chodang.ac.kr','','초당대학교(산업대)');
INSERT INTO university (email_suffix, logo, name) VALUES ('chongshin.ac.kr','','총신대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('chugye.ac.kr','','추계예술대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('cnue.ac.kr','','춘천교육대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('cnu.ac.kr','','충남대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('chungbuk.ac.kr','','충북대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kbtus.ac.kr','','침례신학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('calvin.ac.kr','','칼빈대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('tnu.ac.kr','','탐라대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ptu.ac.kr','','평택대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('postech.ac.kr','','POSTECH');
INSERT INTO university (email_suffix, logo, name) VALUES ('hknu.ac.kr','','한경대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hknu.ac.kr','','한경대학교(산업대)');
INSERT INTO university (email_suffix, logo, name) VALUES ('kaist.ac.kr','','KAIST');
INSERT INTO university (email_suffix, logo, name) VALUES ('knue.ac.kr','','한국교원대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ut.ac.kr','','한국교통대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('ut.ac.kr','','한국교통대학교(산업대)');
INSERT INTO university (email_suffix, logo, name) VALUES ('iuk.ac.kr','','한국국제대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('koreatech.ac.kr','','한국기술교육대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('knou.ac.kr','','한국방송통신대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kpu.ac.kr','','한국산업기술대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kpu.ac.kr','','한국산업기술대학교(산업대)');
INSERT INTO university (email_suffix, logo, name) VALUES ('bible.ac.kr','','한국성서대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('karts.ac.kr','','한국예술종합학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hufs.ac.kr','','한국외국어대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('nuch.ac.kr','','한국전통문화대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('knsu.ac.kr','','한국체육대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kau.kr','','한국항공대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('kmou.ac.kr','','한국해양대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hannam.ac.kr','','한남대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('handong.edu','','한동대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('halla.ac.kr','','한라대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hanlyo.ac.kr','','한려대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hanlyo.ac.kr','','한려대학교(산업대)');
INSERT INTO university (email_suffix, logo, name) VALUES ('hallym.ac.kr','','한림대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hanmin.ac.kr','','한민학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hanbat.ac.kr','','한밭대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hanbat.ac.kr','','한밭대학교(산업대)');
INSERT INTO university (email_suffix, logo, name) VALUES ('hanbuk.ac.kr','','한북대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hanseo.ac.kr','','한서대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hansung.ac.kr','','한성대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('uohs.ac.kr','','한세대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hs.ac.kr','','한신대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hanyang.ac.kr','','한양대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hanyang.ac.kr','','한양대학교(ERICA)');
INSERT INTO university (email_suffix, logo, name) VALUES ('hycu.ac.kr','','한양사이버대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hytu.ac.kr','','한영신학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hanil.ac.kr','','한일장신대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hanzhong.ac.kr','','한중대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('uhs.ac.kr','','협성대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('honam.ac.kr','','호남대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('htus.ac.kr','','호남신학대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hoseo.edu','','호서대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('howon.ac.kr','','호원대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hongik.ac.kr','','홍익대학교');
INSERT INTO university (email_suffix, logo, name) VALUES ('hongik.ac.kr','','홍익대학교(세종)');
INSERT INTO university (email_suffix, logo, name) VALUES ('hscu.ac.kr','','화신사이버대학교');

-- FREE Community 생성
INSERT INTO community (deleted, department_id, title, description)
SELECT 0, id, 'FREE', '자유'
FROM department;

-- GRADUATE Community 생성
INSERT INTO community (deleted, department_id, title, description)
SELECT 0, id, 'GRADUATE', '대학원'
FROM department;

-- JOB Community 생성
INSERT INTO community (deleted, department_id, title, description)
SELECT 0, id, 'JOB', '취준'
FROM department;

-- STUDY Community 생성
INSERT INTO community (deleted, department_id, title, description)
SELECT 0, id, 'STUDY', '학업 및 스터디 구인'
FROM department;

-- QUESTION Community 생성
INSERT INTO community (deleted, department_id, title, description)
SELECT 0, id, 'QUESTION', '질문과 답변'
FROM department;

-- PROMOTION Community 생성
INSERT INTO community (deleted, department_id, title, description)
SELECT 0, id, 'PROMOTION', '홍보'
FROM department;