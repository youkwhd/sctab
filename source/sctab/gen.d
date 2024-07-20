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

void generate(File type)
{
    string[][] syscall64 = tbl.parse("cache/syscall_64.tbl");

    final switch (type)
    {
        case File.html:
            writeln("<table>");

            writeln("    <tr>");
            writeln("        <th>Number</th>");
            writeln("        <th>Name</th>");

            for (int i = 0; i < 6; i++)
                writeln("        <th>arg" ~ to!(string)(i) ~ "</th>");

            writeln("    </tr>");

            foreach (row; syscall64)
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
            break;

        case File.csv:
            write("Number,Name");

            for (int i = 0; i < 6; i++)
                write(",arg" ~ to!(string)(i));

            write("\n");

            foreach (row; syscall64)
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

            break;
    }
}
