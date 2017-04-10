require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'
require 'sqlite3'

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

barber_names = [ 'WW', 'Jessie Pinkman', 'Gas' ]

def is_barber_exist? db, name
	db.execute('select * from barbers where name=?',[name]).length > 0
end

def add_barber db, barbers
	barbers.each do |barber|
		if !is_barber_exist? db, barber
			db.execute 'insert into barbers 
				(
					name
				)
				values (?)', [barber]
		end
	end
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
		"users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"name" TEXT,
			"phone" TEXT,
			"datestamp" TEXT,
			"barber" TEXT,
			"color" TEXT
		)'

	db.execute 'CREATE TABLE IF NOT EXISTS
		"barbers"
		(
			"barber_id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"name" TEXT
		)'

	add_barber db, barber_names	

end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	db = get_db

	@barbers = db.execute 'select * from barbers'

	erb :visit
end

get '/contacts' do
	erb :contacts
end

get '/showusers' do
	db = get_db

	@result = db.execute 'select * from Users order by id desc'

	erb :showusers
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@date = params[:datetime]
	color = params[:color]
	@barber = params[:barber]

	db = get_db

	@barbers = db.execute 'select * from barbers'

	# автозаполнение введенных полей при повтороном вводе

	hh = { 	:username => 'Введите имя', 
			:phone => 'Введите телефон', 
			:datetime => 'Выберите дату' }

	# для каждой пары ключ-значение 
	hh.each do |key, value|

		if params[key] == ''
			@error = value

			return erb :visit 
		end 
	end

	# Можно объединить сообщения об ошибках
	# @error = hh.select { |key,_| params[key] == '' }.values.join(",")

	db = get_db
	db.execute 'insert into users 
		(
			name,
			phone,
			datestamp,
			barber,
			color
		)
		values (?,?,?,?,?)', [@username, @phone, @date, @barber, color]

	erb "OK!, username is #{@username}, #{@phone}, #{@date}, #{@barber}, #{color}"
	
end

post '/contacts' do
  
  #Pony.mail()
 
 erb "Ok, message send"
end
