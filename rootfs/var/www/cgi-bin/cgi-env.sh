#!/bin/sh
. /lib/libtaz.sh

# Internationalization.
TEXTDOMAIN='slitaz-base'
. /etc/locale.conf
export TEXTDOMAIN LANG

. /usr/lib/slitaz/httphelper.sh
header

title=$(_ "CGI SHell Environment")
cat << EOT
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta charset="utf-8" />
	<title>$title</title>
	<link rel="stylesheet" type="text/css" href="../style.css" />
</head>
<body>

<!-- Header -->
<div id="header">
	<h1>$title</h1>
</div>

<!-- Content -->
<div id="content">

<p>$(_ "Welcome to the SliTaz web server CGI Shell environment. Let the \
power of SHell script meet the web! Here you can check HTTP info and try some \
requests.")</p>

<p>$(_ "Including /usr/lib/slitaz/httphelper.sh in your scripts lets you \
use PHP-like syntax such as: \$(GET var)")</p>

<p>$(_ "QUERY_STRING test:")
	<a href="$SCRIPT_NAME?var=value">$SCRIPT_NAME?var=value</a>
</p>


<h2>$(_ "HTTP Info")</h2>

<pre>$(httpinfo)</pre>


<!-- End content -->
</div>

</body>
</html>
EOT

exit 0
