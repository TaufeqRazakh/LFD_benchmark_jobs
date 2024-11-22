# expression /\d(compute_cur)\w+,\s+\d,\s+(\d+),/
# used to open a file named
# /lfd_kernels_O1_32_32_32_32.21556

require 'optparse'
require 'csv'

options = {}
OptionParser.new do |parser|
  parser.on("-dDIRECTORYPATH", String,
            "Use ** for recursive or set path here") do |dirpath|
    puts "Compute current kernel time will be extracted from files in #{dirpath}"
    options[:d] = dirpath
  end

  parser.on("-oCSVFILENAME", String,
  	"Name of CSV to generate") do |csvpath|
  	puts "mesh info and kernel time will be written in #{csvpath}"
  	options[:o] = csvpath
  end
end.parse!

base_path = options[:d]
tracefiles = File.join(base_path,"lfd_kernels_O1_*")
outfile = CSV.open(File.join(base_path, options[:o]), "wb")
outfile << ["nx", "ny", "nx", "norb","kernel time (ns)"]

def write_csv(mesh_options, kernel_options, out_file)
	out_file << [mesh_options[:nx], mesh_options[:ny], mesh_options[:nz], mesh_options[:norb],
                  kernel_options[:ktime]]
end

Dir.glob(tracefiles).each do |file_name|
	f_name = File.basename(file_name)
	f_contents = File.readlines(file_name).filter {|v| /compute_cur/.match?(v)}

	mesh_info = f_name.match(/_(?<nx>\d+)_(?<ny>\d+)_(?<nz>\d+)_(?<norb>\d+)/)	
	kernel_line = f_contents[0].match(/\dcompute_cur\w+,\s+\d,\s+(?<ktime>\d+),/)

	write_csv(mesh_info, kernel_line, outfile)
end
outfile.close

puts "done!"

