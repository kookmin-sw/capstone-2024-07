create table anonymous
(
    id                bigint      not null auto_increment,
    user_id           bigint      not null,
    post_id           bigint      not null,
    deleted           bit         not null,
    primary key (id)
) engine = InnoDB;

ALTER TABLE post ADD COLUMN is_anonymous BOOLEAN DEFAULT FALSE NOT NULL;
ALTER TABLE comment ADD COLUMN is_anonymous BOOLEAN DEFAULT FALSE NOT NULL;
ALTER TABLE reply ADD COLUMN is_anonymous BOOLEAN DEFAULT FALSE NOT NULL;
