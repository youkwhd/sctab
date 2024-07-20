module sctab.gen;

import std.stdio;
import std.regex;
import std.range;
import std.conv;
import std.file;
import decl = sctab.decl;
import tbl = sctab.tbl;

/// Supported file types
enum File { html, csv };

/// Supported architectures
enum Arch { x86, x64 };

private string[][] rawTable(Arch arch)
{
    final switch (arch)
    {
        case Arch.x86: return tbl.parse("cache/syscall_32.tbl");
        case Arch.x64: return tbl.parse("cache/syscall_64.tbl");
    }
}

private void generateCsv(Arch arch)
{
    string[][] table = rawTable(arch);

    write("Number,Name");

    for (int i = 0; i < 6; i++)
        write(",arg" ~ to!(string)(i));

    write("\n");

    foreach (ref row; table)
    {
        write(row[0] ~ ",");
        write(row[2]);

        string func = decl.func("sys_" ~ row[2]);
        if (func.empty && row.length > 3)
            func = decl.func(row[3]);

        string[] params = decl.params(func);
        for (int i = 0; i < 6; i++)
        {
            string param = i < params.length ? params[i] : "";
            write("," ~ param);
        }

        write("\n");
    }

}

private void generateHtml(Arch arch)
{
    string[][] table = rawTable(arch);

    writeln("<table>");
    writeln("    <tr>");
    writeln("        <th>Number</th>");
    writeln("        <th>Name</th>");

    for (int i = 0; i < 6; i++)
        writeln("        <th>arg" ~ to!(string)(i) ~ "</th>");

    writeln("    </tr>");

    foreach (ref row; table)
    {
        writeln("    <tr>");
        writeln("        <td>" ~ row[0] ~ "</td>");
        writeln("        <td>" ~ row[2] ~ "</td>");

        string func = decl.func("sys_" ~ row[2]);
        if (func.empty && row.length > 3)
            func = decl.func(row[3]);

        string[] params = decl.params(func);
        for (int i = 0; i < 6; i++)
        {
            string param = i < params.length ? params[i] : "";
            writeln("        <td>" ~ param ~ "</td>");
        }

        writeln("    </tr>");
    }

    writeln("</table>");
}

void generate(Arch arch, File type)
{
    final switch (type)
    {
        case File.html: return generateHtml(arch);
        case File.csv: return generateCsv(arch);
    }
}
