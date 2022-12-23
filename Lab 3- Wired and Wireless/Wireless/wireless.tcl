set val(chan)           Channel/WirelessChannel    ;
set val(prop)           Propagation/TwoRayGround   ;
set val(netif)          Phy/WirelessPhy            ;
set val(mac)            Mac/802_11                 ;
set val(ifq)            Queue/DropTail/PriQueue    ;
set val(ll)             LL                         ;
set val(ant)            Antenna/OmniAntenna        ;
set val(ifqlen)         50                         ;
set val(nn)             4                         ;
set val(rp)             DSDV                       ;
set val(x)        500
set val(y)        500

set ns      [new Simulator]

set nf [open wireless_out.tr w]
$ns trace-all $nf

set namf [open wireless_out.nam w]
$ns namtrace-all-wireless $namf $val(x) $val(y)
set topo  [new Topography]

$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)
set channel1 [new $val(chan)]
$ns node-config -adhocRouting $val(rp)\
            -llType $val(ll)\
            -macType $val(mac)\
            -ifqType $val(ifq)\
            -ifqLen $val(ifqlen)\
            -antType $val(ant)\
            -propType $val(prop)\
            -phyType $val(netif)\
            -topoInstance $topo\
            -energyModel "EnergyModel"\
            -initialEnergy 3.2\
            -txPower 0.3 \
            -rxPower 0.1 \
            -sleepPower 0.05 \
            -idlePower 0.1 \
            -agentTrace ON \
            -routerTrace ON \
            -macTrace ON \
            -movementTrace OFF \
            -channel $channel1
 
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$n0 random-motion 0
$n1 random-motion 0
$n2 random-motion 0
$n3 random-motion 0

$ns initial_node_pos $n1 20
$ns initial_node_pos $n0 20
$ns initial_node_pos $n2 20
$ns initial_node_pos $n3 20

$n0 set X_ 5.0
$n0 set Y_ 2.0
$n0 set Z_ 0.0

$n1 set X_ 8.0
$n1 set Y_ 5.0
$n1 set Z_ 0.0

$n2 set X_ 18.0
$n2 set Y_ 15.0
$n2 set Z_ 0.0

$n3 set X_ 23.0
$n3 set Y_ 28.0
$n3 set Z_ 0.0

$ns at 3.0 "$n1 setdest 50.0 40.0 25.0"
$ns at 3.0 "$n0 setdest 48.0 38.0 5.0"
$ns at 4.0 "$n2 setdest 100.0 100.0 40.0"
$ns at 10.0 "$n3 setdest 490.0 480.0 30.0"

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
$tcp0 set class_ 2

set sink0 [new Agent/TCPSink]
$ns attach-agent $n1 $sink0
$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set tcp1 [new Agent/TCP]
$ns attach-agent $n2 $tcp1
$tcp1 set class_ 2

set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1
$ns connect $tcp1 $sink1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

set tcp2 [new Agent/TCP]
$ns attach-agent $n3 $tcp2
$tcp2 set class_ 2

set sink2 [new Agent/TCPSink]
$ns attach-agent $n1 $sink2
$ns connect $tcp2 $sink2

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

$ns at 0.5 "$ftp0 start";
$ns at 1.5 "$ftp1 start";
$ns at 2.0 "$ftp1 stop";
$ns at 2.5 "$ftp2 start";
$ns at 5.0 "finish"

proc finish {} {
    global ns nf
    $ns flush-trace

    close $nf

    exec nam wireless_out.nam &
    exit 0
}

$ns run
