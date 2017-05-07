#!/usr/bin/env perl

#
# java のインストールと screen のインストールが必要です
#

use Switch;

my $MEMORY="1024M";
my $FILE  ="minecraft_server.1.11.2.jar";
my $SCNAME="minecraft"; #screen name

#java -Xms${MEMORY} -Xmx${MEMORY} -Dhttp.proxyHost=${PROXYHOST} -Dhttp.proxyPort=${PROXYPORT} -jar Minecraft.jar
#my $EVAL='stuff "'.$cmd.'"\015';
#  "screen -p 0 -S minecraft -X eval 'stuff " $cmd \015"'

&main;

sub main
{
	print "[Minecraft_CMD] >>> ";
	while(<STDIN>){
		chomp($_);
		switch("$_"){
			case "start"    {&start;sleep(20);}
			case "stop"     {&stop;}
			case "gamerule" {&grule;}
			case "bash"     {&bash;}
			case "ps"       {&top;}
			case "help"     {&help;}
			case "exit"     {exit 1;}
			else            {&mc_cmd("$_");}
		}
		
		print "[Minecraft_CMD] >>> ";
	}
}


sub mc_cmd
{
	#my $func="mc_cmd";
	my $cmd=shift(@_);
	#print "$func - $cmd \n";
	my $EVAL='stuff "'.$cmd.'"\015';
	system("screen -p 0 -S $SCNAME -X eval \'$EVAL\'");
}

sub start
{
	print "$_ function\n";
	system("screen -AmdS $SCNAME java -Xms$MEMORY -Xmx$MEMORY -jar $FILE nogui");
}

sub stop
{
	print "$_ function\n";
	&mc_cmd("stop");
}

sub grule
{
	print "Configulation my default setting \n";
	print "waiting ...\n";
	sleep(10);
	&mc_cmd("say Setting game rule");
	&mc_cmd("weather clear");
	&mc_cmd("gamerule doWeatherCycle false");
	print "Success ! \n";
}

sub bash
{
	system("bash");
}

sub top
{
	system("ps aux | grep java");
}

sub help
{
print<<"HELP_DOC"
		switch(){
			case "start"    {&start;sleep(20);}
			case "stop"     {&stop;}
			case "gamerule" {&grule;}
			case "ps"       {&top;}
			case "help"     {&help;}
			case "exit"     {exit 1;}
			else            {&mc_cmd();}
		}
HELP_DOC
}

