#!/usr/bin/perl 
#
#  livedtd.pl - generate an html version of a DTD
#
# $Id: livedtd.pl,v 1.4 2005/04/06 08:33:53 bobs Exp $
#
# Copyright (c) 2000-2005 Robert Stayton
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the ``Software''), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# Except as contained in this notice, the names of individuals
# credited with contribution to this software shall not be used in
# advertising or otherwise to promote the sale, use or other
# dealings in this Software without prior written authorization
# from the individuals in question.
# 
# Any program derived from this Software that is publically
# distributed will be identified with a different name and the
# version strings in any derived Software will be changed so that
# no possibility of confusion between the derived package and this
# Software will exist.
# 
# Warranty
# --------
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT.  IN NO EVENT SHALL ROBERT STAYTON OR ANY OTHER
# CONTRIBUTOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# 
# Contacting the Author
# ---------------------
# This program is maintained by Robert Stayton <bobs@sagehill.net>.
# It is available through http://www.sagehill.net/livedtd
# 
#
# POD documentation:

=head1 NAME

livedtd.pl - generate an html version of a DTD

=head1 SYNOPSIS

C<livedtd.pl> [I<options>] F<dtdfile>

Where options are:

B<--catalog> I<catalogs>
   if an SGML (not XML) catalog used by the DTD

B<--outdir> I<outputdirectory>
   default is ./livedtd

B<--label> I<xxx>
   add xxx prefix on output filenames

B<--sgml>
   case insensitive element names

B<--title> "I<displayed title>"
   default is main DTD filename

B<--nousage>
   do not generate usage tables

B<--verbose>
   lists details to STDOUT


=head1 DESCRIPTION

This program scans through an XML or SGML Document Type
Definition (DTD) to locate element and parameter entity
definitions. Then it constructs an HTML version of the DTD
with hot links from element references to element
declarations, and from entity references to entity
declarations.  These links let you navigate through
the DTD with ease.  Just point your favorite frames-capable
browser at I<index.html> in the output directory
to see the results.

This program was written for use by maintainers of highly
parameterized DTDs such as Docbook or TEI. It allows you 
to quickly see how a parameter entity or element is defined,
following it through many levels of indirection to
its source. It also helps you find the active definition
when more than one is supplied, as when a customization
layer is used.

The program takes a single command line argument
(after any options) that is the pathname to the
main DTD file. [Windows users: use forward slashes
in all filenames.]  Any additional arguments are ignored.
DTD files referenced by the main DTD as SYSTEM entities
are processed when they are encountered, unless they
are in a marked section whose status is IGNORE.
SGML catalogs are supported to locate system files,
but http URLs are not supported.  XML catalogs are
not supported either.

The program handles marked sections properly. That is,
marked sections whose status is IGNORE are output
as plain text and do not have any live links.
Those whose status is INCLUDE are made live by adding
links. Parameter entities are also handled properly.
That is, if there is more than one declaration 
for the same name, only the first one is active.

Livedtd parses a DTD for display purposes, but it does
not validate it. In performing its function, it will flag
many common validation errors. But lack of such errors
does not necessarily mean the DTD is valid.

This program generates an HTML file for each DTD file
used.  The content is displayed within a <PRE> element
to preserve the white space and line breaks of the
original DTD file. The only difference from the original
file is the HTML markup to make it live. In fact,
removing the HTML markup leaves you with an identical
copy of the original. 

It outputs them into a single output directory, even if
the originals are scattered all over the place.
It also constructs lists of elements, entities, and
filenames, and constructs an HTML framework file
to display it all.  

The program generates name usage tables as well.  These are accessed
by clicking on the "+" marker next to an element or
entity name in the left-frame tables of contents.  A usage listing shows 
where the name itself was seen in the DTD.  It is not
a complete list of element usage, however.  To get that,
you have to follow the various parameter entities 
that contain the element name.

The program is not for authoring or editing a DTD. However,
if you have a good HTML editor that preserves lines endings
and whitespace, you can edit the HTML version with it.
When you are done, you can scrub out the HTML markup
using the program B<scrubdtd.pl> included with the
distribution.  That program converts a LiveDTD file
back to a "dead" DTD file without HTML markup.
It is used on each file that makes up the DTD:
	
   scrubdtd.pl file.dtd.html > file.dtd

If your HTML editor doesn't mess with the text,
you should have a working DTD file. Test it by
doing a round trip: use livedtd.pl to generate the
HTML version, make some editing changes with your
HTML editor, save it, and then apply scrubdtd.pl to
each generated HTML file. The only differences with the
original DTD files should be the changes you made.


=head1 OPTIONS

The B<--catalog> option lets you specify an SGML catalog
path (such as that used in SGML_CATALOG_PATH) to be used
to resolve PUBLIC identifiers in your DTD.
XML catalogs are not supported at this time.
The option can include more than one path, separated by colons.
Note that the OASIS/Catalog.pm module located below the
location of the livedtd.pl program is needed
to process a catalog file.  Your environment
variable SGML_CATALOG_PATH is I<not> automatically
used, because you may be processing in a mixed XML
and SGML environment.  If it is set, you can use:
  --catalog "$SGML_CATALOG_PATH"

The B<--label> option lets you add a prefix to
each of the generated filenames. That allows you to
output several different liveDTDs to the same directory
without filename conflict as long as the labels are
different.

The B<--outdir> option lets you specify an output
directory for the generated HTML files.  If not specified,
the program uses I<./livedtd>. That is, it creates
a subdirectory I<livedtd> below the current 
working directory.

The B<--sgml> option alters how names are parsed.
Without this option, the program defaults to XML name parsing, which
is always case sensitive.
With this option, B<livedtd> treats element names as not
being case sensitive. That is a feature of the reference concrete syntax
for SGML DTDs.
Entity names remain case sensitive, but entity names may include
only characters from the class [-A-Za-z0-9.] and not
underscore or colon as are permitted in XML.
Note that the program does not automatically detect
that a DTD is SGML.
Also, if your SGML declaration deviates from the reference concrete syntax.
you can adjust the variables $SGMLEntname and $SGMLElemName
defined at the top of the program.

The B<--title> option lets you specify a printed title to appear
in the HTML display, such as "DocBook XML 4.1".

The B<--nousage> option turns off the generation of tables showing
where each element and entity name are used in declarations.
The usage tables are useful for tracking down potential effects of
any changes you want to make to a DTD, so it is on by default.

The B<--verbose> option provides many details during the
processing that can be useful for diagnosis of problems.
It also provides tables of element and parameter entity
definitions.  It writes to standard output.

=head1 ACKNOWLEDGEMENTS

Thanks for Norm Walsh for permission to use code fragments
from his B<flatten> program for catalog and DTD parsing.


=cut

#######################################################
# Modules to use
# 
use strict;
use IO::File;
use File::Basename;
use Getopt::Long;
use vars qw($homedir);
# Note: OASIS::Catalog loaded if --catalog option used

# Note: if you get a 'missing @INC' error, add the
# following line (with comment removed),
# and changing /perl/lib to the path where the IO::File module
# is installed:
# 
# BEGIN { push @INC, '/perl/lib' };


