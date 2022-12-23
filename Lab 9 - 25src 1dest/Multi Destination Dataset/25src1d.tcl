# 25 src 1 dest

# create a dataset for the corresponding topology by considering
# the src node chars,:
# a. Various data rates
# b. Various Packet Size

# create the graphs for one simulation b4 constructing the data Set
# and create the graphs by considering all the results  in a data set.

set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(ant) Antenna/OmniAntenna
set val(ll) LL
set val(ifq) Queue/DropTail/PriQueue
set val(ifqlen) 50
set val(netif) Phy/WirelessPhy
set val(mac) Mac/802_11
set val(rp) DSDV
set val(nn) 50
set val(x) 2000
set val(y) 1000
set val(stop) 10
set val(traffic) cbr
set val(traffic) tcp

for {set i 0} {$i < $val(nn) } { incr i } {
set node_($i) [$ns node]
}

for {set i 0} {$i < $val(nn)} { incr i } {
# 30 defines the node size for nam
$ns initial_node_pos $node_($i) 30
}
proc destination {} {
global ns val node_
set time 1.0
set now [$ns now]

for {set i 0} {$i<$val(nn)} {incr i} {
set xx [expr rand()*1600]
set yy [expr rand()*800]
$ns at $now "$node_($i) setdest $xx $yy 1000.0"
}
$ns at [expr $now+$time] "destination"
}

for {set i 0} {$i < $val(nn) } {incr i } {
$node_($i) color yellow
$ns at 1.0 "$node_($i) color red"
}

for {set i 0} {$i < $val(nn) } {incr i } {
$node_($i) color yellow
$ns at 2.0 "$node_($i) color lightgreen"
}

for {set i 0} {$i < $val(nn) } {incr i } {
$node_($i) color yellow
$ns at 3.0 "$node_($i) color orange"
}


$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ ns at $val(stop) "stop"
$ns at 10.5 "puts \"end simulation\" ; $ns halt"

proc stop {} {
global ns tracefd namtrace
$ns flush-trace
close $tracefd
close $namtrace
exec nam out.nam &
}
$ns run
 

$ns wireles.tcl