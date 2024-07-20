module sctab.args;

import core.stdc.stdlib : exit;
import std.algorithm.searching;
import std.uni;
import std.stdio;
import sctab.gen : Arch, Format;

struct Args
{
    bool fetch = false;
    Format format = Format.html;
    Arch arch = Arch.x64;
}

void help(string prog)
{
    write(i"Usage: $(prog) [options ...]\n",
            "Linux syscall table.\n",
            "\n",
            "Options:\n",
            "   --fetch           fetches the latest syscall table.\n",
            "   --arch <arch>     specify architecture, can be either x86 or x64.\n",
            "   --format <format> specify file format, can be either html or csv.\n",
            "   -h, --help        prints this message and exit.\n");
}

/// Shitbox hack-ish, but it works for now
Args parse(string[] argv)
{
    Args args;

    for (size_t i = 1; i < argv.length; i++)
    {
        switch (argv[i])
        {
            case "-h", "--help":
                help(argv[0]);
                exit(0);

            case "--fetch":
                args.fetch = true;
                break;

            case "--arch":
                if (i + 1 >= argv.length)
                {
                    help(argv[0]);
                    exit(1);
                }

                switch (argv[++i].toLower())
                {
                    case "x86":
                        args.arch = Arch.x86;
                        break;

                    case "x64":
                        args.arch = Arch.x64;
                        break;

                    default:
                        writeln(argv[0] ~ ": unknown value for `--arch`");
                        writeln("Try `" ~ argv[0] ~ " -h` " ~ "for more information.");
                        exit(1);
                }

                break;

            case "--format":
                if (i + 1 >= argv.length)
                {
                    help(argv[0]);
                    exit(1);
                }

                switch (argv[++i].toLower())
                {
                    case "html":
                        args.format = Format.html;
                        break;

                    case "csv":
                        args.format = Format.csv;
                        break;

                    default:
                        writeln(argv[0] ~ ": unknown value for `--format`");
                        writeln("Try `" ~ argv[0] ~ " -h` " ~ "for more information.");
                        exit(1);
                }

                break;

            default:
                writeln(argv[0] ~ ": unknown flag `" ~ argv[i] ~  "`");
                writeln("Try `" ~ argv[0] ~ " -h` " ~ "for more information.");
                exit(1);
        }
    }

    return args;
}
