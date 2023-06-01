<?php
$algo = user()->getState('yaamp-algo');

JavascriptFile("/extensions/jqplot/jquery.jqplot.js");
JavascriptFile("/extensions/jqplot/plugins/jqplot.dateAxisRenderer.js");
JavascriptFile("/extensions/jqplot/plugins/jqplot.barRenderer.js");
JavascriptFile("/extensions/jqplot/plugins/jqplot.highlighter.js");
JavascriptFile("/extensions/jqplot/plugins/jqplot.cursor.js");
JavascriptFile('/yaamp/ui/js/auto_refresh.js');

$height = '240px';

$min_payout = floatval(YAAMP_PAYMENTS_MINI);
$min_sunday = $min_payout / 10;

$payout_freq = (YAAMP_PAYMENTS_FREQ / 3600) . " hours";
?>

<div id='resume_update_button' style='color: #444; background-color: #ffd; border: 1px solid #eea;
    padding: 10px; margin-left: 20px; margin-right: 20px; margin-top: 15px; cursor: pointer; display: none;'
    onclick='auto_page_resume();' align=center>
    <b>Auto refresh is paused - Click to resume</b></div>

<table cellspacing=20 width=100%>
<tr><td valign=top width=50%>

<!--  -->

<div class="main-left-box">
<div class="main-left-title"><?=YAAMP_SITE_URL?></div>
<div class="main-left-inner">

<ul>

<li>Welcome to <?=YAAMP_SITE_URL?>! </li>
<li>The Innova Mining Pool is a pool management solution based on the Yii Framework.</li>
<li>This fork was based on the yaamp source code and is now managed by the Innova-Foundation Dev Team.</li>
<li>No registration is required, we do payouts in the currency you mine. Use your wallet address as the username.</li>
<li>Payouts are made automatically every <?= $payout_freq ?> for all balances above <b><?= $min_payout ?></b>, or <b><?= $min_sunday ?></b> on Sunday.</li>
<li>For some coins, there is an initial delay before the first payout, please wait at least 8 hours before asking for support.</li>
<li>Blocks are distributed proportionally among valid submitted shares.</li>

<br/>

</ul>
</div></div>
<br/>

<!-- Stratum Auto generation code, will automatically add coins when they are enabled and auto ready -->

<div class="main-left-box">
<div class="main-left-title">How to mine with <?=YAAMP_SITE_URL?></div>
<div class="main-left-inner">

<table>
	<thead>
		<tr>
			<th>Stratum Location</th>
			<th>Coin</th>
			<th>Wallet Address</th>
			<th>Rig Name</th>
			<th>Solo</th>
		</tr>
	</thead>

<tbody>
	<tr>
		<td>
			<select id="drop-stratum" style="border-style:solid; padding: 3px; font-family: monospace; border-radius: 5px;" onchange="generate()">

			<!-- Add your stratum locations here -->
			<option value="">Main Stratum</option>
			<!--<option value="mine.">Asia Stratum</option>
			<option value="eu.">Europe Stratum</option>
			<option value="cad.">CAD Stratum</option>
			<option value="uk.">UK Stratum</option> -->
			</select>
		</td>

		<td>
			<select id="drop-coin" style="border-style:solid; padding: 3px; font-family: monospace; border-radius: 5px;" onchange="generate()">
        <?php
        $list = getdbolist('db_coins', "enable and visible and auto_ready order by algo asc");

        $algoheading="";
        $count=0;
        foreach($list as $coin)
        {
        	$name = substr($coin->name, 0, 18);
        	$symbol = $coin->getOfficialSymbol();
                $id = $coin->id;
                $algo = $coin->algo;

        	$port_count = getdbocount('db_stratums', "algo=:algo and symbol=:symbol", array(':algo' => $algo,':symbol' => $coin->symbol));

        	$port_db = getdbosql('db_stratums', "algo=:algo and symbol=:symbol", array(':algo' => $algo,':symbol' => $coin->symbol));

       		if ($port_count >= 1){$port = $port_db->port;}else{$port = '0000';}
       		if($count == 0){ echo "<option disabled=''>$algo";}elseif($algo != $algoheading){echo "<option disabled=''>$algo</option>";}
        	echo "<option data-port='$port' data-algo='-a $algo' data-symbol='$coin->symbol'>$name ($symbol)</option>";

       		$count=$count+1;
        	$algoheading=$algo;
        }
        ?>
			</select>
		</td>
		<td>
			<input id="text-wallet" type="text" size="30" placeholder="iL9diZHxTQ48qPVCRY6SGQR8KiPixq7zPz" style="border-style:solid; padding: 3px; font-family: monospace; border-radius: 5px;" onkeyup="generate()">
		</td>
		<td>
			<input id="text-rig-name" type="text" size="10" placeholder="001" style="border-style:solid; padding: 3px; font-family: monospace; border-radius: 5px;" onkeyup="generate()">
		</td>
		<td>
			<select id="drop-solo" style="border-style:solid; padding: 3px; font-family: monospace; border-radius: 5px;" onchange="generate()">
			<option value="">No</option>
			<option value=",m=solo">Yes</option>
			</select>
		</td>
	
