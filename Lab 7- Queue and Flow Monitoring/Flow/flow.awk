BEGIN{
    queued=0;
    interval=0;
    prev=0;
}
{
 event = $1
    time = $2
    source = $3
    destination = $4
    protocol = $5
    packet_size = $6
    if((interval>=0.001)){
    print time, queued;
    interval=0;
    queued=0;
    }
    else{
        if((event == "+"))
        {
            queued++;
        }
        interval+=(time-prev);
    }
    prev=time;
}
END{
    ;
}