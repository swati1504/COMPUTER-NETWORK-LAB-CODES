BEGIN{
receive=0
drop=0
total=0
ratio=0
}
{
if($1=="r")
{
receive++;
}
if($1=="d")
{
drop++;
}
}
END{
total=receive+drop
ratio=(receive/total)*100
print "\n";
printf("\n Total packet sent: %d", total)
printf("\n Packet Delivery Ratio: %d", ratio)
printf("\n Total Packet Dropped: %d", drop)
print "\n";
}
