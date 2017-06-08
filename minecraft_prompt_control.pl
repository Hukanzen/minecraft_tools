#!/usr/bin/env perl

#
# java のインストールと screen のインストールが必要です
#

use Switch;

my $MEMORY="1024M";
my $FILE  ="minecraft_server.1.11.2.jar";
my $SCNAME="minecraft0"; #screen name

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
			case "start"    {&start;&dot_wait(1,10);}
			case "stop"     {&stop;}
			case "gamerule" {&grule;}
			case "restart"{
				&mc_cmd("say restart after 30sec");
				sleep(20);
				&mc_cmd("say restart after 10sec");
				sleep(10);
				&mc_cmd("say restart start");
				&stop;
				&dot_wait(1,10);
				&start;
				&dot_wait(1,10);
				&grule;
			}
			case "bash"     {&bash;}
			case "ps"       {&top;}
			case "help"     {&help;}
			case "exit"     {exit 1;}
			#else            {&mc_cmd("$_");}
			else            {&other("$_");}
		}
		
		print "[Minecraft_CMD] >>> ";
	}
}

sub dot_wait
{
	my ($t,$n)=@_;

	for(my $i=0;$i<$n;$i++){
		sleep($t);
		print ".";
	}

	print "\n";
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
	#system("screen -AmdS $ java -Xms$MEMORY -Xmx$MEMORY -jar $FILE nogui");
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
			case "restart"{
				&stop;
				sleep(20);
				&start;
				sleep(20);
				&grule;
			}
			case "bash"     {&bash;}
			case "ps"       {&top;}
			case "help"     {&help;}
			case "exit"     {exit 1;}
			#else            {&mc_cmd("$_");}
			else            {&other("$_");}
		}
HELP_DOC
}

sub other
{
	my $str=shift(@_); #input string

	if($str=~/bash_/){
		$str=~s/bash_//g;
		my $bash_v=`$str`; #execution bash command
		$bash_v=~s/ /_/g;
		my @bash_cmd=split(/\n/,$bash_v);
		#&mc_cmd("say $bash_v");
		foreach(@bash_cmd){
			&mc_cmd("say $_");
		}
	}else{
		&mc_cmd($str);	
	}
}
