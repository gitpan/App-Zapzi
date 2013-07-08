
use strict;
use warnings;

use 5.010;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "a tool to store articles and publish them as eBooks to read later",
  "AUTHOR" => "Rupert Lane <rupert\@rupert-lane.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "App-Zapzi",
  "EXE_FILES" => [
    "bin/zapzi"
  ],
  "LICENSE" => "perl",
  "NAME" => "App::Zapzi",
  "PREREQ_PM" => {
    "Carp" => 0,
    "DBIx::Class::Core" => 0,
    "DBIx::Class::Schema" => 0,
    "DateTime" => 0,
    "DateTime::Format::SQLite" => 0,
    "EBook::MOBI" => 0,
    "Encode" => 0,
    "Exporter" => 0,
    "File::HomeDir" => 0,
    "File::MMagic" => 0,
    "Getopt::Lucid" => 0,
    "HTML::Element" => 0,
    "HTML::Entities" => 0,
    "HTML::ExtractMain" => 0,
    "HTTP::CookieJar" => 0,
    "HTTP::Tiny" => 0,
    "Moo" => 0,
    "SQL::Translator" => 0,
    "Text::Markdown" => 0,
    "base" => 0,
    "strict" => 0,
    "utf8" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "Test::DBIx::Class::Schema" => 0,
    "Test::More" => 0,
    "Test::Most" => 0,
    "Test::Output" => 0
  },
  "VERSION" => "0.003",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



