require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'
require 'sqlite3'

configure do
	@db = SQLite3::Database.new 'barbershop.db'
	@db.execute 'CREATE TABLE IF NOT EXISTS
		"users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"username" TEXT,
			"phone" TEXT,
			"datestamp" TEXT,
			"barber" TEXT,
			"color" TEXT
		)'	
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@date = params[:datetime]
	@barber_id = params[:barber_id]
	color = params[:color]

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

	@db.execute  'insert into users 
		(
		username,
		phone,
		tadestamp,
		barber,
		color
		)
		values (?,?,?,?,?)', [@username, @phone, @date, @barber_id, color]

	erb "OK!, username is #{@username}, #{@phone}, #{@date}, #{@barber_id}, #{color}"
	
end

post '/contacts' do
  
  #Pony.mail()
 
 erb "Ok, message send"
end