</tbody>
<tbody>
	<tr>
		<td colspan="5"><p class="main-left-box" style="padding: 3px; background-color: #ffffee; font-family: monospace;" id="output">-a  -o stratum+tcp://<?=YAAMP_STRATUM_URL?>:0000 -u . -p c=</p></td>
	</tr>
</tbody>
</table>

<ul>
<li>&lt;WALLET_ADDRESS&gt; must be valid for the currency you mine. <b>DO NOT USE a BTC address here, the auto exchange is disabled on these stratums</b>!</li>
<!-- <li><b>Our stratums are now NiceHASH compatible and ASICBoost enabled, please message support if you have any issues.</b></li> -->
<li>See the "<?=YAAMP_SITE_NAME?> coins" area on the right for PORT numbers. You may mine any coin regardless if the coin is enabled or not for autoexchange. Payouts will only be made in that coins currency.</li>
<li>Payouts are made automatically every hour for all balances above <b><?=$min_payout?></b>, or <b><?=$min_sunday?></b> on Sunday.</li>
<br>
</ul>
</div></div><br>

<!-- End new stratum generation code  -->

<!------------------------------------------------------------------------Miner Links------------------------------------------------------------------------------------------------------------->
<div class="main-left-box">
 <div class="main-left-title">Miner Download Links</div>
  <div class="main-left-inner">
	<ul>

	<li><b>CCMiner</b> - <a href='https://github.com/tpruvot/ccminer/releases'>Download CCMiner</a></li>
	<li><b>CPUMiner-Multi</b> - <a href='https://github.com/tpruvot/cpuminer-multi/releases'>Download CPUMiner-Multi (Multi CPU)</a></li>

	<br>

	</ul>
 </div>	
</div>
	<br>

<!------------------------------------------------------------------------New Releases------------------------------------------------------------------------------------------------------------->
<div class="main-left-box">
 <div class="main-left-title">New Releases</div>
  <div class="main-left-inner">
	<ul>
		<li><img width="16px" src="/images/innova.png" alt="innova"><strong></strong></a></li>
		<li><img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/innova-foundation/innova?label=Innova%20Current%20Release&style=for-the-badge"></li>
		<li><img alt="GitHub Release Date" src="https://img.shields.io/github/release-date/innova-foundation/innova?label=Innova%20Release%20Date&style=for-the-badge"></li>

	</ul>
 </div>
</div>
	<br>

<div class="main-left-box">
<div class="main-left-title"><?=YAAMP_SITE_URL?> Links</div>
<div class="main-left-inner">

<ul>

<li><b>API</b> - <a href='/site/api'>http://<?=YAAMP_SITE_URL?>/site/api</a></li>
<li><b>Difficulty</b> - <a href='/site/diff'>http://<?=YAAMP_SITE_URL?>/site/diff</a></li>
<?php
if (YIIMP_PUBLIC_BENCHMARK):
?>
<li><b>Benchmarks</b> - <a href='/site/benchmarks'>http://<?=YAAMP_SITE_URL?>/site/benchmarks</a></li>
<?php
endif;
?>

<?php
if (YAAMP_ALLOW_EXCHANGE):
?>
<li><b>Algo Switching</b> - <a href='/site/multialgo'>http://<?=YAAMP_SITE_URL?>/site/multialgo</a></li>
<?php
endif;
?>

<br>

</ul>
</div></div><br>

<div class="main-left-box">
<div class="main-left-title"><?=YAAMP_SITE_URL?> Support</div>
<div class="main-left-inner">

<ul class="social-icons">
<!-- <li><a href="http://www.facebook.com"><img src='/images/Facebook.png' /></a></li> -->
    <li><a href="http://www.twitter.com/Innova_Fdn"><img src='/images/Twitter.png' /></a></li>
<!-- <li><a href="http://www.youtube.com"><img src='/images/YouTube.png' /></a></li> -->
    <li><a href="http://www.github.com"><img src='/images/Github.png' /></a></li> 
    <li><a href="https://discord.gg/mNM59znzNG"><img src='/images/discord.png' /></a></li>
</ul>

</div></div><br>
</td><td valign=top>
<!--  -->

<div id='pool_current_results'>
<br><br><br><br><br><br><br><br><br><br>
</div>

<div id='pool_history_results'>
<br><br><br><br><br><br><br><br><br><br>
</div>

<div id='pool_coins_info'>
<br><br><br><br><br><br><br><br><br><br>
</div>

