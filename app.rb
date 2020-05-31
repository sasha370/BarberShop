require 'rubygems'
require 'sinatra' # Подключаем Синатру
require 'sinatra/reloader' #Подключаем  GEM для того, чтобы постоянно не перезапускать сервер
require 'sqlite3' # Подключаем БД


#  Метод который открывает путь к БД
def get_db
  SQLite3::Database.new 'barbershop.db' # Создаем канал связи с файлом
end

# метод проверяеь наличие введеного имя в таблице. и если оно есть, mk длинна возвращаемого элемента будет больше 0
# таким образом провеояем  Существует или нет
def is_barber_exists? db, name
  db.execute('select * from masters where name =?', [name]).length > 0
end


# Метод добавдяет нового Мастера в твблицу, если его там небыло
def seed_db db, barbers  # на вход получаем имя бвзы и массив введеных имен
  barbers.each do |name|
    if !is_barber_exists? db, name # проверяем есть ли такое имя в таблице
      db.execute 'insert into masters (name) values (?)', [name] # если ответом пришло FALSE то добавляем новую строку
    end
  end
end

# этот кодд выполнится в самом начале, lzk толго чтобы переменая была видна в любом методе, включая GET и POST
before do
  db  = get_db
  db.results_as_hash = true
  @masters_results = db.execute 'select * from masters'
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

  # создаем таблицу с именами мастеров
  create_db.execute 'CREATE TABLE IF NOT EXISTS  "masters" (
                          "id"   INTEGER PRIMARY KEY AUTOINCREMENT
  UNIQUE,
      "name" TEXT    UNIQUE
  );'

  # посде создания таблиц инициализируем значения по умолчанию
  seed_db create_db, ['Джейми', 'Нора', 'Джони', 'Лиза']
end

# Строница Главная
get '/' do
  erb "Привет"
end

get '/about' do
  erb :about
end

# открываем базу данных и выбираем все значения в ХЕШ
get '/visit' do
  erb :visit
end

get '/login' do
  erb :login
end

get '/contacts' do
  erb :contacts
end

get '/showusers' do
  db = get_db
   db.results_as_hash = true # делает возврат ответа из БД в виде ХЕША, откуда мы можем достать все ключи по названию Колонок

  # выбрать все из Таблицы USERS сортируя по ID на цбывание
  # Этот массив мы будем использовать для вывода таблицы в представлении
  @results = db.execute 'select * from users order by id desc'

  # Таким образом можно выводить в консоль
  # db.execute 'select * from users' do |row| # ROW в данном случае ХЕШ
  #   @result =   "#{row['Name']} записался на #{row['DateStamp']}"
  # end
  erb :showusers
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
  @error = hash_error.select { |key,| params[key] == "" }.values.join(', ')
# Если Ошибки НЕ пустые, то возвращаем на страницу Заполнения формы
  if @error != ''
    return erb :visit
  end

# Записываем полученные данные в БД
#
  db = get_db
  db.execute 'Insert into
 users (name, phone, datestamp, master, color)
values (?,?,?,?,?) ', [@username, @phone, @datetime, @master, @color]

#Если прошли все валидации, то записываем данные в файл (ЛИБО В БД см.ВЫШЕ)
#   file = File.open('./public/contacts.txt', 'a')
#   file.write " Имя: #{@username}, Телефон: #{@phone}, Время: #{@datetime}, Мастер: #{@master}, Цвет покраски: #{@color} \n"
#   file.close
  erb "<h2> Спасибо, #{@username}, Ваша заявка принята </h2>"
end


# Обработчик событий на странице регистрации
# Работает только если  в Форме на странице Явно указан метод POST ? который будет передавать эти параметры серверу
#
post '/login' do
  @login = params[:login]
  @password = params[:password]
  if (@login == 'admin') && (@password == '123')
    @message = 'Успешно'
    erb :about
  else
    @message = 'Неправильный логин или пароль'
    erb :login
  end
end

