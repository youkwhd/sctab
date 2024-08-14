// C decleration function parser
// 
// TODO: parse decleration functions from man pages
// it is generally better, ex: nfsservctl can be found from man 2.
//
// `man --location`
module sctab.decl;

import std.algorithm.iteration;
import std.string;
import std.stdio;
import std.range;
import std.conv;

string[] header;
bool     loaded = false;

private void loadHeader()
{
    if (loaded)
    {
        return;
    }

    loaded = true;
    header ~= File("cache/syscalls.h").byLine().map!(line => to!(string)(line)).array();
    header ~= File("cache/syscalls-asm-generic.h").byLine().map!(line => to!(string)(line)).array();
}

// get asm linked function decleration
string func(string name)
{
    // @once
    loadHeader();

    for (size_t i = 0; i < header.length; i++)
    {
        if (!header[i].startsWith("asmlinkage") || header[i].indexOf(" " ~ name ~ "(") == -1)
        {
            continue;
        }

        string decl;
        while (!decl.endsWith(";"))
        {
            decl ~= header[i++].strip();
        }

        return decl;
    }

    return "";
}

// get function parameters
//
// TODO: return value should not be fixed length 6
// make it more generic to be useable out of this project's scope.
string[] params(string fn)
{
    immutable syscallMaxArgs = 6;

    if (fn.empty)
    {
        return repeat("?", syscallMaxArgs).array();
    }

    assert(fn.endsWith(");"));
    fn = fn[fn.indexOf("(")+1..fn.lastIndexOf(");")];

    if (fn == "void")
    {
        return repeat("-", syscallMaxArgs).array();
    }

    // TODO: this is bogos, invalid.
    // Considering we have type function pointer, which could have ",".
    return fn.split(",").map!(a => a.strip()).padRight("-", syscallMaxArgs).array();
}
