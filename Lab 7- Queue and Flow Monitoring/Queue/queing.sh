set terminal png
set output 'queing.png'
set xlabel "Time(in seconds)"
set ylabel "PDR"
set autoscale yfix
set grid
set style data linespoints
plot "out" using 1:2 title "Queued" lt rgb "green", "out" using 1:3 title "Dequed" lt rgb "blue", "out" using 1:4 title "Dropped" lt rgb "red"