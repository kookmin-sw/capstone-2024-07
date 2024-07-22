create table recruitment_comment
(
    id                  bigint       not null auto_increment,
    user_id             bigint       not null,
    recruitment_id      bigint       not null,
    reply_count         integer      not null,
    content             varchar(255) not null,
    created_date_time   datetime(6)  not null,
    modified_date_time  datetime(6)  not null,
    version             bigint       not null,
    deleted             bit          not null,
    primary key (id)
) engine=InnoDB;

create table recruitment_reply
(
    id                      bigint       not null auto_increment,
    user_id                 bigint       not null,
    recruitment_comment_id  bigint       not null,
    content                 varchar(255) not null,
    created_date_time       datetime(6)  not null,
    modified_date_time      datetime(6)  not null,
    deleted                 bit          not null,
    primary key (id)
) engine=InnoDB;

