#!/usr/bin/env groovy

class CoverageReportSummaryParser {

    Double lineCoveragePercent;
    String lineCoverageDetail;

    // ================================================================================================================================== //
    // Constructors
    // ================================================================================================================================== //

    CoverageReportSummaryParser(String summary) {
        parse(summary);
    }

    // ================================================================================================================================== //
    // Public
    // ================================================================================================================================== //

    void print(OutputStream outputStream) {
        outputStream.println("Coverage rate:")
        outputStream.print("  lines......: ")
        outputStream.print("${lineCoveragePercent}% ${lineCoverageDetail}\n")
        outputStream.print "\n"
    }

    // ================================================================================================================================== //
    // Private
    // ================================================================================================================================== //
    void parse(String summary) {
        boolean linesFound = false
        summary.eachLine {
            if (it.startsWith("  lines......:")) {
                def lineSummary = it.split("%")
                lineCoveragePercent = new Double(lineSummary[0].substring(15))
                lineCoverageDetail = lineSummary[1].trim()
                linesFound = true
            }
        }
        if (!linesFound) {
            throw new RuntimeException("Coverage data not found")
        }
    }
}


try {
    def cli = new CliBuilder()
    cli.with
            {
                h(longOpt: 'help', 'Help - Usage Information')
                f(longOpt: 'info-file', 'Coverage info file to read', args: 1, type: String, required: true)
                c(longOpt: 'line-coverage', 'Required line coverage', args: 1, type: String, required: true)
            }
    def opt = cli.parse(args)
    if (!opt) System.exit(-1)
    if (opt.h) cli.usage()

    String inputFile = opt.getProperty("f")
    Double requiredCoverage = new Double(opt.getProperty("c"))

    println "\nReading coverage file: " + inputFile
    OutputStream os = new ByteArrayOutputStream()

    Process summary = ("lcov --summary " + inputFile).execute()
    summary.consumeProcessOutput(os, os)
    summary.waitFor()

    def parser = new CoverageReportSummaryParser(os.toString())
    parser.print(System.out)

    if (parser.lineCoveragePercent < requiredCoverage) {
        throw new RuntimeException("Line coverage was " + parser.lineCoveragePercent + ", but required coverage is " + requiredCoverage + "\n");
    }
}
catch (RuntimeException e) {
    println "\nError: " + e.getMessage();
    System.exit(-1)
}




