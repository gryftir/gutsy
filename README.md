gutsy version .2
=====

.2 uses HTML::TreeBuilder

.1 used simple regex

for the gutsy intern to be: scrapes HN's who's hiring for internships

Requires Crypt:SSLeay http://search.cpan.org/~nanis/Crypt-SSLeay-0.64/SSLeay.pm for local download or curl, as well as LWP::Simple

License is GPL3

Note: Gutsy is a work in progress, and currently has several issues that will be addressed in the next version

current issues:
<li>
<ul><del>gutsy uses a rather simplistic means to parse the html file.</del></ul>

<ul>gutsy generates plain text.</ul>

<ul>gutsy doesn't follow More links.</ul>

<ul>gutsy isn't polite and doesn't use the recommend API for Hacker News</ul>
</li>


Other features to be added in the next version: 
add search options for remote, H1B, and categorize by location

