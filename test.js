import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  stages: [
    { duration: '30s', target: 20 },
    { duration: '3m30s', target: 1000},
    { duration: '20s', target: 0 },
  ],
};

export default function () {
  let res = http.get('http://emmanuel-pius-ogiji-elb-553756890.eu-west-1.elb.amazonaws.com');
  console.log(res)
  sleep(1);
}

//TODO: Sort out testing/stress testing for CPU Utilization and way to have just one json
