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
#   if @username  == ''
#   @error = "Введите имя!"
#   end
#     if @phone  == ''
#   @error = "Введите номер телефона!"
#   end
#     if @datetime  == ''
#   @error = "Введите время!"
#   end
# Если переменная Error не пустая, то мы показываем ошибку на э
#   if @error != ''
#     return erb :visit
#   end


#Валидация с использование HUSH с перечнем ошибок
  hash_error = {
      :username => "введите имя",
      :phone => "введите номер телефона",
      :datetime => "введите дату и время"
  }
# Проверяем наличие  соответвия хеша с ошибками и переданных парметров
# если Текущий Ключ и параметрах пуст, то мы записываем в переменную Errors значение из массива ошибок и обновляем страницу
#   hash_error.each {|key, value|
#       if params[key] == ''
#         @error = value
#         return erb :visit
#       end
#   }

  @error = hash_error.select{|key, | params[key] == ""}.values.join(', ')
  if @error != ''
    return erb :visit
  end

#Если прошли все валидации, то записываем данные в файл

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