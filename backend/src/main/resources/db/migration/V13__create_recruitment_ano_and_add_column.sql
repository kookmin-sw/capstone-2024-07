create table recruitment_anonymous
(
    id             bigint not null auto_increment,
    recruitment_id bigint not null,
    user_id        bigint not null,
    primary key (id)
) engine=InnoDB;

alter table recruitment add column is_anonymous bit default TRUE;
alter table recruitment_comment add column is_anonymous bit default TRUE;
alter table recruitment_reply add column is_anonymous bit default TRUE;
