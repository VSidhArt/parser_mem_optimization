### Note
*Пример использования инструментов профилирования и оптимизации памяти в Ruby*

# Проблема
В файле `task.rb` находится ruby-программа, которая выполняет обработку данных из файла.

В файл встроен тест, который показывает, как программа должна работать.

С помощью этой программы нужно обработать файл данных `data_large.txt`.

**Проблема в том, что это происходит слишком долго, дождаться пока никому не удавалось.**


## Задача
- Профилировать программу с помощью различных инструментов
- Добиться того, чтобы программа корректно обработала файл `data_large.txt`;


## FeedBack Loop
Файл `data_large.txt` - 129Mb слишком большой для быстрого feedback, создан файл `data.txt` на 380Kb, все замеры производятся на нем.

## Оптимизации


### Проблема
`memory_profiler` показал что наибольшее количество памяти аллоцируется массивами
```
allocated memory by class
-----------------------------------
 416.75 MB  Array
```
в стоке конкатинации массивов `sessions = sessions + [parse_session(line)] if cols[0] == 'session'`
### Решение
Замена на Array#push
```
allocated memory by class
-----------------------------------
 129.58 MB  Array
```
---
### Проблема
`memory_profiler` показал что наибольшее количество объектов аллоцируется строками
```
allocated objects by class
-----------------------------------
    224211  String
```
### Решение
использование `# frozen_string_literal: true`
```
allocated objects by class
-----------------------------------
    188061  String
```
---
### Проблема
`stackprof` показал, что наибольшее количество семплов происходится на метода parse_session, вызов String#split
```
 TOTAL    (pct)     SAMPLES    (pct)     FRAME
407692 (100.0%)      294644  (72.3%)     Object#work
 76176  (18.7%)       76176  (18.7%)     Object#parse_session
191118  (46.9%)       24584   (6.0%)     Object#collect_stats_from_users
 12288   (3.0%)       12288   (3.0%)     Object#parse_user
```
### Решение
Убрать лишние вызовы String#split
```
 TOTAL    (pct)     SAMPLES    (pct)     FRAME
329228 (100.0%)      294644  (89.5%)     Object#work
191118  (58.1%)       24584   (7.5%)     Object#collect_stats_from_users
  8464   (2.6%)        8464   (2.6%)     Object#parse_session
  1536   (0.5%)        1536   (0.5%)     Object#parse_user
```
---
### Проблема
`ruby-prof` в режиме `WALL_TIME` выявил, что 90% процента времени тратятся в методе `Array#select`
```
Total allocated: 142.14 MB
```
### Решение
Использовать Hash вместо Array для коллекций user и sessions
Потребление RAM упало c 142Mb до 21Mb, скорость выполнения программы на 10_000 строк снизилась до
0.1c
```
Total allocated: 21.44 MB
```
---


## Инструменты

### Time benchmark
Измерение времени программы `time_bench.rb`
Неоптимизированный результат: `1.40s`

### Rss memomory
Запрос у ОСС на количество потребляемой памяти `rss_bench.rb`
Неоптимизированный результат на файле 10_000 строк:
```
Before 19 MB
After 72 MB
```

### ObjectSpace
Класс показывающий количество аллоцировнных объектов `object_space_bench.rb`
Неоптимизированный результат на файле 10_000 строк: `Total objects diff: 119416`

### MemoryProfiler
`gem memory_profiler`
Семплирующий профайлер показывающий количество аллоцировнных объектов `memory_profiler_bench.rb`

### StackProf
Семплирующий профайлер показывающий количество аллоцировнных объектов, можно создать flamegraph и graphviz
`stackprof_bench.rb`

### RubyProf
Тресирующий профайлер



