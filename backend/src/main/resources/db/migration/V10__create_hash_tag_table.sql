create table hash_tag
(
    id        bigint       not null auto_increment,
    target_id bigint       not null,
    name      varchar(255) not null,
    target    enum ('RECRUITMENT'),
    primary key (id)
) engine=InnoDB;

ALTER TABLE recruitment ADD COLUMN comment_count INTEGER DEFAULT 0 NOT NULL;
