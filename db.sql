CREATE DATABASE IF NOT EXISTS attack_db;
USE attack_db;

CREATE TABLE attacks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    group_name VARCHAR(255) NOT NULL,
    country VARCHAR(100) NOT NULL,
    industry VARCHAR(100) NOT NULL,
    attack_type VARCHAR(100) NOT NULL,
    attack_technique VARCHAR(50) NOT NULL,
    attack_count INT NOT NULL
);

CREATE TABLE countries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE industries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    industry_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE attack_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    attack_type_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE attack_techniques (
    id INT AUTO_INCREMENT PRIMARY KEY,
    technique_code VARCHAR(50) UNIQUE NOT NULL
);

ALTER TABLE attacks
ADD CONSTRAINT fk_country FOREIGN KEY (country) REFERENCES countries(country_name),
ADD CONSTRAINT fk_industry FOREIGN KEY (industry) REFERENCES industries(industry_name),
ADD CONSTRAINT fk_attack_type FOREIGN KEY (attack_type) REFERENCES attack_types(attack_type_name),
ADD CONSTRAINT fk_attack_technique FOREIGN KEY (attack_technique) REFERENCES attack_techniques(technique_code);

INSERT INTO countries (country_name) VALUES
('미국'), ('중국'), ('한국'), ('일본'), ('인도'), ('러시아'), ('독일'),
('이스라엘'), ('영국'), ('프랑스'), ('브라질'), ('호주'),
('캐나다'), ('이탈리아'), ('이집트'), ('사우디아라비아'), ('남아프리카');

INSERT INTO industries (industry_name) VALUES
('정부'), ('제조'), ('과학기술'), ('통신'), ('금융'), ('의료'),
('물류'), ('교육'), ('방산'), ('에너지'), ('우주항공'),
('인터넷'), ('공공안전'), ('전자상거래'), ('미디어'), ('자동차');

INSERT INTO attack_types (attack_type_name) VALUES
('파일'), ('IP'), ('도메인'), ('링크');

INSERT INTO attack_techniques (technique_code) VALUES
('T1059'), ('T1106'), ('T1055'), ('T1112'), ('T1622'), ('T1010'),
('T1027'), ('T1203'), ('T1105'), ('T1071'), ('T1087'),
('T1003'), ('T1047'), ('T1218'), ('T1547'), ('T1486'),
('T1190'), ('T1134'), ('T1053'), ('T1090'), ('T1566');

INSERT INTO attacks (group_name, country, industry, attack_type, attack_technique, attack_count) VALUES
('Gold Evergreen', '중국', '정부', '파일', 'T1059', 80),
('Gold Evergreen', '미국', '제조', 'IP', 'T1106', 21),
('Gold Evergreen', '한국', '과학기술', '도메인', 'T1055', 22),
('Silver Falcon', '일본', '통신', '링크', 'T1027', 15),
('Silver Falcon', '독일', '금융', '파일', 'T1203', 8),
('Night Wolf', '한국', '정부', 'IP', 'T1059', 30),
('Night Wolf', '중국', '통신', '도메인', 'T1105', 45),
('Crimson Cobra', '러시아', '제조', '파일', 'T1106', 65),
('Shadow Panther', '미국', '통신', '링크', 'T1071', 20),
('Shadow Panther', '한국', '정부', '파일', 'T1087', 15),
('Dark Lotus', '이스라엘', '방산', 'IP', 'T1003', 17),
('Dark Lotus', '영국', '우주항공', '파일', 'T1047', 49),
('Crimson Hawk', '프랑스', '물류', '링크', 'T1218', 12),
('Crimson Hawk', '브라질', '미디어', '도메인', 'T1547', 35),
('Shadow Lynx', '호주', '에너지', 'IP', 'T1486', 41),
('Shadow Lynx', '캐나다', '전자상거래', '링크', 'T1190', 24),
('Violet Hydra', '이탈리아', '금융', '도메인', 'T1134', 65),
('Violet Hydra', '이집트', '교육', '파일', 'T1053', 31),
('Black Raven', '사우디아라비아', '공공안전', 'IP', 'T1090', 18),
('Black Raven', '남아프리카', '자동차', '도메인', 'T1566', 22),
('Fire Spider', '이스라엘', '정부', '파일', 'T1059', 55),
('Fire Spider', '브라질', '의료', '도메인', 'T1106', 26),
('Silver Flame', '호주', '인터넷', 'IP', 'T1071', 33),
('Silver Flame', '이집트', '교육', '링크', 'T1027', 29),
('Gold Specter', '프랑스', '제조', '파일', 'T1087', 11),
('Gold Specter', '사우디아라비아', '물류', '도메인', 'T1055', 19),
('Emerald Wind', '캐나다', '우주항공', 'IP', 'T1105', 13),
('Emerald Wind', '남아프리카', '방산', '링크', 'T1112', 47),
('Azure Hydra', '이탈리아', '인터넷', '링크', 'T1010', 52),
('Azure Hydra', '영국', '자동차', '파일', 'T1203', 14);

