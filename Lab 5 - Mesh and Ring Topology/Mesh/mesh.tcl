set ns  [new Simulator]

$ns color 1 blue
$ns color 2 red


set nt [open mesh.tr w]
$ns trace-all $nt

set nf [open mesh.nam w]
$ns namtrace-all $nf

proc finish {} {
        global ns nf
        global ns nt
        $ns flush-trace
        close $nf
        close $nt
        exec nam mesh.nam
        exit 0
        }

      
for {set i 0} {$i<4} {incr i} {
set n($i) [$ns node]
}


$ns duplex-link $n(0) $n(1) 1Mb 10ms DropTail
$ns duplex-link $n(0) $n(2) 1Mb 10ms DropTail
$ns duplex-link $n(0) $n(3) 1Mb 10ms DropTail
$ns duplex-link $n(1) $n(2) 1Mb 10ms DropTail
$ns duplex-link $n(1) $n(3) 1Mb 10ms DropTail
$ns duplex-link $n(2) $n(3) 1Mb 10ms DropTail

 


set tcp0 [new Agent/TCP]
$tcp0 set class_ 1
$ns attach-agent $n(1) $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n(3) $sink0

$ns connect $tcp0 $sink0


set tcp1 [new Agent/TCP]
$tcp1 set class_ 2
$ns attach-agent $n(2) $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n(0) $sink1

$ns connect $tcp1 $sink1


set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0



set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1




$ns at 0.1 "$ftp0 start"
$ns at 1.5 "$ftp0 stop"

$ns at 0.2 "$ftp1 start"
$ns at 1.3 "$ftp1 stop"

$ns at 2.0 "finish"
$ns run
