cfgimpy
=======

A simple ColdFusion based XMPP bot
This is a bot I built many years ago, many of the ideas were from Sean Corfields IRC bot: http://corfield.org/blog/index.cfm/do/blog.entry/entry/IRCBot_Event_Gateway_Now_Available

While moving applications over to Railo, I discovered Railo does not have native support for XMPP/Jabber gateways. But they're surprisingly easy to implement. This gateway uses the Smack library http://www.igniterealtime.org/projects/smack/index.jsp - many of the functions are left out, though they may be implemented later.

For the people specifically looking for the Railo custom gateway bits, check in WEB-INF/:

https://github.com/sigmaprojects/cfgimpy/blob/master/WEB-INF/railo/components/railo/extension/gateway/XMPPClientGateway.cfc

https://github.com/sigmaprojects/cfgimpy/blob/master/WEB-INF/railo/context/admin/gdriver/XMPPClient.cfc

https://github.com/sigmaprojects/cfgimpy/tree/master/WEB-INF/railo/lib

=
Recently conveted the entire app to ColdBox using CB's remote proxy support.
Individual commands are implemented as modules now, see hello-command and time-command for basic examples.
