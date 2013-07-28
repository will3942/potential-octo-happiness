Ruby MD5 or SHA1 hash cracking using a dictionary attack
========================


Requirements
------------

* Ruby or JRuby

Usage
------------

Usage: `jruby app.rb [OPTIONS]` **OR** `ruby app.rb [OPTIONS]`    
  
Options  
>    -a, --algorithm ALGORITHM        Hashing algorithm (MD5 or SHA1)  
    -h, --hashlist HASHLIST          Hashlist to use (filename.txt)  
    -d, --dictionary DICTIONARY      Dictionary to use (filename.txt)  
    -o, --help  
    
 
Benchmarks
------------

The timing I record using the Ruby script shows that hashing is quicker when using JRuby however JRuby takes longer to startup than standard Ruby.