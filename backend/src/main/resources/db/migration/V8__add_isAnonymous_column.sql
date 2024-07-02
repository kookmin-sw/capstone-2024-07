create table post_comment_ids
(
    post_id          bigint not null,
    _comment_ids     bigint null,
    _comment_ids_key bigint not null,
    primary key (post_id, _comment_ids_key),
    constraint FK_post_comment_ids_post_id foreign key (post_id) references post (id)
);

ALTER TABLE post ADD COLUMN is_anonymous BOOLEAN DEFAULT FALSE NOT NULL;
ALTER TABLE post ADD COLUMN next_value BIGINT DEFAULT 1 NOT NULL;

ALTER TABLE comment ADD COLUMN is_anonymous BOOLEAN DEFAULT FALSE NOT NULL;
ALTER TABLE comment ADD COLUMN is_owner BOOLEAN DEFAULT FALSE NOT NULL;

ALTER TABLE reply ADD COLUMN is_anonymous BOOLEAN DEFAULT FALSE NOT NULL;
ALTER TABLE reply ADD COLUMN is_owner BOOLEAN DEFAULT FALSE NOT NULL;
