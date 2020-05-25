CREATE TABLE pseudo_sake_data(
  "タイプ" VARCHAR,
  "アルコール分" NUMERIC,
  "日本酒度" NUMERIC,
  "エキス分" NUMERIC,
  "総酸" NUMERIC,
  "アミノ酸度" NUMERIC,
  "甘辛度" NUMERIC,
  "濃淡度" NUMERIC
);

COPY pseudo_sake_data from '/var/lib/postgresql/pseudo_sake_data.csv' with csv header;

CREATE TABLE large_pseudo_sake_data(
  "タイプ" VARCHAR,
  "アルコール分" NUMERIC,
  "日本酒度" NUMERIC,
  "エキス分" NUMERIC,
  "総酸" NUMERIC,
  "アミノ酸度" NUMERIC,
  "甘辛度" NUMERIC,
  "濃淡度" NUMERIC
);

COPY large_pseudo_sake_data from '/var/lib/postgresql/large_pseudo_sake_data.csv' with csv header;
