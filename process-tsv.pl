#!/usr/bin/perl

use strict;
use Text::CSV qw(csv);

my $csv=Text::CSV->new({sep_char => "\t", quote_space => 0});

# optional: define how to print undefined fields
#$csv->undef_str ('--');
#$csv->undef_str ('N/A');
$csv->undef_str ('""');

# get header line, split into an arrayref called $cols
my $cols = $csv->getline(*ARGV);

# get first data row, extract headers & data from metadata field
my $row = $csv->getline(*ARGV);

# The following line assumes that the metadata in the FIRST data row
# contains ALL of the metadata fields in the exact order you want them
# included in the output.
#
my $md_headers = extract_metadata_headers($$row[4]);
#
# If this is not the case, then delete the extract_metadata_headers
# subroutine and define the metadata fields manually with something
# like:
#
#my $md_headers = [
#  'ID', 'Name', 'Title', 'Cell group', 'source_name',
#  'biomaterial_provider', 'lab', 'lab description', 'datatype',
#  'datatype description', 'cell organism', 'cell description',
#  'cell karyotype', 'cell lineage', 'cell sex',
#  'antibody antibodydescription'
#];
# This defines both the extra metadata headers **and** the order
# that they will be included in each output row.

# extract the data from the metadata field
my $md_data = extract_metadata($$row[4]);

# replace the metadata header in $cols aref with the md headers
splice @$cols,4,1,@$md_headers;

# replace the metadata field in $row aref with the md fields
splice @$row,4,1,@$md_data;

# print the updated header line and the first row of data
$csv->say(*STDOUT,$cols);
$csv->say(*STDOUT,$row);

# main loop: extract and print the rest of the data
while (my $row = $csv->getline(*ARGV)) {
  my $md_data = extract_metadata($$row[4]);
  splice @$row,4,1,@$md_data;

  $csv->say(*STDOUT,$row);
}

###
### subroutines
###

sub extract_metadata_headers {
  my $md = clean_metadata(shift);
  my @metadata = split /;/, $md;
  my @headers=();

  foreach (@metadata) {
    next if m/^\s*$/; # skip empty metadata
    my ($key,$val) = split /=/;
    push @headers, $key;
  };

  return \@headers;
};

sub extract_metadata {
  my $md = clean_metadata(shift);
  my @metadata = split /;/, $md;
  my %data=();

  foreach (@metadata) {
    next if m/^\s*$/; # skip empty metadata
    my ($key,$val) = split /=/;
    $data{$key} = $val;
  };

  return [@data{@$md_headers}];
};

sub clean_metadata {
    my $md = shift;
    $md =~ s/%(\d\d)/chr hex $1/eg; # decode %-encoded spaces etc.
    $md =~ s/<[^>]*>//g;            # remove HTML stuff like <br>
    return $md;
};
