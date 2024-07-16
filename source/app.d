import std.stdio;
import core.stdc.stdlib : exit;
import args = sctab.args : Args;

void fetch()
{
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
