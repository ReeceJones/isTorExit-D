import std.stdio: writeln;
import std.net.curl: byLine;
import std.string: strip;

bool[string] lookup;
immutable string exitLoc = "https://check.torproject.org/cgi-bin/TorBulkExitList.py?ip=8.8.8.8";

void loadExits()
{
	//we need to exlude comments
	foreach (ip; byLine(exitLoc))
		lookup[cast(string)ip] = (cast(char[])ip).strip[0] == '#' ? false : true; 
}

bool isExit(string ip)
{
	//check to see if the lookup string is present in the map
	if ((ip in lookup) !is null)
		return lookup[ip];
	return false;
}

int main(string[] args)
{
	if (args.length <= 1)
	{
		writeln("[error] no ips provided");
		return 1;
	}
	else
	{
		loadExits();
		foreach (ip; args[1..$])
		{
			writeln(ip, " is ", isExit(ip) == true ? "a tor exit!" : "not a tor exit.");
		}
	}
	return 0;
}
