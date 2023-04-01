DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS present_histories;

DROP SEQUENCE IF EXISTS accounts_id_seq;
DROP SEQUENCE IF EXISTS roles_id_seq;

CREATE TABLE items
(
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name varchar(40),
  create_at timestamp DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO
  items (name)
VALUES
  ('アイテム1'),
  ('アイテム2'),
  ('アイテム3'),
  ('アイテム4')
;

CREATE TABLE roles
(
  id INTEGER PRIMARY KEY,
  name varchar(40),
  create_at timestamp DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO
  roles (id, name)
VALUES
  (0, '管理者'),
  (1, '一般'),
  (2, '見るだけの人1'),
  (3, '見るだけの人2')
;

CREATE TABLE accounts
(
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name varchar(40),
  role_id integer references roles(id),
  create_at timestamp DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO
  accounts (name, role_id)
VALUES
  ('管理者', 0),
  ('一般', 1),
  ('見るだけの人1', 2),
  ('見るだけの人2', 3)
;

CREATE TABLE present_histories
(
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name varchar(40),
  item_id UUID references items(id),
  count integer,
  from_account_id UUID references accounts(id),
  to_account_id UUID references accounts(id)
);

