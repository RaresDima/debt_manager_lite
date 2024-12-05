-- https://sqliteonline.com/

DROP TABLE IF EXISTS debts;
DROP TABLE IF EXISTS mainUser;
DROP TABLE IF EXISTS users;

PRAGMA foreign_keys = ON;

CREATE TABLE users(
  id INTEGER PRIMARY KEY ASC,
  name TEXT UNIQUE
);

CREATE TABLE mainUser(
  id INTEGER PRIMARY KEY ASC,
  mainUserId INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE,
  CHECK (id = 1)
);

CREATE TABLE debts(
  id INTEGER PRIMARY KEY ASC,
  lenderId INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE,
  debtorId INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE,
  amount REAL NOT NULL,
  type INTEGER NOT NULL,
  description TEXT NOT NULL,
  date TEXT NOT NULL,
  CHECK (lenderId != debtorId),
  CHECK (type BETWEEN 0 AND 1)
);

INSERT INTO users (name) VALUES ('u1');
INSERT INTO users (name) VALUES ('u2');
INSERT INTO users (name) VALUES ('u3');
INSERT INTO users (name) VALUES ('u4');
INSERT INTO users (name) VALUES ('u5');

INSERT INTO debts (lenderId, debtorId, amount, type, date) VALUES (1, 2, 10.5,  1, '-');
INSERT INTO debts (lenderId, debtorId, amount, type, date) VALUES (3, 2, 20.5,  1, '-');
INSERT INTO debts (lenderId, debtorId, amount, type, date) VALUES (2, 4, 30.7,  1, '-');
INSERT INTO debts (lenderId, debtorId, amount, type, date) VALUES (5, 1, 10.75, 2, '-');
INSERT INTO debts (lenderId, debtorId, amount, type, date) VALUES (5, 1,  1.75, 1, '-');

INSERT INTO mainUser (mainuserid) VALUES (3);

SELECT * FROM mainUser;
