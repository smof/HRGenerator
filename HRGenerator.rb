#!/usr/bin/env ruby
#Simon Moffatt Jan 2013
#Creates a CSV file of random user HR data.  Useful for populating LDAP/databases for ACL testing
#Requires a unique names file with "firstname lastname" per each line
 
#requires
require 'rubygems'
require 'date'
require 'csv'

#Globals and constants#######################################################################
INPUT_FILE="names.dat" #one name per line (firstname lastname)
OUTPUT_FILE="HR_generated_data.csv"
@unique_employeeids = [] #initialized.  contains newly created ids in order to manage uniqueness
@managers = {} #where manager to dept assignments are stored
@completed_users = [] #where all user arrays end up

#Org Data
COMPANY_NAME="Acme"

DEPTS=["IT","Finance","Sales","Engineering","Accounts","Marketing","Operations_Centre","Research", "Consulting"]

TITLES={:IT => ["Developer","Analyst","Engineer"], :Finance=>["Administrator","Payroll-Clerk","Reporting"], :Sales=>["Rep","Field-Rep"], 
  :Engineering=>["Engineer","Snr-Engineer"], :Accounts=>["Payable-Clerk","Receivable-Clerk"], :Marketing=>["Inbound-Exec","Outbound-Exec"],
  :Operations_Centre=>["Analyst1","Analyst2","Analyst3"], :Research=>["Assistant","Supervisor"], :Consulting=>["Consultant","Snr-Consultant"] }

#Globals and constants#######################################################################


def init
  
  @completed_users << "employeeid,fullname,firstname,lastname,email,department,job_title,manager,start_date"
  
end


def read_employees

  puts "Reading input file..."

  #iterate over csv of first and last names.  Each row is passed to row[]
  
  if File.exist?(INPUT_FILE)
    
    #create the managers array for the first n number of employees where n = number of departments specified in global DEPTS array
    i=0
    managers_to_be = []
    
    CSV.foreach(INPUT_FILE) do |employee|
    
           break if (i == DEPTS.length) #only want to pull out enough managers to cover the depts
           managers_to_be << employee
           i += 1
                     
    end
        
    #go and actually assign the managers to their depts
    create_managers managers_to_be
    
    #go and create HR records for all employees found in the employees csv
    puts "Creating new HR records"
    CSV.foreach(INPUT_FILE) do |employee|
      
      create_HR_record employee
      
    end
    puts "\nCompleted creating HR records"
  else
    puts "#{INPUT_FILE} file not found!"
    exit
  end
  
end

#Creates single HR record with random data and pushes into COMPLETED_USERS array
def create_HR_record employee
        
    processed_record = "."   
    
    firstname = employee[0].split(" ")[0]
    lastname = employee[0].split(" ")[1]
    fullname = employee[0]
    dept = @managers.has_value?(fullname.to_s) ? @managers.key(fullname.to_s) : get_dept #check if employee fullname already exists in MANAGERS hash if so use dept
    job_title = @managers.has_value?(fullname.to_s) ? "Manager" : get_title(dept) #check if employee fullname already exists in MANAGERS hash is so = manager
    employeeid = get_employeeid firstname, lastname
    email = get_email firstname, lastname
    start_date = get_start_date
    end_date = get_end_date #not implemented
    manager = job_title == "Manager" ? "CEO" : @managers[dept.to_sym]
    
    @completed_users << "#{employeeid},#{fullname},#{firstname},#{lastname},#{email},#{dept},#{job_title},#{manager},#{start_date}"
   
    STDERR.print processed_record
end


#creates a single manager per business unit
def create_managers managers_to_be
  
  i = 0 
  1.upto(managers_to_be.length-1) do
    
    @managers[DEPTS[i].to_s.to_sym] = managers_to_be[i][0] #Eg. {:Finance => "Simon Moffatt"}
     
    i += 1 #move on to next value
    
  end  
  
end


#creates random start_date DD/MM/YYYY
def get_start_date
  
  start_of_date_range = "2005/01/01" #YYYY/MM/DD
  end_of_date_range = "2013/01/01" #YYYY/MM/DD
  #array of all dates in range
  date_range = (Date.parse(start_of_date_range)..Date.parse(end_of_date_range)).to_a
  #pulls out a random date based on the Kernel randomizer going now higher than the array length
  date_range[Kernel.rand(date_range.length-1)].to_s
  
end


#creates random end date DD/MM/YYYY
def get_end_date
  
  
end


#creates email address
def get_email firstname, lastname
  
  "#{firstname}.#{lastname}@#{COMPANY_NAME}.com"

end



#randomly pulls out a single dept
def get_dept
  
   DEPTS[Kernel.rand(DEPTS.length-1)].to_s

end

#pulls out job title based on @dept value
def get_title dept

  all_titles = TITLES[dept.to_sym]
  all_titles[Kernel.rand(all_titles.length-1)]

end

#creates random and unique employeeid.  Format=fl##### (f=firstname first char, l=lastname first char)
def get_employeeid firstname,lastname
    
    employeeid = "#{firstname[0]}#{lastname[0]}#{Kernel.rand(99999)}"
    
    while @unique_employeeids.include? employeeid #check to set if new employeeid hasn't already been assigned to someone
      employeeid = "#{firstname[0]}#{lastname[0]}#{Kernel.rand(99999)}"
    end
    
    @unique_employeeids << employeeid #add accepted id to array of all ids
    return employeeid    
  
end
  




#writes out to new HR record
def write_data
  
  puts "Writing out new HR data"
  processed_record ="."
  output_file = File.open(OUTPUT_FILE, 'w')
  
  @completed_users.each do |user| 
    output_file.puts user.to_s 
    STDERR.print processed_record
  end #basic puts but driven to open file
  
  output_file.close #closes
  puts "\nCompleted writing out new HR data \n#{@completed_users.length} records processed"

end

#Run Through

puts "#####################################################################################"
puts "Started HR Generator #{Time.now}" 
init
read_employees
write_data
puts "Ended HR Generator #{Time.now}"
puts "#####################################################################################"

 
