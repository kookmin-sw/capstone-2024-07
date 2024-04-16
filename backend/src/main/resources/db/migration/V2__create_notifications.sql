create table notifications
(
    is_read    bit          not null,
    created_at datetime(6) not null,
    id         bigint       not null auto_increment,
    post_id    bigint       not null,
    user_id    bigint       not null,
    content    varchar(255) not null,
    type       enum ('COMMENT','REPLY') not null,
    primary key (id)
) engine=InnoDB