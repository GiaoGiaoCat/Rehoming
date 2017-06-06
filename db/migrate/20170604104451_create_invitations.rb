class CreateInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :invitations do |t|
      t.string :token
      t.datetime :accepted_at
      t.belongs_to :forum
      t.belongs_to :user

      t.timestamps
    end

    add_index :invitations, [:token], name: 'invitations_token_index'
  end
end
