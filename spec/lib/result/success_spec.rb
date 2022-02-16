# frozen_string_literal: true

describe Result::Success do
  it "is success" do
    expect(described_class.new).to be_success
  end

  it "is not failure" do
    expect(described_class.new).not_to be_failure
  end

  it "it's value contains object passed to constructor" do
    object = Object.new
    expect(described_class.new(object).value).to eq(object)
  end

  it "raises exception on #error call" do
    expect { described_class.new.error }.to raise_exception(
      Result::NonExistentError,
      "Success result does not have error"
    )
  end
end
