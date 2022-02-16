# frozen_string_literal: true

describe Result::Failure do
  it "is failure" do
    expect(described_class.new).to be_failure
  end

  it "is not success" do
    expect(described_class.new).not_to be_success
  end

  it "raises exception on #value call" do
    expect { described_class.new.value }.to raise_exception(
      Result::NonExistentValue,
      "Failure result does not have value"
    )
  end

  it "it's #error returns object passed to constructor" do
    object = Object.new
    expect(described_class.new(object).error).to eq(object)
  end
end
