require 'spec_helper'

describe Kafkadmin::Web do

  context 'POST /topics' do
    it 'creates a new topic' do
      args = {
        name: 'foo',
        partitions: 5,
        replication_factor: 1
      }
      # The command we expect to get build
      cmd_string = Kafkadmin::Command::CreateTopic.new(args).command_string

      # Check the command is executed
      expect(Kafkadmin::CommandRunner).to(
        receive(:execute)
        .with(cmd_string)
        .and_return(execution_result(cmd_string, 0, 'foo', 'bar'))
      )

      # Make the request
      post '/topics', args

      # Check the reponse
      expect(last_response.status).to eq 201
      expect(JSON.load(last_response.body)).to eq({
        'status'      => 'ok',
        'command'     => {
          'command_string' => cmd_string,
          'exit_status' => 0,
          'stdout' => 'foo',
          'stderr' => 'bar'
        }
      })
    end

    it 'returns an error if the command is invalid' do
      args = {
        name: '123$!£$',
        partitions: 0,
      }

      # Check the command is _not_ executed
      expect(Kafkadmin::CommandRunner).to_not receive(:execute)

      # Make the request
      post '/topics', args

      # Check the reponse
      expect(last_response.status).to eq 422
      expect(JSON.load(last_response.body)).to eq({
        'status'  => 'error',
        'message' => 'The provided parameters were invalid.',
        'errors'  => [
          "The name \"123$!£$\" is not a valid Kafka topic name.",
          "Partition count must be greater than 0. Got 0."
        ]
      })
    end

    it 'returns an error if the command failed to execute' do
      args = {
        name: 'foo',
        partitions: 5,
        replication_factor: 1
      }

      # The command we expect to get build
      cmd_string = Kafkadmin::Command::CreateTopic.new(args).command_string

      # Check the command is executed
      expect(Kafkadmin::CommandRunner).to(
        receive(:execute)
        .with(cmd_string)
        .and_return(execution_result(cmd_string, 1, 'foo', 'bar'))
        # But return a bad result!
      )

      # Make the request
      post '/topics', args

      # Check the reponse
      expect(last_response.status).to eq 422
      expect(JSON.load(last_response.body)).to eq({
        'status'      => 'error',
        'message'     => 'Kafka returned a non-zero exit status.',
        'command'     => {
          'command_string' => cmd_string,
          'exit_status' => 1,
          'stdout' => 'foo',
          'stderr' => 'bar'
        }
      })
    end
  end

  context 'DELETE /topics/name' do
    it 'creates a new topic' do
      name = 'foo'
      # The command we expect to get build
      cmd_string = Kafkadmin::Command::DeleteTopic.new(name: name).command_string

      # Check the command is executed
      expect(Kafkadmin::CommandRunner).to(
        receive(:execute)
        .with(cmd_string)
        .and_return(execution_result(cmd_string, 0, 'foo', 'bar'))
      )

      # Make the request (foo is topic name)
      delete '/topics/' + name

      # Check the reponse
      expect(last_response.status).to eq 200
      expect(JSON.load(last_response.body)).to eq({
        'status'      => 'ok',
        'command'     => {
          'command_string' => cmd_string,
          'exit_status' => 0,
          'stdout' => 'foo',
          'stderr' => 'bar'
        }
      })
    end

    it 'returns an error if the command failed to execute' do
      name = 'bar'

      # The command we expect to get build
      cmd_string = Kafkadmin::Command::DeleteTopic.new(name: name).command_string

      # Check the command is executed
      expect(Kafkadmin::CommandRunner).to(
        receive(:execute)
        .with(cmd_string)
        .and_return(execution_result(cmd_string, 1, 'foo', 'bar'))
        # But return a bad result!
      )

      # Make the request
      delete '/topics/' + name

      # Check the reponse
      expect(last_response.status).to eq 422
      expect(JSON.load(last_response.body)).to eq({
        'status'      => 'error',
        'message'     => 'Kafka returned a non-zero exit status.',
        'command'     => {
          'command_string' => cmd_string,
          'exit_status' => 1,
          'stdout' => 'foo',
          'stderr' => 'bar'
        }
      })
    end
  end
end
