const https = require('http')


function do_request() {
	if (process.env.METHOD === 'latest') {
		const options = {
		  hostname: 'EXTERNAL_IP',
		  port: 8668,
		  path: '/v2/entities/urn:ngsi-ld:Sensor:123?limit=10000',
		  method: 'GET'
		}
	} else {
		const options = {
		  hostname: 'EXTERNAL_IP',
		  port: 8668,
		  path: '/v2/entities/urn:ngsi-ld:Sensor:123?aggrMethod=$METHOD&aggrPeriod=$AGGRPERIOD&fromDate=$FROMDATE&toDate=$TODATE&limit=10000 ',
		  method: 'GET'
		}
	}	

	const start = new Date()
	const req = https.request(options, res => {
      const end = new Date() - start;
      console.info('Execution time: %dms', end)
	  
	  // console.log(`statusCode: ${res.statusCode}`)

	  res.on('data', d => {
	    process.stdout.write(d)
	  })
	})

	req.on('error', error => {
	  console.error(error)
	})
	req.write(data)

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