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
    string[] urls = [
        "https://raw.githubusercontent.com/torvalds/linux/master/arch/x86/entry/syscalls/syscall_64.tbl",
        "https://raw.githubusercontent.com/torvalds/linux/master/arch/x86/entry/syscalls/syscall_32.tbl",
        "https://raw.githubusercontent.com/torvalds/linux/master/include/linux/syscalls.h",
    ];

    if (!fs.exists(cacheDir)) {
        fs.mkdir(cacheDir);
    }

    /**
    TODO: add threading, log downloaded file.
    */
    for (size_t i = 0; i < urls.length; i++) {
        download(urls[i], cacheDir ~ baseName(urls[i]));
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
