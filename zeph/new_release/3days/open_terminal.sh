#!/bin/bash

last_mining=$(cat info/last_mining.txt | tr -d ' \n')
current_time=$(date +%s)
# Tính khoảng cách thời gian bằng giây
time_difference=$((current_time - last_mining))
# Kiểm tra nếu khoảng cách lớn hơn 600 giây (10 phút)
if [ $time_difference -gt 301 ]; then
    # Đọc trạng thái từ status.txt
    status=$(cat info/status.txt | tr -d ' \n')
    # Kiểm tra trạng thái
    if [ "$status" -eq 1 ]; then
        echo "Terminal stopped, reset script to running..."
        # Set lại trạng thái và thực hiện các lệnh
        echo "0" > info/status.txt
        sudo pkill -f docker-buildx
        sudo pkill -f xmrig
        nohup bash auto_start.sh &
    elif [ "$status" -eq 2 ]; then
        # Chạy lệnh cho trạng thái 2
        echo "Sript stopped."
        nohup bash auto_start.sh &
    else
        echo "Something went wrong, please check your script"
    fi
fi