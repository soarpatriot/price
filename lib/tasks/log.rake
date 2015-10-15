task :log do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end

