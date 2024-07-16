import std.stdio;
import args = sctab.args;

void main(string[] argv)
{
    args.parse(argv);

    writeln(argv);
    writeln("Hello from D!");
}
