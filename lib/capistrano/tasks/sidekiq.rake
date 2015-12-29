namespace :sidekiq do

  task :start do
    invoke :"rvm:hook"
    on roles :app do
      within current_path do
        with rails_env: fetch(:rails_env) do 
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

  task :update_config do
    on roles :web do
      dest = "#{shared_path}/config/sidekiq.yml"
      upload! from_template("sidekiq.yml.erb"), dest
      info "Uploaded to '#{fetch(:server_name)}@#{dest}'"
    end
  end


end
