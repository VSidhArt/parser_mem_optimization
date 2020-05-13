### Note
*Пример использования инструментов профилирования и оптимизации памяти в Ruby*

# Проблема
В файле `task.rb` находится ruby-программа, которая выполняет обработку данных из файла.

В файл встроен тест, который показывает, как программа должна работать.

С помощью этой программы нужно обработать файл данных `data_large.txt`.

**Проблема в том, что это происходит слишком долго, дождаться пока никому не удавалось.**


## Задача
- Оптимизировать эту программу, выстроив процесс согласно "общему фреймворку оптимизации"
- Профилировать программу с помощью различных инструментов
- Добиться того, чтобы программа корректно обработала файл `data_large.txt`;


## FeedBack Loop
Файл `data_large.txt` - 129Mb слишком большой для быстрого feedback, создан файл `data.txt` на 380Kb, все замеры производятся на нем.

## Инструменты

### Time benchmark
Измерение времени программы `time_bench.rb`
Неоптимизированный результат: `1.40s`

### Rss memomory
Запрос у ОСС на количество потребляемой памяти `rss_bench.rb`
Неоптимизированный результат:
```
Before 19 MB
After 72 MB
```

### ObjectSpace
Класс показывающий количество аллоцировнных объектов `object_space_bench.rb`
Неоптимизированный результат: `Total objects diff: 119416`

### MemoryProfiler
`gem memory_profiler`
Семплирующий профайлер показывающий количество аллоцировнных объектов `memory_profiler_bench.rb`
Неоптимизированный результат: `reports/memory_profiler_origin`

### StackProf
Семплирующий профайлер показывающий количество аллоцировнных объектов, можно создать flamegraph и graphviz
`stackprof_bench.rb`
Неоптимизированный результат: `reports/stackprof_origin.dump`

### RubyProf
Тресирующий профайлер
Неоптимизированный результат: `reports/stackprof_origin.dump`

