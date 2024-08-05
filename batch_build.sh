#!/bin/bash

# hwdef 폴더에서 보드명 추출
board_files=$(ls extra_hwdef_boards/*.hwdef.dat)

# 실행할 명령어 정의
command="./waf configure --board %s -g --check-verbose --disable-Werror --toolchain=arm-none-eabi --notests --enable-scripting --enable-opendroneid --enable-check-firmware --enable-custom-controller --enable-gps-logging --enable-header-checks --enable-stats --enable-ppp --extra-hwdef %s -o ./build/batch/%s && ./waf -v copter"

# 보드명마다 명령어 실행
for file in $board_files; do
    board_name=$(basename "$file" .hwdef.dat)
    base_board_name=$(echo "$board_name" | cut -d'_' -f1)
    extra_hwdef_file="./extra_hwdef_boards/${board_name}.hwdef.dat"
    
    # 명령어 실행
    cmd=$(printf "$command" "$base_board_name" "$extra_hwdef_file" "$board_name")
    echo "Executing: $cmd"
    eval $cmd
    
    # 명령어 실패 시 메시지 출력
    if [ $? -ne 0 ]; then
        echo "Command failed for board $board_name. Continuing with next board."
    fi
done