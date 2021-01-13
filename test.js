import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  stages: [
    { duration: '10m30s', target: 500},
    { duration: '20s', target: 0 },
  ],
};

export default function () {
  let res = http.get('http://emmanuel-pius-ogiji-elb-1402978270.eu-west-1.elb.amazonaws.com');
  console.log(res)
  sleep(1);
}

//TODO: Sort out testing/stress testing for CPU Utilization and way to have just one json
