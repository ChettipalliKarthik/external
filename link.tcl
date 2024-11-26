# Initialize the simulator
set ns [new Simulator]

# Enable Link State routing protocol
$ns rtproto LS

# Create nodes
set node1 [$ns node]

# Trace files
set tf [open out.tr w]
$ns trace-all $tf
set nf [open out.nam w]
$ns namtrace-all $nf

# Assign labels and colors to nodes
$node1 label "node 1"

$node1 label-color blue

# Create duplex links between nodes
$ns duplex-link $node1 $node2 1.5Mb 10ms DropTail

# Define link orientations
$ns duplex-link-op $node1 $node2 orient left-down

# Define TCP connection
set tcp2 [new Agent/TCP]
$ns attach-agent $node1 $tcp2

set sink2 [new Agent/TCPSink]
$ns attach-agent $node4 $sink2

$ns connect $tcp2 $sink2

# Attach FTP application to TCP
set traffic_ftp2 [new Application/FTP]
$traffic_ftp2 attach-agent $tcp2

# Finish procedure
proc finish {} {
    global ns nf tf
    $ns flush-trace
    close $nf
    close $tf
    exec nam out.nam &
    exit 0
}

# Schedule events
$ns at 0.5 "$traffic_ftp2 start"
$ns rtmodel-at 1.0 down $node2 $node3
$ns rtmodel-at 2.0 up $node2 $node3
$ns at 3.0 "$traffic_ftp2 stop"
$ns at 5.0 "finish"

# Run the simulation
$ns run
