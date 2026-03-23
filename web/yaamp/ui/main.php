<?php

require('misc.php');
echo <<<END

<!doctype html>
<html lang="en-US">

<head>

<meta charset="utf-8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<meta name="description" content="Cryptocurrency mining pool with auto profit switching and auto exchange">
<meta name="keywords" content="mining,pool,bitcoin,altcoin,auto,switch,exchange,profit,crypto,stratum">

END;

$pageTitle = empty($this->pageTitle) ? YAAMP_SITE_NAME : YAAMP_SITE_NAME." - ".$this->pageTitle;

echo '<title>'.$pageTitle.'</title>';

echo CHtml::cssFile("/extensions/jquery/themes/ui-lightness/jquery-ui.css");
echo CHtml::cssFile('/yaamp/ui/css/main.css');
echo CHtml::cssFile('/yaamp/ui/css/table.css');

$cs = app()->getClientScript();
$cs->registerCoreScript('jquery.ui');

echo CHtml::scriptFile('/yaamp/ui/js/jquery.tablesorter.js');

echo "</head>";

///////////////////////////////////////////////////////////////

echo '<body class="page">';

showPageHeader();
showPageContent($content);
showPageFooter();

echo "</body></html>";
return;

/////////////////////////////////////////////////////////////////////

function showItemHeader($selected, $url, $name)
{
	if($selected) $selected_text = "class='selected'";
	else $selected_text = '';

	echo "<a $selected_text href='$url'>$name</a>";
}

function showPageHeader()
{
	echo '<nav class="tabmenu-out">';
	echo '<div class="tabmenu-inner">';

	echo '<a href="/" style="color: var(--text-primary); font-weight: 700; margin-right: 8px;">'.YAAMP_SITE_NAME.'</a>';

	$action = controller()->action->id;
	$wallet = user()->getState('yaamp-wallet');
	$ad = isset($_GET['address']);

	showItemHeader(controller()->id=='site' && $action=='index' && !$ad, '/', 'Home');
	showItemHeader($action=='mining', '/site/mining', 'Pool');
	showItemHeader(controller()->id=='site'&&($action=='index' || $action=='wallet') && $ad, "/?address=$wallet", 'Wallet');
	showItemHeader(controller()->id=='stats', '/stats', 'Graphs');
	showItemHeader($action=='miners', '/site/miners', 'Miners');
	showItemHeader(controller()->id=='api', '/site/api', 'API');
	if (YIIMP_PUBLIC_EXPLORER)
		showItemHeader(controller()->id=='explorer', '/explorer', 'Explorers');

	if (YIIMP_PUBLIC_BENCHMARK)
		showItemHeader(controller()->id=='bench', '/bench', 'Benchmarks');

	if (YAAMP_RENTAL)
		showItemHeader(controller()->id=='renting', '/renting', 'Rental');

	if(controller()->admin)
	{
		if (isAdminIP($_SERVER['REMOTE_ADDR']) === false)
			debuglog("admin {$_SERVER['REMOTE_ADDR']}");

		showItemHeader(controller()->id=='coin', '/coin', 'Coins');
		showItemHeader($action=='common', '/site/common', 'Dashboard');
		showItemHeader(controller()->id=='site'&&$action=='admin', "/site/admin", 'Wallets');

		if (YAAMP_RENTAL)
			showItemHeader(controller()->id=='renting' && $action=='admin', '/renting/admin', 'Jobs');

		if (YAAMP_ALLOW_EXCHANGE)
			showItemHeader(controller()->id=='trading', '/trading', 'Trading');

		if (YAAMP_USE_NICEHASH_API)
			showItemHeader(controller()->id=='nicehash', '/nicehash', 'Nicehash');
	}

	echo '<span style="flex: 1;"></span>';

	$mining = getdbosql('db_mining');
	$nextpayment = date('H:i T', $mining->last_payout+YAAMP_PAYMENTS_FREQ);
	$eta = ($mining->last_payout+YAAMP_PAYMENTS_FREQ) - time();
	$eta_mn = 'in '.round($eta / 60).' minutes';

	echo '<span id="nextpayout" title="'.$eta_mn.'">Next Payout: '.$nextpayment.'</span>';

	echo "</div>";
	echo "</nav>";
}

function showPageFooter()
{
	echo '<div class="footer">';
	$year = date("Y", time());

	echo "<p>&copy; $year ".'Powered by '.
		'<a href="https://github.com/innova-foundation/yiimp">YiiMP</a></p>';

	echo '</div>';
}


