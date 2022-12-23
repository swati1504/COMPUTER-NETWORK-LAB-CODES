set terminal png
set output 'Result.png'
#set xrange [0.0:3.0]
set xlabel "Time(in seconds)"
set autoscale xfix
set autoscale
#set yrange [0:80]
set ylabel "PacketLossRatio(in Kbps)"
set grid
set style data linespoints
set output "busPacket.png"
plot "bus" using 1:2 title "PacketLossRatio" lt rgb "blue" 

