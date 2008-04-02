# -*- perl -*-

# t/004_podcoverage.t - check function

use Test::More tests => 20;
use DateTime;
use DateTime::Event::Zodiac qw(zodiac_date_name zodiac_date_symbol zodiac_astro_name zodiac_astro_symbol);

my @data = (
    [10 , 10, 2000, 'libra', 'libra'],
    [31 , 12, 2000, 'capricornus', 'capricornus'],
    [1 , 1, 2000, 'capricornus', 'capricornus'],
    [19 , 1, 2000,, 'capricornus', 'capricornus'],
    [20 , 1, 2000, 'aquarius', 'capricornus'],
    [4 , 6, 2000, 'gemini', 'gemini'],
    [11 , 10, 1977, 'libra', 'libra'],
    [30 , 6, 1978, 'cancer', 'cancer'],
    [26 , 2, 1976, 'pisces', 'pisces'],
    [27 , 03, 1979, 'aries', 'aries'],
);

foreach (@data) {
    my $dt = DateTime->new( 
        year   => $_->[2],
        month  => $_->[1],
        day    => $_->[0]
    );
    is(zodiac_date_name($dt),$_->[3],$dt->dmy.' '.$_->[3]);
    is(zodiac_astro_name($dt),$_->[4],$dt->dmy.' '.$_->[4]);
}