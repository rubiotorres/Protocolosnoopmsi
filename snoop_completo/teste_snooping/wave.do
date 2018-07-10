view wave 
wave clipboard store
wave create -driver freeze -pattern repeater -initialvalue zzzzzzz -period 50ps -sequence { 1001000 zzzzzzz zzzzzzz 1111011 zzzzzzz  } -repeat forever -range 6 0 -starttime 0ps -endtime 1000ps sim:/snoopinstance/Inst 
WaveExpandAll -1
wave modify -driver freeze -pattern repeater -initialvalue zzzzzzz -period 100ps -sequence { 1001000 zzzzzzz zzzzzzz 1111011 zzzzzzz  } -repeat forever -range 6 0 -starttime 0ps -endtime 1000ps Edit:/snoopinstance/Inst 
wave create -driver freeze -pattern clock -initialvalue HiZ -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/snoopinstance/clk 
WaveCollapseAll -1
wave clipboard restore