CREATE OR REPLACE VIEW max_country_group AS
SELECT a.country AS 국가, a.group_name AS 그룹명, SUM(a.attack_count) AS 총공격횟수
FROM attacks a
GROUP BY a.country, a.group_name
HAVING 총공격횟수 = (
    SELECT MAX(sub.total) FROM (
        SELECT group_name, SUM(attack_count) AS total
        FROM attacks
        WHERE country = a.country
        GROUP BY group_name
    ) AS sub
)
ORDER BY 총공격횟수 DESC;

-- SELECT * FROM max_country_group;

CREATE OR REPLACE VIEW min_country_group AS
SELECT a.country AS 국가, a.group_name AS 그룹명, SUM(a.attack_count) AS 총공격횟수
FROM attacks a
GROUP BY a.country, a.group_name
HAVING 총공격횟수 = (
    SELECT MIN(sub.total) FROM (
        SELECT group_name, SUM(attack_count) AS total
        FROM attacks
        WHERE country = a.country
        GROUP BY group_name
    ) AS sub
)
ORDER BY 총공격횟수 ASC;

-- SELECT * FROM min_country_group;

CREATE OR REPLACE VIEW max_industry_group AS
SELECT a.industry AS 산업, a.group_name AS 그룹명, SUM(a.attack_count) AS 총공격횟수
FROM attacks a
GROUP BY a.industry, a.group_name
HAVING 총공격횟수 = (
    SELECT MAX(sub.total) FROM (
        SELECT group_name, SUM(attack_count) AS total
        FROM attacks
        WHERE industry = a.industry
        GROUP BY group_name
    ) AS sub
)
ORDER BY 총공격횟수 DESC;

-- SELECT * FROM max_industry_group;

CREATE OR REPLACE VIEW min_industry_group AS
SELECT a.industry AS 산업, a.group_name AS 그룹명, SUM(a.attack_count) AS 총공격횟수
FROM attacks a
GROUP BY a.industry, a.group_name
HAVING 총공격횟수 = (
    SELECT MIN(sub.total) FROM (
        SELECT group_name, SUM(attack_count) AS total
        FROM attacks
        WHERE industry = a.industry
        GROUP BY group_name
    ) AS sub
)
ORDER BY 총공격횟수 ASC;

-- SELECT * FROM min_industry_group;

CREATE OR REPLACE VIEW max_attack_type_group AS
SELECT a.attack_type AS 공격유형, a.group_name AS 그룹명, SUM(a.attack_count) AS 총공격횟수
FROM attacks a
GROUP BY a.attack_type, a.group_name
HAVING 총공격횟수 = (
    SELECT MAX(sub.total) FROM (
        SELECT group_name, SUM(attack_count) AS total
        FROM attacks
        WHERE attack_type = a.attack_type
        GROUP BY group_name
    ) AS sub
)
ORDER BY 총공격횟수 DESC;

-- SELECT * FROM max_attack_type_group;

CREATE OR REPLACE VIEW min_attack_type_group AS
SELECT a.attack_type AS 공격유형, a.group_name AS 그룹명, SUM(a.attack_count) AS 총공격횟수
FROM attacks a
GROUP BY a.attack_type, a.group_name
HAVING 총공격횟수 = (
    SELECT MIN(sub.total) FROM (
        SELECT group_name, SUM(attack_count) AS total
        FROM attacks
        WHERE attack_type = a.attack_type
        GROUP BY group_name
    ) AS sub
)
ORDER BY 총공격횟수 ASC;

-- SELECT * FROM min_attack_type_group;

CREATE OR REPLACE VIEW max_attack_technique_group AS
SELECT a.attack_technique AS 공격기법, a.group_name AS 그룹명, SUM(a.attack_count) AS 총공격횟수
FROM attacks a
GROUP BY a.attack_technique, a.group_name
HAVING 총공격횟수 = (
    SELECT MAX(sub.total) FROM (
        SELECT group_name, SUM(attack_count) AS total
        FROM attacks
        WHERE attack_technique = a.attack_technique
        GROUP BY group_name
    ) AS sub
)
ORDER BY 총공격횟수 DESC;

-- SELECT * FROM max_attack_technique_group;

CREATE OR REPLACE VIEW min_attack_technique_group AS
SELECT a.attack_technique AS 공격기법, a.group_name AS 그룹명, SUM(a.attack_count) AS 총공격횟수
FROM attacks a
GROUP BY a.attack_technique, a.group_name
HAVING 총공격횟수 = (
    SELECT MIN(sub.total) FROM (
        SELECT group_name, SUM(attack_count) AS total
        FROM attacks
        WHERE attack_technique = a.attack_technique
        GROUP BY group_name
    ) AS sub
)
ORDER BY 총공격횟수 ASC;

