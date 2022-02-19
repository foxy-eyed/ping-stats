## Ping Monitor

[![Lint and test](https://github.com/foxy-eyed/ping-stats/actions/workflows/lint_and_test.yml/badge.svg?branch=main&event=push)](https://github.com/foxy-eyed/ping-stats/actions/workflows/lint_and_test.yml)

### To run locally
```
docker-compose up -d --build
```
Now you have app running at http://localhost:9292 and ready to process your requests.

### API

 * To add IP to monitoring: `POST /api/v1/monitored_hosts`

    Example:
    ```
    curl -X POST "http://localhost:9292/api/v1/monitored_hosts" \
    -H "Content-Type: application/json" \
    -d '{"ip":"8.8.8.8"}'
    ```

 * To remove IP from monitoring: `DELETE /api/v1/monitored_hosts`

    Example:
    ```
    curl -X DELETE "http://localhost:9292/api/v1/monitored_hosts?ip=8.8.8.8"
    ```

 * To get stats: `GET /api/v1/monitored_hosts/stats`

    Example:
    ```
    curl -X GET "http://localhost:9292/api/v1/monitored_hosts/stats?ip=8.8.8.8&interval_start=2022-02-01+00%3A00%3A00&interval_end=2022-02-19+23%3A59%3A59"
    ```

You can find interactive API documentation at http://localhost:9292/documentation:

![Documentation](http://g.recordit.co/Av1AUhxitK.gif)

### To run tests
```
docker-compose run --rm test bundle exec rspec
```

Also you can check [this workflow](https://github.com/foxy-eyed/ping-stats/actions/workflows/lint_and_test.yml) runs to ensure all tests are passed.
