CREATE TABLE IF NOT EXISTS user_login (
    id SERIAL PRIMARY KEY,
    social_id int NOT NULL,
    name varchar(256) NOT NULL,
    email varchar(256) NOT NULL,
    institution varchar(256) NOT NULL
);

CREATE TABLE IF NOT EXISTS "users" (
    user_id SERIAL PRIMARY KEY,
    login_id int REFERENCES user_login (id),
    username varchar(256) NOT NULL,
    aws_username varchar(256) NOT NULL,
    password_hash varchar(256),
    email varchar(256),
    created_on timestamptz,
    modified_on timestamptz,
    created_by int,
    modified_by int
);

CREATE TABLE IF NOT EXISTS user_token (
    user_id int REFERENCES users (user_id),
    type varchar(256),
    token text,
    token_expiration timestamptz,

    CONSTRAINT user_token_pk PRIMARY KEY (user_id, type)
);

CREATE TABLE IF NOT EXISTS user_role (
    user_id int REFERENCES users (user_id),
    role varchar(256),
    created_on timestamptz,
    modified_on timestamptz,
    created_by int,
    modified_by int,

    CONSTRAINT user_role_pk PRIMARY KEY (user_id, role)
);

CREATE TABLE IF NOT EXISTS user_team (
    user_id int REFERENCES users (user_id),
    team_id int,
    team_name varchar(256),
    created_on timestamptz,
    modified_on timestamptz,
    created_by int,
    modified_by int,

    CONSTRAINT user_team_pk PRIMARY KEY (user_id, team_id)
);

CREATE TABLE IF NOT EXISTS jupyter_user (
    user_id int REFERENCES users (user_id),
    jupyter_username varchar(256),
    jupyter_pwd varchar(256),
    jupyter_token varchar(256),
    created_on timestamptz,
    modified_on timestamptz,
    created_by int,
    modified_by int,

    CONSTRAINT user_jupyter_pk PRIMARY KEY (user_id, jupyter_username)
);

CREATE TABLE IF NOT EXISTS user_job (
    job_id varchar(256) PRIMARY KEY,
    user_id int REFERENCES users (user_id),
    message_id varchar(256),
    s3_location varchar(256),
    efs_location varchar(256),
    job_status varchar(256),
    type varchar(256),
    description varchar(256),
    dataset varchar(256),
    started_on timestamptz,
    modified_on timestamptz,
    started_by int,
    modified_by int
);

CREATE TABLE IF NOT EXISTS tool (
    tool_id varchar(256) PRIMARY KEY,
    description varchar(256),
    name varchar(256),
    script_name varchar(256),
    command varchar(256),
    permissions jsonb,
    created_on timestamptz,
    modified_on timestamptz,
    created_by int,
    modified_by int
);

CREATE TABLE IF NOT EXISTS archive (
    archive_id  varchar(256) PRIMARY KEY,
    s3_location varchar(256),
    description varchar(256),
    name varchar(256),
    permissions jsonb,
    created_on timestamptz,
    modified_on timestamptz,
    created_by int,
    modified_by int
);

CREATE TABLE IF NOT EXISTS package (
    package_id varchar(256),
    tool_id varchar(256) REFERENCES tool (tool_id),
    archive_id varchar(256) REFERENCES archive (archive_id),
    type varchar(256),
    description varchar(256),
    name varchar(256),
    doi varchar(256),
    permissions jsonb,
    created_on timestamptz,
    modified_on timestamptz,
    created_by int,
    modified_by int,

    CONSTRAINT package_pk PRIMARY KEY (package_id, archive_id)
);

CREATE TABLE IF NOT EXISTS share (
    share_id SERIAL PRIMARY KEY,
    type varchar(256),
    shared_list jsonb,
    created_on timestamptz,
    modified_on timestamptz,
    created_by int,
    modified_by int
);


