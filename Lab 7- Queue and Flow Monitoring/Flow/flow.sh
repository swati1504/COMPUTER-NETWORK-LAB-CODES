set terminal png
set output 'flow.png'
set xlabel "Time(in seconds)"
set ylabel "Queued"
set autoscale yfix
set xrange [0:1]
set grid
set style data linespoints
plot "out1" using 1:2 title "Queued" lt rgb "green"