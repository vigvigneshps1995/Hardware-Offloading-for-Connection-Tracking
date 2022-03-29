# Plot packetloss over time. 
# Arguments defined from command line. 
TIME_BF     = ARG1  # Time of basic forwarder files, format: 2021-10-10T0910
TIME_LB     = ARG2  # Time of loadbalancer files, format: 2021-10-10T0910
TIME_HO     = ARG3  # Time of hw files files, format: 2021-10-10T0910
HT_SIZE     = ARG4  # Hash table size, e.g. 2. 
FLOW_COUNT  = ARG5
OFF_SCHEME  = ARG6
RUN         = ARG7

# Colors defined
HO1_COLOR = "#2c7fb8"
HO4_COLOR = "#ffc380"

fontTickSize    = 21
fontAxisTitle   = 21
fontKeySize     = 21
lineWidth       = 3
pointIntensity  = 5

# Titles
xTitle = "Time (s)"
yTitle = "Packetloss (%)"
# plotTitle = gprintf("Packetloss vs. CPU core count\n\n{/*0.85 (Hash table %gM entries", HT).gprintf(", %gM rules, 2M Flows, Table 0)}", RULE)

# File names defined HO 
HO1_C1 = sprintf("data/%s-LBwHO-c1-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, HT_SIZE, "1", FLOW_COUNT, RUN)
HO1_C2 = sprintf("data/%s-LBwHO-c2-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, HT_SIZE, "1", FLOW_COUNT, RUN)
HO1_C4 = sprintf("data/%s-LBwHO-c4-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, HT_SIZE, "1", FLOW_COUNT, RUN)
HO1_C8 = sprintf("data/%s-LBwHO-c8-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, HT_SIZE, "1", FLOW_COUNT, RUN)

HO4_C1 = sprintf("data/%s-LBwHO-c1-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, HT_SIZE, "4", FLOW_COUNT, RUN)
HO4_C2 = sprintf("data/%s-LBwHO-c2-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, HT_SIZE, "4", FLOW_COUNT, RUN)
HO4_C4 = sprintf("data/%s-LBwHO-c4-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, HT_SIZE, "4", FLOW_COUNT, RUN)
HO4_C8 = sprintf("data/%s-LBwHO-c8-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, HT_SIZE, "4", FLOW_COUNT, RUN)


set terminal postscript size 12,12 portrait enhanced background rgb 'white' color dashed lw 1 "cmr,12"
set output sprintf("%s-PACKETLOSS-HT%sM_$s.ps", TIME_BF, HT_SIZE, RULE)
set datafile separator ","
unset key

# Columns defined: Time, TxCount, RxCount, TxRate, RxRate, PacketLoss, LAT, LAT95, LAT99
t = 1
tx_c = 2
rx_c = 3
tx_r = 4
rx_r = 5
loss = 6
lat = 7
lat95 = 8
lat99 = 9

stats HO1_C1 using t name "time" nooutput

set lmargin at screen 0.12
set tmargin at screen 0.90
set bmargin at screen 0.15
set rmargin at screen 0.95

set xrange [2:50]
set yrange[0:120]
set xtics 0,5,time_max font ", ".fontTickSize out offset 0,-0.5
set ytics 0,20,100 font ", ".fontTickSize
set xlabel "".xTitle font ", ".fontAxisTitle offset 0,-2
set ylabel "".yTitle font ", ".fontAxisTitle offset -5,0

set style line 1 pi pointIntensity+1 ps 1.5 lt 2 lc rgb HO1_COLOR lw lineWidth dt 15 
set style line 2 pi pointIntensity+3 ps 1.5 lt 4 lc rgb HO1_COLOR lw lineWidth dt 2
set style line 3 pi pointIntensity+5 ps 1.5 lt 6 lc rgb HO1_COLOR lw lineWidth dt 3
set style line 4 pi pointIntensity+7 ps 1.5 lt 8 lc rgb HO1_COLOR lw lineWidth dt 4
set style line 6 pi pointIntensity+2 ps 1.5 lt 2 lc rgb HO4_COLOR lw lineWidth dt 15
set style line 7 pi pointIntensity+4 ps 1.5 lt 4 lc rgb HO4_COLOR lw lineWidth dt 2
set style line 8 pi pointIntensity+6 ps 1.5 lt 6 lc rgb HO4_COLOR lw lineWidth dt 3
set style line 9 pi pointIntensity+8 ps 1.5 lt 8 lc rgb HO4_COLOR lw lineWidth dt 4

set key horizontal top center font ", ".fontKeySize

# set title "".plotTitle font ", ".fontAxisTitle offset 0,-4

set key invert

plot \
HO1_C1 using t:($6*100) with linespoints ls 1 title "HO Flow size 1 Core",\
HO1_C2 using t:($6*100) with linespoints ls 2 title "HO Flow size 2 Cores",\
HO1_C4 using t:($6*100) with linespoints ls 3 title "HO Flow size 4 Cores",\
HO1_C8 using t:($6*100) with linespoints ls 4 title "HO Flow size 8 Cores",\
HO4_C1 using t:($6*100) with linespoints ls 6 title "HO Naive 1 Cores",\
HO4_C2 using t:($6*100) with linespoints ls 7 title "HO Naive 2 Cores",\
HO4_C4 using t:($6*100) with linespoints ls 8 title "HO Naive 4 Cores",\
HO4_C8 using t:($6*100) with linespoints ls 9 title "HO Naive 8 Cores",\
