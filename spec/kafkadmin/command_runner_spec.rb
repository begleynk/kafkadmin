require 'spec_helper'

describe Kafkadmin::CommandRunner do

  it 'runs a shell command and returns a result' do
    result = Kafkadmin::CommandRunner.execute("echo foo")

    expect(result).to be_success
    expect(result.exit_status).to eq 0
    expect(result.stdout).to eq "foo\n"
    expect(result.stderr).to eq ''
    expect(result.command).to eq 'echo foo'
  end

  it 'captures stderr too' do
    result = Kafkadmin::CommandRunner.execute("echo foo >&2")

    expect(result).to be_success
    expect(result.exit_status).to eq 0
    expect(result.stdout).to eq ''
    expect(result.stderr).to eq "foo\n"
    expect(result.command).to eq 'echo foo >&2'
  end

  it 'captures a non-zero status code' do
    result = Kafkadmin::CommandRunner.execute("ls /asdfasdf")

    expect(result).to be_failure
    expect(result).to_not be_success

    expect(result.exit_status).to eq 256
    expect(result.stdout).to eq ''
    expect(result.stderr).to eq "ls: /asdfasdf: No such file or directory\n"
    expect(result.command).to eq 'ls /asdfasdf'
  end
end
