require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/login' do
  erb :login
end

post '/visit' do
  @username = params[:username]
  @phone = params[:phone]
  @datetime = params[:datetime]
  @master = params[:master]

  file = File.open('./public/contacts.txt', 'a')
  file.write " Имя: #{@username}, Телефон: #{@phone}, Время: #{@datetime}, Мастер: #{@master} \n"
  file.close
  erb "Спасибо, #{@username}, Ваша заявка принята"
end

post '/login' do
  @login = params[:login]
  @password = params[:password]
  if @login == 'admin' && @password == '123'


    @message =  'Успешно'
    erb :about
  else
    erb :login
    @message = 'Неправильный логин или пароль'

  end
end