module sctab.args;

import core.stdc.stdlib : exit;
import std.algorithm.searching;
import std.stdio;

struct Args
{
    bool fetch;
}

void help(string prog)
{
    write(i"Usage: $(prog) [options ...]\n",
            "Linux syscall table.\n",
            "\n",
            "Options:\n",
            "   -f, --fetch    fetches the latest syscall table.\n",
            "   -h, --help     prints this message and exit.\n");
}

Args parse(string[] argv)
{
    if (argv.canFind("-h") || argv.canFind("--help"))
    {
        help(argv[0]);
        exit(0);
    }

    Args args;
    args.fetch = argv.canFind("-f") || argv.canFind("--fetch");

    return args;
}