-- SELECT * FROM min_attack_technique_group;

CREATE OR REPLACE VIEW group_attack_summary AS
SELECT
    g.group_name AS 그룹명,
    max_country.country AS 최대공격국가,
    min_country.country AS 최소공격국가,
    max_industry.industry AS 최대공격산업,
    min_industry.industry AS 최소공격산업,
    max_type.attack_type AS 최대공격유형,
    min_type.attack_type AS 최소공격유형,
    max_tech.attack_technique AS 최대공격기법,
    min_tech.attack_technique AS 최소공격기법
FROM
    (SELECT DISTINCT group_name FROM attacks) AS g

LEFT JOIN (
    SELECT ac.group_name, ac.country, SUM(ac.attack_count) AS total
    FROM attacks ac
    GROUP BY ac.group_name, ac.country
    HAVING total = (
        SELECT MAX(sub.total) FROM (
            SELECT country, SUM(attack_count) AS total
            FROM attacks
            WHERE group_name = ac.group_name
            GROUP BY country
        ) AS sub
    )
) AS max_country ON max_country.group_name = g.group_name

LEFT JOIN (
    SELECT ac.group_name, ac.country, SUM(ac.attack_count) AS total
    FROM attacks ac
    GROUP BY ac.group_name, ac.country
    HAVING total = (
        SELECT MIN(sub.total) FROM (
            SELECT country, SUM(attack_count) AS total
            FROM attacks
            WHERE group_name = ac.group_name
            GROUP BY country
        ) AS sub
    )
) AS min_country ON min_country.group_name = g.group_name

LEFT JOIN (
    SELECT ai.group_name, ai.industry, SUM(ai.attack_count) AS total
    FROM attacks ai
    GROUP BY ai.group_name, ai.industry
    HAVING total = (
        SELECT MAX(sub.total) FROM (
            SELECT industry, SUM(attack_count) AS total
            FROM attacks
            WHERE group_name = ai.group_name
            GROUP BY industry
        ) AS sub
    )
) AS max_industry ON max_industry.group_name = g.group_name

LEFT JOIN (
    SELECT ai.group_name, ai.industry, SUM(ai.attack_count) AS total
    FROM attacks ai
    GROUP BY ai.group_name, ai.industry
    HAVING total = (
        SELECT MIN(sub.total) FROM (
            SELECT industry, SUM(attack_count) AS total
            FROM attacks
            WHERE group_name = ai.group_name
            GROUP BY industry
        ) AS sub
    )
) AS min_industry ON min_industry.group_name = g.group_name

LEFT JOIN (
    SELECT at.group_name, at.attack_type, SUM(at.attack_count) AS total
    FROM attacks at
    GROUP BY at.group_name, at.attack_type
    HAVING total = (
        SELECT MAX(sub.total) FROM (
            SELECT attack_type, SUM(attack_count) AS total
            FROM attacks
            WHERE group_name = at.group_name
            GROUP BY attack_type
        ) AS sub
    )
) AS max_type ON max_type.group_name = g.group_name

LEFT JOIN (
    SELECT at.group_name, at.attack_type, SUM(at.attack_count) AS total
    FROM attacks at
    GROUP BY at.group_name, at.attack_type
    HAVING total = (
        SELECT MIN(sub.total) FROM (
            SELECT attack_type, SUM(attack_count) AS total
            FROM attacks
            WHERE group_name = at.group_name
            GROUP BY attack_type
        ) AS sub
    )
) AS min_type ON min_type.group_name = g.group_name

LEFT JOIN (
    SELECT atk.group_name, atk.attack_technique, SUM(atk.attack_count) AS total
    FROM attacks atk
    GROUP BY atk.group_name, atk.attack_technique
    HAVING total = (
        SELECT MAX(sub.total) FROM (
            SELECT attack_technique, SUM(attack_count) AS total
            FROM attacks
            WHERE group_name = atk.group_name
            GROUP BY attack_technique
        ) AS sub
    )
) AS max_tech ON max_tech.group_name = g.group_name

LEFT JOIN (
    SELECT atk.group_name, atk.attack_technique, SUM(atk.attack_count) AS total
    FROM attacks atk
    GROUP BY atk.group_name, atk.attack_technique
    HAVING total = (
        SELECT MIN(sub.total) FROM (
            SELECT attack_technique, SUM(attack_count) AS total
            FROM attacks
            WHERE group_name = atk.group_name
            GROUP BY attack_technique
        ) AS sub
    )
) AS min_tech ON min_tech.group_name = g.group_name;

-- SELECT * FROM group_attack_summary;