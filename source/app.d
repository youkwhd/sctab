import std.stdio;
import fs = std.file;
import std.path;
import std.format;
import std.net.curl;
import core.stdc.stdlib : exit;
import tbl = sctab.tbl;
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

    /// TODO: add threading, log downloaded file.
    foreach (ref url; urls) {
        string filename = url[1] ? url[1] : baseName(url[0]);
        download(url[0], cacheDir ~ filename);
    }
}

void main(string[] argv)
{
    Args args = args.parse(argv);

    if (args.fetch) {
        fetch();
        exit(0);
    }

    string[][] syscall64 = tbl.parse(cacheDir ~ "syscall_64.tbl");
}
