# This script is created by NSG2 beta1
# <http://wushoupong.googlepages.com/nsg>

#===================================
#     Simulation parameters setup
#===================================
set val(stop)   10.0                         ;# time of simulation end

#===================================
#        Initialization       
#===================================
#Create a ns simulator
set ns [new Simulator]

$ns color 1 Purple
$ns color 2 Yellow

#Open the NS trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile

#===================================
#        Nodes Definition       
#===================================
#Create 6 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#===================================
#        Links Definition       
#===================================
#Createlinks between nodes
$ns duplex-link $n0 $n2 10.0Mb 10ms DropTail
$ns queue-limit $n0 $n2 20
$ns duplex-link $n1 $n2 10.0Mb 10ms DropTail
$ns queue-limit $n1 $n2 20
$ns duplex-link $n2 $n3 10.0Mb 10ms DropTail
$ns queue-limit $n2 $n3 20
$ns duplex-link $n3 $n4 10.0Mb 10ms DropTail
$ns queue-limit $n3 $n4 20
$ns duplex-link $n3 $n5 10.0Mb 10ms DropTail
$ns queue-limit $n3 $n5 20

#Give node position (for NAM)
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n4 orient right-up
$ns duplex-link-op $n3 $n5 orient right-down

#===================================
#        Agents Definition       
#===================================
#Setup a UDP connection
set udp0 [new Agent/UDP]
$udp0 set class_ 1
$ns attach-agent $n0 $udp0
set null2 [new Agent/Null]
$ns attach-agent $n4 $null2
$ns connect $udp0 $null2
$udp0 set packetSize_ 1000

#Setup a TCP connection
set tcp1 [new Agent/TCP]
$tcp1 set class_ 1
$ns attach-agent $n1 $tcp1
set sink3 [new Agent/TCPSink]
$ns attach-agent $n5 $sink3
$ns connect $tcp1 $sink3
$tcp1 set packetSize_ 1500


#===================================
#        Applications Definition       
#===================================
#Setup a CBR Application over UDP connection
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp0
$cbr1 set packetSize_ 1000
$cbr1 set rate_ 1.0Mb
$cbr1 set random_
$ns at 1.0 "$cbr1 start"
$ns at 2.0 "$cbr1 stop"

#Setup a FTP Application over TCP connection
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp1
$ns at 1.0 "$ftp2 start"
$ns at 5.0 "$ftp2 stop"


#===================================
#        Termination       
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam out.nam &
    exit 0
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run

