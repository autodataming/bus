#!/usr/bin/perl -w
use strict;
use Storable qw(dclone);	


#author:chenzhaoqiang@simm dddc
#data:2014-05-15
#contact:744891290@qq.com

#为了保证以后的通用性
#这里的输入要为hash的数据结构 存储连通信息



##########input START################
##input1 hash
##input2  node1 node2
my $node1=7;
my $node2=4;

my %hash;
my $nodenum=19;
for(my $i=1;$i<=$nodenum;$i++)
{
	for(my $ii=1;$ii<=$nodenum;$ii++)
	{
		$hash{$i}{$ii}=0;
	}
}

while(<DATA>)
{
	print $_;
	my @nodes=split(/\s+/,$_);
	$hash{$nodes[0]}{$nodes[1]}=1;
}
##########input  END##################


##########output START###################
my @graph1=&splitgraph(\%hash,$node1,$node2);   #Cut off the contact between node1 and node2,return node1 graph
my @graph2=&splitgraph(\%hash,$node2,$node1);    #Cut off the contact between node1 and node2,return node1 graph
print join "--",@graph1;

print "\n";
print join "--",@graph2;

##########output END   ####################




sub splitgraph
{
		my %matrix=%{dclone($_[0])};
    my $begin=$_[1];
    my $next=$_[2];
    $matrix{$begin}{$next}=0;
    $matrix{$next}{$begin}=0;

    my $size=values %matrix;

	  my @output;

	 my @color;#0 white 1grey 2 black
	 my @parent;#0 
	 my @grey;  #to store grey nodes;
	 #all atom is white default
	

	  for(1..$size)
	  {
		$color[$_]="white";   #initial  color is white,just collect black nodes
	  }
	  
	 $color[$begin]="grey";
	#$parent[$begin]="null";
	
	 push @grey,$begin;
	 
	 
	 while(@grey)
	{
		my $head=shift @grey;
		my @adjatoms=&adj($head,\%matrix);   #modify
		foreach my $atomid(@adjatoms)
		{
			if($color[$atomid]eq "white")
			{
				$color[$atomid]="grey";
			#	$parent[$atomid]=$head;
				$matrix{$atomid}{$head}=0;  #to avoid  backtrace
				push @grey,$atomid;
			}
		}		
			$color[$head]="black";
	}
	
		for(1..$size)
	{
		if($color[$_]  eq "black")
		{
			push @output,$_;
                     #   print $_;
		}
	}
	
	return @output;




}


sub  adj
{
 
	my $begin=$_[0];
	my %matrix=%{$_[1]};
	my $atomnum=keys %matrix;	



	my @adjatoms;
	for(my $i=1;$i<=$atomnum;$i++)
	{
		if($matrix{$i}{$begin}==1 || $matrix{$begin}{$i}==1)
		{
			push @adjatoms,$i;
		}
	}

	return @adjatoms ;
}




__DATA__
1   2
1   6
1   12
2   1
2   3
2   13
3   2
3   4
3   14
4   3
4   5
4   7
5   4
5   6
5   15
6   1
6   5
6   16
7   4
7   8
7   11
8   7
8   9
9   8
9   10
9   17
10   9
10   11
10   18
11   7
11   10
11   19
12   1
13   2
14   3
15   5
16   6
17   9
18   10
19   11
