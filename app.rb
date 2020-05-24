require 'rubygems'
require 'sinatra' # Подключаем Синатру
require 'sinatra/reloader' #Подключаем  GEM для того, чтобы постоянно не перезапускать сервер

# Строница Главная
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

# Обработчик для событий на странице VIZIT
# Вытаскиваем из параметров Переменные и записываем их в текстовый файл
post '/visit' do
  @username = params[:username]
  @phone = params[:phone]
  @datetime = params[:datetime]
  @master = params[:master]
  @color = params[:colorpicker]
# Валидация на заполнение поля с Именем. Если поле пустое, показываем Ошибку и возвращаем на страницу записи
  if @username  == ''
  @error = "Введите имя!"
  return erb :visit
end

  file = File.open('./public/contacts.txt', 'a')
  file.write " Имя: #{@username}, Телефон: #{@phone}, Время: #{@datetime}, Мастер: #{@master}, Цвет покраски: #{@color} \n"
  file.close
  erb "Спасибо, #{@username}, Ваша заявка принята"
end


# Обработчик событий на странице регистрации
# Работает только если  в Форме на странице Явно указан метод POST ? который будет передавать эти параметры серверу
#
post '/login' do
  @login = params[ :login]
  @password = params[ :password]
  if (@login == 'admin' )&& (@password == '123')
    @message =  'Успешно'
    erb :about
  else
    @message = 'Неправильный логин или пароль'
    erb :login
  end
end