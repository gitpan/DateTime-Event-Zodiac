# ============================================================================
package DateTime::Event::Zodiac;
# ============================================================================
use strict;
use warnings;
use utf8;

use Exporter::Lite;
use DateTime;
use DateTime::Util::Astro::Sun qw(solar_longitude);

use vars qw($VERSION @EXPORT @EXPORT_OK @ZODIAC);
$VERSION = '1.01';
@EXPORT = qw();
@EXPORT_OK = qw(zodiac_date_name zodiac_date_symbol zodiac_astro_name zodiac_astro_symbol zodiac_date zodiac_astro);

@ZODIAC = (
    {
        name    => 'aries',
        symbol  => '♈',
        #symbol  => "\x{2648}",
        start   => '21.03',
        end     => '20.04',
    },
    {
        name    => 'taurus',
        symbol  => '♉',
        #symbol  => "\x{2649}",
        start   => '21.04',
        end     => '20.05',
    },
    {
        name    => 'gemini',
        symbol  => '♊',
        #symbol  => "\x{264a}",
        start   => '21.05',
        end     => '21.06',
    },
    {
        name    => 'cancer',
        symbol  => '♋',
        #symbol  => "\x{264b}",
        start   => '22.06',
        end     => '22.07',
    },
    {
        name    => 'leo',
        symbol  => '♌',
        #symbol  => "\x{264c}",
        start   => '23.07',
        end     => '23.08',
    },
    {
        name    => 'virgo',
        symbol  => '♍',
        #symbol  => "\x{264d}",
        start   => '24.08',
        end     => '22.09',
    },
    {
        name    => 'libra',
        symbol  => '♎',
        #symbol  => "\x{264e}",
        start   => '23.09',
        end     => '22.10',
    },
    {
        name    => 'scorpius',
        symbol  => '♏',
        #symbol  => "\x{264f}",
        start   => '23.10',
        end     => '21.11',
    },
    {
        name    => 'sagittarius',
        symbol  => '♐',
        #symbol  => "\x{2650}",
        start   => '22.11',
        end     => '21.12',
    },
    {
        name    => 'capricornus',
        symbol  => '♑',
        #symbol  => "\x{2651}",
        start   => '22.12',
        end     => '19.01',
    },
    {
        name    => 'aquarius',
        symbol  => '♒',
        #symbol  => "\x{2652}",
        start   => '20.01',
        end     => '18.02',
    },
    {
        name    => 'pisces',
        symbol  => '♓',
        #symbol  => "\x{2653}",
        start   => '19.02',
        end     => '20.03',
    },
);

=pod

=head1 NAME

DateTime::Event::Zodiac - Return zodiac for a given date

=head1 SYNOPSIS

  use DateTime::Event::Zodiac qw(zodiac_date_name zodiac_date_symbol zodiac_astro_name zodiac_astro_symbol);
  
  my $dt = DateTime->new( 
       year   => 1979,
       month  => 3,
       day    => 27,
  );

  print zodiac_date_name($dt);
  print zodiac_astro_symbol($dt);
  
Returns the latin zodiac name or alternatively the unicode zodiac symbol
for the given date. The zodiac may be calculated using either fixed dates or 
using the longitude/position of the sun.

The module exports no symbols by default. All used functions must be requested
in the use statement. 

All methods return undef on failiure.
  
=head1 DESCRIPTION

=head2 zodiac_date_name

 $name = zodiac_date_name($dt);
 
Latin zodiac name: aries, taurus, gemini, ...
Fixed dates.

=head2 zodiac_date_symbol

 $symbol = zodiac_date_symbol($dt);
 
Unicode zodiac symbol positions U+2648 to U+2653
Fixed dates.

=head2 zodiac_astro_name

 $name = zodiac_astro_name($dt);
 
Latin zodiac name: aries, taurus, gemini, ...
Calculated from the longitude/position of the sun. 

=head2 zodiac_astro_symbol

 $symbol = zodiac_astro_symbol($dt);
 
Unicode zodiac symbol positions U+2648 to U+2653
Calculated from the longitude/position of the sun.

=head2 zodiac_date

Simply computes the zodiac from the date and returns a hash with the keys
name, symbol, start and end.

Used internally by C<zodiac_date_name> and C<zodiac_date_symbol>

