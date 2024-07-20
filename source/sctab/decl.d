/// C decleration function parser
module sctab.decl;

import std.algorithm.iteration;
import std.string;
import std.stdio;
import std.range;
import std.conv;

string[] header;
bool loaded = false;

void __loadHeader()
{
    if (loaded) return;
    loaded = true;
    header ~= File("cache/syscalls.h").byLine().map!(line => to!(string)(line)).array();
    header ~= File("cache/syscalls-asm-generic.h").byLine().map!(line => to!(string)(line)).array();
}

/// get asm linked function decleration
string func(string name)
{
    /// @once
    __loadHeader();

    for (size_t i = 0; i < header.length; i++)
    {
        if (!header[i].startsWith("asmlinkage") || header[i].indexOf(" " ~ name ~ "(") == -1)
            continue;

        string decl;
        while (!decl.endsWith(";"))
            decl ~= header[i++].strip();

        return decl;
    }

    return "";
}

/// get function parameters
string[] params(string fn)
{
    if (fn.empty)
    {
        return [];
    }

    assert(fn.endsWith(");"));
    fn = fn[fn.indexOf("(")+1..fn.lastIndexOf(");")];

    if (fn == "void")
    {
        return [];
    }

    /// TODO: this is bogos, invalid.
    /// Considering we have type function pointer, which could have ",".
    return fn.split(",").map!(a => a.strip()).array();
}
