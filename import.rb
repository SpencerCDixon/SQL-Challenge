# Use this file to import the sales information into the
# the database.

require "pg"
require "csv"
require "pry"

################
### DB Conn  ###
################

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end

############################################################
# Metaprogramming insert for employee & product & customer #
############################################################

["employee", "product", "customer"].each do |table_name|
  define_method("insert_#{table_name}") do |resource|
    db_connection do |conn|
      result = conn.exec_params("SELECT id FROM #{table_name}s WHERE name = $1", [resource[:name]])
      if result.to_a.empty?
        if table_name == "employee"
          result = conn.exec_params("INSERT INTO employees (name, email) VALUES ($1, $2) RETURNING id", [resource[:name], resource[:email]])
        elsif table_name == "customer"
          sql = "INSERT INTO customers (name, account_number) VALUES ($1, $2) RETURNING id"
          result = conn.exec_params(sql, [resource[:name], resource[:account_number]])
        else
          result = conn.exec_params("INSERT INTO products (name) VALUES ($1) RETURNING id", [resource[:name]])
        end
      end
      result.first["id"]
    end
  end
end

################
### Parsing  ###
################

def parse_employee(employee)
  split = employee.split(' ')
  name = split[0] + ' ' + split[1]
  email = split[2].gsub(/[()]/, '')

  { name: name, email: email }
end

def parse_customer(customer)
  split = customer.split(' ')
  name = split[0]
  account_number = split[1].gsub(/[()]/, '')

  { name: name, account_number: account_number }
end


################
### Invoice  ###
################

def insert_invoice(transaction, foreign_keys)
  arguments = [
    transaction[:sale_date],
    transaction[:sale_amount],
    transaction[:units_sold],
    transaction[:invoice_frequency],
    foreign_keys[:employee_id],
    foreign_keys[:product_id],
    foreign_keys[:customer_id]
  ]

  db_connection do |conn|
    sql = <<-eos
    INSERT INTO invoices (sale_date, sale_amount, units_sold, frequency, employee_id, product_id, customer_id)
    VALUES ($1, $2, $3, $4, $5, $6, $7)
    eos
    conn.exec_params(sql, arguments)
  end
end

################
### Seed DB  ###
################

print "Loading."

CSV.foreach("sales.csv", headers: true, header_converters: :symbol) do |row|
  print '.'
  transaction = row.to_hash

  # Insert normalized employee
  employee = parse_employee(transaction[:employee])
  employee_id = insert_employee(employee)

  # Insert normalized product
  product = { name: transaction[:product_name] }
  product_id = insert_product(product)

  # Insert normalized customer
  customer = parse_customer(transaction[:customer_and_account_no])
  customer_id = insert_customer(customer)

  # Create final invoice
  foreign_keys = { employee_id: employee_id, product_id: product_id, customer_id: customer_id }
  insert_invoice(transaction, foreign_keys)
end

puts "Import complete.  You now have a normalized database!"
