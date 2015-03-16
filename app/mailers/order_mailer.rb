# coding: utf-8
class OrderMailer < BaseMailer
  def notify_mail(order_id)
    # receipts = %w[tomwey@163.com tangwei1@smalltreemedia.com]
    # @order = Oder.find_by(id: order_id)
    # return false if @order.blank?
    mail to: 'tangwei1@smalltreemedia.com', subject: 'test'
  end
end