namespace :common do
  task :check_environment do
    puts '--> checking Environment'
    if ENV.key?('AWS_ACCESS_KEY_ID') and ENV.key?('AWS_SECRET_ACCESS_KEY')
      puts 'Environment looks Good.'
    else
      fail 'Please export your IAM AWS_ACCESS_KEY_ID AND AWS_SECRET_ACCESS_KEY before running this.'
    end
  end
end