create table if not exists recruitment
(
    deleted            bit                       not null,
    is_ongoing         bit                       not null,
    is_online          bit                       not null,
    number             int                       null,
    recruitable        bit                       not null,
    scrap_count        int                       not null,
    created_date_time  datetime(6)               not null,
    department_id      bigint                    not null,
    end_date_time      datetime(6)               not null,
    id                 bigint auto_increment
    primary key,
    modified_date_time datetime(6)               not null,
    start_date_time    datetime(6)               not null,
    user_id            bigint                    not null,
    version            bigint                    not null,
    content            varchar(2000)              not null,
    title              varchar(255)              not null,
    type               enum ('STUDY', 'PROJECT') not null
) engine=InnoDB;
