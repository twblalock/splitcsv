require "csv"

if ARGV.length < 2
    puts "Usage: ruby splitcsv.rb [file] [number_of_ROWS]"
    exit 1
end

CSV_FILE = ARGV[0]
NUM_ROWS = ARGV[1].to_i

parts = CSV_FILE.split(".")
ext = ""
if parts.length > 1
    ext = "." + parts.pop
end
EXTENSION = ext
BASENAME = parts.join(".")

filenum = 0
rownum = 0
outfile = nil
CSV.foreach(CSV_FILE, {:headers => true}) do |row|
    if rownum == 0 || rownum % NUM_ROWS == 0
        if !outfile.nil?
            outfile.close
        end

        filenum += 1
        outfile = File.open("#{BASENAME}_#{filenum}#{EXTENSION}", "w")

        outfile.puts CSV.generate { |csv| csv << row.headers }
        rownum += 1
    end

    outfile.puts CSV.generate { |csv| csv << row }
    rownum += 1
end
