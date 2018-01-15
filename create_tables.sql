CREATE TABLE IF NOT EXISTS users (
    id                BIGSERIAL PRIMARY KEY,
    email             VARCHAR(255) NOT NULL UNIQUE,
    password          VARCHAR(128) NOT NULL,
    registration_time TIMESTAMP WITH TIME ZONE NOT NULL,
    last_visit        TIMESTAMP WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS currency(
    id        SERIAL PRIMARY KEY,
    code_name VARCHAR(3)
);

CREATE TABLE IF NOT EXISTS skill (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(128) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS resume (
    id                BIGSERIAL PRIMARY KEY,
    user_id           INTEGER NOT NULL
		CONSTRAINT resume_user_id_user_id
			REFERENCES users(id)
				deferrable initially deferred,
    first_name        VARCHAR(80) NOT NULL,
    last_name         VARCHAR(50) NOT NULL ,
    middle_name       VARCHAR(80) NULL,
    birth_date        DATE,
    experience SMALLINT,
    name              VARCHAR(255),
    salary_from       INTEGER,
    salary_to         INTEGER,
    currency_id       INTEGER NOT NULL
    CONSTRAINT resume_currency_id_currency_id
      REFERENCES currency(id)
				deferrable initially deferred

);

CREATE INDEX IF NOT EXISTS resume_user_idx ON resume(user_id);

CREATE TABLE IF NOT EXISTS resume_skill(
    resume_id INTEGER NOT NULL,
    skill_id  INTEGER NOT NULL,
    FOREIGN KEY (resume_id) REFERENCES resume(id),
    FOREIGN KEY (skill_id)  REFERENCES skill(id)
);

CREATE UNIQUE INDEX IF NOT EXISTS resume_skill_uniq
  ON resume_skill USING BTREE (resume_id, skill_id);
CREATE INDEX IF NOT EXISTS resume_skill_resume_idx
  ON resume_skill USING BTREE (resume_id);
CREATE INDEX IF NOT EXISTS resume_skill_skill_idx
  ON resume_skill USING BTREE (skill_id);

CREATE TABLE IF NOT EXISTS company(
    id      BIGSERIAL PRIMARY KEY,
    name    VARCHAR(128) NOT NULL,
    user_id INTEGER REFERENCES users(id)
);

CREATE INDEX IF NOT EXISTS company_user_idx ON company (user_id);

CREATE TABLE IF NOT EXISTS vacancy (
    id                BIGSERIAL PRIMARY KEY,
    company_id        INTEGER REFERENCES company(id) NOT NULL,
    position_name     VARCHAR(255),
    description       TEXT,
    salary_from       INTEGER,
    salary_to         INTEGER,
    experience SMALLINT,
    public_date       TIMESTAMP WITH TIME ZONE NOT NULL,
    expired_date      TIMESTAMP WITH TIME ZONE NOT NULL,
    currency_id       INTEGER NOT NULL
    CONSTRAINT vacancy_currency_id_currency_id
      REFERENCES currency(id)
				deferrable initially deferred
);

CREATE INDEX IF NOT EXISTS vacancy_company_idx ON vacancy(company_id);

CREATE TABLE IF NOT EXISTS vacancy_skill (
    vacancy_id INTEGER NOT NULL,
    skill_id   INTEGER NOT NULL,
    FOREIGN KEY (vacancy_id) REFERENCES vacancy (id),
    FOREIGN KEY (skill_id)   REFERENCES skill (id)
);

CREATE UNIQUE INDEX IF NOT EXISTS vacancy_skill_uniq
  ON vacancy_skill USING BTREE (vacancy_id, skill_id);
CREATE INDEX IF NOT EXISTS vacancy_skill_vacancy_idx
  ON vacancy_skill USING BTREE (vacancy_id);
CREATE INDEX IF NOT EXISTS vacancy_skill_skill_idx
  ON vacancy_skill USING BTREE (skill_id);


CREATE TABLE IF NOT EXISTS response (
    id         BIGSERIAL PRIMARY KEY,
    vacancy_id BIGINT NOT NULL,
    user_id    BIGINT NOT NULL,
    time       TIMESTAMP WITH TIME ZONE NOT NULL,
    FOREIGN KEY (user_id)    REFERENCES users(id),
    FOREIGN KEY (vacancy_id) REFERENCES vacancy(id)
);

CREATE INDEX IF NOT EXISTS response_vacancy_id_idx
  ON response (vacancy_id);
CREATE INDEX IF NOT EXISTS response_user_id_idx
  ON response (user_id);

CREATE TABLE IF NOT EXISTS message_type(
    id        SERIAL PRIMARY KEY,
    code_name VARCHAR(64)
);


CREATE TABLE IF NOT EXISTS message (
    id         BIGSERIAL PRIMARY KEY,
    vacancy_id BIGINT NOT NULL,
    resume_id  BIGINT NOT NULL,
    user_id    BIGINT NOT NULL,
    text       TEXT,
    type_id    INTEGER NOT NULL,
    time       TIMESTAMP WITH TIME ZONE NOT NULL,
    FOREIGN KEY (user_id)    REFERENCES users(id),
    FOREIGN KEY (vacancy_id) REFERENCES vacancy(id),
    FOREIGN KEY (resume_id)  REFERENCES resume(id),
    FOREIGN KEY (type_id)    REFERENCES message_type(id)
);

CREATE INDEX IF NOT EXISTS message_vacancy_id_idx
  ON message (vacancy_id);
CREATE INDEX IF NOT EXISTS message_resume_id_idx
  ON message (resume_id);
CREATE INDEX IF NOT EXISTS message_user_id_idx
  ON message (user_id);
