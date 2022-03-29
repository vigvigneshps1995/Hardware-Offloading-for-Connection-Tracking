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
lb_color = "#00ad57"
bf_color = "#d90073"
ho_color = "#ffc380" 

fontTickSize    = 21
fontAxisTitle   = 21
fontKeySize     = 21
lineWidth       = 3
pointIntensity  = 10

# Titles
xTitle = "CPU Core count"
yTitle = "Throughput (Gbps)"
# plotTitle = gprintf("Throughput vs CPU core count\n\n{/*0.85 (Hash table %gM entries", HT).gprintf(", %gM rules, 2M Flows, Table 0)}", RULE)

# File names defined BF
BF_C1 = sprintf("data/%s-BF-c1-F%s-avg.csv", TIME_BF, FLOW_COUNT) # BF_C1 = sprintf("data/%s-BF-c1-F%s.csv", TIME_BF, FLOW_COUNT)  
BF_C2 = sprintf("data/%s-BF-c2-F%s-avg.csv", TIME_BF, FLOW_COUNT) # BF_C2 = sprintf("data/%s-BF-c2-F%s.csv", TIME_BF, FLOW_COUNT)  
BF_C4 = sprintf("data/%s-BF-c4-F%s-avg.csv", TIME_BF, FLOW_COUNT) # BF_C4 = sprintf("data/%s-BF-c4-F%s.csv", TIME_BF, FLOW_COUNT)  
BF_C8 = sprintf("data/%s-BF-c8-F%s-avg.csv", TIME_BF, FLOW_COUNT) # BF_C8 = sprintf("data/%s-BF-c8-F%s.csv", TIME_BF, FLOW_COUNT)  

# File names defined LB
LB_C1 = sprintf("data/%s-LB-c1-ht%sM-T1-F%s-avg.csv", TIME_LB, HT_SIZE, FLOW_COUNT) # LB_C1 = sprintf("data/%s-LB-c1-ht%sM-T1-F%s.csv", TIME_LB, HT_SIZE, FLOW_COUNT) 
LB_C2 = sprintf("data/%s-LB-c2-ht%sM-T1-F%s-avg.csv", TIME_LB, HT_SIZE, FLOW_COUNT) # LB_C2 = sprintf("data/%s-LB-c2-ht%sM-T1-F%s.csv", TIME_LB, HT_SIZE, FLOW_COUNT) 
LB_C4 = sprintf("data/%s-LB-c4-ht%sM-T1-F%s-avg.csv", TIME_LB, HT_SIZE, FLOW_COUNT) # LB_C4 = sprintf("data/%s-LB-c4-ht%sM-T1-F%s.csv", TIME_LB, HT_SIZE, FLOW_COUNT) 
LB_C8 = sprintf("data/%s-LB-c8-ht%sM-T1-F%s-avg.csv", TIME_LB, HT_SIZE, FLOW_COUNT) # LB_C8 = sprintf("data/%s-LB-c8-ht%sM-T1-F%s.csv", TIME_LB, HT_SIZE, FLOW_COUNT) 

