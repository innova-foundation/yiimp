<!doctype html>
<html lang="en-US">
<head>
	<meta charset="utf-8">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

	<meta name="description" content="Cryptocurrency mining pool with auto profit switching and auto exchange">
	<meta name="keywords" content="mining,pool,bitcoin,altcoin,auto,switch,exchange,profit,crypto,stratum">

<?php

$pageTitle = empty($this->pageTitle) ? YAAMP_SITE_NAME : YAAMP_SITE_NAME." - ".$this->pageTitle;
echo '<title>'.$pageTitle.'</title>';

echo CHtml::cssFile("/extensions/jquery/themes/ui-lightness/jquery-ui.css");
echo CHtml::cssFile('/yaamp/ui/css/main.css');
echo CHtml::cssFile('/yaamp/ui/css/table.css');

$cs = app()->getClientScript();
$cs->registerCoreScript('jquery.ui');

echo "</head>";
