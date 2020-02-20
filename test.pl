#!/usr/bin/perl
 
# use strict;
# use Jcode;
use CGI;
use LWP::UserAgent;
use LWP::Protocol::http;
use JSON qw( decode_json );   

# From CPAN


my $canSendMail = 0;
my $secret_key = '';
my $url = 'https://www.google.com/recaptcha/api/siteverify';

my $cgi = CGI->new();
my $ua = LWP::UserAgent->new(
ssl_opts => { verify_hostname => 0 },
    protocols_allowed => ['https']
);
my $recaptcha_response = $cgi->param('g-recaptcha-response');
my $remote_ip = $ENV{REMOTE_ADDR};
my $response = $ua->post(
	    $url,
	      {
	        remoteip => $remote_ip,
	        response => $recaptcha_response,
	        secret => $secret_key,
	    },
 );
 if ( $response->is_success() ) {
        my $json = $response->decoded_content();
        my $out = decode_json($json);
       	if ( $out->{'success'} ) {
        # send mail
     }else{
         &verifyerror
     }
}else{
    &verifyerror
}

sub verifyerror{
	print "Content-type: text/html\n\n";
	print "<html>\n";
	print "\t<head>\n";
	print "\t\t<title>Verification Error</title>\n";
	print "\t</head>\n";
	print "\t<body>\n";
	print "\t\t<h1>Verification Error</h1>\n";
	print "\t\t<p>Please complete reCAPTCHA Verification</p>\n";
	print "</body></html>\n";
}

