create table report
(
    created_date_time  datetime(6) not null,
    id                 bigint not null auto_increment,
    reported_object_id bigint not null,
    reporter_id        bigint not null,
    reason             enum ('INSULTING','COMMERCIAL','INAPPROPRIATE','FRAUD','SPAM','PORNOGRAPHIC') not null,
    report_type        enum ('POST','COMMENT','REPLY') not null,
    primary key (id)
) engine=InnoDB