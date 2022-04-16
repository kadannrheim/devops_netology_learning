# Двойная строки и ее подсветка bash
* `sudo nano ~/.bashrc` -редактируем файл
Добавляем в него в самый конец:
```
INPUT_COLOR="\[\033[0m\]"
DIR_COLOR="\[\033[0;33m\]"
DIR="\w"
 
LINE_VERTICAL="\342\224\200"
LINE_CORNER_1="\342\224\214"
LINE_CORNER_2="\342\224\224"
LINE_COLOR="\[\033[0;37m\]"
 
USER_NAME="\[\033[0;32m\]\u"
SYMBOL="\[\033[0;32m\]$"
 
if [[ ${EUID} == 0 ]]; then
    USER_NAME="\[\033[0;31m\]\u"
    SYMBOL="\[\033[0;31m\]#"
fi
 
PS1="$LINE_COLOR$LINE_CORNER_1$LINE_VERTICAL $USER_NAME $DIR_COLOR$DIR \n$LINE_COLOR$LINE_CORNER_2$LINE_VERTICAL $SYMBOL $INPUT_COLOR"
```
# Ссылка для донастройки другой подсветки
[ССЫЛКА](https://ziggi.org/cveta-v-terminale/)