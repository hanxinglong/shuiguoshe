# coding: utf-8
class OrderMailer < BaseMailer
  def notify_mail(order)
    # receipts = %w[tomwey@163.com tangwei1@smalltreemedia.com]
    # @order = Oder.find_by(id: order_id)
    # return false if @order.blank?
    @order = order
    mail to: SiteConfig.receipts, subject: '订单提醒邮件'
  end
end