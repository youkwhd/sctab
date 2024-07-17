module sctab.gen;

enum Generation { html, csv };

void generate(Generation type)
{
    final switch (type) {
        case Generation.html: return;
        case Generation.csv: return;
    }
}
