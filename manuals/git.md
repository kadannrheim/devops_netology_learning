Команды для *UNIX систем на примере Ubuntu 20.04
# Установка git
```
sudo apt install git
git --version
```
После того как установка Git Ubuntu будет завершена одним из выше перечисленных способов, вам нужно еще кое-что сделать перед тем, как вы сможете полноценно работать. Вам нужно идентифицировать себя указав имя пользователя и адрес электронной почты.
Самый простой способ это сделать - с помощью команды git config. Git использует имя пользователя и Email при каждом коммите, так что задавать их обязательно. Для этого выполните команды:
```
git config --global user.name "kadannrheim"
git config --global user.email "kadannr@gmail.com"
```
или
тоже самое в конфигурационном файле `nano ~/.gitconfig`
`git config --list` -просмотр установленных параметров

# Команды git
- `git config --list --show-origin` -Посмотреть все настройки и где они заданы
- `git config --global core.editor vim` -Установить отличный от стандартного редактор
- `git help (команда)` -справка
- `git (команда) --help` -справка
- `man git-(команда)` -справка
`**git init**` -создать в текущей директории новую поддиректорию с именем .git
- `git add *` - добавить под версионный контроль существующие файлы 
или
- `git add (созданный файл)` -аналог предыдущей команды
- `git commit -m "first commit"` - выполнить коммит
- `git clone https://github.com/kadannrheim/devops-netology.git` -получить копию существующего репозитория

# Подсветка ветки Git в строке терминала
В файле $/.bashrc в домашней директории надо найти и закомментировать строки:
```
if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
```
Чуть ниже надо вставить такие строки:
```
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]$(parse_git_branch)\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)\$ '
fi
```
Результат:
kadannr@wcrow:~/git/devops-netology/home-work/virt-homeworks(main)$