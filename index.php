<html>
Working Webserver :)
<pre>
<?php
$result=shell_exec("/sbin/ifconfig");
echo "<pre>".$result."</pre>";
?>
</pre>
</html>
