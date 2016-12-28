require 'spec_helper'

describe Kafkadmin::Command::CreateTopic do

  it 'builds a command to create a kafka topic' do
    command = Kafkadmin::Command::CreateTopic.new({
      name: "foo",
      replication_factor: 2,
      partitions: 3
    })

    expect(command.command_string).to eq(
      "/opt/kafka/bin/kafka-topics.sh " +
      "--create " +
      "--zookeeper 192.168.35.10 " +
      "--replication-factor 2 " +
      "--partitions 3 " +
      "--topic foo"
    )
  end

  it 'does not require a replication factor' do
    command = Kafkadmin::Command::CreateTopic.new({
      name: "bar",
      partitions: 5
    })

    expect(command.command_string).to eq(
      "/opt/kafka/bin/kafka-topics.sh " +
      "--create " +
      "--zookeeper 192.168.35.10 " +
      "--partitions 5 " +
      "--topic bar"
    )
  end

  it 'validates the name is a valid Kafka topic name' do
    command = Kafkadmin::Command::CreateTopic.new({
      name: "!@£",
      partitions: 5
    })

    expect(command.valid?).to eq false
    expect(command.errors).to eq [
      "The name \"!@£\" is not a valid Kafka topic name."
    ]
  end

  it 'requires a positive parition count' do
    command = Kafkadmin::Command::CreateTopic.new({
      name: "asdf",
      partitions: -1
    })

    expect(command.valid?).to eq false
    expect(command.errors).to eq [
      "Partition count must be greater than 0. Got -1."
    ]

    command = Kafkadmin::Command::CreateTopic.new({
      name: "asdf"
    })

    expect(command.valid?).to eq false
    expect(command.errors).to eq [
      "Partition count must be provided."
    ]
  end

  it 'must be given a name' do
    command = Kafkadmin::Command::CreateTopic.new({
      partitions: 5
    })

    expect(command.valid?).to eq false
    expect(command.errors).to eq [
      "Topic name must be provided."
    ]

    command = Kafkadmin::Command::CreateTopic.new({
      topic_name: '',
      partitions: 5
    })

    expect(command.valid?).to eq false
    expect(command.errors).to eq [
      "Topic name must be provided."
    ]
  end

  it 'raises an error if you ask for a command string when the command is invalid' do
    command = Kafkadmin::Command::CreateTopic.new({
      name: "!@£",
      partitions: 5
    })

    expect do
      command.command_string
    end.to raise_error("Command is invalid. Call #valid? before generating the command string.")
  end
end
