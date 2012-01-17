<html>
<head>
<title>Server Status Checker</title>
</head>
<body color="#FFFFFF" bgcolor="#000000">

<?
function getServerStatus($site, $port, $timeout=5) {
  $fp = fsockopen($site, $port, $errno, $errstr, $timeout);
	if ($fp) { //IF ONLINE
		echo "$site is <font color='#FF0000'>Online</font>";
	} else { //IF OFFLINE
		echo "$site is <font color='#00FF00'>Offline</font>";
	}
}
getServerStatus('mywebsite.com', 80); //Change it to your Server's IP Address or Hostname
?>

</body>
</html>