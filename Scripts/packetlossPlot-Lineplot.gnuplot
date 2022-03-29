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
lb_color = "#00ad57"
bf_color = "#d90073"
ho_color = "#ffc380" 

fontTickSize    = 21
fontAxisTitle   = 21
fontKeySize     = 21
lineWidth       = 3
pointIntensity  = 5

# Titles
xTitle = "Time (s)"
yTitle = "Packetloss (%)"
# plotTitle = gprintf("Packetloss vs. CPU core count\n\n{/*0.85 (Hash table %gM entries", HT).gprintf(", %gM rules, 2M Flows, Table 0)}", RULE)

# File names defined BF
BF_C1 = sprintf("data/%s-BF-c1-F%s-avg.csv", TIME_BF, FLOW_COUNT) 
BF_C2 = sprintf("data/%s-BF-c2-F%s-avg.csv", TIME_BF, FLOW_COUNT) 
BF_C4 = sprintf("data/%s-BF-c4-F%s-avg.csv", TIME_BF, FLOW_COUNT) 
BF_C8 = sprintf("data/%s-BF-c8-F%s-avg.csv", TIME_BF, FLOW_COUNT) 

# File names defined LB
LB_C1 = sprintf("data/%s-LB-c1-ht%sM-T1-F%s-avg.csv", TIME_LB, HT_SIZE, FLOW_COUNT)
LB_C2 = sprintf("data/%s-LB-c2-ht%sM-T1-F%s-avg.csv", TIME_LB, HT_SIZE, FLOW_COUNT)
LB_C4 = sprintf("data/%s-LB-c4-ht%sM-T1-F%s-avg.csv", TIME_LB, HT_SIZE, FLOW_COUNT)
LB_C8 = sprintf("data/%s-LB-c8-ht%sM-T1-F%s-avg.csv", TIME_LB, HT_SIZE, FLOW_COUNT)

# File names defined HO 
HO_C1 = sprintf("data/%s-LBwHO-c1-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, HT_SIZE, OFF_SCHEME, FLOW_COUNT, RUN)
HO_C2 = sprintf("data/%s-LBwHO-c2-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, HT_SIZE, OFF_SCHEME, FLOW_COUNT, RUN)
HO_C4 = sprintf("data/%s-LBwHO-c4-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, HT_SIZE, OFF_SCHEME, FLOW_COUNT, RUN)
HO_C8 = sprintf("data/%s-LBwHO-c8-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, HT_SIZE, OFF_SCHEME, FLOW_COUNT, RUN)


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

stats LB_C8 using t name "time" nooutput

set lmargin at screen 0.12
set tmargin at screen 0.90
set bmargin at screen 0.15
set rmargin at screen 0.95

set xrange [2:time_max]
set yrange[0:120]
set xtics 0,5,time_max font ", ".fontTickSize out offset 0,-0.5
set ytics 0,20,100 font ", ".fontTickSize
set xlabel "".xTitle font ", ".fontAxisTitle offset 0,-2
set ylabel "".yTitle font ", ".fontAxisTitle offset -5,0

set style line 5 pi pointIntensity lt -1 lc rgb bf_color lw lineWidth dt 39 
set style line 1 pi pointIntensity+1 ps 1.5 lt 2 lc rgb lb_color lw lineWidth dt 15 
set style line 2 pi pointIntensity+3 ps 1.5 lt 4 lc rgb lb_color lw lineWidth dt 2
set style line 3 pi pointIntensity+5 ps 1.5 lt 6 lc rgb lb_color lw lineWidth dt 3
set style line 4 pi pointIntensity+7 ps 1.5 lt 8 lc rgb lb_color lw lineWidth dt 4
set style line 6 pi pointIntensity+2 ps 1.5 lt 2 lc rgb ho_color lw lineWidth dt 15
set style line 7 pi pointIntensity+4 ps 1.5 lt 4 lc rgb ho_color lw lineWidth dt 2
set style line 8 pi pointIntensity+6 ps 1.5 lt 6 lc rgb ho_color lw lineWidth dt 3
set style line 9 pi pointIntensity+8 ps 1.5 lt 8 lc rgb ho_color lw lineWidth dt 4

set key horizontal top center font ", ".fontKeySize

# set title "".plotTitle font ", ".fontAxisTitle offset 0,-4

set key invert

plot \
LB_C8 using t:($6*100) with linespoints ls 4 title "LB 8 Cores",\
HO_C8 using t:($6*100) with linespoints ls 9 title "HO 8 Cores",\
HO_C4 using t:($6*100) with linespoints ls 8 title "HO 4 Cores",\
LB_C2 using t:($6*100) with linespoints ls 2 title "LB 2 Cores",\
LB_C4 using t:($6*100) with linespoints ls 3 title "LB 4 Cores",\
HO_C2 using t:($6*100) with linespoints ls 7 title "HO 2 Cores",\
HO_C1 using t:($6*100) with linespoints ls 6 title "HO 1 Cores",\
BF_C8 using t:($6*100) with linespoints ls 5 title "BF 8 Cores",\
LB_C1 using t:($6*100) with linespoints ls 1 title "LB 1 Cores",\
