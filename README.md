# ReadOnce

Readonce is a web service for sharing passwords and other private information with exactly one person.

Currently, the only supported client is the [ReadOnce CLI](https://github.com/freerobby/readonce-client).

Data can be created via POST requests to /create. The server responds with a key, where the data can be accessed at (/:key). Data is destroyed immediately the first time a key is queried.

## Notes

* All data are stored in memory, and therefore will be lost upon a server restart.
* No encryption is used.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