#######################################################
# Global variables
# 
my $VERSION = "1.0";
my $outdir = "./livedtd";            # default HTML output directory
my @Files = ();                      # Files used by the DTD.
my @ELEMENT = ();                    # List of declared element names.
my %ELEMENT = ();                    # Data records for each element.
my @ElemUsage = ();                  # List of used element names.
my %ElemUsage = ();                  # Data records for element usage.
my @PE = ();                         # List of declared parameter entity names.
my %PE = ();                         # Data records for each PE
my @PEUsage = ();                    # List of used parameter entity names.
my %PEUsage = ();                    # Data records for PE usage.
my @ATTLIST = ();                    # List of declared ATTLIST names.
my %ATTLIST = ();                    # Data records for each ATTLIST.
my $pass;                            # First or second pass through the DTD
my @dirstack = ('.');                # Keeps track of relative paths.
my $catalog;                         # Catalog object.
my $label = '';                      # HTML filename prefix
my $title = '';                      # HTML title string
my $verbose;                         # Verbosity flag.
my $MainDTD;                         # Main DTD filename.
my $ElementDefCount = 0;             # Counts valid elements
my $AttlistDefCount = 0;             # Counts valid ATTLISTs
my $MarkedSectionCount = 0;          # Counts marked section starts
my $XMLEntName =  '[A-Za-z][-A-Za-z0-9._:]*';
                                     # Defines entity name char pattern
my $XMLElemName = '[A-Za-z][-A-Za-z0-9._:]*';
                                     # Defines element name char pattern
my $SGMLEntName =  '[A-Za-z][-A-Za-z0-9.]*';
                                     # Defines entity name char pattern
my $SGMLElemName = '[A-Za-z][-A-Za-z0-9.]*';
                                     # Defines element name char pattern
my $ML = 'XML';                      # XML or SGML markup language
my $EntName = $XMLEntName;           # Sets default to XML
my $ElemName = $XMLElemName;         # Sets default to XML

my %ListTitle = (                    # Printed HTML titles
    'FileList', 'DTD Files',
    'ElemList', 'Elements',
    'EntityList', '% Entities',
    'ElemUsage', 'Element Usage Table',
    'EntityUsage', 'Parameter Entity Usage Table'
    ) ;
my $usagetables = 1 ;                # Option flag, on by default.
my $UsageSymbol = "+";               # Link text to usage table
my $DOCTYPE = "<!DOCTYPE HTML PUBLIC"
              . " \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n";


#######################################################
# Usage statement
# 
my $USAGE = "\nlivedtd.pl      version $VERSION
Usage:
   livedtd.pl [options] dtdfile

Options:
   --catalog catalogfile      [if DTD uses a catalog file]
   --label xxx                [output filename prefix]
   --outdir outputdirectory   [default is ./livedtd]
   --title \"displayed title\"  [title in HTML files]
   --sgml                     [DTD is SGML, not default XML]
   --nousage                  [do not generate tables of name usage]
   --verbose                  [lots of info to STDOUT]
";


#######################################################
# Process the command line
# 
my %opt = ();
&GetOptions(\%opt,
    'catalog=s@',
    'label:s',
    'outdir:s',
    'title:s',
    'sgml',
    'nousage',
    'verbose') || die "$USAGE";

# Catalog option processed below.
$label = $opt{'label'} if $opt{'label'};
$outdir = $opt{'outdir'} if $opt{'outdir'};
$title = $opt{'title'} if $opt{'title'};
$usagetables = 0 if $opt{'nousage'};
$verbose = $opt{'verbose'} if $opt{'verbose'};

if ( $opt{'sgml'} ) {
    $ML = 'SGML';
    $EntName = $SGMLEntName;
    $ElemName = $SGMLElemName;
}

$MainDTD = shift @ARGV || die "ERROR: Missing DTD argument.\n$USAGE";

# Set the default title
$title = basename($MainDTD) unless $title;

#######################################################
# Make sure the output dir is writable
# 
if ( -d $outdir ) {
    # It exists, but is it writable?
    -w $outdir
        or die "Cannot write to output directory $outdir.\n";
}
else {
    # Create it
    system ("mkdir -p $outdir") == 0
        or die "Cannot create output directory $outdir.\n";
}

#######################################################
# Process the catalog file(s) 
# 
if ( $opt{'catalog'} ) {
    print "Got here\n";
    # Add current directory to @INC
    ($homedir = $0 ) =~ s/\\/\//g;
    $homedir =~ s/^(.*)\/[^\/]+$/$1/;
    unshift (@INC, $homedir);
    require 'OASIS/Catalog.pm' 
        or die "Must have OASIS/Catalog.pm to process catalogs\n";
    $catalog = new OASIS::Catalog('DEBUG'=>1);
    my @catalogs = @{$opt{'catalog'}};
    foreach my $catfile (@catalogs) {
        print "catalog = $catfile \n";
        $catalog->parse($catfile) or die "Cannot load catalog file $catfile\n";
    }
}

#######################################################
# Main program
#######################################################
#
# Set outputs to autoflush
select(STDERR); $| =  1;
select(STDOUT); $| =  1;

# Set this for the first pass through the DTD to get names.
$pass = 1;

# And parse the DTD to load the name arrays.
print STDOUT "Parsing DTD files ...\n";
&parsefile($MainDTD);

# Print out verbose lists if option used.
&PrintLists if $verbose;

# Clear the Files array
@Files = ();

# Parse again and generate DTD html files
$pass = 2;
print STDOUT "Generating HTML files ...\n";
&parsefile($MainDTD);

# Generate framework and list HTML files
print STDOUT "Generating list files and HTML frameset...\n";
&MakeFramework;

# Generate usage tables 
if ($usagetables) {
    print STDOUT "Generating usage tables...\n" ;
    &GenerateUsageTables() ;
}

print STDOUT "Done.\n";

#######################################################
# PrintLists -- Print verbose lists of elements and entities
# 
sub PrintLists {
    my ($i, $columns, @header, $ruleline) ;

    # Print out the entity list
    $columns = "%-28s %-7s %-15s %s\n";
    @header = ('Name', 'Type', 'File', 'Value');
    $ruleline = "-" x 75 . "\n";

    print STDOUT "\n", $ruleline;
    print STDOUT "ENTITIES (in order of declaration)\n";
    print STDOUT $ruleline;
    printf STDOUT ($columns, @header);
    print STDOUT $ruleline;
    for ($i = 0; $i <= $#PE; ++$i) {
        my $rec = $PE{$PE[$i]};
        my $value = substr($rec->{value}, 0, 20);
        $value =~ s/\s+/ /gs;
        $value =~ s/^ //;
        $value .= " ..." if ( length($rec->{value}) > 20);
        printf STDOUT ($columns, 
            $rec->{name},
            $rec->{type},
            basename($rec->{file}),
            $value,
            );
    }
    # Print out the element list
    $columns = "%-30s %-15s %s\n";
    @header = ('Name', 'File', 'Anchor name');
    $ruleline = "-" x 60 . "\n";

    print STDOUT "\n", $ruleline;
    print STDOUT "ELEMENTS (in order of declaration)\n";
    print STDOUT $ruleline;
    printf STDOUT ($columns, @header);
    print STDOUT $ruleline;
    for ($i = 0; $i <= $#ELEMENT; ++$i) {
        my $rec = $ELEMENT{$ELEMENT[$i]};
        printf STDOUT ($columns,
            $rec->{name}, 
            basename($rec->{file}),
            $rec->{anchor});
    }
    print STDOUT $ruleline;
}


    
########################################################
# resolve -- Resolve an entity
sub resolve {
    my $string = shift;

    if ( $string =~ /%($EntName);?/)  {
        # then it is a parameter entity that needs looking up
        if ( $PE{$1} ) {
            $string = $PE{$1}->{value};
        }
    }
    return($string);
}

