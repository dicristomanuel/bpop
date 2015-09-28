workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  @sidekiq_pid ||= spawn("bundle exec sidekiq -c 2")
  ActiveRecord::Base.establish_connection
end


# ============================
# CONFIGURATION FROM TUTORIAL
# ============================
# workers Integer(ENV['PUMA_WORKERS'] || 3)
# threads Integer(ENV['MIN_THREADS']  || 1), Integer(ENV['MAX_THREADS'] || 16)
#
# preload_app!
#
# rackup      DefaultRackup
# port        ENV['PORT']     || 3000
# environment ENV['RACK_ENV'] || 'development'
#
# on_worker_boot do
#   # worker specific setup
#   ActiveSupport.on_load(:active_record) do
#     config = ActiveRecord::Base.configurations[Rails.env] ||
#                 Rails.application.config.database_configuration[Rails.env]
#     config['pool'] = ENV['MAX_THREADS'] || 16
#     ActiveRecord::Base.establish_connection(config)
#   end
# end
#
