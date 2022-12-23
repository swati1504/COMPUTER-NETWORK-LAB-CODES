LanRouter set debug_ 0
set ns [new Simulator]

set nf [ open out.nam w ]
$ns namtrace-all $nf

set tf [open tf.tr w]
$ns trace-all $tf

proc finish {} {	
	global ns nf tf
	$ns flush-trace
	close $nf
    close $tf
	exit 0
}

for {set i 0} {$i < 10} {incr i} {
    set n($i) [$ns node]
}

set dummy [$ns node]

$ns duplex-link $dummy $n(0) 2Mb 10ms DropTail
$ns duplex-link-op $dummy $n(0) orient right

set lan [ $ns newLan "$n(0) $n(1) $n(2) $n(3) $n(4) $n(5) $n(6) $n(7) $n(8) $n(9)" 2Mb 10ms LL Queue/DropTail MAC/-802_3 Channel ]

set src0 [expr int(rand()*10)%10]
set dst0 [expr int(rand()*10)%10]
set src1 [expr int(rand()*10)%10]
set dst1 [expr int(rand()*10)%10]

set udp0 [new Agent/UDP]
$ns attach-agent $n($src0) $udp0

set udp1 [new Agent/UDP]
$ns attach-agent $n($src1) $udp1

set sink0 [new Agent/LossMonitor]
$ns attach-agent $n($dst0) $sink0

set sink1 [new Agent/LossMonitor]
$ns attach-agent $n($dst1) $sink1

$ns connect $udp0 $sink0
$ns connect $udp1 $sink1

set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 1000
$cbr0 set rate_ 4Mb
$cbr0 attach-agent $udp0

set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 1000
$cbr1 set rate_ 4Mb
$cbr1 attach-agent $udp1

$ns at 1.0 "$cbr0 start"
$ns at 1.0 "$cbr1 start"
$ns at 49.0 "$cbr0 stop"
$ns at 49.0 "$cbr1 stop"
$ns at 50.0 "finish"
$ns run
