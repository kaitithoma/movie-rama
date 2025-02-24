class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError

  class << self
    def running_jobs
      Rails.cache.read(self::CACHE_KEY) || []
    end

    def job_in_progress?(*args)
      running_jobs.include?(cache_args(*args))
    end

    def add_to_running_jobs(*args)
      write_to_cache(running_jobs + [ cache_args(*args) ])
    end

    def remove_from_running_jobs(*args)
      write_to_cache(running_jobs - [ cache_args(*args) ])
    end

    private

    def write_to_cache(array)
      Rails.cache.write(self::CACHE_KEY, array, expires_in: self::CACHE_EXPIRATION)
    end
  end
end