########################################################
# resolveall -- Resolve all entities in a string
sub resolveall {
    my $string = shift;

    while ($string =~ /(%($EntName);?)/s) {
        # save this for comparison
        my $prevstring = $string;
        my $entityref = $1;
        if ($PE{$2}) {
            my $new = $PE{$2}->{value};
            $string =~ s/$entityref/$new/s;
        }
        # Punt if it didn't change
        if ($string eq $prevstring) {
            die "Unresolved parameter entity $entityref in $string\n";
        }
    }
    return($string);
}

#######################################################
# parsefile -- Parse a DTD file 
#   Argument should be a SYSTEM name.  If the catalog option
#   is used, it should already have been looked up when
#   the SYSTEM entity was declared.  If no catalog option
#   then the SYSTEM name has not been checked for
#   readability or relative pathname.
#   
sub parsefile {
    my $Filename = shift;
    my $Basename = basename($Filename);
    my $size ;
    my $Output;
    local ($_);

    # Resolve pathnames relative to previous file
    # if not absolute
    if ( ! -f $Filename ) {
        $Filename = $dirstack[$#dirstack] . "/" . $Filename;
    }

    if ($Filename =~ /^(.*)[\/\\]([^\/\\]+)$/) {
        push (@dirstack, $1);
    } else {
        push (@dirstack, ".");
    }
    
    # Is the file already open?
    if ( grep /^$Filename$/, @Files ) {
        return;
    }
    # Add to the file array
    push @Files, $Filename;

    # Open and read the whole file into $_ variable for parsing
    my $Filehandle = IO::File->new($Filename)
        or die "Can't open file $Filename $!\n";
    read ($Filehandle, $_, -s $Filename);
    $Filehandle->close;

    # Start output file if pass 2
    if ( $pass > 1 ) {
        my $outfile = $outdir . "/" . $label . $Basename . ".html";
        $Output = IO::File->new("> $outfile") 
           or die "Cannot write to output file $outfile.\n";

        # Set to autoflush 
        select($Output); $| = 1;

        # Write the header to the file
        my $onload = "parent.file.document.open();"
                      . "parent.file.document.write("
                      . "'<BODY TOPMARGIN=0><B>"
                      . $Basename
                      . "</B></BODY>');" 
                      . "parent.file.document.close()";

        print $Output $DOCTYPE;
        print $Output "<HTML>\n<HEAD>\n<TITLE>$Basename</TITLE>\n",
	     "<LINK REL=\"stylesheet\" TYPE=\"text/css\" HREF=\"livedtd.css\">\n",
                     "<STYLE TYPE=\"text/css\">\n",
                     "  STRONG { font-weight: bold; color: red;}\n",
                     "  .COMMENT { font-style:italic; color: #A8A8A8;}\n",
                     "</STYLE>\n",
                     "</HEAD>\n",
                     "<BODY onLoad=\"$onload\"><?LIVEDTD ENDHEAD?>\n<PRE>";
    }

    print STDOUT "Parsing file $Filename pass $pass ...\n" if $verbose;
    # Locate all declarations.
    while (/^(.*?)<!(.*?)>/s) {
        my $nondecl = $1;
        my $decl = $2;
        my $rest = $';

        # Parse the non declaration first.
        # Leading non-declarations may be PEs calling SYSTEM files.
        if ($nondecl) {
            &handlenondecl($nondecl, $Filename, $Output);
        }

        # Comments require reparse to include any > characters
        if ($decl =~ /^--/) {
            /^.*?<!(--.*?--)>/s;
            $decl = $1;
            $rest = $';

        }

        # Marked sections also are a special case.
        if ($decl =~ /^(\[\s*(\S+)\s*\[)/s ) {
            my $MSstart = $1;
            my $condition = $2;
            my $depth = 1;
            my $content = "";
            # Reset $_ to what follows the [
            $_ = $' . ">" . $rest;

            # This loop assembles a complete marked section
            # content (between [ and ]]>, exclusive).
            # Any nested marked sections are included.
            # No processing of conditions yet.
            while (($depth > 0) && /^(.*?)((<!\[)|(\]\]>))/s) {
                $content .= $1;
                if ($4) {
                    $depth--;
                    if ($depth > 0) {
                        $content .= $4;
                    }
                } else {
                    $depth++;
                    $content .= $3;
                }
                $_ = $';
            }

            # Reset $rest to after this marked section
            $rest = $_;
            if ( &resolveall($condition) =~ /^INCLUDE$/i ) {
                if ( $pass == 1 ) {
                    # Use it.
                    $_ = $content . $rest;
                    print STDOUT "Including marked section "
                                 . "$condition in $Filename\n" if $verbose;
                    next;
                }
                # If pass 2
                else {
                    print $Output "&lt;!" ;
                    # Track this in usage table 
                    # if the condition is an entity reference
                    if ( $condition =~ /%($EntName)(;?)/ && $usagetables ) {
                        my $status = $1;
                        # Is it a live PE?
                        if ( grep /^$status$/, @PE ) {
                            # Insert anchor
                            my $declname = "MS" . ++$MarkedSectionCount;
                            print $Output "<A NAME=\""
                                          . $declname
                                          . "\"></A>";
                            # And add to usage table
                            if ($usagetables) {
                                &UsageTables($status, 'PE', $declname, 'MS');
                            }
                            # And add the data to the record
                            my $address = $label . $Basename . '.html#'
                                   . $declname ;
                            push @{$PEUsage{$status}->{msusage}}, $address;
                        }
                    }
                    print $Output &MakeLive($MSstart);
                    # Restore the closing marker
                    $_ = $content . "]]>" . $rest;
                    next;
                }
            }
            elsif ( &resolveall($condition) =~ /^IGNORE$/i ) {
                if ( $pass == 1 ) {
                    # Skip this content.
                    $_ = $rest;
                    print STDOUT "Ignoring marked section $condition"
                                  . " in $Filename\n" if $verbose;
                    next;
                }
                # if pass 2                
                else {
                    # Just print it plain except for condition
                    print $Output "&lt;!" ;
                    # Track this for usage table reference
                    # if the condition is an entity reference
                    if ( $condition =~ /%($EntName)(;?)/ && $usagetables ) {
                        my $status = $1;
                        # Is it a live PE?
                        if ( grep /^$status$/, @PE ) {
                            # Insert anchor
                            my $declname = "MS" . ++$MarkedSectionCount;
                            print $Output "<A NAME=\""
                                          . $declname
                                          . "\"></A>";
                            # And add to usage table
                            if ($usagetables) {
                                &UsageTables($status, 'PE', $declname, 'MS');
                            }
                            # And add the data to the record
                            my $address = $label . $Basename . '.html#'
	 . $declname ;
                            push @{$PEUsage{$status}->{msusage}}, $address;
                        }
                    }

                    print $Output &MakeLive($MSstart);
                    print $Output &html($content);
                    print $Output "]]&gt;";
                    $_ = $rest;
                    next;
                }
            }
            else {
                die "Invalid marked section condition"
                    . " $condition in $Filename\n";
            }
        } # end of marked section processing

        $_ = $rest;
        &handledecl($decl, $Filename, $Output);
    }

    # Handle any trailing stuff at end of file
    &handlenondecl($_, $Filename, $Output);

    # Close off the $Output in pass 2
    if ( $Output ) {
        # Mark the bottom so can remove HTML
        print $Output "<?LIVEDTD EOF?>\n";
        # Pad bottom so #scrolls always show at top of frame
        print $Output "\n" x 40 ;
        print $Output "</PRE></BODY></HTML>";

        # Close the file
        $Output->close() 
    }
    pop (@dirstack);
}

#######################################################
# handlenondecl -- Parse and print text outside of declarations
# 
sub handlenondecl {
    my $nondecl = shift;
    my $Filename = shift;
    my $Output = shift;

    # Loop through to process all SYSTEM entities
    while ( $nondecl =~ /(%($EntName)(;?))/s ) {
        my $entityref = $1;
        my $entname = $2;
        my $rest = $';

        # Output any leading stuff if pass 2
        print $Output &html($`) if $Output;


        if ( my $ent = $PE{$entname} ) {
            if ( $ent->{type} eq 'SYSTEM' ) {
                &parsefile($ent->{value}) if $ent->{value};
            }
            else {
                # If not an empty string, then error
                if ( $ent->{value} ) {
                    die "Parameter entity reference $entityref"
                        . " must be a SYSTEM file if used outside"
                        . " of a declaration\n";
                }
            }
            # And output this as a hot spot
            print $Output "<A HREF=\""
                . $PE{$entname}->{address}
                . "\">"
                . $entityref
                . "</A>"
                if $Output;
        }
        else {
            # Else not an active system file
            print $Output $entityref if $Output;
        }
        $nondecl = $rest;
    }
    print $Output &html($nondecl) if $Output;
}

#######################################################
# handledecl -- Parse declarations
# 
sub handledecl {
    my $decl = shift;
    my $Filename = shift;
    my $Output = shift;

    if ($decl =~ /^ENTITY/s ) {
        if ( $Output ) {
            &entityprint($decl, $Filename, $Output);
        }
        else {
            &entitydef($decl, $Filename);
        }
    }
    elsif ($decl =~ /^ELEMENT/s ) {
        if ( $Output ) {
            &elementdef($decl, $Filename, $Output);
        }
        else {
            &elementdef($decl, $Filename);
        }
    }
    elsif ($decl =~ /^NOTATION/s ) {
        print $Output "&lt;!" . &MakeLive($decl) . "&gt;" if $Output;
    }
    elsif ($decl =~ /^ATTLIST/s ) {
        &attlistprint($decl, $Filename, $Output);
    }
    elsif ($decl =~ /^--.*?--/s ) {
	    &commentprint($decl, $Output);
    }
    else {
        print $Output "&lt;!" . &html($decl) . "&gt;" if $Output;
    }
}


#######################################################
# commentprint -- Print Comment
# 
sub commentprint {
    my $decl = shift;
    my $Output = shift;

    print $Output "<SPAN CLASS=\"COMMENT\">" if $Output;
    print $Output "&lt;!" . &html($decl) . "&gt;" if $Output;
    print $Output "</SPAN>" if $Output;
}


#######################################################
# entitydef -- Register a valid parameter entity definition
# 
sub entitydef {
    my $decl = shift;
    my $Filename = shift;

    my $Basename = basename($Filename);

    my $rec = {};
    my ($name, $type, $value, $address);

    # There are five cases of entity defs with keywords:
    # 1  PUBLIC "publicid" SYSTEM "systemid"
    # 2  PUBLIC "publicid" "systemid"
    # 3  PUBLIC "publicid"
    # 4  SYSTEM "systemid"
    # 5  "anyvalue"

    # Case 1 seems to be reserved for XML.
    # Cases 2 and 3 for SGML.

    # The order of resolution according to the SGML Open
    # Technical Resolution 9401:1997 is:
    #   catalog SYSTEM identifier from the systemid
    #   catalog PUBLIC identifier from the publicid
    #   entity  SYSTEM identifier from the systemid

    # NOTE: ALLOW OVERRIDE catalog feature not yet supported.

    # Resolved identifiers become $type = SYSTEM.

    # Case 1: PUBLIC and SYSTEM
    if ( $decl =~ /^ENTITY\s+%\s+($EntName)\s+PUBLIC\s+(["'])([^\2]*)\2\s+SYSTEM\s+(["'])([^\4]*)\4/si ) {
        $name = $1;
        my $pubid = $3;
        my $sysid = $5;
        $type = 'PUBLIC';

        # Resolve identifier if a new name
        unless ( grep /^$name$/, @PE ) {
            $value = &ResolveExternalID($pubid, $sysid);
        }
        $type = 'SYSTEM' if $value;
    }
    # Case 2: PUBLIC with systemid too
    elsif ( $decl =~ /^ENTITY\s+%\s+($EntName)\s+PUBLIC\s+(["'])([^\2]*)\2\s+(["'])([^\4]*)\4/si ) {
        $name = $1;
        my $pubid = $3;
        my $sysid = $5;
        $type = 'PUBLIC';

        # Resolve identifier if a new name
        unless ( grep /^$name$/, @PE ) {
            $value = &ResolveExternalID($pubid, $sysid);
        }
        $type = 'SYSTEM' if $value;
    }
    # Case 3: only PUBLIC
    elsif ( $decl =~ /^ENTITY\s+%\s+($EntName)\s+PUBLIC\s+(["'])([^\2]*)\2/si ) {
        $name = $1;
        my $pubid = $3;
        $type = 'PUBLIC';

        # Resolve identifier if a new name
        unless ( grep /^$name$/, @PE ) {
            $value = &ResolveExternalID($pubid, undef);
        }
        $type = 'SYSTEM' if $value;

    }
    # Case 4: only SYSTEM
    elsif ( $decl =~ /^ENTITY\s+%\s+($EntName)\s+SYSTEM\s+(["'])([^\2]*)\2/si ) {
        $name = $1;
        my $sysid = $3;
        $type = 'SYSTEM';

        # Resolve identifier if a new name
        unless ( grep /^$name$/, @PE ) {
            $value = &ResolveExternalID(undef, $sysid );
        }

    }
    # Case 5: not an external entity
    elsif ( $decl =~ /^ENTITY\s+%\s+($EntName)\s+.*(["'])([^\2]*)\2/s ) {
        $name = $1;
        $type = 'pe';
        $value = $3;

    }
    else {
        # must be either a text entity or bad declaration 
        return;
    }

    # Add to list if not already there.
    # Is the name already defined?
    unless ( grep /^$name$/, @PE ) {
        $rec->{name} = $name;
        $rec->{type} = $type;
        $rec->{value} = $value;
        $rec->{file} = $Filename;
        $rec->{anchor} = 'EntityDef.' . $name;
        $rec->{address} = $label . $Basename . '.html#' . $rec->{anchor} ;
        # save the whole record
        $PE{$rec->{name}} = $rec;
        push ( @PE, $name);
    }
}


#######################################################
# elementdef -- Register or print a valid element definition
# 
sub elementdef {
    my $decl = shift;
    my $Filename = shift;
    my $Output = shift;
    my @names;
    my $namefield;
    my $rest;
    my $lead;

    my $Basename = basename($Filename);


    # Element def may contain list or parameter entity.
    # Case 1: list (name1|name2) in parens
    if ( $decl =~ /^(ELEMENT\s+)(\(\s*(.*?)\s*\))(\s+)/s ) {
        # Save the pieces
        $lead = $1;
        # Save the raw string for output
        $namefield = $2;
        $rest = $4 . $' ;
        # Resolve all entities and remove whitespace
        my $resolved = &resolveall($3);
        $resolved =~ s/\s+//g;
        @names = split (/\|/, $resolved ) ;
    }
    elsif ( $decl =~ /(^ELEMENT\s+)(\S+)(\s+)/s ) {
        $lead = $1;
        $namefield = $2;
        $rest = $3 . $' ;
        my $resolved = &resolveall($2);
        # Is the resolved string a list?
        if ( $resolved =~ /\(\s*(.*?)\s*\)/s ) {
            $resolved = $1;
            $resolved =~ s/\s+//g;
            @names = split (/\|/, $resolved ) ;
        }
        else {
            # Else single name array
            @names = ($resolved);
        }
    }
    else {
        print STDERR "Badly formed element declaration: $decl\n";
        return;
    }


    # Process the declaration
    if ( $pass == 1 ) {
        # Only increment ElementDefCount once per declaration.
        my $oldcount = $ElementDefCount;

        for my $name (@names) {
            # strip spaces
            $name =~ s/\s*//gs;
            # Error if element name defined twice
            # Marked sections should prevent this.
            if ( grep /^$name$/, @ELEMENT ) {
               my $msg = "ERROR: element "
                         . $name
                         . " defined more than once, in "
                         . $ELEMENT{$name}->{file}
                         . " and "
                         . $Filename 
                         . ".\n" ;
               print STDERR $msg;
            }
            # Add to element list if not already there
            else {
                ++$ElementDefCount if ( $ElementDefCount == $oldcount);
                my $rec = {};
                $rec->{name} = $name;
                $rec->{file} = $Filename;
                $rec->{anchor} = 'ElementDef' . $ElementDefCount ;
                $rec->{address} = $label . $Basename
                                  . '.html#' . $rec->{anchor} ;
                # save the record
                $ELEMENT{$name} = $rec;
                push (@ELEMENT, $name);
            }
        }
    }
    # else pass 2
    else {
        # Build a new declaration from the pieces
        my $newdecl = $lead;

        $names[0] =~ s/\s*//gs;
        # All the names must be in the ELEMENT array.
        if ( grep /^$names[0]$/, @ELEMENT ) {
            # Add the anchor
            my $replace = "<A NAME=\""
                          . $ELEMENT{$names[0]}->{anchor}
                          . "\"></A>"
                          . "<STRONG>"
                          . &MakeLive($namefield, 'ELEMENT', \@names, 'NoElem')
                          . "</STRONG>" ;
            $newdecl .= $replace ;
        }
        else {
            # Error if not in the array.
            # Marked sections should prevent this.
            my $msg = "ERROR: element name "
                      . $names[0] 
                      . " in "
                      . $Filename
                      . " not declared.\n";
            print STDERR $msg;
            $newdecl .= $namefield;
        }
        # Now make the rest of it live and print the declaration
        $newdecl .= &MakeLive($rest, 'ELEMENT', \@names );
        print $Output "&lt;!", $newdecl, "&gt;" ;
    }
}

#######################################################
# ResolveExternalID -- Resolve an external identifier
#    If catalog specified, tries to resolve to readable pathname,
#    or returns  SYSTEM ID if available (not checked for 
#    readability), or returns an empty string.
#    If no catalog, just returns  SYSTEM ID if available (not checked for 
#    readability), or returns an empty string.
# 
sub ResolveExternalID {
    my $pubid = shift;
    my $sysid = shift;
    my $value = "";

    # Catalog has precedence, if used.
    if ( defined($catalog) ) {
        $value = $catalog->system_map($sysid) if $sysid;
        return($value) if ( -f $value);
        $value = $catalog->public_map($pubid) if $pubid;
        return($value) if ( -f $value);
        $value = $sysid if $sysid;
        return($value) if ( -f $value);
    }
    $value = $sysid if $sysid;
    return($value) 

}

#######################################################
# html -- Escape any special characters for HTML output
#
sub html {
    my $string = shift;

    $string =~ s/&/&amp;/sg;
    $string =~ s/</&lt;/sg;
    $string =~ s/>/&gt;/sg;

    return ($string);
}

#######################################################
# entityprint -- Print out a live entity definition
# 
sub entityprint {
    my $decl = shift;
    my $Filename = shift;
    my $Output = shift;
    my $name;
    my $lead;
    my $rest;
    my $newdecl;

    # If a parameter entity
    if ( $decl =~ /^(ENTITY\s+%\s+)($EntName)/ ) {
        $lead = $1;
        $name = $2;
        $rest = $';

        # Build a new declaration piece by piece
        $newdecl = $lead;

        # Check to see if this is the first instance, which becomes live.
        if ( grep /^$name$/, @PE ) {
           # If already live, just print.
           if ( $PE{$name}->{live} ) {
               $newdecl .= $name;
               print $Output "&lt;!",
                            $newdecl,
                            $rest,
                            "&gt;" ;
           }
           else {
               # Make it live
               $PE{$name}->{live} = 1;
               my $replace = "<A NAME=\""
                   . $PE{$name}->{anchor}
                   . "\"><STRONG>"
                   . $name
                   . "</STRONG></A>" ;
               $newdecl .= $replace ;
               print $Output "&lt;!",
                             $newdecl,
                             &MakeLive($rest, 'ENTITY', $name),
                             "&gt;" ;
           }
        }
        else {
            $newdecl .= $name;
            print $Output "&lt;!",
                         $newdecl,
                         $rest,
                         "&gt;" ;
        }
    }
    # Else some other kind of entity def.
    else {
        print $Output "&lt;!", &MakeLive($decl), "&gt;" ;
    }
}

#######################################################
# MakeLive -- Add HREFs to declaration
# 
sub MakeLive {
    my $string = shift;
    my $decltype = shift;
    my $declname = shift;
    my $mode = shift;

    # Defaults to blank
    $decltype = "" unless $decltype;
    $declname = "" unless $declname;
    $mode = "" unless $mode;

    # Escape any HTML markup
    $string = &html($string);

    # format parameter entity references
    while ($string =~ /(%($EntName)(;?))/s) {
        my $entityref = $1;
        my $name = $2;
        # Is this name in the array of entities?
        if ( grep /^$name$/, @PE ) {
            my $replace = "<A HREF=\"" 
               . $PE{$name}->{address}
               . "\">X52 ZZyG3"
               . $name ;
            $replace .= $3 if $3 eq ';' ;
            $replace .= "</A>";
            $string =~ s/$entityref/$replace/s ;

            # Generate record for usage tables
            if ( $usagetables && $declname && $decltype ) {
                &UsageTables($name, 'PE', $declname, $decltype);
            }
        }
        # else just hide it
        else {
            my $replace = "X52 ZZyG3$name";
            $replace .= $3 if $3 eq ';' ;
            $string =~ s/$entityref/$replace/s ;
        }
    }

    # format element references.
    # These are harder because they look like
    # ordinary words.  Don't format element names
    # if $mode is NoElem (in element name declarations)

    # Initialize
    my $rest = $string ;
    $string = "" ;

    # And rebuild the string piece by piece
    while( $mode ne 'NoElem' && $rest =~ /$ElemName/ ) {
        my $Match ;
        my $href;
        my $pre = $`;
        my $name = $&;
        my $post = $';


        # Don't enliven words inside any HTML tags
        if ( $pre =~ /</ ) {
            $string .= $pre . $name;
            $rest = $post;
            # And find the closing >
            $rest =~ />/;
            $string .= $` . $&;
            $rest = $';
            next;
        }

        # And don't enliven inside SGML -- comments --
        if ( $pre =~ /--/ && $ML eq 'SGML' ) {
            $string .= $pre . $name;
            $rest = $post;
            # And find the closing --
            $rest =~ /--/;
            $string .= $` . $&;
            $rest = $';
            next;
        }

        # Handle SGML element names, which are not case sensitive
        if ( $ML eq 'SGML' ) {
            if ( ( ($Match) = grep( /^$name$/i, @ELEMENT) )
                 && defined($ELEMENT{$Match}->{file}) ) {
                    $href = $ELEMENT{$Match}->{address};
            }
        }
        # Handle XML element names, which are case sensitive
        else {
            if ( ( ($Match) = grep( /^$name$/, @ELEMENT) )
                 && defined($ELEMENT{$name}->{file}) ) {
                    $href = $ELEMENT{$name}->{address};
            }
        }
        # If conditions satisfied, then format
        if ( $Match && $href ) {
            $string = $string . $pre . "<A HREF=\"$href\">" . $name . "</A>" ;
            # Generate record for usage tables
            if ( $usagetables && $declname && $decltype ) {
                &UsageTables($Match, 'ELEMENT', $declname, $decltype);
            }
        }
        else {
            $string = $string . $pre . $name ;
        }
        $rest = $post ;
    }
    $string = $string . $rest ;

    # Remove entity reference marker
    $string =~ s/X52 ZZyG3/%/sg ;
    # Now return the filtered string
    return($string);
}

#######################################################
# MakeFramework -- generate HTML frameset and TOC files
# 
sub MakeFramework {
    my $key;

    # Generate the main TOC rows as variable for insertion into
    # each of the three alpha list tables.

    my $maintoc = "<TR><TD><B>$title</B></TD></TR>\n";
    foreach $key ('FileList', 'ElemList', 'EntityList') {
        $maintoc .= "<TR><TD><A HREF=\""
                      . $label
                      . $key
                      . ".html"
                      . "\" TARGET=\"left\">"
                      . $ListTitle{$key}
                      . "</A></TD></TR>\n";
    }
    $maintoc .= "<TR><TD><HR></TD></TR>\n";

    # Generate the three alphabetical list files.
    # Elements
    open OUTFILE, "> $outdir/" . $label . "ElemList.html";
    print OUTFILE $DOCTYPE;
    print OUTFILE "<HTML>\n<HEAD>\n<TITLE>",
                  $title,
                  " Element list</TITLE>\n",
	     	  "<LINK REL=\"stylesheet\" TYPE=\"text/css\" HREF=\"livedtd.css\">\n",
                  "</HEAD>\n<BODY>\n";
    print OUTFILE "<TABLE CELLSPACING=0 CELLPADDING=0 ALIGN=left",
                  " BORDER=0 COLS=1>\n";
    print OUTFILE "$maintoc";
    print OUTFILE "<TR><TD><B>$ListTitle{'ElemList'}</B></TD></TR>\n";
    foreach $key ( sort { lc($a) cmp lc($b) } @ELEMENT) {
        my $rec = $ELEMENT{$key};
        print OUTFILE "<TR><TD>";
        if ($usagetables) {
            print OUTFILE "<A HREF=\"",
                          $label,
                          "ElemUsage.html#ELU",
                          $key,
                          "\" TARGET=\"right\">",
                          $UsageSymbol,
                          "</A>&nbsp;";
        }
        print OUTFILE "<A HREF=\"",
                      $rec->{address},
                      "\" TARGET=\"right\">$key</A></TD></TR>\n";
    }
    print OUTFILE "</TABLE>\n</BODY>\n</HTML>\n";
    close OUTFILE;

    # Entities
    open OUTFILE, "> $outdir/" . $label . "EntityList.html";
    print OUTFILE $DOCTYPE;
    print OUTFILE "<HTML>\n<HEAD>\n<TITLE>",
                  $title,
                  " Entity list</TITLE>\n",
	     	  "<LINK REL=\"stylesheet\" TYPE=\"text/css\" HREF=\"livedtd.css\">\n",
                  "</HEAD>\n<BODY>\n";
    print OUTFILE "<TABLE CELLSPACING=0 CELLPADDING=0 ALIGN=left",
                  " BORDER=0 COLS=1>\n";
    print OUTFILE "$maintoc";
    print OUTFILE "<TR><TD><B>$ListTitle{'EntityList'}</B></TD></TR>\n";
    foreach $key ( sort { lc($a) cmp lc($b) } @PE) {
        my $rec = $PE{$key};
        print OUTFILE "<TR><TD>";
        if ($usagetables) {
            print OUTFILE "<A HREF=\"",
                          $label,
                          "EntityUsage.html#PEU",
                          $key,
                          "\" TARGET=\"right\">",
                          $UsageSymbol,
                          "</A>&nbsp;";
        }
        print OUTFILE "<A HREF=\"",
                      $rec->{address},
                      "\" TARGET=\"right\">$key</A></TD></TR>\n";
    }
    print OUTFILE "</TABLE>\n</BODY>\n</HTML>\n";
    close OUTFILE;

    # Files in order of appearance
    open OUTFILE, "> $outdir/" . $label . "FileList.html";
    print OUTFILE $DOCTYPE;
    print OUTFILE "<HTML>\n<HEAD>\n<TITLE>",
                  $title,
                  " File list</TITLE>\n",
	     	  "<LINK REL=\"stylesheet\" TYPE=\"text/css\" HREF=\"livedtd.css\">\n",
                  "</HEAD>\n<BODY>\n";
    print OUTFILE "<TABLE CELLSPACING=0 CELLPADDING=0 ALIGN=left",
                  " BORDER=0 COLS=1>\n";
    print OUTFILE "$maintoc";
    print OUTFILE "<TR><TD><B>$ListTitle{'FileList'}</B></TD></TR>\n";
    foreach $key (0 .. $#Files) {
        print OUTFILE "<TR><TD><A HREF=\"",
                      "$label",
                      basename($Files[$key]),
                      ".html",
                      "\" TARGET=\"right\">",
                      basename($Files[$key]),
                      "</A></TD></TR>\n";
    }
    print OUTFILE "</TABLE>\n</BODY>\n</HTML>\n";
    close OUTFILE;

    # And generate the framework file
    open OUTFILE, "> $outdir/" . $label . "index.html";
    print OUTFILE "<HTML>\n<HEAD>\n<TITLE>",
                  "LiveDTD: ",
                  $title,
                  "</TITLE>\n",
                  "<META name=\"generator\" content=\"livedtd.pl\">\n",
                  "<META name=\"source\" content=\"http://www.sagehill.net\">\n",
                  "</HEAD>\n";
    print OUTFILE "<FRAMESET COLS=\"20%,80%\">\n",
                  "    <FRAME SRC=\"",
                  $label,
                  "ElemList.html\" NAME=\"left\">\n",
                  "    <FRAMESET FRAMEBORDER=NO ROWS=\"7%,*\">\n",
                  "        <FRAME SRC=\"\" SCROLLING=AUTO NAME=\"file\">\n",
                  "        <FRAME SRC=\"",
                  $label . basename($MainDTD),
                  ".html\" NAME=\"right\">\n",
                  "    </FRAMESET>\n",
                  "    <NOFRAMES>\n",
                  "    This version requires a frames-based browser.\n",
                  "    </NOFRAMES>\n",
                  "</FRAMESET>\n",
                  "</HTML>\n";
    close OUTFILE;

    # Generate the stylesheet file
    open OUTFILE, "> $outdir/" . "livedtd.css";
    print OUTFILE "PRE { font-family: monospace; }\n";
    close OUTFILE;
}

#######################################################
# UsageTables -- Add a line item to a usage table
#   Usage: UsageTables($name, $utype, $declname, $decltype);
#       $name being used 
#       $utype - item type being used (PE or ELEMENT)
#       $declname - which declaration is using it
#       $decltype - type of declaration using the name
#                    ELEMENT | ENTITY | ATTLIST | MS (marked section)
sub UsageTables {
    my $uname = shift;
    my $utype = shift;
    my $declname = shift;
    my $decltype = shift;

    # If usage is a parameter entity
    if ( $utype eq 'PE' ) {
        # Is there already some usage encountered?
        unless ( grep /^$uname$/, @PEUsage ) {
            # Start a new PE usage record
            my $rec = {};
            $rec->{name} = $uname;
            $rec->{elemusage} = ();
            $rec->{peusage} = ();
            $rec->{'attusage'} = ();
            $rec->{'msusage'} = ();
    
            # Attach this set of arrays to this PE name
            $PEUsage{$uname} = $rec;
            # Keep track of which names have been used
            push ( @PEUsage, $uname);
        }
        # And add the data to the record
        if ($decltype eq 'ELEMENT') {
            # names are an array reference
            foreach my $i (@$declname) {
                push @{$PEUsage{$uname}->{elemusage}}, $i;
            }
        }
        elsif ($decltype eq 'ENTITY') {
            push @{$PEUsage{$uname}->{peusage}}, $declname;
        }
        elsif ($decltype eq 'ATTLIST') {
            # names are an array reference
            foreach my $i (@$declname) {
                push @{$PEUsage{$uname}->{'attusage'}}, $i;
            }
        }
        # Marked section usage handled at MS 
    }
    elsif ( $utype eq 'ELEMENT' ) {
        # Is there already some usage encountered?
        unless ( grep /^$uname$/, @ElemUsage ) {
            # Start a new element usage record
            my $rec = {};
            $rec->{name} = $uname;
            $rec->{elemusage} = ();
            $rec->{peusage} = ();
            $rec->{'attusage'} = ();
            $rec->{'msusage'} = ();
    
            # Attach this set of arrays to this element name
            $ElemUsage{$uname} = $rec;
            # Keep track of which names have been used
            push ( @ElemUsage, $uname);
        }
        # And add the data to the record
        if ($decltype eq 'ELEMENT') {
            # names are an array reference
            foreach my $i (@$declname) {
                push @{$ElemUsage{$uname}->{elemusage}}, $i;
            }
        }
        elsif ($decltype eq 'ENTITY') {
            push @{$ElemUsage{$uname}->{peusage}}, $declname;
        }
        elsif ($decltype eq 'ATTLIST') {
            # names are an array reference
            foreach my $i (@$declname) {
                push @{$ElemUsage{$uname}->{'attusage'}}, $i;
            }
        }
    }
}

#######################################################
# GenerateUsageTables -- Generate the usage tables
#   
sub GenerateUsageTables {
    my $declname;
    my $usagename;

    # Generate the three alphabetical usage files.
    # Elements
    open OUTFILE, "> $outdir/" . $label . "ElemUsage.html";
    # Code to print title above right frame
    my $onload = "parent.file.document.open();"
                  . "parent.file.document.write("
                  . "'<BODY TOPMARGIN=0><B>"
                  . $ListTitle{ElemUsage}
                  . "</B></BODY>');" 
                  . "parent.file.document.close()";

    print OUTFILE $DOCTYPE
                  . "<HTML>\n<HEAD>\n<TITLE>"
                  . "$title $ListTitle{ElemUsage}</TITLE>\n"
	     	  . "<LINK REL=\"stylesheet\" TYPE=\"text/css\" HREF=\"livedtd.css\">\n"
		  . "</HEAD>\n"
                  . "<BODY onLoad=\"$onload\">\n"
                  . "<H2>$ListTitle{ElemUsage}</H2>\n";

    # Output a <PRE> usage list for each declared element
    foreach $declname ( sort { lc($a) cmp lc($b) } @ELEMENT) {
        # Get its record of data
        my $rec = $ELEMENT{$declname};
        # Start this element
        print OUTFILE "<HR><SPAN class=\"usage\"><B><A HREF=\"",
                      $rec->{address},
                      "\" TARGET=\"right\"",
                      " NAME=\"ELU",
                      $declname,
                      "\"><CODE>$declname</CODE></A>",
                      " element seen in:</B></SPAN><PRE>\n";
        # Now sorted list of its usage in other element declarations
        if ( defined $ElemUsage{$declname}->{'elemusage'} ) {
            foreach $usagename ( sort {lc($a) cmp lc ($b)}
                                 @{$ElemUsage{$declname}->{'elemusage'}} ) {
                print OUTFILE "   !ELEMENT <A HREF=\"",
                      $ELEMENT{$usagename}->{'address'},
                      "\">",
                      $usagename,
                      "</A>\n";
            }
        }
        # Now sorted list of its usage in parameter entity declarations
        if ( defined $ElemUsage{$declname}->{'peusage'} ) {
            foreach $usagename ( sort {lc($a) cmp lc ($b)}
                                 @{$ElemUsage{$declname}->{'peusage'}} ) {
                print OUTFILE "   !ENTITY % <A HREF=\"",
                      $PE{$usagename}->{'address'},
                      "\">",
                      $usagename,
                      "</A>\n";
            }
        }
        # Now sorted list of its usage in ATTLIST declarations
        if ( defined $ElemUsage{$declname}->{'attusage'} ) {
            foreach $usagename ( sort {lc($a) cmp lc ($b)}
                                 @{$ElemUsage{$declname}->{'attusage'}} ) {
                print OUTFILE "   !ATTLIST <A HREF=\"",
                      $ATTLIST{$usagename}->{'address'},
                      "\">",
                      $usagename,
                      "</A>\n";
            }
        }
        print OUTFILE "</PRE>\n";
    }
    # Pad bottom so #scrolls always show at top of frame
    print OUTFILE "<PRE>\n"
                  . "\n" x 40 
                  . "</PRE>\n"
                  . "</BODY>\n</HTML>\n";
    close OUTFILE;

    # Parameter entities
    open OUTFILE, "> $outdir/" . $label . "EntityUsage.html";

    # Code to print title above right frame
    $onload = "parent.file.document.open();"
                  . "parent.file.document.write("
                  . "'<BODY TOPMARGIN=0><B>"
                  . $ListTitle{EntityUsage}
                  . "</B></BODY>');" 
                  . "parent.file.document.close()";

    print OUTFILE $DOCTYPE
                  . "<HTML>\n<HEAD>\n<TITLE>"
                  . "$title "
                  . $ListTitle{EntityUsage}
                  . "</TITLE>\n"
	     	  . "<LINK REL=\"stylesheet\" TYPE=\"text/css\" HREF=\"livedtd.css\">\n"
		  . "</HEAD>\n"
                  . "<BODY onLoad=\"$onload\">\n"
                  . "<H2>"
                  . $ListTitle{EntityUsage}
                  . "</H2>\n";

    # Output a <PRE> usage list for each declared PE
    foreach $declname ( sort { lc($a) cmp lc($b) } @PE) {
        # Get its record of data
        my $rec = $PE{$declname};
        # Start this element
        print OUTFILE "<HR><SPAN class=\"usage\"><B><A HREF=\"",
                      $rec->{address},
                      "\" TARGET=\"right\"",
                      " NAME=\"PEU",
                      $declname,
                      "\"><CODE>%$declname;</CODE></A>",
                      " seen in:</B></SPAN><PRE>\n";
        # Now sorted list of its usage in other element declarations
        if ( defined $PEUsage{$declname}->{'elemusage'} ) {
            foreach $usagename ( sort {lc($a) cmp lc ($b)}
                                 @{$PEUsage{$declname}->{'elemusage'}} ) {
                print OUTFILE "   !ELEMENT <A HREF=\"",
                      $ELEMENT{$usagename}->{'address'},
                      "\">",
                      $usagename,
                      "</A>\n";
            }
        }
        # Now sorted list of its usage in parameter entity declarations
        if ( defined $PEUsage{$declname}->{'peusage'} ) {
            foreach $usagename ( sort {lc($a) cmp lc ($b)}
                                 @{$PEUsage{$declname}->{'peusage'}} ) {
                print OUTFILE "   !ENTITY % <A HREF=\"",
                      $PE{$usagename}->{'address'},
                      "\">",
                      $usagename,
                      "</A>\n";
            }
        }

        # Now sorted list of its usage in ATTLIST declarations
        if ( defined $PEUsage{$declname}->{'attusage'} ) {
            foreach $usagename ( sort {lc($a) cmp lc($b)}
                                 @{$PEUsage{$declname}->{'attusage'}} ) {
                print OUTFILE "   !ATTLIST <A HREF=\"",
                      $ATTLIST{$usagename}->{'address'},
                      "\">",
                      $usagename,
                      "</A>\n";
            }
        }
        # Now sorted list of its usage in Marked Section declarations
        if ( defined $PEUsage{$declname}->{'msusage'} ) {
            foreach $usagename ( sort {lc($a) cmp lc ($b)}
                                 @{$PEUsage{$declname}->{'msusage'}} ) {
                print OUTFILE "   Marked Section <A HREF=\"",
                      $usagename,
                      "\">",
                      "status keyword",
                      "</A>\n";
            }
        }
        print OUTFILE "</PRE>\n";
    }
    # Pad bottom so #scrolls always show at top of frame
    print OUTFILE "<PRE>\n"
                  . "\n" x 40 
                  . "</PRE>\n"
                  . "</BODY>\n</HTML>\n";
    close OUTFILE;
}

#######################################################
# attlistprint -- Print an ATTLIST declaration
#   
sub attlistprint {
    my $decl = shift;
    my $Filename = shift;
    my $Output = shift;
    my @names;
    my $namefield;
    my $rest;
    my $lead;

    my $Basename = basename($Filename);

    # ATTLIST name may contain list or parameter entity.
    # Case 1: list (name1|name2) in parens
    if ( $decl =~ /^(ATTLIST\s+)(\(\s*(.*?)\s*\))(\s+)/si ) {
        # Save the pieces
        $lead = $1;
        # Save the raw string for output
        $namefield = $2;
        $rest = $4 . $' ;
        # Resolve all entities and remove whitespace
        my $namelist = resolveall($3);
        $namelist =~ s/\s+//g;
        @names = split (/\|/, $namelist ) ;
    }
    elsif ( $decl =~ /(^ATTLIST\s+)(\S+)(\s+)/si ) {
        $lead = $1;
        $namefield = $2;
        $rest = $3 . $' ;
        my $resolved = &resolveall($2);
        # Is the resolved string a list?
        if ( $resolved =~ /\(\s*(.*?)\s*\)/s ) {
            $resolved = $1;
            $resolved =~ s/\s+//g;
            @names = split (/\|/, $resolved) ;
        }
        else {
            # Else single name
            @names = ($resolved);
        }
    }
    else {
        print STDERR "Badly formed ATTLIST declaration: $decl\n";
        return;
    }


    # Process the declaration
    if ( $pass == 1 ) {
        # Only increment AttlistDefCount once per declaration.
        my $oldcount = $AttlistDefCount;

        for my $name (@names) {
            # strip spaces
            $name =~ s/\s*//gs;
            # Error if element name defined twice
            # Marked sections should prevent this.
            if ( $ML eq 'SGML' && grep /^$name$/, @ATTLIST ) {
               my $msg = "ERROR: ATTLIST "
                         . $name
                         . " defined more than once, in "
                         . $ATTLIST{$name}->{file}
                         . " and "
                         . $Filename 
                         . ".\n" ;
               print STDERR $msg;
            }
            # Add to attlist list if not already there
            else {
                ++$AttlistDefCount if ( $AttlistDefCount == $oldcount);
                my $rec = {};
                $rec->{name} = $name;
                $rec->{file} = $Filename;
                $rec->{anchor} = 'AttlistDef' . $AttlistDefCount ;
                $rec->{address} = $label . $Basename
                                  . '.html#' . $rec->{anchor} ;
                # save the record
                $ATTLIST{$name} = $rec;
                push (@ATTLIST, $name);
            }
        }
    }
    # else pass 2
    else {
        # Build a new declaration from the pieces
        my $newdecl = $lead;

        $names[0] =~ s/\s*//gs;
        # All the names must be in the ATTLIST array.
        if ( grep /^$names[0]$/, @ATTLIST ) {
            # Add the anchor
            my $replace = "<A NAME=\""
                          . $ATTLIST{$names[0]}->{anchor}
                          . "\"></A>"
                          . "<STRONG>"
                          . &MakeLive($namefield, 'ATTLIST', \@names, 'NoElem')
                          . "</STRONG>" ;
            $newdecl .= $replace ;
        }
        else {
            # Error if not in the array.
            # Marked sections should prevent this.
            my $msg = "ERROR: ATTLIST name "
                      . $names[0] 
                      . " in "
                      . $Filename
                      . " not declared.\n";
            print STDERR $msg;
            $newdecl .= $namefield;
        }
        # 
        # Now make the rest of it live and print the declaration.
        # Use NoElem mode since ATTLISTs don't contain elements
        # but some names may match element names.
        $newdecl .= &MakeLive($rest, 'ATTLIST', \@names, 'NoElem' );
        print $Output "&lt;!", $newdecl, "&gt;" ;
    }
}
