# xmr-stak-amd_optimizations
Perl Script for automatic testing of different intensity and workersize numbers for xmr-stak-amd miner. It applies settings to config.txt, starts the miner, waits 40 sec, **kills all programs with the name xmr-stak-amd.exe**, reads the log.txt, deletes it afterwards and saves last 10s hashrate in result.txt

Due to System function calling Windows functions currently only works on Windows, has to be edited for Linux. 

Results are saved in results.txt

Needs Perl installed (i.e. Strawberry Perl for Windows) and the Win32 Module (install via CPAN, type "install Module::Win32")

Only the optimizations.pl script is needed. It works ONLY on a preconfigured config file with **verbosity level 4** and **hashrate report set to 30s or less** (I have it set to 10s to filter out first seconds). Also spaces have to be removed from intensity and workers so that it reads 'intensity":x,' and '"worksize":y'.

The script needs to be launched via cmd.exe. Put the script into the same folder that xmr-stak-amd.exe is in, open cmd.exe, enter "cd Your:\Path\To\Xmr-Stak", start the script by writing "optimizations.pl".
