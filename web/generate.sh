#!/bin/bash
#
# usage: ./web/generate.sh > web/syscalls/x64.html

tab() {
    local n=$1
    local i=0

    while [ "$i" -ne "$n" ]; do
        echo -n "    "
        i=$((i + 1))
    done
}

cat <<EOF
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>sctab - syscall table</title>
    </head>
    <body>
        <h1>Linux x64 System Call Reference Table</h1>
        <p>Auto generated syscalls table</p>
EOF

./sctab | while IFS='' read -r line; do
    tab 2
    echo "$line"
done

cat <<EOF
    </body>
</html>
EOF
