module sctab.gen;

import std.stdio;
import std.regex;
import std.range;
import std.array : appender;
import std.format;
import std.conv;
import std.file;
import decl = sctab.decl;
import tbl = sctab.tbl;

enum Format {
    html,
    csv,
};

enum Arch {
    x86,
    x64,
};

string[] registers(Arch arch)
{
    final switch (arch)
    {
        case Arch.x86: return ["%eax", "%ebx", "%ecx", "%edx", "%esi", "%edi", "%ebp"];
        case Arch.x64: return ["%rax", "%rdi", "%rsi", "%rdx", "%r10", "%r8", "%r9"];
    }
}

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
    string[] regs = arch.registers();

    write("Name");

    for (int i = 0; i <= 6; i++)
        write("," ~ regs[i]);

    write("\n");

    foreach (ref row; table)
    {
        auto hex = appender!string();
        formattedWrite(hex, "0x%02x", to!int(row[0]));

        write(row[2] ~ ",");
        write(hex[]);

        string func = decl.func("sys_" ~ row[2]);
        if (func.empty && row.length > 3)
            func = decl.func(row[3]);

        string[] params = decl.params(func);
        for (int i = 0; i < 6; i++)
        {
            write("," ~ params[i]);
        }

        write("\n");
    }

}

private void colorizeParamHtml(string param)
{
    string[] keywords = param.split(" ");
    for (int j = 0; j < keywords.length - 1; j++)
    {
        ulong start = 0;
        ulong end = keywords[j].length;

        // check if starts with or ends with C pointer
        if (keywords[j].length > 1)
        {
            start += keywords[j][0] == '*';
            end -= keywords[j][end - 1] == '*';
        }

        if (start != 0)
        {
            write("*");
        }

        string kw = keywords[j][start..end];
        switch (kw)
        {
            case "const":
            case "struct":
                write("<span style=\"color: #de333c; font-weight: bold\">" ~ kw ~ "</span>");
                break;
            case "*":
                write(kw);
                break;
            default:
                write("<span style=\"color: #997cd7\">" ~ kw ~ "</span>");
                break;
        }

        if (end != keywords[j].length)
        {
            write("*");
        }

        write(" ");
    }

    // for type that has no variable name
    if (keywords.length == 1 && !(keywords[0] == "?" || keywords[0] == "-"))
    {
        write("<span style=\"color: #997cd7\">" ~ keywords[0] ~ "</span>");
        return;
    }

    write(keywords[keywords.length - 1]);
}

private void generateHtml(Arch arch)
{
    string[][] table = rawTable(arch);
    string[] regs = arch.registers();

    writeln("<table>");
    writeln("    <thead>");
    writeln("        <tr>");
    writeln("            <th>Name</th>");

    for (int i = 0; i <= 6; i++)
        writeln("            <th>" ~ regs[i] ~ "</th>");

    writeln("        </tr>");
    writeln("    </thead>");

    writeln("    <tbody>");
    foreach (ref row; table)
    {
        auto hex = appender!string();
        formattedWrite(hex, "0x%02x", to!int(row[0]));

        writeln("        <tr>");
        writeln("            <td>" ~ row[2] ~ "</td>");
        writeln("            <td>" ~ hex[] ~ "</td>");

        string func = decl.func("sys_" ~ row[2]);
        if (func.empty && row.length > 3)
            func = decl.func(row[3]);

        string[] params = decl.params(func);
        for (int i = 0; i < 6; i++)
        {
            if (false)
            {
                write("            <td>");
                colorizeParamHtml(params[i]);
                writeln("</td>");
                continue;
            }

            writeln("            <td>" ~ params[i] ~ "</td>");
        }

        writeln("        </tr>");
    }
    writeln("    </tbody>");

    writeln("</table>");
}

void generate(Arch arch, Format type)
{
    final switch (type)
    {
        case Format.html: return generateHtml(arch);
        case Format.csv: return generateCsv(arch);
    }
}
