require 'rubygems'
require 'sinatra' # Подключаем Синатру
require 'sinatra/reloader' #Подключаем  GEM для того, чтобы постоянно не перезапускать сервер
require 'sqlite3'  # Подключаем БД


#  Метод который открывает путь к БД
def get_db
  SQLite3::Database.new 'barbershop.db' # Создаем канал связи с файлом
end


# В перед запуском приложения необходима созжать БД
configure do
  create_db = get_db # Делаем новый доступ к  файлу с БД
  # создаем в файле БД "Если она не существует" и задаем ей название и тпи колонок
  create_db.execute 'CREATE TABLE IF NOT EXISTS "users" (
      "id"        INTEGER  PRIMARY KEY AUTOINCREMENT UNIQUE,
      "Name"      VARCHAR,
      "Phone"     VARCHAR,
      "DateStamp" DATETIME,
      "Master"    VARCHAR,
      "Color"     TEXT
  );'
end

# Строница Главная
get '/' do
	erb "Привет"
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
get '/contacts' do
  erb :contacts
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


# Выбираем в  массиве  Params пустые значения, находим им соответсвия в Хеше ошибок и объедеиняем через запятую
#
  @error = hash_error.select{|key, | params[key] == ""}.values.join(', ')
# Если Ошибки НЕ пустые, то возвращаем на страницу Заполнения формы
  if @error != ''
    return erb :visit
  end

# Записываем полученные данные в БД
#
  db= get_db
  db.execute 'Insert into
 users (name, phone, datestamp, master, color)
values (?,?,?,?,?) ', [@username, @phone, @datetime, @master, @color]

#Если прошли все валидации, то записываем данные в файл (ЛИБО В БД см.ВЫШЕ)
#   file = File.open('./public/contacts.txt', 'a')
#   file.write " Имя: #{@username}, Телефон: #{@phone}, Время: #{@datetime}, Мастер: #{@master}, Цвет покраски: #{@color} \n"
#   file.close
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

