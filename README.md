# Auto-Scale-Display
У меня есть ноутбук и большую часть времени он подключен к монитору. Монитор больше чем диагональ ноутбука и сижу дальше от ноутбука, поэтому мне не хватает масштаба ноутбука, поэтому я ставлю масштаб экрана ноутбука больше, но когда отключаю от монитора приходится или ходить с тем же масштабом или менять на меньший. И вот однажды я решился найти решение. Собственно этот скрипт(в конце статьи) и есть решение, с нюансом, нужно самому создавать задачу. Возможно в будущем будет авто добавление.  
  
Так вот как же все настроить? Заходим в планировщик заданий, дальше создаем задачу, в триггере у меня стоит “при разблокирование рабочей станции”, и каждый раз вводя pin код запускается скрипт. Ну и осталось указать действие запуск программы и указать путь до bat файла который запустит скрипт.  
  
Теперь когда все настроено можно вкратце объяснить, как работает алгоритм. При разблокировке ноутбука запускается скрипт и проверяет сколько мониторов подключено, в зависимости от результата меняет масштаб.  
  
Есть нюанс масштаба в скрипте установлено значение 4294967295, это потому, что в uint нельзя ставить значение с минусом. То есть “4294967295” это “-1”, значение “0” это рекомендованный масштаб, в большинстве это 100%, в моем случае 150%.  
