use strict;
use warnings;
use Test::Requires 'DBD::SQLite';
use Test::More;
use t::Util;
use DBIx::QueryLog;

my $dbh = t::Util->new_dbh;

DBIx::QueryLog->filter(sub {
  my ($sql) = @_;
  return $sql =~ m/\bupdate\b/i;
});

my $matched = capture {
    $dbh->do('SELECT * FROM sqlite_master');
};
is $matched, undef;

DBIx::QueryLog->reset_filter;

my $not_matched = capture {
    $dbh->do('SELECT * FROM sqlite_master');
};
like $not_matched, qr/SELECT \* FROM sqlite_master/, 'SQL';

done_testing;
