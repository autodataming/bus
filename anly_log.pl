#!/usr/bin/perl -w
use strict;
print "author: chenzhaoqiang;qq 744891290\n\n";
#                                 0    1       2       3

if(@ARGV<4)
{
print "usage:  perl anly_log.pl -dir ./log/ -output ./result.txt                      
       in the dir of log to save xxx.log
       function: to anlyse the vina result : extract the best vina docking score
       the result format is:
       ligandname   score
       to deal with the log may have three case £º
       1 empty (in ./test/cmc_3d_9927.pdbqt.log)£»
       2 no docking score(cmc_3d_2277.pdbqt.log);
       3 success docking(cmc_3d_1394.pdbqt.log)
       notice:if the name of ligand is too long ,you should use another script anlylog_long.pl\n";
       
       
#print $ARGV[0]," -dir",                   $ARGV[1],"e:/log/";
}
opendir(DR,$ARGV[1])|| die "can find the dir of log";
my @files=readdir(DR);

if(@files<=2)
{
	print "errir :this log dir is empty\n";
}

=pod 
#to debug
print $#files,"\n";
print $files[0],$files[1],$files[2],"\n";
=cut
=pod
shift @files;
shift @files;

print $#files,"\n";
print $files[0];
=cut


###########################################
#put energy to hash table

my %hash;
shift @files;
shift @files;
foreach my $file(@files)
{
	my $filepath=$ARGV[1].$file;
	open FH,$filepath or die "in the log dir can't find the file $file";
  my @text=<FH>;
  close(FH);
  
  if(@text>=28)
  {
  	#print $text[14]," ",$text[27],"\n";
    if($text[14]=~/will\s+be\s+(\S+)/)
    {
    	  my $ligandname=$1;
        if($text[27]=~/^\s+\d+\s+(\S+)/)
        {
        	$hash{$ligandname}=$1;
        }
    
    
    }
    else
    {
    	print "error: the log file is not standard!!!\n";
    }

  }
}


###################################################
#sort by the energy
if(@ARGV==4)
{


   open FF,">$ARGV[3]";


   foreach my $key(sort {$hash{$a}<=>$hash{$b}} keys %hash)
   {
   	print FF "$key    $hash{$key}\n";
   }
   print "congratulation!!! successs^^\n";
}
else
{
	 print "error ,in the command you should follow the format 
	 usage:  perl anly_log.pl -dir e:/log/ -output e:/result.txt\n";
}                      
     



		
	

       
