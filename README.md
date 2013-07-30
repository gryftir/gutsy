gutsy version 0.41
=====

v0.41 can now print to html, downloading is no longer silent

v0.4 printing is better thanks to using format() instead of as_text.  Also added GutsyComment class, with an array of comments.

v0.3 Follow's More links to download all top level comments, allows passing a subroutine reference to pull out specific entries.

v0.2 uses HTML::TreeBuilder

v0.1 used simple regex

for the gutsy intern to be: scrapes HN's who's hiring for internships

Requires Crypt:SSLeay http://search.cpan.org/~nanis/Crypt-SSLeay-0.64/SSLeay.pm for local download or curl, as well as LWP::Simple

License is GPL3

Note: Gutsy is a work in progress, and currently has several issues that will be addressed in the next version

current issues:
<li>
<ul><del>gutsy uses a rather simplistic means to parse the html file.</del>Done, uses HTML::TreeBuilder</ul>
<ul><del>gutsy doesn't follow More links.</del>Done, using curl </ul>

<ul><del>gutsy generates plain text.</del>Done, gutsy can now make an html page and comes with a basic stylesheet</ul>

<ul>gutsy isn't polite and doesn't use the recommended API for Hacker News.  I'd love to do this, if somebody wants to send me example code</ul>

<ul>gutsy doesn't store older pages</ul>
<ul>gutsy doesn't have built in search</ul>
<ul>gutsy doesn't have command line options</ul>
<ul>gutsy doesn't have an interactive mode with the most useful queries</ul>

</li>



Currently you can pass a subroutine to spit out relevant comments.

Other features to be added in the next version: 
add search options for remote, H1B, and categorize by location

