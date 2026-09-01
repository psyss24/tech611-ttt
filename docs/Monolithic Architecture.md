# Monolithic Architecture

![[Pasted image 20260825103130.png]]
- hard to refactor and change without rewriting
- even though they may have been seperated into diff components, they would have had high coupling and very meshed together
	
	 ![[Screenshot 2026-08-25 at 10.35.37.png]]
	- load balancer sits infront of mult servers and decide which to send traffic to
	- concurrency issues -> synchronising the data between different servers 
	- less complexity to troubleshoot
	- easiest to deploy
	- simpler to monitor/update
	- can't scale


