# Лабораторная работа No 1
## Система ввода/вывода Си

## Практическая часть
1. Написать программу чтения таблицы данных из стандартного входного потока stdin и
форматированного вывода таблицы данных в стандартный выходной поток stdout.
Для ввода использовать функцию scanf, для вывода использовать функцию printf.
2. Модифицируйте программу так, чтобы она принимала аргумент - имя файла,
и форматировано выводила таблицу данных в стандартный выходной поток stdout.
3. Создайте многофайловый проект.

## Замечание.
1. Исходные данные находятся в файле data.txt.
2. С помощью справочной системы самостоятельно разобраться с правилами вызова функций scanf и printf,
обратив особое внимание на спецификацию формата.

### Пример входных данных для Var. #01
```
ManagerId	FirstName	LastName	Email	Password	Active
1	Johnny	Smithe	no@no.com	system	Y
2	Karen	Xythe	no@no.com	system	Y
3	Brett	Heath	no@no.com	system	Y
4	Gabby	Banks	no@no.com	system	Y
5	Faye	Jones	no@no.com	system	Y
6	Joh	Boy	no@no.com	system	Y
```

## Замечания.
1. Входные данные не содержат имени таблицы
2. Первая строка входного потока содержит имена столбцов
3. В последующих строках содержатся данные столбцов, которые разделяются символом табуляции.

### Пример выходных данных для Var. #01
```
+-----------+-----------+----------+-----------+----------+--------+
| ManagerId | FirstName | LastName | Email     | Password | Active |
+-----------+-----------+----------+-----------+----------+--------+
|         1 | Johnny    | Smithe   | no@no.com | system   |   Y    |
|         2 | Karen     | Xythe    | no@no.com | system   |   Y    |
|         3 | Brett     | Heath    | no@no.com | system   |   Y    |
|         4 | Gabby     | Banks    | no@no.com | system   |   Y    |
|         5 | Faye      | Jones    | no@no.com | system   |   Y    |
|         6 | Joh       | Boy      | no@no.com | system   |   Y    |
+-----------+-----------+----------+-----------+----------+--------+
```

## Замечания.
1. Строки выравниваются по левому краю поля.
2. Числа выравниваются по правому краю поля.
3. Вещественные числа выравниваются по точке.
4. Одиночные символы располагаются в центре поля.
5. Ширина столбцов таблицы определяется по содержимому.