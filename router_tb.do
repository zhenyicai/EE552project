vsim -gui work.router_tb -novopt
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate {/router_tb/intf[0]/data}
add wave -noupdate {/router_tb/intf[1]/data}
add wave -noupdate {/router_tb/intf[2]/data}
add wave -noupdate {/router_tb/intf[3]/data}
add wave -noupdate {/router_tb/intf[4]/data}
add wave -noupdate {/router_tb/intf[5]/data}

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
configure wave -namecolwidth 246
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits fs
update
WaveRestoreZoom {0 fs} {836 fs}

run -all