#!/usr/bin/perl -w
use PDL;
use Storable qw(dclone);
my @atomnums=(8,7,4,3);

open FF,"benz_furan.gjf" or die "can't find gjf files\n";
my %coorhash;
my $inde=1;
while(<FF>)
{
      
      if($_=~/^\s+\S+\s+(\S+)\s+(\S+)\s+(\S+)/)
      {
            $coorhash{$inde}{'x'}=$1;
             $coorhash{$inde}{'y'}=$2;
              $coorhash{$inde}{'z'}=$3;
          $inde++;
      }
}

my @A=($coorhash{$atomnums[1]}{'x'},$coorhash{$atomnums[1]}{'y'},$coorhash{$atomnums[1]}{'z'});
    
#print join "  ",@A;

            
my @B=($coorhash{$atomnums[2]}{'x'},$coorhash{$atomnums[2]}{'y'},$coorhash{$atomnums[2]}{'z'});
       

my $T=pdl 
[

      [1,0,0,0],
      [0,1,0,0],
      [0,0,1,0],
      [-$A[0],-$A[1],-$A[2],1]
];

my $TF=pdl
[
      [1,0,0,0],
      [0,1,0,0],
      [0,0,1,0],
      [$A[0],$A[1],$A[2],1]


];


my @B2=($B[0]-$A[0],$B[1]-$A[1],$B[2]-$A[2]);
my $cosU=$B2[2]/sqrt($B2[1]**2+$B2[2]**2);
my $sinU=$B2[1]/sqrt($B2[1]**2+$B2[2]**2);

my $RX=pdl
 [
      [1,0,0,0],
      [0,$cosU,$sinU,0],
      [0,-$sinU,$cosU,0],
      [0,0,0,1]
];
my $RXF=pdl
 [
      [1,0,0,0],
      [0,$cosU,-$sinU,0],
      [0,$sinU,$cosU,0],
      [0,0,0,1]
];



my $cosV=sqrt($B2[1]**2+$B2[2]**2)/sqrt($B2[0]**2+$B2[1]**2+$B2[2]**2);
my $sinV=-$B2[0]/sqrt($B2[0]**2+$B2[1]**2+$B2[2]**2);  ###Õý¸ººÅ

my $RY=pdl
[

 [$cosV,0,-$sinV,0],
   [0,1,0,0],
   [$sinV,0,$cosV,0],
   [0,0,0,1]


];


my $RYF=pdl
[

 [$cosV,0,$sinV,0],
   [0,1,0,0],
   [-$sinV,0,$cosV,0],
   [0,0,0,1]


];

#############################
my @graph=(1,2,3,4,5,7,4);
my $angle=40;
my %hash=&transform($angle,\%coorhash,$T,$RX,$RY,$RYF,$RXF,$TF,\@graph);
# print $vect x $T x $RX x $RY x $RZ x $RYF x $RXF x $TF;  #perfect;


sub transform
{
      my $angle=$_[0];
       my %hash=%{dclone($_[1])};
       my $outhash=%{dclone($_[1])};
       my $T=$_[2];
       my $RX=$_[3];
       my $RY=$_[4];
       my $RYF=$_[5];
       my $RXF=$_[6];
       
       my $TF=$_[7];
      my @graph=@{$_[8]};
      
      
       $angle=$angle/180*3.14159;
      my $cosW=cos($angle);
      my $sinW=sin($angle);
      
      my $RZ=pdl
 [
   [$cosW,$sinW,0,0],
   [-$sinW,$cosW,0,0],
   [0,0,1,0],
   [0,0,0,1]


];
      
     
      foreach my $id(@graph)
      {
            my @X=($hash{$id}{'x'},$hash{$id}{'y'},$hash{$id}{'z'});
            push @X,1;
            my $vect=pdl
            [
            [@X]
            ];
            
            
            print join "  ",@X;
            
            my $result =$vect x $T x $RX x $RY x $RZ x $RYF x $RXF x $TF;  #perfect;
            print "$result\n";
      }






}



sub mmmult
{
      my @parameters=@_;
      
      my $result=shift @parameters;;
      foreach my $para(@parameters)
      {
            $result=&mmult($result,$para);
            
      }
      
      return $result;
      
}



