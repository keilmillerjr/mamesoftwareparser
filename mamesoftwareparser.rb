require 'rexml/document'
require 'fileutils'

# command
ARGV << '--help' if ARGV.empty?

aliases = {
  'd' => 'drivers',
  'r' => 'roms',
  'e'  => 'export'
}

command = ARGV.shift
command = aliases[command] || command

# print help in terminal window
if command == '--help'
  readme = File.open ('readme.md') do |data|
    data.each_line do |line|
      puts line
    end
  end
  exit
end

# romset class
class Romset
  attr_reader :driver, :roms
  
  def initialize(xml_path)
    # define drivers and roms
    @drivers = []
    @roms = []
    
    # parse softwarelist
    softwarelist = File.open(xml_path) do |data|
      xml = REXML::Document.new data
      
      # add drivers
      xml.elements.each('softwarelists/softwarelist') do |element|
        @drivers.push element.attributes['name']
      end
      
      # add roms
      xml.elements.each('softwarelists/softwarelist/software') do |element|
        @roms.push element.attributes['name']
      end
    end
    
    # sort drivers and roms
    @drivers = @drivers.sort
    @roms = @roms.sort
  end
  
  # print driver list in terminal window
  def drivers
    puts @drivers
    puts "\n"
    puts "Drivers: #{@drivers.count}"
  end
  
  # print rom list in terminal window
  def roms
    puts @roms
    puts "\n"
    puts "Roms: #{@roms.count}"
  end
  
  # export files matching drivers or roms
  def export(src, dest)
    # file count
    count = 0
    
    # copy files with same base name as drivers and roms from source to destination
    Dir.open(src).each do |file_name|
      if (@drivers.include? File.basename(file_name,File.extname(file_name))) || (@roms.include? File.basename(file_name,File.extname(file_name)))
        FileUtils.cp src+file_name, dest+file_name
        count += 1
      end
    end
    
    # print results
    puts "Drivers: #{@drivers.count}"
    puts "Roms: #{@roms.count}"
    puts "\n"
    puts "Files exported: #{count}"
  end
end

# print driver list in terminal window
if command == 'drivers'
  romset = Romset.new(ARGV[0])
  romset.drivers
end

# print rom list in terminal window
if command == 'roms'
  romset = Romset.new(ARGV[0])
  romset.roms
end

# export files matching drivers or roms
if command == 'export'
  romset = Romset.new(ARGV[0])
  romset.export(ARGV[1], ARGV[2])
end

# exit ruby script
exit
  