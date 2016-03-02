#! /usr/bin/env ruby
# make sure file is executable with chmod u+x FILE_PATH

require 'optparse'
require 'rexml/document'
require 'fileutils'

# options
ARGV << '-h' if ARGV.empty?

options = {}

option_parser = OptionParser.new do |opts|
  opts.banner = "Usage: mamesoftwareparser.rb SOFTWARELIST.XML [OPTIONS]"

  opts.on('-n', '--noclones', 'No Clones') do
    options[:noclones] = true
  end

  opts.on('-s', '--source SOURCE', 'Source Folder') do |source|
    options[:source] = source
  end

  opts.on('-d', '--destination DESTINATION', 'Destination Folder') do |destination|
    options[:destination] = destination
  end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end

option_parser.parse!

# Raise an error if only source or destination options is provided
raise OptionParser::MissingArgument if (options[:source] && !options[:destination]) || (!options[:source] && options[:destination])

# romset class
class Romset
  attr_reader :roms

  def initialize(xmlpath)
    # define drivers and roms
    @drivers = []
    @roms = []

    # parse softwarelist
    softwarelist = File.open(xmlpath) do |data|
      xml = REXML::Document.new data

      # add drivers
      xml.elements.each('softwarelists/softwarelist') do |element|
        @drivers.push element.attributes['name']
      end

      # add roms
      xml.elements.each('softwarelists/softwarelist/software') do |element|
        name = element.attributes['name']
        cloneof = element.attributes['cloneof']

        rom = { name: name }
        rom[:cloneof] = cloneof if cloneof
        @roms << rom
      end
    end

    # sort drivers and roms
    @drivers.sort!
    @roms.sort_by! { |rom| rom[:name] }
  end

  # copy files with same base name as drivers and roms from source to destination
  def copy(source, destination)
    # file count
    count = 0

    Dir.open(source).each do |file_name|
      if (@drivers.include? File.basename(file_name, File.extname(file_name))) || (@roms.any? { |rom| rom[:name] == File.basename(file_name, File.extname(file_name)) })
        FileUtils.cp File.join(source, file_name), File.join(destination, file_name)
        puts "copied #{file_name.to_s}"
        count += 1
      end
    end

    # print results
    puts "\n"
    puts "Total Files Exported: #{count}"
  end
  
  # print rom list in terminal window
  def print(noclones: false)
    @roms.each do |rom|
      next if noclones && rom[:cloneof]
      !rom[:cloneof] ? (puts "* #{rom[:name]}") : (puts "  #{rom[:name]}")
    end
    puts "\n"
    puts "Parents: #{@roms.count { |rom| !rom[:cloneof] }}" unless noclones
    puts "Clones: #{@roms.count { |rom| rom[:cloneof] }}" unless noclones
    !noclones ? (puts "Total: #{@roms.count}") : (puts "Total: #{@roms.count { |rom| !rom[:cloneof] }}")
  end
end

# Create romset
romset = Romset.new(ARGV[0])

# Copy or print romset
if (options[:source] && options[:destination])
  romset.copy(options[:source], options[:destination])
else
  romset.print(noclones: options[:noclones])
end

# exit ruby script
exit