class Order < ActiveRecord::Base
  before_save :set_activation_code
  before_save :send_initial_message

  has_and_belongs_to_many :oysters
  has_many :orders_oysters

  validates_presence_of :phone
  validates_presence_of :name
  validates :phone, phone_number: { ten_digits: true }

  def set_activation_code
    self.activation_code = nil
    while self.activation_code == nil
      word = Wordlist::WORDS.sample
      if Order.where(activation_code: word).first
        break
      else
        self.activation_code = word
      end
    end
  end

  def formatted
    attributes.merge(oysters: formatted_oysters)
  end

  def formatted_oysters
    orders_oysters.map do |order_oyster|
      return if order_oyster.count.blank?
      oyster_name = Oyster.find(order_oyster.oyster_id).name
      [oyster_name, order_oyster.count]
    end
  end

  def twilio_client
    Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
  end

  def send_initial_message
    return unless ENV.key? 'TWILIO_ACCOUNT_SID'
    begin
      twilio_client.messages.create(
        to: phone,
        from: ENV['TWILIO_PHONE_NUMBER'],
        body: "Hi #{name}! We'll let you know when your order is ready, or you can check the status with code: #{activation_code}. You owe $#{amount_owed}"
      )
    rescue Twilio::REST::RequestError => e
      self.errors.add(:oops, e.message)
    end
  end

  def send_ready_message
    twilio_client.messages.create(
      to: phone,
      from: ENV['TWILIO_PHONE_NUMBER'],
      body: "Hi #{name}! Your order is ready."
    )
  end

  def send_reminder_message
    twilio_client.messages.create(
      to: phone,
      from: ENV['TWILIO_PHONE_NUMBER'],
      body: "Hi #{name}! Your order is ready. Get it while it's cold."
    )
  end

  def amount_owed
    order_oysters = OrdersOyster.where(order_id: id)
    order_oysters.map{|oo| oo.count}.sum
  end

  def validate_order_oysters(order_oysters)
    total_count = 0
    order_oysters.each do |name, count|
      oyster = Oyster.where(name: name).first
      unless oyster
        self.errors.add(:oops!, "Oyster does not exist.")
        break
      end
      if count.to_i > oyster.max
        self.errors.add(:darn, "can't order more than #{oyster.max} #{oyster.name} oysters!")
      end
      if oyster.count - count.to_i < 0
        self.errors.add(:shoot, "only #{oyster.count} #{oyster.name} oysters left.")
      end
      total_count += count.to_i
    end
    self.errors.add(:golly, "only 12 oysters per order please.") if total_count > 12
  end
end
