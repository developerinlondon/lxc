
def to_param_string(params)
  params.map {|k, v| "ParameterKey=#{k},ParameterValue=#{v}"}.join(" ")
end

def alter_stack(command, stack, template, params)
  puts "--> #{command} to #{stack}"
  sh <<-CMD
    aws cloudformation #{command} \
      --template-body #{template} \
      --stack-name #{stack} \
      --capabilities CAPABILITY_IAM \
      --parameters \
        #{to_param_string(params)}
  CMD
end

def delete_stack(stack)
  puts "--> Deleting #{stack}"
  sh "aws cloudformation delete-stack --stack-name #{stack}"
end

def validate_stack(template)
  puts "--> validating #{template}"
  sh "aws cloudformation validate-template --template-body #{template}"
end



namespace :cluster do

  def cluster_params
    @cluster_params ||= {
      'DnsZone' => ENV['DNS_ZONE'],
      'VpcId' => ENV['VPC_ID']
    }
  end

  desc 'validate cluster template'
  task :validate => 'common:check_environment' do
    validate_stack "file://cfn/cluster.json"
  end

  desc 'create cluster stack'
  task :create do
    alter_stack 'create-stack', ENV['STACK_NAME'], "file://cfn/cluster.json", cluster_params
  end

  desc 'update cluster stack'
  task :update do
    alter_stack 'update-stack', ENV['STACK_NAME'], "file://cfn/cluster.json", mesos_params
  end

  desc 'delete cluster stack'
  task :delete do
    delete_stack ENV['STACK_NAME']
  end
end
