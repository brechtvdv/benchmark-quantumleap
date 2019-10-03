const https = require('http')

const data = '80';

const options = {
  hostname: 'localhost',
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

  res.on('data', d => {
    process.stdout.write(d)
  })
})

req.on('error', error => {
  console.error(error)
})
req.write(data)

req.end()