=head2 zodiac_astro

Computes the zodiac from the position of the sun and returns a hash with the 
keys name, symbol, start and end. The keys start and end should be ignored
since they are used for the C<zodiac_date> function.

May differ from the results of C<zodiac_date> depending on the solar year
(leap year ect). 

See L<DateTime::Util::Astro::Sun> for notes on accuracy. If computed 
accurately enough this module should be also able to get the correct zodiac
for the exact time of birth.

Used internally by C<zodiac_astro_name> and C<zodiac_astro_symbol>
  
=cut

# ----------------------------------------------------------------------------
sub zodiac_date_name
# ----------------------------------------------------------------------------
{
    my $datetime = shift;
    my $zodiac = zodiac_date($datetime);
    return defined $zodiac ? $zodiac->{name}:undef;
}

# ----------------------------------------------------------------------------
sub zodiac_date_symbol
# ----------------------------------------------------------------------------
{
    my $datetime = shift;
    my $zodiac = zodiac_date($datetime);
    return defined $zodiac ? $zodiac->{symbol}:undef;
}

# ----------------------------------------------------------------------------
sub zodiac_astro_name
# ----------------------------------------------------------------------------
{
    my $datetime = shift;
    my $zodiac = zodiac_astro($datetime);
    return defined $zodiac ? $zodiac->{name}:undef;
}

# ----------------------------------------------------------------------------
sub zodiac_astro_symbol
# ----------------------------------------------------------------------------
{
    my $datetime = shift;
    my $zodiac = zodiac_astro($datetime);
    return defined $zodiac ? $zodiac->{symbol}:undef;
}

# ----------------------------------------------------------------------------
sub zodiac_date
# ----------------------------------------------------------------------------
{
    my $date = shift;

    die('Must specify a DateTime object') unless (defined $date 
        && ref($date)
        && $date->isa('DateTime'));

    # Loop all zodiacs
    foreach my $zodiac (@ZODIAC) {
        my $start = _convertdate($zodiac->{start},$date->year);
        my $end = _convertdate($zodiac->{end},$date->year);
        
        next unless defined $start && defined $end;
        
        # Special case: Zodiac spans new year
        if ($start->month > $end->month) {
            # Check zodiac for past year
            $start->set(year => $start->year -1);
            return $zodiac if ($date >= $start && $date <= $end);
            # Reset and search current year too
            $start->set(year => $start->year +1);
            $end->set(year => $end->year + 1);
        }
        
        # Check zodiac
        return $zodiac if ($date >= $start && $date <= $end);    

    }
    return undef;
}

# ----------------------------------------------------------------------------
sub zodiac_astro
# ----------------------------------------------------------------------------
{
    my $date = shift;

    die('Must specify a DateTime object') unless (defined $date 
        && ref($date)
        && $date->isa('DateTime'));

    # Get longitude (0-360) for given DateTime object
    my $longitude = solar_longitude($date);
    
    return undef unless defined $longitude;
    
    # Return the zodiac
    return $ZODIAC[int($longitude / 30)];
}

# ----------------------------------------------------------------------------
sub _convertdate
# ----------------------------------------------------------------------------
{
    my $date = shift;
    my $year = shift;
    if ($date =~ m/^(\d\d)\.(\d\d)$/) {
        my $dt = DateTime->new(
            month  => $2,
            day    => $1,
            year   => $year,
        );
        return $dt;
    }
    return undef;
}

1;

=head1 DISCLAIMER  

The author of this module regads astrology as being a pseudoscience and 
superstition. I wrote this module for my job. I was young, foolish and 
I needed the money.

=head1 TODO

The C<zodiac_astro_horoscope> and C<zodiac_date_horoscope> functions have not 
yet been implemented ;-)

=head1 SUPPORT

Please report any bugs or feature requests to 
C<datetime-event-zodiac@rt.cpan.org>, or through the web interface at 
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically be 
notified of progress on your bug as I make changes.

=head1 AUTHOR

    Maroš Kollár
    CPAN ID: MAROS
    maros [at] k-1.com
    L<http://www.k-1.com>

=head1 COPYRIGHT

DateTime::Event::Zodiac is Copyright (c) 2006,2007 Maroš. Kollár.
All rights reserved.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut