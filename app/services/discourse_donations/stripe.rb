module DiscourseDonations
  class Stripe
    attr_reader :charge, :currency, :description

    def initialize(secret_key, opts)
      ::Stripe.api_key = secret_key
      @description = opts[:description]
      @currency = opts[:currency]
    end

    def checkoutCharge(email, token, amount)
      customer = ::Stripe::Customer.create(
          :email => email,
          :source  => token
      )

      charge = ::Stripe::Charge.create(
        :customer => customer.id,
        :amount => amount,
        :description => @description,
        :currency => @currency
      )
      charge
    end

    def charge(email, token, amount)
      customer = ::Stripe::Customer.create(
        email: email,
        source: token
      )
      @charge = ::Stripe::Charge.create(
        customer: customer.id,
        amount: amount,
        description: description,
        currency: currency
      )
      @charge
    end

    def subscribe(email, opts)
      customer = ::Stripe::Customer.create(
        email: email,
        source: opts[:stripeToken]
      )
      @subscription = ::Stripe::Subscription.create(
        customer: customer.id,
        plan: opts[:plan]
      )
      @subscription
    end

    def successful?
      @charge[:paid]
    end
  end
end
