-- DEFINE YOUR DATABASE SCHEMA HERE

CREATE TABLE employees(
  id serial PRIMARY KEY,
  name varchar(100) NOT NULL UNIQUE,
  email varchar(100) NOT NULL UNIQUE 
);

