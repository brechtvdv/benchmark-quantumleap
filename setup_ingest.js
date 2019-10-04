const https = require('http')


function do_request() {
	console.log("start request");

	const data = '80';

	const options = {
	  hostname: 'EXTERNAL_IP',
	  port: 1026,
	  path: '/v2/entities/urn:ngsi-ld:Sensor:123/attrs/value/value',
	  method: 'PUT',
	   headers: {
	    'Content-Type': 'text/plain',
	    'Content-Length': data.length
	  }
	}

	const req = https.request(options, res => {
	  console.log(`statusCode: ${res.statusCode}`)

	  console.log("done");

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

sleep(1000, do_request);