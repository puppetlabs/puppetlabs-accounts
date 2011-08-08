# This shared example allows you to pass a hash of valid and invalid values
# for each parameter for a class.
#
# Example:
#
#     describe "when setting class params" do
#       properties = {
#         :prop1 => {
#           :valid => ["valid value"],
#           :invalid => ["invalid value"],
#         }
#       }
#       it_should_behave_like "a parameterized class", "classname", properties
#     end
#
shared_examples "a parameterized class" do |type, properties|
  properties.each do |name, settings|
    settings[:valid].each do |value|
      it "and should support #{value.inspect} as a value to '#{name.to_s}'" do
        params[name.to_s] = value
        should create_class(type).send("with_" + name.to_s, value)
      end
    end

    settings[:invalid].each do |value|
      it "and should fail if #{value.inspect} is a value of '#{name.to_s}'" do
        params[name.to_s] = value
        expect { subject }.should raise_error
      end
    end
  end
end
