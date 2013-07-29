# Ruby MD5 or SHA1 hash cracking using a dictionary attack
# For the IRCNode hackathon (https://github.com/IRCNode/Programming/tree/master/hackathons/01)

require 'digest/sha1'
require 'digest/md5'
require 'optparse'

puts "Starting up..."

algorithms = ['md5', 'sha1']
options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: jruby app.rb [OPTIONS]"
  opt.separator  ""
  opt.separator  "Options"

  opt.on("-a","--algorithm ALGORITHM","Hashing algorithm (MD5 or SHA1)") do |hashtype|
    options[:hashtype] = hashtype
  end

  opt.on("-h","--hashlist HASHLIST","Hashlist to use (filename.txt)") do |hashlist|
    options[:hashlist] = hashlist
  end

  opt.on("-d","--dictionary DICTIONARY","Dictionary to use (filename.txt)") do |dictionary|
    options[:dictionary] = dictionary
  end

  opt.on("-o","--help", "Help") do
    puts opt_parser
    abort()
  end
end

opt_parser.parse!

if options[:hashtype].nil? || !algorithms.include?(options[:hashtype].downcase)
  abort("Please specify a hashing algorithm with -a")
end

if options[:hashlist].nil? 
  abort("Please specify a hash list with -h")
end

if options[:dictionary].nil? 
  abort("Please specify a dictionary with -d")
end

$hashes = lines = IO.read(options[:hashlist]).split("\n")
$hashesfound = 0
$hashestofind = $hashes.count

$starttime = Time.now
open(options[:dictionary]).each_line do |line|
  if $hashesfound != $hashestofind
    line = line.gsub(/\n/,"")
    line = line.gsub(/\r/,"")
    if options[:hashtype].downcase == "md5"
      hash = Digest::MD5.hexdigest(line)
    else 
      hash = Digest::SHA1.hexdigest(line)
    end
    if $hashes.include?(hash)
      puts "HASH #{hash} == #{line}"
      $hashesfound += 1
    end
  else
    puts (Time.now - $starttime)
    abort("Finished hashing")
  end
end