BEGIN{
    queued=0;
    dequed=0;
    dropped=0;
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
    print time, queued, dequed, dropped;
    interval=0;
    }
    else{
        if((event == "+"))
        {
            queued++;
        }
        if((event=="d"))
        {
            dropped+=10;
        }
        if((event=="-"))
        {
            dequed++;
        }
        interval+=(time-prev);
    }
    prev=time;
}
END{
    ;
}