# Create a new simulator instance
set ns [new Simulator]

# Create output files for NAM and trace
set namf [open stop_wait_protocol.nam w]
$ns namtrace-all $namf

set trf [open stop_wait_protocol.tr w]
$ns trace-all $trf

# Define the finishing procedure
proc finish {} {
    global ns namf trf
    $ns flush-trace
    close $namf
    close $trf
    exec nam stop_wait_protocol.nam &
    exit 0
}

# Create nodes
set n0 [$ns node]
set n1 [$ns node]

# Set up duplex link and queue limits between nodes
$ns duplex-link $n0 $n1 0.2Mb 200ms DropTail
$ns duplex-link-op $n0 $n1 orient right
$ns queue-limit $n0 $n1 10

# Define TCP agent and sink
set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]

# Attach agents to nodes
$ns attach-agent $n0 $tcp
$ns attach-agent $n1 $sink
$ns connect $tcp $sink

# Create FTP application and attach it to the TCP agent
set ftp [new Application/FTP]
$ftp attach-agent $tcp

# Configure Stop-and-Wait protocol parameters
$tcp set window_ 1
$tcp set maxcwnd_ 1

# Uncomment these lines for sliding window instead of Stop-and-Wait
# $tcp set windowInit_ 4
# $tcp set maxcwnd_ 4

# Enable NAM trace for TCP
$tcp set nam_tracevar_ true
$ns add-agent-trace $tcp tcp
$ns monitor-agent-trace $tcp
$tcp tracevar cwnd_

# Schedule events
$ns at 0.1 "$ftp start"                  ;# Start FTP at 0.1s
$ns at 3.0 "$ns detach-agent $n0 $tcp"   ;# Detach TCP agent at 3.0s
$ns at 3.0 "$ns detach-agent $n1 $sink"  ;# Detach TCPSink agent at 3.0s
$ns at 3.5 "$ftp stop"                   ;# Stop FTP at 3.5s
$ns at 5.0 "finish"                      ;# Finish simulation at 5.0s

# Run the simulation
$ns run
