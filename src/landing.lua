
<link href='//fonts.googleapis.com/css?family=Raleway:400,300,600' rel='stylesheet' type='text/css'>

<style>
td {
  font-family: Raleway;
  font-size: 30pt;
}
body{
    background #ffffff;
}

div.fancy-line {
    border-bottom:1px solid rgba(136,136,136,0.75);
    position:relative;
    background-color:#ffffff;
}

div.fancy-line:before,
div.fancy-line::before {
    display:inline-block;
    content:' ';
    position:absolute;
    z-index:-1;
    width:45%;
    height:1px;
    left:5%;
    bottom:1px;
    background-color:transparent;
    box-shadow:0px 2px 4px black;
    -webkit-transform:matrix(1,0.01,0,1,0,0);
    -webkit-transform-origin:bottom center;
    -moz-transform:matrix(1,0.01,0,1,0,0);
    -moz-transform-origin:bottom center;
    -ms-transform:matrix(1,0.01,0,1,0,0);
    -ms-transform-origin:bottom center;
    -o-transform:matrix(1,0.01,0,1,0,0);
    -o-transform-origin:bottom center;
    transform:matrix(1,0.01,0,1,0,0);
    transform-origin:bottom center;
}

div.fancy-line:after,
div.fancy-line::after {
    display:inline-block;
    content:' ';
    position:absolute;
    z-index:-1;
    width:45%;
    height:1px;
    right:5%;
    bottom:1px;
    background-color:transparent;
    box-shadow:0px 2px 4px black;
    -webkit-transform:matrix(1,-0.01,0,1,0,0);
    -webkit-transform-origin:bottom center;
    -moz-transform:matrix(1,-0.01,0,1,0,0);
    -moz-transform-origin:bottom center;
    -ms-transform:matrix(1,-0.01,0,1,0,0);
    -ms-transform-origin:bottom center;
    -o-transform:matrix(1,-0.01,0,1,0,0);
    -o-transform-origin:bottom center;
    transform:matrix(1,-0.01,0,1,0,0);
    transform-origin:bottom center;
}
.blurb {
  font-family: Courier New;
  font-size: 14pt;
  
}
</style>
<script language="javascript">
function register() {
  var person = prompt("Please enter your email address:", "@");
  var orgname = prompt("Please enter your account name:", "");
  window.location = "/register/person/orgname";
}
</script>
<body>
<table align="center" style="margin: 0px auto;" width="80%">
<tr>
  <td>
<div class="fancy-line">Zero-Hassle Log Aggregation</div>

<tr valign=middle>

  <td valign=middle>
  <span class=blurb><br>
<font color=blue># first register an account</font><br>
curl -H "org: mycompany" http:<a class="__cf_email__" href="/cdn-cgi/l/email-protection" data-cfemail="80afaff4e5f8f4e4e1f3e8aef8f9faaff2e5e7e9f3f4e5f2afede5c0edf9e3efedf0e1eef9aee3efed">[email&#160;protected]</a><script data-cfhash='f9e31' type="text/javascript">/* <![CDATA[ */!function(t,e,r,n,c,a,p){try{t=document.currentScript||function(){for(t=document.getElementsByTagName('script'),e=t.length;e--;)if(t[e].getAttribute('data-cfhash'))return t[e]}();if(t&&(c=t.previousSibling)){p=t.parentNode;if(a=c.getAttribute('data-cfemail')){for(e='',r='0x'+a.substr(0,2)|0,n=2;a.length-n;n+=2)e+='%'+('0'+('0x'+a.substr(n,2)^r).toString(16)).slice(-2);p.replaceChild(document.createTextNode(decodeURIComponent(e)),c)}p.removeChild(t)}}catch(u){}}()/* ]]> */</script><br>
<font color=green>account created, API key is 'b8e696f4bb'</font><br><br>
<font color=blue># lets start logging</font><br>
ssh appserver<br>
cd /app/logs<br>
{ echo "mycompany myapi" ; tail -F app.log ; } | nc textdash.xyz 5052<br><br>
<span class=blurb>
<font color=blue># look at the last 20 log lines</font><br>curl -H "key: b8e696f4bb" http://textdash.xyz/mycompany/myapi<br>
<font color=green>
2016-07-02 20:52:39 DEBUG errorLine:200 - A log line<br>
2016-07-02 20:52:39 DEBUG errorLine:201 - Another log line<br><br>
</font>
<font color=blue># stream logs to terminal</font><br>
curl -H "key: b8e696f4bb" -H "accept: text/event-stream" http://textdash.xyz/mycompany/myapi<br>
<font color=green> 2016-07-02 20:52:39 This connection is held open<br><br> </font>

<font color=blue># coming soon: HTTPS, log retention, remote log grepping</font><br><br>
<font color=blue># contact: <a class="__cf_email__" href="/cdn-cgi/l/email-protection" data-cfemail="52263b3f3d263a2b363d253c2112353f333b3e7c313d3f">[email&#160;protected]</a><script data-cfhash='f9e31' type="text/javascript">/* <![CDATA[ */!function(t,e,r,n,c,a,p){try{t=document.currentScript||function(){for(t=document.getElementsByTagName('script'),e=t.length;e--;)if(t[e].getAttribute('data-cfhash'))return t[e]}();if(t&&(c=t.previousSibling)){p=t.parentNode;if(a=c.getAttribute('data-cfemail')){for(e='',r='0x'+a.substr(0,2)|0,n=2;a.length-n;n+=2)e+='%'+('0'+('0x'+a.substr(n,2)^r).toString(16)).slice(-2);p.replaceChild(document.createTextNode(decodeURIComponent(e)),c)}p.removeChild(t)}}catch(u){}}()/* ]]> */</script><br>
<tr>
  <td>

</table>
</body>


