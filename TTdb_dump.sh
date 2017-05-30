now=$(date +"%d-%m-%Y")
pg_dump -U tangoLyricsDB --format=c tangoLyricsDB_production > /var/www/tangoLyricsDB/backup/TDB_$now.dump
