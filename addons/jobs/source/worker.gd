extends Node

var mutex := Mutex.new()
var done_mutex := Mutex.new()
var semaphore := Semaphore.new()
var thread := Thread.new()
var abort := false
var job_queue := []
var done_queue := []

var main_thread_job_semaphore := Semaphore.new()
var main_thread_job: Job 
var main_thread_job_co: GDScriptFunctionState

func _ready() -> void:
	thread.start(self, "work", "no_arg")

func post_job(job: Job) -> void:
	mutex.lock()
	job_queue.push_back(job)
	mutex.unlock()
	
	semaphore.post()

func _process(delta: float) -> void:
	if main_thread_job_co:
		main_thread_job_co = main_thread_job_co.resume()
		
		if not main_thread_job_co:
			main_thread_job._remove_staging_node()
			main_thread_job = null
			main_thread_job_semaphore.post()

	elif main_thread_job:
		main_thread_job._add_staging_node()
		main_thread_job_co = main_thread_job.__instance()

	var done_job: Job
	done_mutex.lock()
	if not done_queue.empty():
		done_job = done_queue.pop_front()
	done_mutex.unlock()
	
	if done_job:
		if is_instance_valid(done_job.requester):
			done_job.requester.call(done_job.callback, done_job)
		else:
			print("instance_valid " + str(done_job.requester))
			done_job._on_requester_invalid()

func work(no_arg) -> void:
	while true:
		semaphore.wait()
		
		if abort:
			return
		
		var job: Job
		mutex.lock()
		if not job_queue.empty():
			job = job_queue.pop_front()
		mutex.unlock()

		if job:
			job.__load()
			if abort:
				return

			set_deferred("main_thread_job", job)
			main_thread_job_semaphore.wait()

			done_mutex.lock()
			done_queue.push_back(job)
			done_mutex.unlock()

func _exit_tree() -> void:
	abort = true
	if thread.is_active():
		semaphore.post()
		main_thread_job_semaphore.post()
		thread.wait_to_finish()
