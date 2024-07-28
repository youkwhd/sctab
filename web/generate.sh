#!/bin/bash
#
# usage: ./web/generate.sh <arch> > web/syscalls/<arch>.html

tab() {
    local n=$1
    local i=0

    while [ "$i" -ne "$n" ]; do
        echo -n "    "
        i=$((i + 1))
    done
}

if [[ "$1" = "" ]]; then
    echo "usage: ./web/generate.sh [-a] <arch>"
    echo "all possible values of arch can be seen from: \`sctab -h\`"
    echo
    echo "options:"
    echo "  -a commands to just generate all"
    exit 1
fi

if [[ "$1" = "-a" ]]; then
    ./web/generate.sh x64 > web/syscalls/x64.html
    ./web/generate.sh x86 > web/syscalls/x86.html
    exit 0
fi

cat <<EOF
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>sctab - syscall table</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="/style.css">
    </head>
    <body>
        <nav>
            <p>
                <a href="/">sctab</a> - Linux system call table.
            </p>
            <ul>
                <li><a href="/syscalls/x86.html">x86</a></li>
                <li><a href="/syscalls/x64.html">x64</a></li>
            </ul>
        </nav>
EOF

./sctab --arch "$1" | while IFS='' read -r line; do
    tab 2
    echo "$line"
done

cat <<EOF
    </body>
</html>
EOF
