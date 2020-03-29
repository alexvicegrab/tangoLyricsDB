#!/usr/bin/env bash

export NOW=$(date +"%Y-%m-%d")

docker exec -i tangolyricsdb_db_1 pg_dump -U postgres --format=c tangoLyricsDB_production > ${TTDB_PATH}/backup/TDB_${NOW}.dump

purgeFiles/purgeFiles.py --age=1,2,3,4,5,6,7,8,16,32,64,128,256,384,512,640,768,896,1024,1152,1280,1408,1536,1664,1792,1920,2048 --directory=${TTDB_PATH}/backup --pattern="*.dump" --force
