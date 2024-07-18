module sctab.gen;

/// Supported file types
enum File { html, csv };

void generate(File type)
{
    final switch (type) {
        case File.html: return;
        case File.csv: return;
    }
}
