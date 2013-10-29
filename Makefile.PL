
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
    "Browser::Open" => 0,
    "Carp" => 0,
    "Cwd" => 0,
    "DBIx::Class::Core" => 0,
    "DBIx::Class::Schema" => 0,
    "Data::Validate::URI" => "0.06",
    "DateTime" => 0,
    "DateTime::Format::SQLite" => 0,
    "EBook::EPUB" => "0.6",
    "EBook::MOBI" => "0.65",
    "Email::MIME" => "1.924",
    "Email::Sender::Simple" => "1.300006",
    "Email::Simple" => 0,
    "Email::Simple::Creator" => 0,
    "Encode" => 0,
    "Exporter" => 0,
    "File::Basename" => 0,
    "File::Copy" => 0,
    "File::HomeDir" => 0,
    "File::MMagic" => "1.30",
    "File::Slurp" => 0,
    "File::Temp" => 0,
    "Getopt::Lucid" => "1.05",
    "HTML::Element" => 0,
    "HTML::Entities" => 0,
    "HTML::ExtractMain" => "0.63",
    "HTML::TreeBuilder" => 0,
    "HTTP::CookieJar" => 0,
    "HTTP::Tiny" => 0,
    "IO::All" => 0,
    "IO::Interactive" => 0,
    "Module::Find" => "0.11",
    "Moo" => "1.003000",
    "Moo::Role" => 0,
    "Pod::Find" => 0,
    "Pod::Html" => 0,
    "SQL::Translator" => 0,
    "Term::Prompt" => "1.04",
    "Text::Markdown" => 0,
    "Try::Tiny" => 0,
    "base" => 0,
    "strict" => 0,
    "utf8" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "File::Spec" => 0,
    "IO::Handle" => 0,
    "IPC::Open3" => 0,
    "Test::DBIx::Class::Schema" => 0,
    "Test::More" => 0,
    "Test::Most" => 0,
    "Test::Output" => 0
  },
  "VERSION" => "0.012",
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



