require 'spec_helper'

describe Kafkadmin::Command::DeleteTopic do

  it 'builds a command to delete a kafka topic' do
    command = Kafkadmin::Command::DeleteTopic.new({
      name: "foo"
    })

    expect(command.command_string).to eq(
      "/opt/kafka/bin/kafka-topics.sh " +
      "--delete " +
      "--zookeeper 192.168.35.10:2181 " +
      "--topic foo"
    )
  end

  it 'must be given a name' do
    command = Kafkadmin::Command::DeleteTopic.new({
    })

    expect(command.valid?).to eq false
    expect(command.errors).to eq [
      "Topic name must be provided."
    ]

    command = Kafkadmin::Command::DeleteTopic.new({
      topic_name: '',
    })

    expect(command.valid?).to eq false
    expect(command.errors).to eq [
      "Topic name must be provided."
    ]
  end

  it 'validates the name is a valid Kafka topic name' do
    command = Kafkadmin::Command::DeleteTopic.new({
      name: "!@£"
    })

    expect(command.valid?).to eq false
    expect(command.errors).to eq [
      "The name \"!@£\" is not a valid Kafka topic name."
    ]
  end
end
