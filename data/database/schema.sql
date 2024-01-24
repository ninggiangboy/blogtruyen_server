DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS public.users
(
    user_id           UUID PRIMARY KEY             DEFAULT uuid_generate_v4(),
    username          VARCHAR(50) UNIQUE  NOT NULL,
    email             VARCHAR(100) UNIQUE NOT NULL,
    display_name      VARCHAR(100),
    profile_image     TEXT                         DEFAULT NULL,
    hashed_password   VARCHAR(255)        NOT NULL,
    is_email_verified BOOLEAN             NOT NULL DEFAULT FALSE,
    is_blocked        BOOLEAN             NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS public.roles
(
    role_id   SERIAL PRIMARY KEY,
    role_name VARCHAR(20) UNIQUE NOT NULL,
    role_desc TEXT DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS public.permissions
(
    permission_id   SERIAL PRIMARY KEY,
    permission_name VARCHAR(50) UNIQUE NOT NULL,
    permission_desc TEXT DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS public.user_role
(
    user_id UUID    NOT NULL,
    role_id INTEGER NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES public.users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES public.roles (role_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.role_permission
(
    role_id       INTEGER NOT NULL,
    permission_id INTEGER NOT NULL,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES public.roles (role_id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES public.permissions (permission_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.translation_groups
(
    group_id      SERIAL PRIMARY KEY,
    group_name    VARCHAR(50) NOT NULL,
    profile_image TEXT DEFAULT NULL,
    group_desc    TEXT DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS public.group_member
(
    group_id INTEGER NOT NULL,
    user_id  UUID    NOT NULL,
    role_id  INTEGER NOT NULL,
    PRIMARY KEY (group_id, user_id),
    FOREIGN KEY (group_id) REFERENCES public.translation_groups (group_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES public.users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES public.roles (role_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.tags
(
    tag_id    SERIAL PRIMARY KEY,
    tag_name  VARCHAR(50) UNIQUE NOT NULL,
    is_active BOOLEAN            NOT NULL DEFAULT TRUE,
    tag_slug  TEXT               NOT NULL,
    tag_desc  TEXT                        DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS public.authors
(
    author_id            SERIAL PRIMARY KEY,
    author_pseudonym     VARCHAR(50) NOT NULL,
    author_profile_image TEXT DEFAULT NULL,
    author_desc          TEXT DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS public.mangas
(
    manga_id               SERIAL PRIMARY KEY,
    author_id              INTEGER      NOT NULL,
    manga_name             VARCHAR(100) NOT NULL,
    manga_slug             TEXT UNIQUE  NOT NULL,
    translation_group_id   INTEGER      NOT NULL,
    manga_short_desc       TEXT                  DEFAULT NULL,
    manga_full_desc_html   TEXT                  DEFAULT NULL,
    manga_cover_image      TEXT                  DEFAULT NULL,
    total_views_last_day   INTEGER               DEFAULT 0,
    total_views_last_week  INTEGER               DEFAULT 0,
    total_views_last_month INTEGER               DEFAULT 0,
    manga_status           VARCHAR(20)  NOT NULL,
    created_at             TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_updated_at        TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES public.authors (author_id) ON DELETE CASCADE,
    FOREIGN KEY (translation_group_id) REFERENCES public.translation_groups (group_id) ON DELETE CASCADE,
    CONSTRAINT valid_status
        CHECK (manga_status IN ('DRAFT', 'PENDING', 'IN_PROCESS', 'ARCHIVED', 'FINISHED', 'BLOCKED'))
);

CREATE TABLE IF NOT EXISTS public.user_manga_bookmark
(
    user_id  UUID    NOT NULL,
    manga_id INTEGER NOT NULL,
    PRIMARY KEY (user_id, manga_id),
    FOREIGN KEY (user_id) REFERENCES public.users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (manga_id) REFERENCES public.mangas (manga_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.chapters
(
    chapter_id          SERIAL PRIMARY KEY,
    manga_id            INTEGER      NOT NULL,
    uploader_id         UUID         NOT NULL,
    chapter_name        VARCHAR(100) NOT NULL,
    chapter_status      VARCHAR(20)  NOT NULL,
    chapter_slug        TEXT         NOT NULL,
    chapter_content     TEXT         NOT NULL,
    chapter_number      INTEGER      NOT NULL,
    chapter_views_count INTEGER      NOT NULL DEFAULT 0,
    created_at          TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_updated_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (manga_id) REFERENCES public.mangas (manga_id) ON DELETE CASCADE,
    FOREIGN KEY (uploader_id) REFERENCES public.users (user_id) ON DELETE CASCADE,
    CONSTRAINT valid_chapter_status
        CHECK (chapter_status IN ('DRAFT', 'PENDING', 'PUBLISHED', 'ARCHIVED'))
);

CREATE TABLE IF NOT EXISTS public.user_read_history
(
    user_id    UUID    NOT NULL,
    chapter_id INTEGER NOT NULL,
    PRIMARY KEY (user_id, chapter_id),
    FOREIGN KEY (user_id) REFERENCES public.users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (chapter_id) REFERENCES public.chapters (chapter_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.manga_tag
(
    manga_id INTEGER NOT NULL,
    tag_id   INTEGER NOT NULL,
    PRIMARY KEY (manga_id, tag_id),
    FOREIGN KEY (manga_id) REFERENCES public.mangas (manga_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES public.tags (tag_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.comments
(
    comment_id      SERIAL PRIMARY KEY,
    manga_id        INTEGER NOT NULL,
    reply_on_id     INTEGER                  DEFAULT NULL,
    user_id         UUID    NOT NULL,
    comment_content TEXT    NOT NULL,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT now(),
    last_updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    FOREIGN KEY (manga_id) REFERENCES public.mangas (manga_id) ON DELETE CASCADE,
    FOREIGN KEY (reply_on_id) REFERENCES public.comments (comment_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES public.users (user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.comment_likes
(
    comment_id INTEGER NOT NULL,
    user_id    UUID    NOT NULL,
    PRIMARY KEY (comment_id, user_id),
    FOREIGN KEY (comment_id) REFERENCES public.comments (comment_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES public.users (user_id) ON DELETE CASCADE
);