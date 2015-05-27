# Nala

Lightweight gem for adding events to use case style classes.

## Install

To install via RubyGems run:

```
gem install nala
```

To install via bundler, add this line to your Gemfile and run `bundle install`:

```
gem "nala"
```

## Usage

Nala is intended to be used with use case style classes where the class performs a
single action. These classes typically have verb names such as `PlaceOrder` etc.

To use, add the `Nala::Publisher` module to your class and expose a `call`
instance method. If your class requires data, it can be passed to it via the constructor.

For example:

```ruby
class PlaceOrder
  include Nala::Publisher

  def initialize(params)
    @params = params
  end

  def call
    # ...

    if order.save
      publish(:ok, order)
    else
      publish(:error)
    end
  end
end
```

Usage of these use case style classes gives a home to your business logic, removes
conditionals from your Rails controllers and helps prevent your models getting too
big.

```ruby
class OrderController < ApplicationController
  # ...

  def create
    PlaceOrder.call(order_params)
      .on(:ok) { |order| redirect_to orders_path, :notice => "..." }
      .on(:error) { render :new }
  end

  # ...
end
```

This comes in handy when there are more than two out comes to a use case:

```ruby
class RegistrationController < ApplicationController
  # ...

  def create
    RegisterAccount.call(account_params)
      .on(:already_registered) { redirect_to login_path, :notice => "..." }
      .on(:ok) { |user| redirect_to dashboard_path, :notice => "..." }
      .on(:error) { render :new }
  end

  # ...
end
```

## Testing with RSpec

If you are using RSpec then you can use the supplied matcher by adding the following line to your `spec_helper.rb` file:

```
require "nala/rspec"
```

Then within your specs, you can confirm that a handler is called with the following:

```
let(:block) { Nala::BlockSpy.new }

it "invokes a handler for a published event" do
  SuccessClass.call.on(:success) { block.called! }

  expect(block).to be_called
end
```

If you want to check the arguments that are passed to the block you can use the following:

```
let(:block) { Nala::BlockSpy.new }

it "passes multiple arguments to handlers" do
  PublishArgsClass.call
    .on(:multiple) { |*x| block.called_with!(x) }

  expect(block).to be_called_with(:a, :b, :c)
end
```

If you need check the arguments attributes in more detail you can do the following:

```
let(:block) { Nala::BlockSpy.new }

it "passes a user with the correct name" do
  RegisterUser.call
    .on(:success) { |*x| block.called_with!(x) }

  user = block.args.first
  expect(user.name).to eq("Andy")
end
```

## License

See the [LICENSE](LICENSE.txt) file for license rights and limitations (MIT).
