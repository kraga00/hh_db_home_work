INSERT INTO "users" (id, email, password, registration_time, last_visit)
  SELECT
    GENERATE_SERIES(1000, 100000) as id,
    substring(MD5(RANDOM()::TEXT) FROM 1 FOR 20) || ('{@mail.ru, @ya.ru, @rambler.ru, @gmail.com}'::text[])[ceil(random()*4)] AS email,
    MD5(RANDOM()::TEXT)              AS password,
    TIMESTAMP '2017-01-01 20:00:00' + random() * (NOW() - TIMESTAMP '2018-01-01 20:00:00')                        AS registration_time,
    TIMESTAMP '2018-01-01 20:00:00' + random() * (NOW() - TIMESTAMP '2018-01-01 20:00:00')                            AS last_visit
  ON CONFLICT (email) DO NOTHING;

INSERT INTO company (id, name, user_id)
  SELECT
    GENERATE_SERIES(100, 5100),
    MD5(RANDOM() :: TEXT),
    GENERATE_SERIES(1000, 6000) as user_id;

INSERT INTO currency (id, code_name)
  VALUES (100, 'RUR'),
         (101, 'USD');

INSERT INTO skill (id, name)
  SELECT
    GENERATE_SERIES(100, 1100),
    MD5(RANDOM()::TEXT)
  ON CONFLICT (name) DO NOTHING;


INSERT INTO vacancy (id, company_id, position_name, description, salary_from, salary_to, experience, public_date, expired_date, currency_id)
  SELECT
    GENERATE_SERIES(1000, 1001000) as id,

    RANDOM() * 5000 + 100 as company_id,

    MD5(RANDOM() :: TEXT) as position_name,
    MD5(RANDOM() :: TEXT) as description,
    ROUND(RANDOM() * 100000) as salary_from,
    ROUND(RANDOM() * 200000) as salary_to,
    ROUND(RANDOM() * 10) as experience,

    TIMESTAMP '2017-12-01 20:00:00' + random() * (NOW() - TIMESTAMP '2018-01-01 20:00:00') as public_date,
    TIMESTAMP '2017-01-01 20:00:00' + random() * (NOW() - TIMESTAMP '2018-01-01 20:00:00') as expired_date,

    CASE
      WHEN random()>0.3 THEN 100 ELSE 101
    END as currnecy_id;


INSERT INTO resume (id, user_id, name, last_name, first_name, middle_name, birth_date, salary_from, salary_to, experience, currency_id)
  SELECT
    GENERATE_SERIES(1000, 2001000) as id,

    RANDOM() * 1000 + 10000 as user_id,

    MD5(RANDOM() :: TEXT) as name,
    MD5(RANDOM() :: TEXT) as last_name,
    MD5(RANDOM() :: TEXT) as first_name,
    MD5(RANDOM() :: TEXT) as middle_name,
    TIMESTAMP '1970-01-01 20:00:00' + random() * (TIMESTAMP '2008-01-01 20:00:00' - TIMESTAMP '1970-01-01 20:00:00') as birth_date,
    ROUND(RANDOM() * 100000) as salary_from,
    ROUND(RANDOM() * 200000) as salary_to,
    ROUND(RANDOM() * 100) as experience,
    CASE
      WHEN random()>0.3 THEN 100 ELSE 101
    END  as currency_id;


INSERT INTO response (id, vacancy_id, user_id, time)
  SELECT
    GENERATE_SERIES(1000, 2001000) as id,

    RANDOM() * 1000 + 10000 as vacancy_id,

    RANDOM() * 1000 + 10000 as user_id,

    TIMESTAMP '2017-01-01 20:00:00' + random() * (NOW() - TIMESTAMP '2018-01-01 20:00:00');

INSERT INTO message_type (id, code_name)
   VALUES (100, 'request'),
         (101, 'response');


INSERT INTO message (id, vacancy_id, resume_id, user_id, text, type_id, time)
  SELECT
    GENERATE_SERIES (1000, 2000000) as id,

    RANDOM() * 1000 + 10000 as vacancy_id,

    RANDOM() * 1000 + 10000 as resume_id,

    RANDOM() * 1000 + 10000 as user_id,

    MD5(RANDOM()::TEXT),

    CASE
      WHEN random()>0.3 THEN 100 ELSE 101
    END  as currency_id,

    TIMESTAMP '2017-01-01 20:00:00' + random() * (NOW() - TIMESTAMP '2018-01-01 20:00:00');
