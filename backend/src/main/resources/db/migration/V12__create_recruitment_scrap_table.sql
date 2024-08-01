create table recruitment_scrap
(
    deleted        bit    not null,
    id             bigint not null auto_increment,
    recruitment_id bigint not null,
    user_id        bigint not null,
    primary key (id)
) engine=InnoDB;
