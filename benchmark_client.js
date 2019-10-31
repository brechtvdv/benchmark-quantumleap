const https = require('http')


function do_request() {
	let options;

	if (process.env.METHOD && process.env.METHOD === 'latest') {
		options = {
		  hostname: 'EXTERNAL_IP',
		  port: 8668,
		  path: '/v2/entities/urn:ngsi-ld:Sensor:123?lastN=100',
		  method: 'GET'
		}
	} else {
		const aggrMethod = process.env.METHOD || 'avg';
		const aggrPeriod = process.env.AGGRPERIOD || 'minute';
		const fromDate = process.env.FROMDATE || '2018-01-05T15:44:34';
		const toDate = process.env.TODATE || '2020-01-05T15:44:34';

		options = {
		  hostname: 'EXTERNAL_IP',
		  port: 8668,
		  path: '/v2/entities/urn:ngsi-ld:Sensor:123?attrs=value&aggrMethod=' + aggrMethod + '&aggrPeriod=' + aggrPeriod + '&fromDate=' + fromDate + '&toDate=' + toDate,
		  method: 'GET'
		}
	}	

	const start = new Date()
	const req = https.request(options, res => {
      const end = new Date() - start;
      console.info('%d', end)
	  
	  // console.log(`statusCode: ${res.statusCode}`)

	  res.on('data', d => {
	    // process.stdout.write(d)
	  })
	})

	req.on('error', error => {
	  console.error(error)
	})

	req.end();
}

function sleep(time, callback) {
    var stop = new Date().getTime();
    while(new Date().getTime() < stop + time) {
        ;
    }
    callback();
}

setInterval(do_request, 2000);