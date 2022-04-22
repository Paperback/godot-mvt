class_name RequestJob extends Job

func _init(requester: Node, callback: String).(requester, callback) -> void:
	pass

static func request(host: String, port: String = '80', path: String = '') -> PoolByteArray:
	var http = HTTPClient.new()
	var err = 0
	err = http.connect_to_host(host, int(port))
	if err != OK: Log.error(err)

	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
	
	if http.get_status() != HTTPClient.STATUS_CONNECTED:
		Log.error('Could not connect with HTTP client')

	var headers = [
		"Accept: */*"
	]
	err = http.request(HTTPClient.METHOD_GET, '/'+path, headers)
	if err != OK: Log.error(err)

	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		http.poll()

	assert(http.get_status() == HTTPClient.STATUS_BODY or http.get_status() == HTTPClient.STATUS_CONNECTED) # Make sure request finished well.

	#print("response? ", http.has_response()) # Site might not have a response.
	
	if http.has_response():
		headers = http.get_response_headers_as_dictionary() # Get response headers.
		#print("code: ", http.get_response_code()) # Show response code.
		#print("**headers:\\n", headers) # Show headers.

	# Getting the HTTP Body
	var bl: int = 0
	if http.is_response_chunked():
		Log.warning('response is chunked')
		# Does it use chunks?
		print("Response is Chunked!")
	else:
		# Or just plain Content-Length
		bl = http.get_response_body_length()
		#("Response Length: ", bl)

	# This method works for both anyway
	var rb := PoolByteArray() # Array that will hold the data.
	while http.get_status() == HTTPClient.STATUS_BODY:
		# While there is body left to be read
		http.poll()
		# Get a chunk.
		var chunk = http.read_response_body_chunk()
		if chunk.size() != 0:
			rb = rb + chunk # Append to read buffer.
	return rb

	
static func requestPBF(host: String, port: String, path: String) -> PoolByteArray:
	var response: PoolByteArray = .request(host, port, path)
	return response

static func requestJSON(host: String, port: String, path: String):
	var response: PoolByteArray = .request(host, port, path)
	var text = response.get_string_from_ascii()
	return JSON.parse(text)
