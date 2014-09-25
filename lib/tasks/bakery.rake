namespace :bakery do

  desc 'bake a node'
  task :bake_node => 'common:check_environment' do
    puts '--> baking a new AMI'
    chdir "packer"
    sh "packer build build.json"
  end

  desc 'build an instance'
  task :build_instance do
    puts '--> building a new instance'
    sh " aws ec2 run-instances --count=1 --key-name=cronycle-cluster --instance-type=r3.large --image-id=ami-#{$1}"
  end

  desc 'bake and build'
  task :bake_and_build => ['bake_node', 'build_instance'] do
  end

end
