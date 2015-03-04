task :reset do
  system 'dropdb korning'
  system 'createdb korning'
  system 'psql korning < schema.sql'
end
