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

  opts.on('-s', '--source SOURCE', 'Source Folder') do |source|
    options[:source] = source
  end

  opts.on('-d', '--destination DESTINATION', 'Destination Folder') do |destination|
    options[:destination] = destination
  end
  
  opts.on('-n', '--noclones', 'No Clones') do
    options[:noclones] = true
  end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end

option_parser.parse!

# romset class
class Romset
  attr_reader :list

  def initialize(xmlpath)
    # define list
    @list = []

    # parse softwarelist
    softwarelist = File.open(xmlpath) do |data|
      xml = REXML::Document.new data

      # add drivers
      xml.elements.each('softwarelists/softwarelist') do |element|
        driver = { name: element.attributes['name'] }
        driver[:type] = 'driver'
        @list << driver
      end

      # add roms
      xml.elements.each('softwarelists/softwarelist/software') do |element|
        rom = { name: element.attributes['name'] }
        element.attributes['cloneof'].nil? ? rom[:type] = 'rom' : rom[:type] = 'clone'
        @list << rom
      end
    end

    # sort list by name
    @list.sort_by! { |entry| entry[:name] }
  end
  
  def print_list
    # print drivers
    puts "Drivers = #{ @list.count { |entry| entry[:type] == 'driver'} }"
    @list.each do |entry|
      puts "  #{entry[:name]}" if entry[:type] == 'driver'
    end
    puts
    
    # print roms
    puts "Roms = #{ @list.count { |entry| entry[:type] == 'rom'} }"
    @list.each do |entry|
      puts "  #{entry[:name]}" if entry[:type] == 'rom'
    end
    puts
    
    # print clones
    puts "Clones = #{ @list.count { |entry| entry[:type] == 'clone'} }"
    @list.each do |entry|
      puts "  #{entry[:name]}" if entry[:type] == 'clone'
    end
    puts
    
    # print total games
    puts "Total games = #{ list.count { |entry| entry[:type] == 'rom' || entry[:type] == 'clone' } }"
  end
  
  def audit_media(source)
    @list.each do |entry|
      Dir.glob(source + '/' + entry[:name] + '.*') do
        entry[:match] = true
      end
      entry[:match] = false if !entry[:match]
    end
  end
  
  def print_audit(source)
    # audit media
    audit_media(source)
    
    # print matching media
    puts "Matching media = #{ @list.count { |entry| entry[:match] == true } }"
    @list.each do |entry|
      puts "  #{entry[:name]}" if entry[:match] == true
    end
    puts
    
    # print missing media
    puts "Missing Media = #{ @list.count { |entry| entry[:match] == false } }"
    @list.each do |entry|
      puts "  #{entry[:name]}" if entry[:match] == false
    end
  end
  
  def copy_media(source, destination, noclones: false)
    puts "Copying matching media. This may take some time."
    count = 0
    
    @list.each do |entry|
      next if noclones && entry[:type] == 'clone'
    
      Dir.glob(source + '/' + entry[:name] + '.*') do |filename|
        FileUtils.cp File.expand_path(filename), destination
        count += 1
        puts "  copied #{File.basename(filename).to_s}"
      end
    end
    
    # print results
    puts "\n"
    puts "Total files copied: #{count}"
  end
end

# create romset
romset = Romset.new(ARGV[0])

# print romset
romset.print_list if options.count == 0

# audit media
romset.print_audit(options[:source]) if options[:source] && !options[:destination]

# copy media
romset.copy_media(options[:source], options[:destination], noclones: options[:noclones]) if options[:source] && options[:destination]

# exit ruby script
exit