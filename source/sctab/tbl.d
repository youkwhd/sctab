module sctab.tbl;

import std.algorithm.iteration;
import std.conv;
import std.range;
import std.stdio;

string[][] parse(string filePath)
{
    return File(filePath).byLine()
                         .filter!(line => !line.empty && line[0] != '#')
                         /// https://stackoverflow.com/questions/43552468/dlang-map-int-to-string-array 
                         .map!(line => to!(string)(line).split)
                         .array();
}
