reset
set datafile separator ","
set grid
set style data lines
set xlabel "Strain (%)"
set ylabel "Stress (MPa)"
set xrange [0:4]
set yrange [0:20]
max_frame = 48
set terminal gif animate
set output "151.gif"
do for [frame=0:max_frame] {
	plot "151.csv" using ($4*100):5 every ::0::64*frame notitle
}
unset output
set terminal pop
