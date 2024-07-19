module sctab.gen;

import std.stdio;
import std.regex;
import std.range;
import std.file;
import decl = sctab.decl;
import tbl = sctab.tbl;

/// Supported file types
enum File { html, csv };

void generate(File type)
{
    string[][] syscall64 = tbl.parse("cache/syscall_64.tbl");

    final switch (type) {
        case File.html:
            writeln("<table>");
            foreach (row; syscall64) {
                writeln("    <tr>");
                writeln("        <th>" ~ row[0] ~ "</th>");
                writeln("        <th>" ~ row[2] ~ "</th>");

                string func = decl.func("sys_" ~ row[2]);
                if (func.empty && row.length > 3)
                    func = decl.func(row[3]);

                string[] params = decl.params(func);

                writeln("    </tr>");
            }
            writeln("</table>");

            break;

        case File.csv: return;
    }
}
