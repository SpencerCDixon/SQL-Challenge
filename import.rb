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

################
### Employee ###
################

def parse_employee(employee)
  # parse through employee and extract proper information
end

def insert_employee(employee)
  # db_connection do |conn|
    # result = conn.exec_params("SELECT id FROM employees WHERE name = $1", [employee[:name]])
    # if result.to_a.empty?
      # result = conn.exec_params("INSERT INTO employees (name, email) VALUES ($1, $2) RETURNING id", [employee[:name], employee[:email]])
    # end
    # result.first["id"]
  # end
end


################
### Seed DB  ###
################

print "Loading."

CSV.foreach("sales.csv", headers: true, header_converters: :symbol) do |row|
  # do the import
end

puts "Import complete.  You now have a normalized database!"
