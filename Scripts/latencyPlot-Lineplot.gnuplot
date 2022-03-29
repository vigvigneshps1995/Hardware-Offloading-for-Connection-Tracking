# Plot latency over time. 
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

fontAxisTitle   = 21
fontTickSize    = 21
fontKeySize     = 21
lineWidth       = 3
pointIntensity  = 10

# Titles
xTitle = "Time (s)"
yTitle = "Latency (ns)"
#plotTitle = gprintf("Latency vs CPU core count\n\n{/*0.85 (Hash table %gM entries", HT).gprintf(", %gM rules, 2M Flows, Table 0)}", RULE)


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


set terminal postscript size 14,12 portrait enhanced background rgb 'white' color dashed lw 1 "cmr,12"
set output sprintf("%s_LATENCY-HT%sM_$s.ps", TIME_BF, HT_SIZE, RULE)
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

stats BF_C1 using lat name "BF1" nooutput
stats BF_C2 using lat name "BF2" nooutput
stats BF_C4 using lat name "BF4" nooutput
stats BF_C8 using lat name "BF8" nooutput
stats LB_C1 using lat name "LB1" nooutput
stats LB_C2 using lat name "LB2" nooutput
stats LB_C4 using lat name "LB4" nooutput
stats LB_C8 using lat name "LB8" nooutput
stats HO_C1 using lat name "HO1" nooutput
stats HO_C2 using lat name "HO2" nooutput
stats HO_C4 using lat name "HO4" nooutput
stats HO_C8 using lat name "HO8" nooutput
stats LB_C8 using t name "time" nooutput

max = LB1_max; 
min = LB1_min; 
bf_min = BF1_min; 
bf_max = BF1_max;

if (LB2_max > max) max = LB2_max;
if (LB4_max > max) max = LB4_max;
if (LB8_max > max) max = LB8_max;
if (HO2_max > max) max = HO2_max;
if (HO4_max > max) max = HO4_max;
if (HO8_max > max) max = HO8_max;

if (LB2_min < min) min = LB2_min;
if (LB4_min < min) min = LB4_min;
if (LB8_min < min) min = LB8_min;
if (HO2_min < min) min = HO2_min;
if (HO4_min < min) min = HO4_min;
if (HO8_min < min) min = HO8_min;
if (BF1_min < min) min = BF1_min;
if (BF2_min < min) min = BF2_min; 
if (BF4_min < min) min = BF4_min; 
if (BF8_min < min) min = BF8_min; 

if (BF2_min < bf_min) bf_min = BF2_min;
if (BF4_min < bf_min) bf_min = BF4_min; 
if (BF8_min < bf_min) bf_min = BF8_min; 
if (BF2_max > bf_max) bf_max = BF2_max;
if (BF4_max > bf_max) bf_max = BF4_max;
if (BF8_max > bf_max) bf_max = BF8_max;

# y1 = 0; y2 = bf_max+5; y3 = floor(min)-5; y4 = floor(max)+25
y1 = 0; y2 = floor(min)-10; y3 = floor(min)-5; y4 = floor(max)+25
bm = 0.15
lm = 0.3
rm = 0.95
gap = 0.03
size = 0.75
kk=0.1

set style line 5 pi pointIntensity lt -1 lc rgb bf_color lw lineWidth dt 39 
set style line 1 pi pointIntensity+1 ps 1.5 lt 2 lc rgb lb_color lw lineWidth dt 15 
set style line 2 pi pointIntensity+3 ps 1.5 lt 4 lc rgb lb_color lw lineWidth dt 2
set style line 3 pi pointIntensity+5 ps 1.5 lt 6 lc rgb lb_color lw lineWidth dt 3
set style line 4 pi pointIntensity+7 ps 1.5 lt 8 lc rgb lb_color lw lineWidth dt 4
set style line 6 pi pointIntensity+2 ps 1.5 lt 2 lc rgb ho_color lw lineWidth dt 15
set style line 7 pi pointIntensity+4 ps 1.5 lt 4 lc rgb ho_color lw lineWidth dt 2
set style line 8 pi pointIntensity+6 ps 1.5 lt 6 lc rgb ho_color lw lineWidth dt 3
set style line 9 pi pointIntensity+8 ps 1.5 lt 8 lc rgb ho_color lw lineWidth dt 4

set lmargin at screen lm
set rmargin at screen rm
set bmargin at screen bm
# Plot basic forwarder 
if (y2<=0 || y3 < y2 || abs(y3 - y2) < 10) {
    set ytics nomirror
    set xtics 0,5,time_max font ", ".fontTickSize offset 0,-1
    set xrange [0:time_max]
    
    set yrange[0:1400] # Table 1
    set ytics 0,200,1200 font ", ".fontTickSize
    #set yrange[0:y4*1.2] # Table 0

    set key horizontal top center font ", ".fontKeySize
    set tmargin at screen bm + size
    # set title "".plotTitle font ", ".fontAxisTitle offset 0,-2
    set xlabel "".xTitle font ", ".fontAxisTitle offset 0,-2
    set ylabel "".yTitle font ", ".fontAxisTitle offset -2,0    
} else {
    set multiplot
    y2 = (floor(y2 / 10) * 10) + 10
    set yrange[0:1300] # Table 1
    #set yrange[0:y4]

    set ytics nomirror
    set xtics nomirror
    set xtics scale 0.0
    set xtics 0,0,0
    set ytics 0,floor(y2/2),y2 font ", ".fontTickSize
    set tmargin at screen bm + size * kk
    set style line 5 lt -1 lc rgb bf_color lw 2 
    set xlabel "".xTitle font ", ".fontAxisTitle offset 0,-1.5
    set xrange [2:time_max]
    set xtics 0,5,time_max font ", ".fontTickSize offset 0,-0.5
    set border 1+2+8
    plot BF_C1 using t:lat with linespoints ls 5 notitle

    # Plot
    unset xtics
    unset xlabel
    set xtics nomirror
    set ytics nomirror

    set yrange[0:1300] # Table 0

    set xtics 0,0,0
    y3 = floor(y3 / 10) * 10 
    y4 = floor(y4 / 10) * 10

    set yrange[y3:y4+200]
    set key horizontal top center font ", ".fontKeySize
    set ytics y3, floor((y4 - y3) / ( 10 * 10.)) * 10, y4 font ", ".fontTickSize

    set xtics font ", ".fontTickSize out offset 0,-0.5
    set ytics font ", ".fontTickSize
    set ylabel "".yTitle font ", ".fontAxisTitle offset -6.5,0
    set border 2+4+8
    set bmargin at screen bm + size * kk + gap
    set tmargin at screen bm + size + gap

    # set label "".plotTitle font ", ".fontAxisTitle at screen 0.52,0.98 center front
}

set key invert

plot \
LB_C4 using t:lat with linespoints ls 3 title "LB 4 Cores",\
LB_C8 using t:lat with linespoints ls 4 title "LB 8 Cores",\
BF_C8 using t:lat with linespoints ls 5 title "BF 8 Cores",\
LB_C2 using t:lat with linespoints ls 2 title "LB 2 Cores",\
LB_C1 using t:lat with linespoints ls 1 title "LB 1 Cores",\
HO_C8 using t:lat with linespoints ls 9 title "HO 8 Cores",\
HO_C4 using t:lat with linespoints ls 8 title "HO 4 Cores",\
HO_C2 using t:lat with linespoints ls 7 title "HO 2 Cores",\
HO_C1 using t:lat with linespoints ls 6 title "HO 1 Core",\

unset multiplot
