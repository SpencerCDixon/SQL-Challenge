-- DEFINE YOUR DATABASE SCHEMA HERE

CREATE TABLE employees(
  id serial PRIMARY KEY,
  name varchar(100) NOT NULL UNIQUE,
  email varchar(100) NOT NULL UNIQUE 
);

CREATE TABLE products(
  id serial PRIMARY KEY,
  name varchar(255) NOT NULL UNIQUE
);

CREATE TABLE customers(
  id serial PRIMARY KEY,
  name varchar(255) NOT NULL UNIQUE,
  account_number varchar(50) NOT NULL UNIQUE
);

CREATE TABLE invoices(
  id serial PRIMARY KEY,
  sale_date varchar(50) NOT NULL,
  sale_amount varchar(75) NOT NULL,
  units_sold integer NOT NULL,
  frequency varchar(80) NOT NULL,
  employee_id integer REFERENCES employees(id),
  product_id integer REFERENCES products(id),
  customer_id integer REFERENCES customers(id)
);
