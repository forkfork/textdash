return [[
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
<div class="fancy-line">Simple log aggregation with curl + netcat</div>

<tr valign=middle>

  <td valign=middle>
  <span class=blurb><br>
<font color=blue># first register an account</font><br>
curl -H "org: mycompany" http://textdash.xyz/register/me@mycompany.com<br>
<font color=green>account created, API key is 'b8e696f4bb'</font><br><br>
<font color=blue># lets start logging</font><br>
ssh appserver<br>
cd /app/logs<br>
{ echo "mycompany myapi b8e696f4bb" ; tail -F app.log ; } | nc textdash.xyz 5052<br><br>
<span class=blurb>
<font color=blue># look at the last 20 log lines</font><br>curl -H "key: b8e696f4bb" http://textdash.xyz/mycompany/myapi<br>
<font color=green>
2016-07-02 20:52:39 DEBUG errorLine:200 - A log line<br>
2016-07-02 20:52:39 DEBUG errorLine:201 - Another log line<br><br>
</font>
<font color=blue># stream logs to terminal</font><br>
curl -H "key: b8e696f4bb" -H "accept: text/event-stream" http://textdash.xyz/mycompany/myapi<br>
<font color=green> 2016-07-02 20:52:39 This connection is held open<br><br> </font>

<font color=blue># - HTTP POST to a dashboard to append, PUT to a dashboard to set the whole dashboard</font><br>
<font color=blue># - coming soon: HTTPS, log retention, remote log grepping</font><br>
<font color=blue># - this is currently on HTTP, don't send super secret data</font><br><br>
<font color=blue># contact: timothydowns@gmail.com</font>
<tr>
  <td>

</table>
</body>]]
