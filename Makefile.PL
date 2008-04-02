

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'DateTime::Event::Zodiac',
    VERSION_FROM => 'lib/DateTime/Event/Zodiac.pm', # finds \$VERSION
    AUTHOR       => 'Maros Kollar (maros [at] k-1.com)',
    ABSTRACT     => 'Return zodiac for a given date',
    NO_META      => 1,
    PREREQ_PM    => {
                     'Test::Pod' => 0,
                     'Test::More' => 0,
                     'Test::Pod::Coverage' => 0,
                     'DateTime' => 0,
                     'DateTime::Util::Astro' => 0,
                    },
);
