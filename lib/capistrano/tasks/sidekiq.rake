namespace :sidekiq do

  task :start do
    invoke :"rvm:hook"
    on roles :app do
      within current_path do
        unless test("[ -f #{fetch(:sidekiq_pid)} ]")
          info ">>>>>> starting sidekiq"
          execute :bundle, "exec sidekiq -C #{fetch(:sidekiq_config)} -d"
        else
          error ">>>>>> sidekiq already started"
        end
      end
    end
  end 
end
