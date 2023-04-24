---
date: "2008-02-01T23:21:00Z"
slug: egged-getter-0-1
aliases: ["/2008/02/01/egged-getter-0-1/"]
tags:
- software
title: Egged Getter 0.1
---

> The Egged Getter has been lost in the mists of time. However, it's code has
> largely been integrated into [TransportDroidIL]. An old version of the Python
> code has been pasted at the end of this post.

Here's a little something I've been messing with: A simple fetcher script for
the [Egged](http://www.egged.co.il) (Israeli bus company) site. I've made a
deskbar applet which uses it, which was fun to do :) (I'm looking for other
cool ideas to implement as deskbar applets)

You can get it at
[http://lutzky.net/files/egged_getter](http://lutzky.net/files/egged_getter).
The readme file includes installation instructions (...which involve placing
the two included scripts in
`~/.gnome2/deskbar-plugin/modules-2.20-compatible/`.

There's also a [git](http://git.or.cz) repository here:
[http://git.lutzky.net/?p=ohad/egged_getter.git](http://git.lutzky.net/?p=ohad/egged_getter.git).
I don't think I've mentioned git on the blog before... It's freaking awesome.
It made me really despise subversion :). Besides the abundance of information
on [the main site](http://git.or.cz), there's [an excellent (and very amusing)
talk by Linus about it](http://www.youtube.com/watch?v=4XpnKHJAok8). Also, I'm
giving a talk about it in Haifux - this coming Monday (February 4th), the Taub
building of the Technion, room 6, at 18:30.

[TransportDroidIL]: https://github.com/lutzky/TransportDroidIL

```python
#!/usr/bin/python
# coding: utf-8
import socket

try:
    from pyfribidi import log2vis
except ImportError:
    def log2vis(s): return s

# Original values which worked:
# User agent (a sane browser agent):
# USERAGENT="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9b2) Gecko/2007121016 Firefox/3.0b2"
# Session ID: Can be retrieved from the site, but seems to have a very long
# keepalive, and isn't checked anyway.
# SESSION_ID="thjbzmnrhrks3a55w1dymvnx"

BUF_LEN=2048
HOST='mslworld.egged.co.il'
PORT=80

DOUBLE_NEWLINE="\r\n\r\n"

USER_AGENT="EggedGetter"
SESSION_ID="0"

JSON_DATA="""{"str1":"%(query)s","strSession":"%(session_id)s"}"""

_payload="""POST /eggedtimetable/WebForms/wsUnicell.asmx/getAnswer HTTP/1.1
Host: mslworld.egged.co.il
User-Agent: %(user_agent)s
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-us,en;q=0.5
Accept-Charset: utf-8
Keep-Alive: 300
Connection: keep-alive
Content-Type: application/json; charset=utf-8
Referer: http://mslworld.egged.co.il/eggedtimetable/WebForms/wfrmMain.aspx?width=1280&state=3&taavura=0&language=he&freelang=
Content-Length: %(content_length)d
Cookie: ASP.NET_SessionId=%(session_id)s
Pragma: no-cache
Cache-Control: no-cache

%(json_data)s""".replace("\n","\r\n")

def build_json_data(query, session_id = SESSION_ID):
    """Build a JSON-formatted query for the egged site."""
    return JSON_DATA % {
            'query':query.replace('"','\\"').encode("utf-8"),
            'session_id':session_id,
            }

def build_request(query, session_id = SESSION_ID):
    """Build an HTTP request for the egged site."""

    json_data = build_json_data(query, session_id)

    return _payload % {
            'user_agent':USER_AGENT,
            'content_length':len(json_data),
            'session_id':session_id,
            'json_data':json_data,
            }

def send_query(query, session_id = SESSION_ID):
    """Prepare and send query to site. Returned data is raw."""

    http_data = build_request(query)

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((HOST,PORT))
    s.send(http_data)
    data = s.recv(BUF_LEN)
    s.close()
    return data

def clean_response_html(response,linebreak="\n",item="\n * "):
    if response[0] == response[-1] == '"': response = response[1:-1]
    BR = "\u003cbr\u003e"
    LI = "\u003cli\u003e"
    NBSP = "&nbsp"
    return response.replace(BR,linebreak) \
                   .replace(LI,item) \
                   .replace(NBSP," ") \
                   .replace("\\","")

def query_site(query):
    """Query the egged site with query"""
    site_response = send_query(query)
    returned_data = site_response.split(DOUBLE_NEWLINE)[1]

    try:
        cleaned_data = clean_response_html(returned_data)
    except:
        print "Error occured when trying to clean up the following response:"
        print "site_response:"
        print site_response
        print "returned_data:"
        print returned_data
        raise

    return unicode(cleaned_data, "utf-8")

if __name__ == '__main__':
    query = unicode(raw_input("Enter query for Egged site: "),"utf-8")
    result = query_site(query)

    print ""

    try:
        print log2vis(result)
    except UnicodeEncodeError:
        print log2vis(unicode.encode(result,"utf-8"))
```
