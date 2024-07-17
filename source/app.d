import std.stdio;
import fs = std.file;
import std.path;
import std.format;
import std.net.curl;
import core.stdc.stdlib : exit;
import args = sctab.args : Args;

immutable cacheDir = "cache/";

void fetch()
{
    auto urls = [
        /// <url>, [<filename overwrite>]
        ["https://raw.githubusercontent.com/torvalds/linux/master/arch/x86/entry/syscalls/syscall_64.tbl",    null],
        ["https://raw.githubusercontent.com/torvalds/linux/master/arch/x86/entry/syscalls/syscall_32.tbl",    null],
        ["https://raw.githubusercontent.com/torvalds/linux/master/include/linux/syscalls.h",                  null],
        ["https://raw.githubusercontent.com/torvalds/linux/master/include/asm-generic/syscalls.h",            "syscalls-asm-generic.h"],
    ];

    if (!fs.exists(cacheDir)) {
        fs.mkdir(cacheDir);
    }

    /**
    TODO: add threading, log downloaded file.
    */
    for (size_t i = 0; i < urls.length; i++) {
        string filename = urls[i][1] ? urls[i][1] : baseName(urls[i][0]);
        download(urls[i][0], cacheDir ~ filename);
    }
}

void main(string[] argv)
{
    Args args = args.parse(argv);

    if (args.fetch) {
        fetch();
        exit(0);
    }

    writeln("Hello from D!");
}
