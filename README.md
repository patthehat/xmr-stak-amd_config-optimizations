# xmr-stat-amd_optimizations
Perl Script for automatic testing of different intensity and workersize numbers for xmr-stat-amd miner.

Due to System function calling Windows functions currently only works on Windows, has to be edited for Linux. 

Results are saved in results.txt

Needs Perl installed (i.e. Strawberry Perl for Windows)

Only the optimizations.pl script is needed. It works on a preconfigured config file with verbosity level 4 and hashrate report set to 30s or less. The script needs to be launched via cmd.exe. Put the script into the same folder that xmr-stak-amd.exe is in, open cmd.exe, enter "cd Your:\Path\To\Xmr-Stak", start the script by writing "optimizations.pl".