# File names defined HO 
HO_C1 = sprintf("data/%s-LBwHO-c1-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, HT_SIZE, OFF_SCHEME, FLOW_COUNT, RUN) # HO_C1 = sprintf("data/%s-LBwHO-c1-ht%sM-1M-R%s-T1-F%s-#%s.csv", TIME_HO, HT_SIZE, OFF_SCHEME, FLOW_COUNT, RUN)
HO_C2 = sprintf("data/%s-LBwHO-c2-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, HT_SIZE, OFF_SCHEME, FLOW_COUNT, RUN) # HO_C2 = sprintf("data/%s-LBwHO-c2-ht%sM-1M-R%s-T1-F%s-#%s.csv", TIME_HO, HT_SIZE, OFF_SCHEME, FLOW_COUNT, RUN)
HO_C4 = sprintf("data/%s-LBwHO-c4-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, HT_SIZE, OFF_SCHEME, FLOW_COUNT, RUN) # HO_C4 = sprintf("data/%s-LBwHO-c4-ht%sM-1M-R%s-T1-F%s-#%s.csv", TIME_HO, HT_SIZE, OFF_SCHEME, FLOW_COUNT, RUN)
HO_C8 = sprintf("data/%s-LBwHO-c8-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, HT_SIZE, OFF_SCHEME, FLOW_COUNT, RUN) # HO_C8 = sprintf("data/%s-LBwHO-c8-ht%sM-1M-R%s-T1-F%s-#%s.csv", TIME_HO, HT_SIZE, OFF_SCHEME, FLOW_COUNT, RUN)

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

stats BF_C1 using rx_r name "BF1" nooutput
stats BF_C2 using rx_r name "BF2" nooutput
stats BF_C4 using rx_r name "BF4" nooutput
stats BF_C8 using rx_r name "BF8" nooutput
stats LB_C1 using rx_r name "LB1" nooutput
stats LB_C2 using rx_r name "LB2" nooutput
stats LB_C4 using rx_r name "LB4" nooutput
stats LB_C8 using rx_r name "LB8" nooutput
max = LB1_max; 
min = LB1_min; 

if (LB2_max > max) max = LB2_max;
if (LB4_max > max) max = LB2_max;
if (LB8_max > max) max = LB8_max;

if (BF1_max > max) max = BF1_max;
if (BF2_max > max) max = BF2_max;
if (BF4_max > max) max = BF2_max;
if (BF8_max > max) max = BF8_max;

if (LB2_min < min) min = LB4_min;
if (LB4_min < min) min = LB4_min;
if (LB8_min < min) min = LB8_min;

if (BF1_min < min) min = BF1_min;
if (BF2_min < min) min = BF2_min;
if (BF4_min < min) min = BF4_min;
if (BF8_min < min) min = BF8_min;

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
set xtics ("" 1, "1" 2, "" 3, "" 4, "" 5, "2" 6, "" 7, "" 8, "" 9, "4" 10, "" 11, "" 12, "" 13, "8" 14, "" 15) scale 0.0
set xtics font ", ".fontTickSize offset char 0,-0.5

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
    set xtics ("" 1, "1" 2, "" 3, "" 4, "" 5, "2" 6, "" 7, "" 8, "" 9, "4" 10, "" 11, "" 12, "" 13, "8" 14, "" 15) scale 0.0

    plot \
    BF_C1 using (1):(0) title 'BF' lw lineWidth lc rgb bf_color,\
    LB_C1 using (2):(0) title 'LB' lw lineWidth lc rgb lb_color,\
    HO_C1 using (3):(0) title 'HO' lw lineWidth lc rgb ho_color,\
    LB_C1 using (5):(0) notitle,\
    LB_C1 using (6):(0) notitle,\
    LB_C1 using (7):(0) notitle,\
    LB_C1 using (9):(0) notitle,\
    LB_C1 using (10):(0) notitle,\
    LB_C1 using (11):(0) notitle,\
    LB_C1 using (13):(0) notitle,\
    LB_C1 using (14):(0) notitle,\
    LB_C1 using (15):(0) notitle

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
    set xtics ("" 1, "" 2, "" 3, "" 4, "" 5, "" 6, "" 7, "" 8, "" 9, "" 10, "" 11, "" 12, "" 13, "" 14, "" 15) scale 0.0

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
BF_C1 using (1):rx_r title 'BF' lw lineWidth lc rgb bf_color,\
LB_C1 using (2):rx_r title 'LB' lw lineWidth lc rgb lb_color,\
HO_C1 using (3):rx_r title 'HO' lw lineWidth lc rgb ho_color,\
BF_C2 using (5):rx_r notitle lw lineWidth lc rgb bf_color,\
LB_C2 using (6):rx_r notitle lw lineWidth lc rgb lb_color,\
HO_C2 using (7):rx_r notitle lw lineWidth lc rgb ho_color,\
BF_C4 using (9):rx_r notitle lw lineWidth lc rgb bf_color,\
LB_C4 using (10):rx_r notitle lw lineWidth lc rgb lb_color,\
HO_C4 using (11):rx_r notitle lw lineWidth lc rgb ho_color,\
BF_C8 using (13):rx_r notitle lw lineWidth lc rgb bf_color,\
LB_C8 using (14):rx_r notitle lw lineWidth lc rgb lb_color,\
HO_C8 using (15):rx_r notitle lw lineWidth lc rgb ho_color,\

unset multiplot
