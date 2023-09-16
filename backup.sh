#! /bin/bash
echo -e "\e[33m\e[1mNOTE:\e[0m \e[33mdatabase name should be a compination of small and capital letters and numbers only\e[0m"
echo 'Databases backup is starting this may take a few minutes'
dbs=($(mysql -u root -ptoor -Nse "SELECT schema_name FROM information_schema.schemata \
WHERE schema_name NOT IN ('mysql', 'information_schema', 'performance_schema', 'sys');" | grep -oE "[a-zA-Z0-9_]*"))
if [ ! -d $1 ]; then
    mkdir $1
    echo "Directory $1 created as it wasn't exist"
fi
current_dir=$(pwd)
cd $1
find -name "*.sql" -delete
cd $current_dir
date_=$(date +%Y-%m-%d_%H-%M-%S)
for db in ${dbs[@]}; do
    echo -e "\e[33m-->\e[0mstarts backup $db..."
    sqlfile=$1/$db-$date_.sql
    if mysqldump -u root -ptoor $db > $sqlfile; then
        echo -e "\e[32m$db dump file created successfully\e[0m"
    else
        echo "can't create dump file for $db"
    fi
done

cd $1
if tar -cf "all_databases-$date_.tar" $(find -name "*.sql"); then
    echo -e "\e[32mtar file was created\e[0m"
else
    echo -e "\e[31mcan't create tar file\e[0m"

fi

