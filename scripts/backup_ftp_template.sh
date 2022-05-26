#!/bin/sh
### System Setup ###
BACKUP=/root/backup/server

### FTP ###
FTPD="/"
FTPU="username" [имя пользавателя (логин) удаленного ftp-cервера]
FTPP="megapassword" [пароль доступа к удаленному ftp-серверу]
FTPS="my_remote_backup.ru" [собственно, адрес ftp-сервера или его IP]

### Binaries ###
TAR="$(which tar)"
GZIP="$(which gzip)"
FTP="$(which ftp)"

## Today + hour in 24h format ###
NOW=$(date +%Y%m%d) [задаем текущую дату и время, чтобы итоговый файл выглядел в виде server-YYYYMMDD.tar.gz]

### Create tmp dir ###

mkdir $BACKUP/$NOW
$TAR -cf $BACKUP/$NOW/etc.tar /etc [c целью сохранения настроек для простоты копируем весь /etc ]
$TAR -cf $BACKUP/$NOW/site1.tar /home/site1/
$TAR -cf $BACKUP/$NOW/site2.tar /home/site2/
$TAR -cf $BACKUP/$NOW/site2.tar /home/site3/

ARCHIVE=$BACKUP/server-$NOW.tar.gz
ARCHIVED=$BACKUP/$NOW

$TAR -zcvf $ARCHIVE $ARCHIVED

### ftp ###
cd $BACKUP
DUMPFILE=server-$NOW.tar.gz
$FTP -n $FTPS <<END_SCRIPT
quote USER $FTPU
quote PASS $FTPP
cd $FTPD
mput $DUMPFILE
quit
END_SCRIPT

### clear ###

rm -rf $ARCHIVED