create table recommend
(
    id        bigint       not null auto_increment,
    user_name varchar(255) not null,
    primary key (id)
) engine=InnoDB;
