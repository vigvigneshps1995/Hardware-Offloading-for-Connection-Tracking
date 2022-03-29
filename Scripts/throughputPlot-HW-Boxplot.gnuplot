# Plot throughput over time (boxplot). 
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
pointIntensity  = 10

# Titles
xTitle = "CPU Core count"
yTitle = "Throughput (Gbps)"
# plotTitle = gprintf("Throughput vs CPU core count\n\n{/*0.85 (Hash table %gM entries", HT).gprintf(", %gM rules, 2M Flows, Table 0)}", RULE)

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
set output sprintf("%s-THROUGHPUT-HT%sM_$s.ps", TIME_BF, HT_SIZE, RULE)
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
# Get stats to determine y-axis max/min plot. 

stats HO1_C1 using t name "time" nooutput
stats HO1_C1 using rx_r name "HO1C1" nooutput
stats HO1_C2 using rx_r name "HO1C2" nooutput
stats HO1_C4 using rx_r name "HO1C4" nooutput
stats HO1_C8 using rx_r name "HO1C8" nooutput
stats HO4_C1 using rx_r name "HO4C1" nooutput
stats HO4_C2 using rx_r name "HO4C2" nooutput
stats HO4_C4 using rx_r name "HO4C4" nooutput
stats HO4_C8 using rx_r name "HO4C8" nooutput
max = HO1C1_max; 
min = HO1C1_min; 

if (HO1C2_max > max) max = HO1C2_max;
if (HO1C4_max > max) max = HO1C4_max;
if (HO1C8_max > max) max = HO1C8_max;

if (HO4C1_max > max) max = HO4C1_max;
if (HO4C2_max > max) max = HO4C2_max;
if (HO4C4_max > max) max = HO4C4_max;
if (HO4C8_max > max) max = HO4C8_max;

if (HO1C2_min < min) min = HO1C2_min;
if (HO1C4_min < min) min = HO1C4_min;
if (HO1C8_min < min) min = HO1C8_min;

if (HO4C1_min < min) min = HO4C1_min;
if (HO4C2_min < min) min = HO4C2_min;
if (HO4C4_min < min) min = HO4C4_min;
if (HO4C8_min < min) min = HO4C8_min;

y1 = 0; y2 = 10; y3 = floor(min); y4 = floor(max+5)
bm = 0.15
lm = 0.2
rm = 0.95
gap = 0.03
size = 0.75
kk=0.1

set style fill solid 0.75 border -1
set style boxplot
set style data boxplot 
set boxwidth 0.25 absolute
    set xtics ("1" 1, "" 2, "" 3, "2" 4, "" 5, "" 6, "4" 7, "" 8, "" 9, "8" 10, "" 11) scale 0.0
set xtics font ", ".fontTickSize offset char 4,-0.5

set xlabel "".xTitle font ", ".fontAxisTitle offset 0,-2

set lmargin at screen lm
set rmargin at screen rm
set bmargin at screen bm  

# Check if y-axis should be split.
if (y2 > y3 || abs(y3 - y2) < 20) {
    y4 = (floor(y4/10)*10)

    set yrange[y1:105]
    set key horizontal top center font ", ".fontKeySize

    set ylabel "".yTitle font ", ".fontAxisTitle offset -2,0
    set ytics font ", ".fontTickSize
    set tmargin at screen bm + size
    # set label "".plotTitle font ", ".fontAxisTitle at screen 0.52,0.95 center front
} else {
    set multiplot
    set xtics nomirror
    set ytics nomirror
    set ytics 0,10,10 font ", ".fontTickSize
    set border 1+2+8
    set tmargin at screen bm + size * kk
    y2 = (floor(y2/10)*10)

    set yrange[y1:y2]
    set xtics ("1" 1, "" 2, "" 3, "2" 4, "" 5, "" 6, "4" 7, "" 8, "" 9, "8" 10, "" 11) scale 0.0

    plot \
    HO4_C1 using (1):(0) title 'HO Naive' lw lineWidth lc rgb HO4_COLOR,\
    HO1_C1 using (2):(0) title 'HO Flow size' lw lineWidth lc rgb HO1_COLOR,\
    HO1_C1 using (3):(0) notitle,\
    HO1_C1 using (4):(0) notitle,\
    HO1_C1 using (5):(0) notitle,\
    HO1_C1 using (6):(0) notitle,\
    HO1_C1 using (7):(0) notitle,\
    HO1_C1 using (8):(0) notitle,\
    HO1_C1 using (9):(0) notitle,\
    HO1_C1 using (10):(0) notitle,\
    HO1_C1 using (11):(0) notitle

    unset xtics
    unset xlabel
    set xtics nomirror
    set ytics nomirror
    y3 = (floor(y3/10) * 10)
    y4 = (floor(y4/10) * 10)

    if(y4 / y3 < 10){
        set ytics y3, 10, y4 font ", ".fontTickSize
    } else {
        set ytics y3, y4/y3, y4 font ", ".fontTickSize
    }

    set key horizontal top center font ", ".fontKeySize
    set yrange [y3:105]

    set ylabel "".yTitle font ", ".fontAxisTitle offset -5,0
    set style fill solid 0.75 border -1
    set style boxplot
    set style data boxplot 
    set xtics ("" 1, "" 2, "" 3, "" 4, "" 5, "" 6, "" 7, "" 8, "" 9, "" 10, "" 11) scale 0.0

    set border 2+4+8
    set bmargin at screen bm + size * kk + gap
    set tmargin at screen bm + size + gap
    # set label "".plotTitle font ", ".fontAxisTitle at screen 0.52,0.98 center front
    unset key 
}

# Used to print ledgend outside of graph if needed 
# set key outside center bottom font ",20" 
set key horizontal top center font ", ".fontKeySize

plot \
    HO4_C1 using (1):rx_r title 'HO Naive' lw lineWidth lc rgb HO4_COLOR,\
    HO1_C1 using (2):rx_r title 'HO Flow size' lw lineWidth lc rgb HO1_COLOR,\
    HO4_C2 using (4):rx_r notitle lw lineWidth lc rgb HO4_COLOR,\
    HO1_C2 using (5):rx_r notitle lw lineWidth lc rgb HO1_COLOR,\
    HO4_C4 using (7):rx_r notitle lw lineWidth lc rgb HO4_COLOR,\
    HO1_C4 using (8):rx_r notitle lw lineWidth lc rgb HO1_COLOR,\
    HO4_C8 using (10):rx_r notitle lw lineWidth lc rgb HO4_COLOR,\
    HO1_C8 using (11):rx_r notitle lw lineWidth lc rgb HO1_COLOR,\

unset multiplot
