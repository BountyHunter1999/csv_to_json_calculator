-- #!/bin/sh

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TEMP TABLE temp_people (
    name VARCHAR(100),
    state VARCHAR(100),
    gender VARCHAR(10)
);

CREATE TABLE people (
    name VARCHAR(100),
    state VARCHAR(100),
    gender VARCHAR(10),
    count INTEGER DEFAULT 1,
    sha256_hash BYTEA,
    PRIMARY KEY (sha256_hash)
);

-- execute a SQL script file from within a SQL session
-- or just make the name of the script in ascending and run it
-- \i /load_data.sql

-- COPY CSV data to temp table
COPY temp_people(name, state, gender)
FROM '/data.csv' DELIMITER ',' CSV HEADER;

WITH aggregated_people AS (
    SELECT 
        name,
        state,
        gender,
        digest(concat(name, state, gender), 'sha256') AS sha256_hash,
        COUNT(*) AS count
    FROM 
        temp_people
    GROUP BY 
        name, state, gender
        -- sha256_hash
)
INSERT INTO people (name, state, gender, count, sha256_hash)
SELECT
    name,
    state,
    gender,
    count, 
    digest(concat(name, state, gender), 'sha256') AS sha256_hash
FROM aggregated_people
ON CONFLICT (sha256_hash) DO UPDATE
SET
    count = people.count + 1;

DROP TABLE temp_people;
