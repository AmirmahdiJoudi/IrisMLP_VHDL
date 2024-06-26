onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /mlptest/clk
add wave -noupdate -format Logic /mlptest/rst
add wave -noupdate -format Logic /mlptest/done
add wave -noupdate -format Logic /mlptest/start
add wave -noupdate -format Literal -radix hexadecimal /mlptest/inbus
add wave -noupdate -format Literal -radix hexadecimal /mlptest/outbus
add wave -noupdate -color Red -format Logic -itemcolor Red /mlptest/setosa
add wave -noupdate -color {Midnight Blue} -format Logic -itemcolor {Midnight Blue} /mlptest/versicolor
add wave -noupdate -color Gold -format Logic -itemcolor Gold /mlptest/virginica
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7050 ns} 0}
configure wave -namecolwidth 241
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {9472 ns}
