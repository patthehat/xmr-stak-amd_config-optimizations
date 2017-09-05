# xmr-stat-amd_optimizations
Perl Script for automatic testing of different intensity and workersize numbers for xmr-stat-amd miner. It applies settings to config.txt, starts the miner, waits 40 sec, kills it, reads the log.txt, deletes it afterwards and saves last 10s hashrate in result.txt

Due to System function calling Windows functions currently only works on Windows, has to be edited for Linux. 

Results are saved in results.txt

Needs Perl installed (i.e. Strawberry Perl for Windows)

Only the optimizations.pl script is needed. It works ONLY on a preconfigured config file with **verbosity level 4** and **hashrate report set to 30s or less** (I have it set to 10s to filter out first seconds). 

The script needs to be launched via cmd.exe. Put the script into the same folder that xmr-stak-amd.exe is in, open cmd.exe, enter "cd Your:\Path\To\Xmr-Stak", start the script by writing "optimizations.pl".

Currently the miner is opened in a new window which takes focus. This can be a bit annoying. If you have a solution I'd greatly appreciate it.