<!------------------------------------------------------------------------Coin Links------------------------------------------------------------------------------------------------------------->
<div class="main-left-box"><div class="main-left-title">Coin Links</div>
<div class="main-left-inner"><style type="text/css">
td.symb, th.symb {
	width:50px;
	max-width: 50px;
	text-align: right;
}
td.symb {
	font-size: .8em;
}
</style>

<table class="dataGrid2">
<thead>
<tr>
<th></th>
<th>Name</th>
<!-- th class="symb">Symbol</th -->
<th align="center">Info</th>
<th align="center">WWW</th>
<th align="center">Discord</th>
<th align="center">Expl</th>
<th align="center">Github</th>
<th align="center">Exch</th>
<th align="center">Twitter</th>
<th align="center">Wallet*</th>
<th align="center">Nodes</th>
</tr>


<!-- INNOVA COIN -->
</thead><tbody><tr class="ssrow"><td width="18px"><img width="16px" src="/images/innova.png">
</td><td><b>
<a href="/site/block?id=1426">Innova</a></b></td>
<td align="center"><a href="https://bitcointalk.org/index.php?topic=2291517.0" target="_blank"><img width="16px" src="images/btc.png"></a></td>
<td align="center"><a href="https://innova-foundation.com" target="_blank"><img width="16px" src="images/www.png"></a></td>
<td align="center"><a href="https://discord.gg/mNM59znzNG" target="_blank"><img width="16px" src="images/discordm.png"></a></td>
<td align="center"><a href="https://chainz.cryptoid.info/inn/" target="_blank"><img width="16px" src="images/explorer.png"></a></td>
<td align="center"><a href="https://github.com/innova-foundation/innova" target="_blank"><img width="16px" src="images/githubm.png"></a></td>
<td align="center"><a href="https://www.probit.com/app/exchange/INN-USDT" target="_blank"><img width="16px" src="images/exchange.png"></a></td>
<td align="center"><a href="https://twitter.com/Innova_Fdn" target="_blank"><img width="16px" src="images/Twitter.png"></a></td>
<td align="center"><a href="https://github.com/innova-foundation/innova/releases" target="_blank"><img width="16px" src="images/wallet.png"></a></td>
<td align="center"><a href="http://<?=YAAMP_SITE_URL?>/explorer/peers?id=1426" target="_blank"><img width="16px" src="images/addnodes.png"></a></td>



</tr></a></td></tr></tbody></table></div>

<!--<strong>Important: Always use wallets with caution. Never automatically trust them. Submit them to virustotal.com for checking prior to installing.</strong></div>-->
<br>

		</td>
	</tr>
</table>

</td></tr></table>

<br><br><br><br><br><br><br><br><br><br>
<br><br><br><br><br><br><br><br><br><br>
<br><br><br><br><br><br><br><br><br><br>
<br><br><br><br><br><br><br><br><br><br>

<script>

function page_refresh()
{
    pool_current_refresh();
    pool_history_refresh();
	pool_coins_info_refresh();

}

function select_algo(algo)
{
    window.location.href = '/site/algo?algo='+algo+'&r=/';
}

////////////////////////////////////////////////////

function pool_current_ready(data)
{
    $('#pool_current_results').html(data);
}

function pool_current_refresh()
{
    var url = "/site/current_results";
    $.get(url, '', pool_current_ready);
}

////////////////////////////////////////////////////

function pool_history_ready(data)
{
    $('#pool_history_results').html(data);
}

function pool_history_refresh()
{
    var url = "/site/history_results";
    $.get(url, '', pool_history_ready);
}

////////////////////////////////////////////////////

function pool_coins_info_ready(data)
{
    $('#pool_coins_info').html(data);
}

function pool_coins_info_refresh()
{
    var url = "/site/coins_info";
    $.get(url, '', pool_coins_info_ready);
}

</script>

<script>
function getLastUpdated(){
    var stratum = document.getElementById('drop-stratum');
    var coin = document.getElementById('drop-coin');
    var solo = document.getElementById('drop-solo');
    var wallet = document.getElementById('text-wallet').value;
    var rigName = document.getElementById('text-rig-name').value;
    var result = '';

    result += coin.options[coin.selectedIndex].dataset.algo + ' -o stratum+tcp://';
    result += stratum.value + '<?=YAAMP_STRATUM_URL?>:';
    result += coin.options[coin.selectedIndex].dataset.port + ' -u ';
    if (wallet) result += wallet;
    else result += 'WALLET_ADDRESS';
    if (rigName) result += '.' + rigName;
    else result += '.WORKER_NAME';
    result += ' -p c=';
    result += coin.options[coin.selectedIndex].dataset.symbol + solo.value;
    return result;
}
function generate(){
      var result = getLastUpdated()
        document.getElementById('output').innerHTML = result;
}
generate();
</script>
