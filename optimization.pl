use strict;
use warnings;
use File::Copy qw(move);
use Win32::Process::Info;
use Win32::Process;
use Getopt::Long;

#initialize variables
my $workers;
my $workers_max;
my $workers_steps;

my $intensity;
my $intensity_min;
my $intensity_max;
my $intensity_steps;

my $log;
my $logread;
my $overwrite = 0;

#Ask about settings if they were not defined
print "Enter Min Workersize:";
$workers = <STDIN>;
chomp $workers;
print "Enter Max Workersize:";
$workers_max = <STDIN>;
chomp $workers_max;
print "Enter Workersize Step Interval:";
$workers_steps = <STDIN>;
chomp $workers_steps;

print "Enter Min Intensity:";
$intensity = <STDIN>;
chomp $intensity;
$intensity_min = $intensity;
print "Enter Max Intensity:";
$intensity_max = <STDIN>;
chomp $intensity_max;
print "Enter Intensity Step Interval:";
$intensity_steps = <STDIN>;
chomp $intensity_steps;


#Estimate time to finish
print "The program will run about ".(((($workers_max-$workers)/$workers_steps)+1)*((($intensity_max-$intensity)/$intensity_steps)+1)*0.75)." min. Continue? (any key)\n";
<STDIN>;
open(RESULT, "<", "results.txt") or die("Could not write to results.");
	if(<RESULT>){
	print "result.txt not empty, overwrite (y) or append (n)?)\n";
		if (<STDIN> eq "y\n"){
		print "Overwritten.\n";
		$overwrite = 1;
		}
		else{
		print "Appending results.\n";
		}
	}
close(RESULT);

#Write header
if ($overwrite == 1){
	open(RESULT, ">", "results.txt") or die("Could not write to results.");
}else{
	open(RESULT, ">>", "results.txt") or die("Could not write to results.");
}
print RESULT (30*"_")."\nNew run started at ".localtime."\n";
print RESULT "Settings: \n";
print RESULT "Workers from ".$workers." to ".$workers_max." in ".$workers_steps." increments.\n";
print RESULT "Intensity from ".$intensity_min." to ".$intensity_max." in ".$intensity_steps." increments.\n\n";
print RESULT "Intensity\tWorkers\tHashrate\n";
close(RESULT);

print (30*"_")."\nNew run started at ".localtime."\n";
print "Settings: \n";
print "Workers from ".$workers." to ".$workers_max." in ".$workers_steps." increments.\n";
print "Intensity from ".$intensity_min." to ".$intensity_max." in ".$intensity_steps." increments.\n\n";

print "Intensity|Workers|Hashrate|\n";

#Loop every intensity for every worker setting, overwriting config.txt
for ($workers; $workers <= $workers_max; $workers = $workers + $workers_steps){
	open(CONFIG, "<", "config.txt") or die("Could not open config.txt");
		open(CONFOUT, ">", "config.txt.new") or die("Could not write new file.");
		# print the lines before the change
		while( <CONFIG> ){
			print CONFOUT $_;
			last if $. == 15; # line number before change
			}
		
		my $line = <CONFIG>;
		$line =~ s/"worksize":(\d+),/"worksize":$workers,/g;
		print CONFOUT $line;
		
		while( <CONFIG> ){
			print CONFOUT $_;
			}
		
		close(CONFIG);
		close(CONFOUT);

		move "config.txt.new", "config.txt";
	move "config.txt.new", "config.txt";
	
	$intensity = $intensity_min;
	for ($intensity; $intensity <= $intensity_max; $intensity = $intensity + $intensity_steps){
		open(CONFIG, "<", "config.txt") or die("Could not open config.txt");
		open(CONFOUT, ">", "config.txt.new") or die("Could not write new file.");
		# print the lines before the change
		while( <CONFIG> ){
			print CONFOUT $_;
			last if $. == 15; # line number before change
			}
		
		my $line = <CONFIG>;
		$line =~ s/"intensity":(\d+),/"intensity":$intensity,/g;
		print CONFOUT $line;
		
		while( <CONFIG> ){
			print CONFOUT $_;
			}
		
		close(CONFIG);
		close(CONFOUT);

		move "config.txt.new", "config.txt";
		#start miner in new window
		system  "start /Min /ABOVENORMAL xmr-stak-amd.exe";
		
		sleep 40; 
		
		#system  "taskkill /F /IM xmr-stak-amd.exe";
		#kill miner without making a sound
		qx{"taskkill /F /IM xmr-stak-amd.exe"};
		sleep 1;
		#read hashrate in log
		$logread = 1;
		$log = "NA";
		open(LOG, "<", "log.txt") or $logread = 0;
		if ($logread == 1){
			while(<LOG>){
				$_ = m/\|.+\|\s(\d+)\.\d.+\|.+\|/g;
				if ($1 != $intensity){
					$log=$1;
				}
			}
			close(LOG);
			sleep 1;
			system "del /f log.txt";
			sleep 1;
			#write results
			print $intensity."\t | ".$workers."\t | ".$log."   |\n";
			
			open(RESULT, ">>", "results.txt") or die("Could not write to results.");
			print RESULT $intensity."\t".$workers."\t".$log."\n";
			close(RESULT);
		}else{
			print "No Logfile found, restarting miner with same settings.";
			if ($intensity == $intensity_min){
				$workers = $workers-$workers_steps;
			}else{
				$intensity=$intensity-$intensity_steps;
			}
			}
	}
}