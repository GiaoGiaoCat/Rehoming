class Feeds::Hook < ActiveType::Object
  attribute :name, :string
  attribute :transaction_id, :string
  attribute :payload, :hash
  # TODO: 实现根据 payload 的数据，创建 feed，并扔到 jobs 中，不影响主线程操作事件
end
