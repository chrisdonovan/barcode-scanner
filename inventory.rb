#!/usr/bin/env ruby

require 'csv'

def load_database
	begin
		database_file = File.open("./inventory.accdb")
		database_contents = Array.new{Array.new}
		i = 0
		database_file.each do |line|
			database_contents[i] = line.split(",").map(&:strip)
			i += 1
		end

		return database_contents
	rescue
		abort "Unable to continue - database file #{database_file} not found."
	end
end


def help_scrn
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

# UPDATE INVENTORY FUNCTION called when user puts -u <infile>
def update_inv
	if (ARGV[1] == nil)
		puts "\n-u requires an <infile>"
		puts "Usage: ruby inventory.rb [?|-h|help|[-u|-o|-z <infile>|[<outfile>]]]"
	else
		if (!ARGV[1].to_s.end_with?(".csv") || ARGV[1] == nil)
			puts "\nInvalid file format – unable to proceed."
			puts "Usage: ruby inventory.rb [?|-h|help|[-u|-o|-z <infile>|[<outfile>]]]"
		else
			filename = "./" << ARGV[1]
			database_file = "./inventory.accdb"

			# Attempt to open database file. If not found, abort program.
			begin
				data_file = File.open(database_file)
			# Instead of asking for new file name, abort if file not found.
			rescue
				abort "Database file not found - aborting."
			end

			csv_input = Array.new{Array.new}

			i = 0
			data_file.each do |line|
				csv_input[i] = line.split(",").map(&:strip)
				i += 1
			end


			# Attempt to open user csv file. If not found, abort program.
			begin
				csv_file = CSV.open(filename, "r")
			# Instead of asking for new file name, abort if file not found.
			rescue
				abort "Input file #{ARGV[1]} not found - aborting."
			end
			
			CSV.foreach(filename) do |row|
				csv_input << row
			end

			CSV.open(database_file, "w") do |csv|
				csv_input.each do |a|
					csv << [a[0], a[1], a[2], a[3], a[4], a[5]]
				end
			end

			# Update successful
			puts "Updated #{csv_file.count} database records successfully"
		end
	end
end

# OUTPUT INVENTORY FILE called when user puts -o|-z <outfile>
def load_file(everything)
	database_contents = load_database

	if (everything == true)
		if (ARGV[1] == nil)
			database_contents.each do |a|
				puts "==========================================="
				puts "Barcode:       " << a[0]
				puts "Item Name:     " << a[1]
				puts "Item Category: " << a[2]
				puts "Quantity:      " << a[3]
				puts "Price:         " << a[4]
				puts "Description:   " << a[5]
				print "\n"
			end
		else
			new_filename = ARGV[1].to_s
			if (new_filename.end_with?(".tsv"))
				CSV.open(new_filename, "w", {:col_sep => "\t"}) do |csv|
					database_contents.each do |a|
					  csv << [a[0], a[1], a[2], a[3], a[4], a[5]]
					end
				end
				puts "File was successfully created!"
			else
				puts "File format must be .tsv!"
			end
		end
	else
		zero_content = ""
		database_contents.each do |a|
			if (a[3] == '0')
				zero_content << "===========================================\n"
				zero_content << "Barcode:       #{a[0]}\n"
				zero_content << "Item Name:     #{a[1]}\n"
				zero_content << "Item Category: #{a[2]}\n"
				zero_content << "Quantity:      #{a[3]}\n"
				zero_content << "Price:         #{a[4]}\n"
				zero_content << "Description:   #{a[5]}\n"
			end
		end

		if (zero_content == "")
			puts "No database records found with zero quantity."
		else
			puts zero_content
		end
	end
end


# SEARCH INVENTORY FILE called when user enters "ruby inventory.rb" and gets barcode
def search_inv(barcode,database_contents)

	database_item = ""
	database_contents.each do |a|
		if (a[0] == barcode)
			database_item << "Barcode #{barcode} found in the database. Details are given below.\n"
			database_item << "   Item Name: #{a[1]}\n"
			database_item << "   Item Category: #{a[2]}\n"
			database_item << "   Quantity: #{a[3]}\n"
			database_item << "   Price: #{a[4]}\n"
			database_item << "   Description: #{a[5]}\n"
			database_item << "\n"
		end
	end

	if (database_item == "")
		puts "No database records found with barcode number #{barcode}."
	else
		puts database_item
	end
end



if (ARGV[0] == '?' || ARGV[0] == '-h' || ARGV[0] == 'help')
	help_scrn
elsif (ARGV[0] == '-u')
	update_inv
elsif (ARGV[0] == '-z' || ARGV[0] == '-o')
	if (ARGV[0] == '-z')
		load_file(false)
	else
		load_file(true)
	end
else
	dbcontents = load_database
	input = gets.strip
	search_inv(input,dbcontents)
end