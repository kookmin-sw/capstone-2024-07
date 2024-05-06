create table user_block
(
    blocked_user_id bigint not null,
    blocker_user_id bigint not null,
    id              bigint not null auto_increment,
    primary key (id)
) engine=InnoDB