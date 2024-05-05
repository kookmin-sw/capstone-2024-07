create table blocklist
(
    id                bigint      not null auto_increment,
    user_id           bigint      not null,
    created_date_time datetime(6) not null,
    primary key (id)
) engine = InnoDB;