#!/usr/bin/env ruby

#Get the command-line argument

def helpscrn
	# define the help variable which holds the help text
	help = 
	"Usage: ruby inventory.rb [?|-h|help|[-u|-o|-z <infile>|[<outfile>]]]\n
	Parameters:
	   ?                 displays this usage information
	   -h                displays this usage information
	   help              displays this usage information
	   -u <infile>       update the inventory using the file <infile>.
	                     The filename <infile> must have a .csv
	                     extension and it must be a text file in comma
	                     separated value (CSV) format. Note that the
	                     values must be in double quote.
	   -z|-o [<outfile>] output either the entire content of the
	                     database (-o) or only those records for which
	                     the quantity is zero (-z). If no <outfile> is
	                     specified then output on the console otherwise
	                     output in the text file named <outfile>. The
	                     output in both cases must be in a tab separated
	                     value (tsv) format."

	# print the help screen
	puts help
end

def updateinv
	if (ARGV[1] == nil)
		puts "\n-u requires an <infile>"
		puts "Usage: ruby inventory.rb [?|-h|help|[-u|-o|-z <infile>|[<outfile>]]]"
	else
		if (!ARGV[1].to_s.end_with?(".csv") || ARGV[1] == nil)
			puts "\nInvalid file format – unable to proceed."
			puts "Usage: ruby inventory.rb [?|-h|help|[-u|-o|-z <infile>|[<outfile>]]]"
		else
			csv_file = File.open("/Volumes/Chris-Storage/Current Courses/Programming Languages/Homework/Barcode Scanner/" << ARGV[1])
			if csv_file
				puts "file found"
			else
				puts "Input file #{ARGV[1]} not found - aborting."
				break
			end
			
			# Update inventory

			# Update error
			puts ""

			# Update successful
			puts "Updated #{csv_file.count} database records successfully"
		end
	end
end


if (ARGV[0] == '?' || ARGV[0] == '-h' || ARGV[0] == 'help')
	helpscrn
elsif (ARGV[0] == '-u')
	updateinv
elsif (ARGV[0] == '-z' || ARGV[0] == '-o')
	output
else
	puts "\nUsage: ruby inventory.rb [?|-h|help|[-u|-o|-z <infile>|[<outfile>]]]"
end