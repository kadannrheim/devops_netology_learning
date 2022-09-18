#!/usr/bin/env bash
cd /var/www/wordpress
/usr/local/bin/wp post create --post_title='Этот пост из GitLab' \
--post_content='GitLab Runner работает!!!' --post_status=publish
