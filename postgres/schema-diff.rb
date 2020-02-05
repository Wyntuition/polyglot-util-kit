require 'csv'

<<-SQL
SELECT table_schema, table_name, column_name, data_type, character_maximum_length
FROM information_schema.columns
where table_schema <> 'pg_catalog' and table_schema <> 'information_schema'
order by 1,2,3;
SQL

perf = CSV.read('./perf.csv').map {|r| {schema: r[0], table: r[1], column: r[2], type: r[3], length: r[4]}}
prod = CSV.read('./prod.csv').map {|r| {schema: r[0], table: r[1], column: r[2], type: r[3], length: r[4]}}

prod_diff = []
perf_diff = []
perf.each do |r|
  match = prod.select {|test| test[:schema] == r[:schema] && test[:table] == r[:table] && test[:column] == r[:column] && test[:type] == r[:type] && test[:length] == r[:length]}
  if match.length != 1
    perf_diff << r
  end
end
prod.each do |r|
  match = perf.select {|test| test[:schema] == r[:schema] && test[:table] == r[:table] && test[:column] == r[:column] && test[:type] == r[:type] && test[:length] == r[:length]}
  if match.length != 1
    prod_diff << r
  end
end

puts "


Columns not in or not matching PROD:  "
puts perf_diff

puts "


Columns not in or not matching PERF:  "
puts prod_diff