#============================= throughput.awk ========================

BEGIN {
drop=0;
sent=0;
gotime = 0;
time = 0;
packet_size = $8;
time_interval=0.01;
recv=0;
}
#body
{
       event = $1
             time = $2
             node_id = $4
             pktType = $7
	     packet_size = $8
	     
	     
 if(time>gotime && sent !=0) {

  print gotime, (sent-recv)/sent; #packet size * ... gives results in kbps
  gotime+= time_interval;
  drop=0;
  sent=0;
  }

#============= CALCULATE throughput=================

  if (( event == "r") && ( pktType == "tcp" ))
  {
     recv++;
  }
    if (( event == "s") && ( pktType == "tcp" ))
  {
     sent++;
  }


} #body


END {
;
}
#============================= Ends ============================
