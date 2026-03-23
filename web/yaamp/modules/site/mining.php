<?php

$algo = user()->getState('yaamp-algo');

JavascriptFile("/extensions/jqplot/jquery.jqplot.js");
JavascriptFile("/extensions/jqplot/plugins/jqplot.dateAxisRenderer.js");
JavascriptFile("/extensions/jqplot/plugins/jqplot.barRenderer.js");
JavascriptFile("/extensions/jqplot/plugins/jqplot.highlighter.js");
JavascriptFile('/yaamp/ui/js/auto_refresh.js');

$height = '240px';

echo <<<end

<div id='resume_update_button' class='main-left-box' style='color: var(--warning); padding: 14px; margin: 16px 0; cursor: pointer; display: none; text-align: center;'
	onclick='auto_page_resume();'>
<b>Auto refresh is paused &mdash; Click to resume</b></div>

<div class="home-layout" style="flex-direction: column;">

<div id='mining_results'>
<div class="loading-placeholder"></div>
</div>
end;

if($algo != 'all')
echo <<<end
<div class="main-left-box">
<div class="main-left-title">Last 24 Hours Estimate ($algo)</div>
<div class="main-left-inner"><br>
<div id='graph_results_price' style='height: $height;'></div><br>
</div></div><br>

<div class="main-left-box">
<div class="main-left-title">Last 24 Hours Hashrate ($algo)</div>
<div class="main-left-inner"><br>
<div id='pool_hashrate_results' style='height: $height;'></div><br>
</div></div><br>
end;

$algo_unit = 'Mh';
$algo_factor = yaamp_algo_mBTC_factor($algo);
if ($algo_factor == 0.001) $algo_unit = 'Kh';
if ($algo_factor == 1000) $algo_unit = 'Gh';
if ($algo_factor == 1000000) $algo_unit = 'Th';
if ($algo_factor == 1000000000) $algo_unit = 'Ph';

echo <<<end

<div id='pool_current_results'>
<div class="loading-placeholder"></div>
</div>

<div id='found_results'>
<div class="loading-placeholder"></div>
</div>

</div>

<script>

var global_algo = '$algo';
var querystring = '?algo=$algo';
if (querystring=='?algo=') querystring = '';

function select_algo(algo)
{
	//window.location.href = '/site/gomining?algo='+algo;
	window.location.href = '/site/algo?algo='+algo+'&r=/site/mining';
	//window.location.href = '/site/mining?algo='+algo;
}

function page_refresh()
{
	pool_current_refresh();
	mining_refresh();
	found_refresh();

	if(global_algo != 'all')
	{
		pool_hashrate_refresh();
		main_refresh_price();
	}
}

////////////////////////////////////////////////////

function pool_current_ready(data)
{
	$('#pool_current_results').html(data);
}

function pool_current_refresh()
{
	var url = "/site/current_results"+querystring;
	$.get(url, '', pool_current_ready);
}

////////////////////////////////////////////////////

function mining_ready(data)
{
	$('#mining_results').html(data);
}

function mining_refresh()
{
	var url = "/site/mining_results"+querystring;
	$.get(url, '', mining_ready);
}

////////////////////////////////////////////////////

function found_ready(data)
{
	$('#found_results').html(data);
}

function found_refresh()
{
	var url = "/site/found_results"+querystring;
	$.get(url, '', found_ready);
}

///////////////////////////////////////////////////////////////////////

function main_ready_price(data)
{
	graph_init_price(data);
}

function main_refresh_price()
{
	var url = "/site/graph_price_results"+querystring;
	$.get(url, '', main_ready_price);
}

function graph_init_price(data)
{
	$('#graph_results_price').empty();

	var t = $.parseJSON(data);
	var plot1 = $.jqplot('graph_results_price', t,
	{
		title: '<b>Estimate (mBTC/{$algo_unit}/day)</b>',
		axes: {
			xaxis: {
				tickInterval: 7200,
				renderer: $.jqplot.DateAxisRenderer,
				tickOptions: {formatString: '<font size=1>%#Hh</font>'}
			},
			yaxis: {
				min: 0,
				tickOptions: {formatString: '<font size=1>%#.3f &nbsp;</font>'}
			}
		},

		seriesDefaults:
		{
			markerOptions: { style: 'none' }
		},

		grid:
		{
			borderWidth: 1,
			shadowWidth: 0,
			shadowDepth: 0,
			background: 'transparent'
		},

	});
}

///////////////////////////////////////////////////////////////////////

function pool_hashrate_ready(data)
{
	pool_hashrate_graph_init(data);
}

function pool_hashrate_refresh()
{
	var url = "/site/graph_hashrate_results"+querystring;
	$.get(url, '', pool_hashrate_ready);
}

function pool_hashrate_graph_init(data)
{
	$('#pool_hashrate_results').empty();

	var t = $.parseJSON(data);
	var plot1 = $.jqplot('pool_hashrate_results', t,
	{
		title: '<b>Pool Hashrate ($algo_unit/s)</b>',
		axes: {
			xaxis: {
				tickInterval: 7200,
				renderer: $.jqplot.DateAxisRenderer,
				tickOptions: {formatString: '<font size=1>%#Hh</font>'}
			},
			yaxis: {
				min: 0,
				tickOptions: {formatString: '<font size=1>%#.3f &nbsp;</font>'}
			}
		},

		seriesDefaults:
		{
			markerOptions: { style: 'none' }
		},

		grid:
		{
			borderWidth: 1,
			shadowWidth: 0,
			shadowDepth: 0,
			background: 'transparent'
		},

		highlighter:
		{
			show: true
		},

	});
}

</script>


end;
