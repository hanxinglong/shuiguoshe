# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

PaymentType.create(name: "在线支付", sort: 0)
PaymentType.create(name: "货到付款", sort: 1)

ShipmentType.create(name: "13:00-15:00", sort: 0)
ShipmentType.create(name: "15:00-18:00", sort: 1)
ShipmentType.create(name: "18:00-21:00", sort: 2)
ShipmentType.create(name: "21:00-23:00", sort: 3)
