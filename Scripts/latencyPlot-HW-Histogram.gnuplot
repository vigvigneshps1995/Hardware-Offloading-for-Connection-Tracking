# Plot latency over time (boxplot). 
# Arguments defined from command line. 
TIME_BF     = ARG1  # Time of basic forwarder files, format: 2021-10-10T0910
TIME_LB     = ARG2  # Time of loadbalancer files, format: 2021-10-10T0910
TIME_HO     = ARG3  # Time of hw files files, format: 2021-10-10T0910
HT_SIZE     = ARG4  # Hash table size, e.g. 2. 
FLOW_COUNT  = ARG5
OFF_SCHEME  = ARG6
RUN         = ARG7

# Columns defined: Time, TxCount, RxCount, TxRate, RxRate, PacketLoss, LAT, LAT95, LAT99
TIME        = 1;
TX_COUNT    = 2; RX_COUNT    = 3;
TX_RATE     = 4; RX_RATE     = 5;
PKT_LOSS    = 6;
LAT         = 7; LAT95       = 8; LAT99       = 9;

# Font sizes
plotTitleSize   = 34
fontTickSize    = 21
fontLegendSize  = 21
fontAxisTitle   = 21
lineWidth       = 3

# Titles
xTitle      = "CPU Core count"
yTitle      = "Latency (ns)"
# plotTitle   = gprintf("Average latency per CPU core count\n\n{/*0.85 (Hash table %gM entries", HT_SIZE).gprintf(", %gM rules, 2M Flows, Table 1)", RULE_COUNT)

# Categories
CLASS_COLOR      = '#2c7fb8 #ffc380'
CLASS_CORE       = '1 2 4 8'
CLASS_TYPE       = 'LBwHO LBwHO'
CLASS_TYPE_TITLE = '"HO 1" "HO 4"'

# Output
set terminal postscript size 12,12 portrait enhanced background rgb 'white' color dashed lw 1 "cmr,12"
set output sprintf("%s_LATENCY_TEST-HT%sM_F%s.ps", TIME_BF, HT_SIZE, FLOW_COUNT)
set datafile separator ","

## User Defined Functions ##
Colors(n)       = sprintf("%s", word(CLASS_COLOR, n))
Type_Name(n)    = sprintf("%s", word(CLASS_TYPE_TITLE, n))
Average(n)      = sprintf("%s", word(AVGS, n))+0

# Here you go, have some cursed ternary function nesting. Enjoy.
File(n, m)      = (m == 1) ? HO1_FILE(n) : HO4_FILE(n)
HO1_FILE(n)     = sprintf("data/%s-%s-c%s-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, word(CLASS_TYPE, 1), word(CLASS_CORE, n), HT_SIZE, "1", FLOW_COUNT, RUN)
HO4_FILE(n)     = sprintf("data/%s-%s-c%s-ht%sM-1M-R%s-T1-F%s-#%s-avg.csv", TIME_HO, word(CLASS_TYPE, 1), word(CLASS_CORE, n), HT_SIZE, "4", FLOW_COUNT, RUN)
XticGroup(n)    = sprintf("%s", word(CLASS_CORE,n))

# Extra styling
set lmargin at screen 0.15
set tmargin at screen 0.95
set bmargin at screen 0.13
set rmargin at screen 0.90
set boxwidth 0.25 absolute
set style fill solid 0.75 border -1
set tics font ", ".fontTickSize
set xtics nomirror
set ytics nomirror
set xtics offset char 4,-0.5

# Legend
set key horizontal top center font ", ".fontLegendSize

# Time to do the plotting ...
CORES   = words(CLASS_CORE)
TYPES   = words(CLASS_TYPE)
PosX    = 0
x       = 0
y       = 0

set xlabel "".xTitle font ", ".fontAxisTitle offset 0,-1
set ylabel "".yTitle font ", ".fontAxisTitle offset -2,0

AVGS = ""
max_avg = 0; 
do for [n=1:CORES] { do for [m=1:TYPES] { 
    stats File(n, m) using LAT name "STAT" nooutput; 
    if (STAT_mean > max_avg) {
        max_avg = STAT_mean;
    }

    AVGS = AVGS.sprintf("%.3f ", STAT_mean)
}}

set xtics ("1" 1, "" 2, "" 3, "2" 4, "" 5, "" 6, "4" 7, "" 8, "" 9, "8" 10, "" 11) scale 0.0
set yrange[0:(max_avg*1.2)]


plot \
    File(1, 1) u (1):(y=Average(1)) ti 'HO, Flow size' w boxes lc rgb Colors(1),\
    File(1, 2) u (2):(y=Average(2)) ti 'HO, Naive' w boxes lc rgb Colors(2),\
    File(2, 1) u (4):(y=Average(3)) notitle w boxes lc rgb Colors(1),\
    File(2, 2) u (5):(y=Average(4)) notitle w boxes lc rgb Colors(2),\
    File(3, 1) u (7):(y=Average(5)) notitle w boxes lc rgb Colors(1),\
    File(3, 2) u (8):(y=Average(6)) notitle w boxes lc rgb Colors(2),\
    File(4, 1) u (10):(y=Average(7)) notitle w boxes lc rgb Colors(1),\
    File(4, 2) u (11):(y=Average(8)) notitle w boxes lc rgb Colors(2)
