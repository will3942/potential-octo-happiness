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

def md5hash (gwords)
  gwords.each do |gword|
    md5 = Digest::MD5.hexdigest(gword)
    if $hashes.include?(md5)
		  puts "MD5 #{md5} == #{gword}"
      $hashesfound += 1
    end
  end
end

def sha1hash (gwords)
  gwords.each do |gword|
    sha1 = Digest::SHA1.hexdigest(gword)
    if $hashes.include?(sha1)
      puts "SHA1 #{sha1} == #{gword}"
      $hashesfound += 1
    end
  end
end

wordlist = []
IO.read(options[:dictionary]).each_line do |line|
  words = line.split
  wordlist << words[0]
end

puts "Started hashing"
$starttime = Time.now
wordlist.each_slice(400) do |gwords|
  if $hashesfound != $hashestofind
    if options[:hashtype].downcase == "md5"
      Thread.new { md5hash(gwords) }
    else 
      Thread.new { sha1hash(gwords) }
    end
  else
    finished = (Time.now - $starttime)
    puts finished
    abort("Completed all hashes")
  end
end
finished = (Time.now - $starttime)
puts finished