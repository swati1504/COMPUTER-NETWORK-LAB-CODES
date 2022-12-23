#============================= throughput.awk ========================

BEGIN {
drop=0;
sent=0;
gotime = 0;
time = 0;
packet_size = $6;
time_interval=0.01;
}
#body
{
       event = $1
             time = $2
             node_id = $4
             pktType = $5
	     packet_size = $6
	     
 if(time>gotime && sent !=0) {

  print gotime, drop/sent; #packet size * ... gives results in kbps
  gotime+= time_interval;
  drop=0;
  sent=0;
  }

#============= CALCULATE throughput=================

  if (( event == "d") && ( pktType == "tcp" ))
  {
     drop++;
  }
    if (( event == "+") && ( pktType == "tcp" ))
  {
     sent++;
  }


} #body


END {
;
}
#============================= Ends ============================
