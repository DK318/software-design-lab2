# Hashtag Counter
Эта программа считает частоту появления постов во ВКонтакте с определенным хештегом за последние несколько часов.

## Установка
Для начала нужно поставить систему сборки `stack`. Сделать это можно через [GHCup](https://www.haskell.org/ghcup/).

Затем запустите следующую команду
```bash
$ stack install
```

Для того, чтобы воспользоваться этой программой нужно вставить ваш API ключ в `config.toml`.

## Запуск тестов
Тесты можно запустить следующей командой
```bash
$ stack test
```

## Пример использования
### Окно помощи
```bash
$ hashtag-counter --help

Software design lab 2

Usage: hashtag-counter --query QUERY --numberOfHours NUMBER OF HOURS
  Prints statistic for some QUERY in NUMBER OF HOURS

Available options:
  --query QUERY            Substring to find
  --numberOfHours NUMBER OF HOURS
                           Range of hours starting from now
  -h,--help                Show this help text
```

### Собрать статистику по хештегу `#пиво` за последние 12 часов
```bash
$ hashtag-counter --query "#пиво" --numberOfHours 12

1: 1
2: 2
3: 3
4: 6
5: 13
6: 21
7: 20
8: 29
9: 28
10: 26
11: 23
12: 19
```
