gutsy version 0.621
=====

installation
-----------

gutsy requires curl and perl, HTML::TreeBuilder (available from perlbrew or CPAN) and git to install.

    sudo apt-get update
    sudo apt-get install curl perl
    
    
    git clone https://github.com/gryftir/gutsy.git ~/gutsy
    cd ~/gutsy
    
    you need to run cpan (included with perl) and install HTML::TreeBuilder 
    install HTML::TreeBuilder 
    
    exit cpan
    
    then you can use either:
    ./gutsy.pl or perl gutsy.pl to run
    


Gutsy requires curl, but can be made to work with LWP::Simple and Crypt:SSLeay http://search.cpan.org/~nanis/Crypt-SSLeay-0.64/SSLeay.pm for local download

Usage
------

examples

search for remote jobs

./gutsy.pl -j remote

search for jobs in the SF Bay Area

./gutsy.pl -l sfbay

see ./gutsy.pl -h for help and more options

Licence
--------

License is GPL3

Note: Gutsy is a work in progress, and currently has several issues that will be addressed in the next version

Current Goals (in no particular order):
-----------------------------------

<li>
<ul>make gutsy polite and have it use the recommended API for Hacker News.  I'd love to do this, if somebody wants to send me example code</ul>
<ul>make gutsy  have an interactive mode with the most useful queries</ul>
<ul>make gutsy doesn't store older pages.  I am not sure this is possible with current pages, but storing old pages may work, and may be useful for statistical analysis</ul>
<ul>add more subroutines.  I take pull requests</ul>


<ul><del>make gutsy have built in search</del> Done, use -s|--search. Need to text more complex options</ul>
<ul><del>allow mixing subroutines in command line mode </del> Done, you can combine jobtype, location and language queries from the command line, and they are treated as logical AND </ul>
<ul><del>gutsy doesn't have command line options</del> Done, now takes command line arguments</ul>
<ul><del>gutsy uses a rather simplistic means to parse the html file.</del> Done, uses HTML::TreeBuilder</ul>
<ul><del>gutsy doesn't follow More links.</del> Done, using curl </ul>
<ul><del>gutsy generates plain text.</del> Done, gutsy can now make an html page and comes with a basic stylesheet</ul>



</li>

Version Info
-------
v0.621 updated for December
v0.620 print title in file output and comment count out of total comments in text output
v0.610 Changed default to save all entries and updated for November
v0.601 minor bump for October
v0.6 full text search

v0.521 minor bump for september url
v0.52 added link to poster's user profile in html output
v0.51 made screen output clearer, added ability to combine multiple types of queries (location, job type, programming language)
v0.5 added GutsyExample with H!B, Remote, intern, SF bay area, and perl subroutines;

v0.41 can now print to html, downloading is no longer silent
v0.4 printing is better thanks to using format() instead of as_text.  Also added GutsyComment class, with an array of comments.

v0.3 Follow's More links to download all top level comments, allows passing a subroutine reference to pull out specific entries.

v0.2 uses HTML::TreeBuilder

v0.1 used simple regex




Currently you can pass a subroutine to spit out relevant comments.

Other features to be added in the next version: 
add search options for remote, H1B, and categorize by location


