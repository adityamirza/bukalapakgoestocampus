require 'mysql2'

def mysql_db_connection
  @client = Mysql2::Client.new(
    host:     ENV['MYSQL_DATABASE_HOST'],
    username: ENV['MYSQL_DATABASE_USERNAME'],
    password: ENV['MYSQL_DATABASE_PASSWORD'],
    database: ENV['MYSQL_DATABASE_NAME'],
    port: 3306,
    socket: '/path/to/mysql.sock',
    encoding: 'utf8',
    read_timeout: 100,
    write_timeout: 100,
    connect_timeout: 100,
    reconnect: true,
    local_infile: false,
    secure_auth: true
  )
end
