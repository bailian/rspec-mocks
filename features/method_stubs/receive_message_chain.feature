Feature: stub a chain of methods

  Use the `stub_chain` method to stub a chain of two or more methods in one
  statement.  Method chains are considered a design smell, but it's not really
  the method chain itself that is the problem - it's the dependency chain
  represented by a chain of messages to different objects:

      foo.get_bar.get_baz

  This is a Law of Demeter violation if `get_bar` returns an object other than
  `foo`, and `get_baz` returns yet another object.

  Fluent interfaces look similar from a caller's perspective, but don't
  represent a dependency chain (the caller depends only on the object it is
  calling). Consider this common example from Ruby on Rails:

      Article.recent.by(current_user)

  The `recent` and `by` methods return the same object, so this is not a Law of
  Demeter violation.

  Scenario: stub a chain of methods
    Given a file named "stub_chain_spec.rb" with:
      """ruby
      describe "stubbing a chain of methods" do
        subject { Object.new }

        context "given symbols representing methods" do
          it "returns the correct value" do
            allow(subject).to receive_message_chain(:one, :two, :three).and_return(:four)
            expect(subject.one.two.three).to eq(:four)
          end
        end

        context "given a hash at the end" do
          it "returns the correct value" do
            allow(subject).to receive_message_chain(:one, :two, :three => :four)
            expect(subject.one.two.three).to eq(:four)
          end
        end

        context "given a string of methods separated by dots" do
          it "returns the correct value" do
            allow(subject).to receive_message_chain("one.two.three").and_return(:four)
            expect(subject.one.two.three).to eq(:four)
          end
        end
      end
      """
    When I run `rspec stub_chain_spec.rb`
    Then the examples should all pass
