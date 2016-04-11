# DNS Registrar Checker

This is a basic, hacked together Perl script to check domain registrar information to ensure DNS for your domain has not been hijacked. I wrote the script a while ago in Perl and, since it works great, I haven't bothered to change it.

There are a few key things to note:

* You'll need to adjust some of the variables to fit your environment (e.g., domains, allowed IPs for DNS servers, etc.).
* I recommend that this run on a server or something where you can schedule it via cron to run at regular intervals.
* I recommend that you include administrative emails for notification that are not part of the domains this script.
* If possible, run this from a server that can utilize split DNS to avoid any potential issues if the admin domains are hijacked.

Again, this is a quickly hacked-together script but it works.

Enjoy.
